# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LobeChat AWS Infrastructure as Code - Deploy LobeChat to AWS using CloudFormation and Docker Compose.

## Repository Structure

```
.
├── infra/
│   └── cloudformation.yml  # AWS infrastructure + UserData deployment
├── Dockerfile              # LobeChat Docker image build
├── docker-entrypoint.sh    # Container entrypoint script
├── docker-compose.yml      # Local development compose file
├── .github/
│   └── workflows/
│       └── build-publish.yml  # Build and push to GHCR
├── docs/
│   ├── ARCHITECTURE.md     # Infrastructure documentation
│   ├── HOMEWORK.md         # Student deployment guide
│   ├── diagrams/           # Draw.io source files
│   └── images/             # PNG exports
├── README.md
├── CLAUDE.md               # This file
└── .gitignore
```

## Docker Images

The LobeChat image is built and published to GitHub Container Registry:

```
ghcr.io/oriolrius/lobechat:latest
ghcr.io/oriolrius/lobechat:v4.x
```

## CloudFormation Template

The template (`infra/cloudformation.yml`) creates infrastructure and deploys via UserData:

| Resource | Description |
|----------|-------------|
| VPC | 10.0.0.0/16 with DNS enabled |
| Internet Gateway | Public internet access |
| Public Subnet | 10.0.1.0/24, eu-west-1b |
| Route Table | Routes to Internet Gateway |
| Security Group | Ports 22, 3210, 9000, 9001 |
| EC2 Instance | c7a.2xlarge, Ubuntu 24.04, Docker |

### UserData deploys:
- Docker and Docker Compose
- PostgreSQL 16 with pgvector (container)
- MinIO S3-compatible storage (container)
- LobeChat application (from GHCR)

## Common Operations

```bash
# Build Docker image locally
docker build -t lobechat:local .

# Run locally with docker-compose
docker compose up -d

# Validate CloudFormation template
aws cloudformation validate-template \
  --template-body file://infra/cloudformation.yml

# Deploy infrastructure
aws cloudformation deploy \
  --template-file infra/cloudformation.yml \
  --stack-name lobechat \
  --capabilities CAPABILITY_IAM

# Get outputs
aws cloudformation describe-stacks \
  --stack-name lobechat \
  --query 'Stacks[0].Outputs' --output table

# Delete stack
aws cloudformation delete-stack --stack-name lobechat

# Check UserData logs (SSH into instance)
ssh -i ~/.ssh/lobechat-key.pem ubuntu@<PUBLIC_IP>
sudo cat /var/log/user-data.log

# View Docker logs on instance
cd /opt/lobechat && docker compose logs -f
```

## GitHub Actions Workflow

The workflow (`.github/workflows/build-publish.yml`):

1. **On push to v4.x**: Builds and pushes Docker image to GHCR
2. **On tags (v*)**: Creates versioned releases
3. **Validates**: CloudFormation template on every push/PR

## Branch Strategy

| Branch | Purpose |
|--------|---------|
| `v1.x` | Manual EC2 deployment documentation |
| `v2.x` | GitHub Actions CI/CD practice |
| `v3.x` | Infrastructure as Code with CloudFormation (UserData shell script) |
| `v4.x` | CloudFormation + Docker Compose + GHCR (this branch) |
| `v5.x` | CloudFormation + Ansible |
