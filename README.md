# LobeChat AWS - Infrastructure as Code

Deploy **LobeChat to AWS** using CloudFormation.

> **Cost Warning**: The EC2 instance (c7a.2xlarge) costs ~$0.35/hour. **Always delete the stack when not in use!**

## Architecture

![Architecture](docs/images/architecture.png)

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) for details.

---

## Quick Start

### Prerequisites

- AWS account (ESADE Innovation Sandbox)
- AWS CLI installed

### Deploy

```bash
# 1. Set AWS credentials
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
export AWS_REGION="eu-west-1"

# 2. Create SSH key pair
aws ec2 create-key-pair --key-name lobechat-key \
  --query 'KeyMaterial' --output text > ~/.ssh/lobechat-key.pem
chmod 400 ~/.ssh/lobechat-key.pem

# 3. Deploy stack
aws cloudformation deploy \
  --template-file infra/cloudformation.yml \
  --stack-name lobechat \
  --capabilities CAPABILITY_IAM

# 4. Get outputs
aws cloudformation describe-stacks --stack-name lobechat \
  --query 'Stacks[0].Outputs' --output table
```

### Access

After ~15 minutes, access LobeChat at `http://<PUBLIC_IP>:3210`

---

## Destroy (Important!)

**Always delete the stack when you're done to avoid unnecessary costs.**

```bash
aws cloudformation delete-stack --stack-name lobechat
```

Verify deletion:

```bash
aws cloudformation describe-stacks --stack-name lobechat
# Should return: "Stack with id lobechat does not exist"
```

### Cost Reference

| Resource | Cost |
|----------|------|
| EC2 c7a.2xlarge | ~$0.35/hour (~$8.40/day) |
| EBS 20GB gp3 | ~$1.60/month |

**Example**: Running the stack for 3 hours = ~$1.05

---

## Documentation

| Document | Description |
|----------|-------------|
| [HOMEWORK.md](docs/HOMEWORK.md) | Step-by-step deployment guide for students |
| [ARCHITECTURE.md](docs/ARCHITECTURE.md) | Infrastructure architecture details |

---

## Infrastructure

| Resource | Description |
|----------|-------------|
| VPC | 10.0.0.0/16 |
| Public Subnet | 10.0.1.0/24 |
| Security Group | Ports 22, 3210, 9000, 9001 |
| EC2 Instance | c7a.2xlarge, Ubuntu 24.04 |

### Services

- PostgreSQL 16 with pgvector
- MinIO (S3-compatible storage)
- LobeChat (Next.js application)

---

## Branches

| Branch | Purpose |
|--------|---------|
| `v1.x` | Manual EC2 deployment guide |
| `v2.x` | GitHub Actions CI/CD practice |
| `v3.x` | Infrastructure as Code (this branch) |
