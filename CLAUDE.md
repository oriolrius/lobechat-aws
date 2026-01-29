# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LobeChat AWS Deployment - Installation guide and configuration for deploying LobeChat on AWS EC2 for ESADE students using the Innovation Sandbox.

## Repository Structure

```
.
├── docs/
│   ├── INSTALLATION.md  # Step-by-step EC2 deployment guide
│   └── ARCHITECTURE.md  # Architecture documentation and diagrams
├── README.md            # Project overview
├── CLAUDE.md            # This file - Claude Code guidance
├── .env.example         # Environment variable template
├── .githooks/           # Git commit validation hooks
└── .gitignore           # Git ignore patterns
```

## Key Files

- `docs/INSTALLATION.md`: Complete guide for deploying LobeChat on AWS EC2 with:
  - VPC/networking setup
  - EC2 instance provisioning (c7a.2xlarge)
  - PostgreSQL 16 with pgvector
  - MinIO for S3-compatible storage
  - Node.js 20 and pnpm
  - LobeChat build and configuration
  - systemd service setup

- `.env.example`: Template for environment variables including:
  - Database connection (PostgreSQL)
  - Authentication (AUTH_SECRET, JWKS_KEY)
  - S3/MinIO storage configuration
  - Optional AI provider API keys

## EC2 Deployment Architecture

```
┌─────────────────────────────────────────────────────┐
│                    EC2 Instance                      │
│                   (c7a.2xlarge)                      │
│                                                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  │
│  │  LobeChat   │  │ PostgreSQL  │  │   MinIO     │  │
│  │   :3210     │  │   :5432     │  │   :9000     │  │
│  │  (Next.js)  │  │  (pgvector) │  │ (S3 storage)│  │
│  └─────────────┘  └─────────────┘  └─────────────┘  │
│                                                      │
└─────────────────────────────────────────────────────┘
```

## Common Operations

### On EC2 Instance

```bash
# View LobeChat logs
sudo journalctl -u lobechat -f

# Restart services
sudo systemctl restart lobechat
sudo systemctl restart minio
sudo systemctl restart postgresql

# Check service status
sudo systemctl status lobechat minio postgresql
```

### From Local Machine

```bash
# Load saved AWS config
source ~/.lobechat_aws

# SSH to instance
ssh -i ~/.ssh/lobechat-key.pem ubuntu@$PUBLIC_IP

# Stop instance (saves money)
aws ec2 stop-instances --instance-ids $INSTANCE_ID

# Start instance (note: IP changes!)
aws ec2 start-instances --instance-ids $INSTANCE_ID
```

## Port Reference

| Port | Service       |
|------|---------------|
| 22   | SSH           |
| 3210 | LobeChat      |
| 5432 | PostgreSQL    |
| 9000 | MinIO API     |
| 9001 | MinIO Console |

## Environment Variables

Key environment variables for LobeChat (configured in `/opt/lobechat/.env`):

| Variable | Description |
|----------|-------------|
| `APP_URL` | Public URL of the application |
| `DATABASE_URL` | PostgreSQL connection string |
| `AUTH_SECRET` | Authentication secret (32+ chars) |
| `KEY_VAULTS_SECRET` | Encryption key for vaults |
| `JWKS_KEY` | JWT signing key (generated) |
| `S3_ENDPOINT` | MinIO endpoint (public IP) |
| `S3_BUCKET` | MinIO bucket name |
