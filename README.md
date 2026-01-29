# LobeChat AWS - Infrastructure as Code

Deploy **LobeChat to AWS** using CloudFormation and GitHub Actions.

---

## Quick Deploy

### Prerequisites

1. AWS account with appropriate permissions
2. GitHub repository secrets configured:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_SESSION_TOKEN` (for temporary credentials)
   - `AWS_REGION` (optional, defaults to `eu-west-1`)

### Deploy via GitHub Actions

1. Go to **Actions** > **Deploy** > **Run workflow**
2. Select action: `deploy`
3. Choose instance type (default: `c7a.2xlarge`)
4. Click **Run workflow**

After ~15 minutes, access LobeChat at the URL shown in the workflow summary.

### Deploy Manually

```bash
# Set AWS credentials
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
export AWS_REGION="eu-west-1"

# Create SSH key pair
aws ec2 create-key-pair --key-name lobechat-key \
  --query 'KeyMaterial' --output text > ~/.ssh/lobechat-key.pem
chmod 400 ~/.ssh/lobechat-key.pem

# Deploy stack
aws cloudformation deploy \
  --template-file infra/cloudformation.yml \
  --stack-name lobechat \
  --capabilities CAPABILITY_IAM

# Get outputs
aws cloudformation describe-stacks --stack-name lobechat \
  --query 'Stacks[0].Outputs'
```

### Destroy

```bash
aws cloudformation delete-stack --stack-name lobechat
```

Or via GitHub Actions: **Deploy** > **Run workflow** > action: `destroy`

---

## Infrastructure

The CloudFormation template creates:

| Resource | Description |
|----------|-------------|
| VPC | 10.0.0.0/16 with DNS enabled |
| Internet Gateway | Public internet access |
| Public Subnet | 10.0.1.0/24, auto-assign public IP |
| Security Group | Ports 22, 3210, 9000, 9001 |
| EC2 Instance | Ubuntu 24.04 with LobeChat stack |

### Installed on EC2

- PostgreSQL 16 with pgvector extension
- MinIO (S3-compatible storage)
- Node.js 20 + pnpm + bun
- LobeChat (built and running as systemd service)

### Access URLs

| Service | Port | URL |
|---------|------|-----|
| LobeChat | 3210 | `http://<PUBLIC_IP>:3210` |
| MinIO Console | 9001 | `http://<PUBLIC_IP>:9001` |
| MinIO S3 API | 9000 | `http://<PUBLIC_IP>:9000` |

---

## Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | Push/PR | Lint & type check |
| `commitlint.yml` | PR | Validate commit messages |
| `release.yml` | Tag `v*.*.*` | Auto-create releases |
| `deploy.yml` | Manual/Release | Deploy/destroy CloudFormation stack |

---

## Branches

| Branch | Purpose |
|--------|---------|
| `v1.x` | Manual EC2 deployment guide |
| `v2.x` | GitHub Actions practice |
| `v3.x` | Infrastructure as Code (this branch) |
