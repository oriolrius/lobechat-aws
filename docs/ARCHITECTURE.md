# LobeChat EC2 Architecture

This document describes the architecture of the LobeChat deployment on AWS EC2.

## Overview

LobeChat runs as a self-contained stack on a single EC2 instance. All components (web application, database, file storage) run on the same server, simplifying deployment and management.

![Architecture Diagram](architecture.png)

## Components

### LobeChat (Port 3210)

The main application - a Next.js web app that provides:
- AI chat interface with multiple provider support
- User authentication (Better-Auth)
- Conversation and settings storage
- File upload and knowledge base features

**Technology**: Next.js, React, TypeScript

### PostgreSQL 16 (Port 5432)

Relational database storing:
- User accounts and sessions
- Conversations and messages
- AI provider configurations (encrypted)
- Knowledge base metadata

**Key Extension**: `pgvector` enables vector embeddings for semantic search in the knowledge base.

**Data Location**: `/var/lib/postgresql/16/main/`

### MinIO (Ports 9000/9001)

S3-compatible object storage for:
- User file uploads (images, documents)
- Knowledge base files
- Chat attachments

**Ports**:
- 9000: S3 API (used by LobeChat)
- 9001: Web console (admin interface)

**Data Location**: `/opt/minio/data/`

## Data Flow

```
┌──────────┐     HTTPS      ┌─────────────────────────────────────┐
│  Browser │ ──────────────▶│           EC2 Instance              │
└──────────┘    :3210       │  ┌─────────────────────────────┐    │
                            │  │         LobeChat            │    │
                            │  │       (Next.js App)         │    │
                            │  └──────────┬─────────┬────────┘    │
                            │             │         │             │
                            │    SQL      │         │  S3 API     │
                            │   :5432     │         │  :9000      │
                            │             ▼         ▼             │
                            │  ┌──────────────┐ ┌──────────┐      │
                            │  │  PostgreSQL  │ │  MinIO   │      │
                            │  │  + pgvector  │ │          │      │
                            │  └──────────────┘ └──────────┘      │
                            │         │               │           │
                            │         ▼               ▼           │
                            │  ┌──────────────────────────────┐   │
                            │  │      EBS Volume (20GB)       │   │
                            │  └──────────────────────────────┘   │
                            └─────────────────────────────────────┘
```

### Request Flow

1. **User visits LobeChat** → Browser connects to `http://<IP>:3210`
2. **Authentication** → LobeChat validates session via PostgreSQL
3. **Chat message** → LobeChat calls AI provider API (OpenRouter, OpenAI, etc.)
4. **Save conversation** → LobeChat writes to PostgreSQL
5. **File upload** → LobeChat stores file in MinIO, metadata in PostgreSQL

## AWS Infrastructure

### VPC Configuration

| Resource | CIDR/Value | Purpose |
|----------|------------|---------|
| VPC | 10.0.0.0/16 | Isolated network |
| Public Subnet | 10.0.1.0/24 | EC2 instance placement |
| Internet Gateway | - | Internet access |
| Route Table | 0.0.0.0/0 → IGW | Default route to internet |

### Security Group Rules

| Port | Protocol | Source | Purpose |
|------|----------|--------|---------|
| 22 | TCP | 0.0.0.0/0 | SSH access |
| 3210 | TCP | 0.0.0.0/0 | LobeChat web UI |
| 9000 | TCP | 0.0.0.0/0 | MinIO S3 API (file uploads) |

> **Note**: Port 5432 (PostgreSQL) is not exposed externally. Database access is localhost only.

### EC2 Instance

| Property | Value |
|----------|-------|
| Type | c7a.2xlarge |
| vCPU | 8 |
| RAM | 16 GB |
| Architecture | AMD EPYC 4th Gen |
| OS | Ubuntu 24.04 LTS |
| Storage | 20 GB gp3 EBS |

## Service Management

All services run as systemd units:

```bash
# Check service status
sudo systemctl status lobechat
sudo systemctl status postgresql
sudo systemctl status minio

# View logs
sudo journalctl -u lobechat -f
sudo journalctl -u minio -f

# Restart services
sudo systemctl restart lobechat
```

### Service Dependencies

```
postgresql.service
       │
       ▼
lobechat.service ◀── minio.service
```

LobeChat starts after PostgreSQL. MinIO runs independently but must be available for file operations.

## Configuration Files

| File | Purpose |
|------|---------|
| `/opt/lobechat/.env` | Build-time configuration |
| `/opt/lobechat/.env.local` | Runtime configuration (systemd) |
| `/etc/systemd/system/lobechat.service` | LobeChat service definition |
| `/etc/systemd/system/minio.service` | MinIO service definition |

### Key Environment Variables

| Variable | Purpose |
|----------|---------|
| `APP_URL` | Public URL for LobeChat |
| `DATABASE_URL` | PostgreSQL connection string |
| `AUTH_SECRET` | Session encryption key |
| `KEY_VAULTS_SECRET` | API key encryption |
| `S3_ENDPOINT` | MinIO endpoint (must be public IP) |
| `JWKS_KEY` | JWT signing key |

## Scaling Considerations

This single-instance deployment is suitable for:
- Individual use
- Small teams (< 10 users)
- Development and testing
- Educational purposes

For production workloads, consider:
- **Database**: Managed PostgreSQL (RDS)
- **Storage**: Amazon S3 instead of MinIO
- **Compute**: Auto-scaling group with load balancer
- **Security**: HTTPS with SSL certificate

## Backup Strategy

### Database Backup
```bash
sudo -u postgres pg_dump lobechat > backup.sql
```

### MinIO Backup
```bash
mc mirror local/lobechat ./backup/minio/
```

### Full Instance Backup
Create an AMI snapshot via AWS Console or CLI:
```bash
aws ec2 create-image --instance-id <ID> --name "lobechat-backup-$(date +%Y%m%d)"
```

## Troubleshooting

### Service Won't Start
```bash
# Check logs for errors
sudo journalctl -u lobechat -n 100 --no-pager

# Verify environment file
cat /opt/lobechat/.env.local
```

### Database Connection Failed
```bash
# Test PostgreSQL
sudo -u postgres psql -c "SELECT 1"

# Check if lobechat database exists
sudo -u postgres psql -l | grep lobechat
```

### File Uploads Fail
```bash
# Check MinIO is running
curl -I http://localhost:9000/minio/health/live

# Verify bucket exists
mc ls local/lobechat
```

## Related Documentation

- [Installation Guide](INSTALLATION.md) - Step-by-step deployment
- [README](../README.md) - Quick start and cost management
