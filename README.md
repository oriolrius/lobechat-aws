# LobeChat on AWS EC2

Deploy LobeChat on AWS EC2 for ESADE students using the Innovation Sandbox.

## What You Get

- **LobeChat**: AI chat platform supporting multiple providers (OpenRouter, OpenAI, Anthropic, etc.)
- **PostgreSQL + pgvector**: Database with vector embeddings for semantic search
- **MinIO**: S3-compatible storage for file uploads
- **Better-Auth**: Built-in user authentication

## Quick Start

Follow the step-by-step guide: **[INSTALLATION.md](INSTALLATION.md)**

Total deployment time: ~16 minutes

## Architecture

```
Browser --> LobeChat (:3210) --> PostgreSQL (:5432)
                |
                +--> MinIO (:9000) --> /opt/minio/data
```

All services run on a single EC2 instance (Ubuntu 24.04).

## Requirements

| Requirement | Details |
|-------------|---------|
| AWS Account | ESADE Innovation Sandbox |
| Instance Type | c7a.2xlarge (8 vCPU, 16GB RAM) |
| Storage | 20GB gp3 EBS |
| Cost | ~$0.35/hour |

## Access URLs

After installation:

| Service | URL |
|---------|-----|
| LobeChat | `http://<PUBLIC_IP>:3210` |
| MinIO Console | `http://<PUBLIC_IP>:9001` |

## Services

| Service | Port | Purpose |
|---------|------|---------|
| LobeChat | 3210 | Main chat application |
| PostgreSQL | 5432 | Database (internal) |
| MinIO API | 9000 | File storage |
| MinIO Console | 9001 | Storage admin UI |

## Default Credentials

| Service | Username | Password |
|---------|----------|----------|
| MinIO | lobechat | lobechat-minio-secret |
| PostgreSQL | postgres | lobechat-db-password |

LobeChat uses self-registration - create your account on first visit.

## Key Files on EC2

```
/opt/lobechat/           # LobeChat application
├── .env                 # Build-time config
├── .env.local           # Runtime config (systemd reads this)
└── ...

/opt/minio/data/         # MinIO file storage
/var/lib/postgresql/     # PostgreSQL data
```

## Managing the Instance

```bash
# SSH to instance
ssh -i ~/.ssh/lobechat-key.pem ubuntu@<PUBLIC_IP>

# View LobeChat logs
sudo journalctl -u lobechat -f

# Restart services
sudo systemctl restart lobechat
sudo systemctl restart minio
sudo systemctl restart postgresql
```

## Cost Management

- **Stop** instance when not in use: `aws ec2 stop-instances --instance-ids <ID>`
- **Start** when needed: `aws ec2 start-instances --instance-ids <ID>`
- **Terminate** when done (deletes everything): see Cleanup section in INSTALLATION.md

Note: Public IP changes after stop/start.

## Troubleshooting

See the Troubleshooting section in [INSTALLATION.md](INSTALLATION.md).

## Version

v1.0.0 - EC2 deployment for ESADE students
