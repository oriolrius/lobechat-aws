# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LobeChat AWS Infrastructure as Code - Deploy LobeChat to AWS using CloudFormation and Ansible.

## Repository Structure

```
.
├── infra/
│   └── cloudformation.yml  # AWS infrastructure template
├── ansible/
│   ├── playbook.yml        # Application deployment playbook
│   └── inventory.yml.template  # Inventory template
├── docs/
│   ├── ARCHITECTURE.md     # Infrastructure documentation
│   ├── HOMEWORK.md         # Student deployment guide
│   ├── diagrams/           # Draw.io source files
│   └── images/             # PNG exports
├── pyproject.toml          # Python/uv configuration for Ansible
├── README.md
├── CLAUDE.md               # This file
└── .gitignore
```

## CloudFormation Template

The template (`infra/cloudformation.yml`) creates infrastructure only:

| Resource | Description |
|----------|-------------|
| VPC | 10.0.0.0/16 with DNS enabled |
| Internet Gateway | Public internet access |
| Public Subnet | 10.0.1.0/24, eu-west-1b |
| Route Table | Routes to Internet Gateway |
| Security Group | Ports 22, 3210, 9000, 9001 |
| EC2 Instance | c7a.2xlarge, Ubuntu 24.04 |

## Ansible Playbook

The playbook (`ansible/playbook.yml`) configures the EC2 instance:

- PostgreSQL 16 with pgvector
- MinIO (S3-compatible storage)
- Node.js 20 + pnpm + bun
- LobeChat (cloned, built, and deployed)

### Running Ansible

Ansible is managed via `uv` (Python package manager):

```bash
# Create inventory from template
PUBLIC_IP=$(aws cloudformation describe-stacks --stack-name lobechat \
  --query 'Stacks[0].Outputs[?OutputKey==`PublicIP`].OutputValue' --output text)
sed "s/<PUBLIC_IP>/$PUBLIC_IP/" ansible/inventory.yml.template > ansible/inventory.yml

# Run playbook
uv run ansible-playbook -i ansible/inventory.yml ansible/playbook.yml
```

## Common Operations

```bash
# Validate template
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

# Run Ansible playbook
uv run ansible-playbook -i ansible/inventory.yml ansible/playbook.yml

# Delete stack
aws cloudformation delete-stack --stack-name lobechat

# Check stack events (for debugging)
aws cloudformation describe-stack-events \
  --stack-name lobechat \
  --query 'StackEvents[?ResourceStatus==`CREATE_FAILED`]'
```

## Branch Strategy

| Branch | Purpose |
|--------|---------|
| `v1.x` | Manual EC2 deployment documentation |
| `v2.x` | GitHub Actions CI/CD practice |
| `v3.x` | Infrastructure as Code with CloudFormation (UserData) |
| `v4.x` | CloudFormation + Ansible (this branch) |
