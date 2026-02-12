# LobeChat Installation Guide (Non-Docker)

This guide is designed for **ESADE students** using the Innovation Sandbox on AWS with the **student role** (`esadeis_IsbUsersPS`). It covers deploying LobeChat with PostgreSQL on an EC2 instance.

## Prerequisites

- Access to ESADE Innovation Sandbox on AWS
- AWS CLI installed locally (`brew install awscli` or `apt install awscli`)
- SSH client

> **Instance Size**: This guide uses **c7a.2xlarge** (8 vCPU, 16GB RAM, AMD EPYC 4th Gen, ~$0.35/hour). The Next.js build is resource-intensive and requires sufficient CPU/RAM to avoid timeouts.

> **Total Time**: ~16 minutes (Steps 1-4: ~2 min local, Steps 5-9: ~14 min on EC2)

---

## Step 0: Get AWS Credentials

**Purpose**: Authenticate your local terminal with AWS so you can create cloud resources.

**Critical**: Credentials expire after a few hours. If commands fail with "expired token", repeat this step.

### Via AWS Console

1. Go to the Innovation Sandbox portal and click **"Login to account"** for your lease
2. In the AWS access portal, click **"Access keys"** next to `esadeis_IsbUsersPS`
3. Copy the export commands and run them in your terminal:

```bash
export AWS_ACCESS_KEY_ID="ASIA..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
export AWS_DEFAULT_REGION="eu-west-1"
```

4. Verify credentials work:

```bash
aws sts get-caller-identity
```

---

## Step 1: Create VPC and Networking

**Purpose**: Create an isolated network for your EC2 instance. The sandbox doesn't have a default VPC, so we must create one with internet access.

**Critical**: Save all the IDs printed by echo commands - you'll need them for cleanup later.

```bash
# Create VPC (Virtual Private Cloud - your isolated network)
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=lobechat-vpc
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames
echo "VPC: $VPC_ID"

# Create Internet Gateway (allows traffic to/from internet)
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
echo "Internet Gateway: $IGW_ID"

# Create public subnet (where EC2 will live, with public IP)
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone eu-west-1a --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=lobechat-public-subnet
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_ID --map-public-ip-on-launch
echo "Subnet: $SUBNET_ID"

# Create route table (directs internet traffic through gateway)
RTB_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $RTB_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
aws ec2 associate-route-table --subnet-id $SUBNET_ID --route-table-id $RTB_ID
echo "Route Table: $RTB_ID"

# Create security group (firewall rules: SSH, LobeChat, MinIO)
SG_ID=$(aws ec2 create-security-group --group-name lobechat-sg --description "LobeChat security group" --vpc-id $VPC_ID --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 3210 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 9000 --cidr 0.0.0.0/0
echo "Security Group: $SG_ID"
```

Save these IDs for later:

```bash
echo "VPC_ID=$VPC_ID" >> ~/.lobechat_aws
echo "IGW_ID=$IGW_ID" >> ~/.lobechat_aws
echo "SUBNET_ID=$SUBNET_ID" >> ~/.lobechat_aws
echo "RTB_ID=$RTB_ID" >> ~/.lobechat_aws
echo "SG_ID=$SG_ID" >> ~/.lobechat_aws
```

---

## Step 2: Create SSH Key Pair

**Purpose**: Generate an SSH key to securely connect to your EC2 instance. AWS stores the public key; you keep the private key.

**Critical**: The `.pem` file is your only way to access the server. Don't lose it or share it.

```bash
aws ec2 create-key-pair --key-name lobechat-key --query 'KeyMaterial' --output text > ~/.ssh/lobechat-key.pem
chmod 400 ~/.ssh/lobechat-key.pem
echo "SSH key saved to ~/.ssh/lobechat-key.pem"
```

---

## Step 3: Launch EC2 Instance

**Purpose**: Create the virtual server that will run LobeChat. We use Ubuntu 24.04 with enough CPU/RAM for the build process.

**Critical**: Wait for "Instance: i-xxx" and "Public IP: x.x.x.x" output before proceeding.

```bash
# Load saved IDs (or set them manually if not saved)
source ~/.lobechat_aws 2>/dev/null || true

# Get latest Ubuntu 24.04 AMI (Amazon Machine Image)
AMI_ID=$(aws ec2 describe-images --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
  --query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' --output text)
echo "AMI: $AMI_ID"

# Launch instance (c7a.2xlarge: 8 vCPU, 16GB RAM - needed for build)
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type c7a.2xlarge \
  --key-name lobechat-key \
  --security-group-ids $SG_ID \
  --subnet-id $SUBNET_ID \
  --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"VolumeSize":20,"VolumeType":"gp3"}}]' \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=lobechat-server}]' \
  --query 'Instances[0].InstanceId' --output text)
echo "Instance: $INSTANCE_ID"
echo "INSTANCE_ID=$INSTANCE_ID" >> ~/.lobechat_aws

# Wait for instance to be running
echo "Waiting for instance to start..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get public IP (this is how you'll access LobeChat)
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "Public IP: $PUBLIC_IP"
echo "PUBLIC_IP=$PUBLIC_IP" >> ~/.lobechat_aws
```

---

## Step 4: Connect to Instance

**Purpose**: SSH into your EC2 server to install software. All remaining steps run on the server.

**Critical**: Wait ~1 minute after launch for SSH to become available. If connection refused, wait and retry.

```bash
source ~/.lobechat_aws
ssh -i ~/.ssh/lobechat-key.pem ubuntu@$PUBLIC_IP
```

---

## Step 5: Install PostgreSQL 16 with pgvector

**Purpose**: Install the database that stores LobeChat's users, conversations, and settings. pgvector enables AI embeddings for semantic search.

**Critical**: The `CREATE EXTENSION vector` command must succeed - it enables AI features.

> **Timing**: ~2 minutes

Run these commands on the EC2 instance:

```bash
# Update system packages
sudo apt update && sudo apt upgrade -y

# Add official PostgreSQL repository (Ubuntu's version is outdated)
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update

# Install PostgreSQL 16 with vector extension
sudo apt install -y postgresql-16 postgresql-contrib-16 postgresql-16-pgvector

# Enable and start PostgreSQL service
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

### Configure PostgreSQL

```bash
# Set password and create database with vector extension
sudo -u postgres psql << 'EOF'
ALTER USER postgres WITH PASSWORD 'lobechat-db-password';
CREATE DATABASE lobechat;
\c lobechat
CREATE EXTENSION IF NOT EXISTS vector;
EOF
```

---

## Step 6: Install MinIO (S3 Storage)

**Purpose**: Install S3-compatible object storage for file uploads (images, documents). LobeChat requires this for the file/knowledge features.

**Critical**: The bucket must be created and set to public download for file access to work.

> **Timing**: ~1 minute

```bash
# Download and install MinIO server
cd /tmp
wget -q https://dl.min.io/server/minio/release/linux-amd64/minio
chmod +x minio
sudo mv minio /usr/local/bin/

# Create data directory
sudo mkdir -p /opt/minio/data
sudo chown -R ubuntu:ubuntu /opt/minio

# Create systemd service (runs MinIO on boot)
sudo tee /etc/systemd/system/minio.service << 'EOF'
[Unit]
Description=MinIO Object Storage
After=network.target

[Service]
Type=simple
User=ubuntu
Environment="MINIO_ROOT_USER=lobechat"
Environment="MINIO_ROOT_PASSWORD=lobechat-minio-secret"
ExecStart=/usr/local/bin/minio server /opt/minio/data --console-address ":9001" --address ":9000"
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable minio
sudo systemctl start minio

# Install MinIO client and create bucket for LobeChat
wget -q https://dl.min.io/client/mc/release/linux-amd64/mc
chmod +x mc
sudo mv mc /usr/local/bin/
mc alias set local http://localhost:9000 lobechat lobechat-minio-secret
mc mb local/lobechat --ignore-existing
mc anonymous set download local/lobechat
```

---

## Step 7: Install Node.js 20

**Purpose**: Install the JavaScript runtime required to build and run LobeChat (a Next.js application).

**Critical**: Must be Node.js 20.x - older versions won't work with LobeChat.

> **Timing**: ~30 seconds

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node --version  # Should show v20.x.x
```

---

## Step 8: Install LobeChat

**Purpose**: Clone, configure, build, and run LobeChat. This is the main application.

### Install prerequisites (~1 minute)

```bash
# Install git and build tools
sudo apt install -y git build-essential unzip

# Install pnpm (LobeChat's package manager)
sudo npm install -g pnpm

# Install bun (needed for database migrations)
curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
```

### Clone LobeChat (~10 seconds)

```bash
sudo mkdir -p /opt/lobechat
sudo chown ubuntu:ubuntu /opt/lobechat
cd /opt/lobechat
git clone --depth 1 https://github.com/lobehub/lobe-chat.git .
```

### Install dependencies (~1.5 minutes)

```bash
cd /opt/lobechat
pnpm install
```

### Configure environment (before build!)

**Purpose**: Set all configuration variables. The build process bakes some values into the app, so this must be done first.

**Critical**:

- `APP_URL` and `S3_ENDPOINT` must use your public IP, not localhost
- `AUTH_SECRET` and `KEY_VAULTS_SECRET` must be random 32+ character strings
- Create `.env` (not `.env.local`) - the build reads from `.env`

```bash
# Get public IP from EC2 metadata service
TOKEN=$(curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")
PUBLIC_IP=$(curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Server IP: $PUBLIC_IP"

# Generate cryptographic secrets
AUTH_SECRET=$(openssl rand -base64 32)
KEY_VAULTS_SECRET=$(openssl rand -base64 32)

cat > /opt/lobechat/.env << EOF
# App URL - must be public IP for browser access
APP_URL=http://$PUBLIC_IP:3210

# Database connection
DATABASE_URL=postgresql://postgres:lobechat-db-password@localhost:5432/lobechat
DATABASE_DRIVER=node

# Authentication secrets (Better-Auth)
AUTH_SECRET=$AUTH_SECRET
AUTH_TRUST_HOST=true

# Encryption key for API keys stored in database
KEY_VAULTS_SECRET=$KEY_VAULTS_SECRET

# Allow HTTP cookies (required without HTTPS)
SECURE_COOKIES=false

# S3/MinIO Storage - must use public IP for browser uploads
S3_ACCESS_KEY_ID=lobechat
S3_SECRET_ACCESS_KEY=lobechat-minio-secret
S3_ENDPOINT=http://$PUBLIC_IP:9000
S3_BUCKET=lobechat
S3_PUBLIC_DOMAIN=http://$PUBLIC_IP:9000
S3_ENABLE_PATH_STYLE=1
S3_SET_ACL=0

# Optional: OpenRouter for AI models (add your key)
# OPENROUTER_API_KEY=sk-or-v1-your-key
# ENABLED_OPENROUTER=1
EOF

# Generate JWKS key for JWT token signing
cd /opt/lobechat
JWKS_KEY=$(node scripts/generate-oidc-jwk.mjs 2>/dev/null)
echo "" >> .env
echo "# OIDC/JWT signing key" >> .env
echo "JWKS_KEY='$JWKS_KEY'" >> .env

# Copy to .env.local for runtime (systemd reads this)
cp /opt/lobechat/.env /opt/lobechat/.env.local

# Save public IP for later reference
echo "PUBLIC_IP=$PUBLIC_IP" > ~/.lobechat_config
```

### Build LobeChat (~5-6 minutes)

**Purpose**: Compile the Next.js application for production. This is CPU-intensive.

**Critical**: Don't interrupt the build. If SSH disconnects, the build continues but you can't see progress.

```bash
cd /opt/lobechat
pnpm run build
```

> **Note**: The build is CPU and memory intensive. On c7a.2xlarge (8 vCPU, 16GB RAM) it completes in ~5-6 minutes. Smaller instances may experience SSH timeouts during build.

### Run database migrations

**Purpose**: Create the database tables LobeChat needs.

```bash
cd /opt/lobechat
source .env.local
MIGRATION_DB=1 bun run ./scripts/migrateServerDB/index.ts
```

### Create LobeChat service

**Purpose**: Configure systemd to run LobeChat automatically on boot and restart on crash.

```bash
sudo tee /etc/systemd/system/lobechat.service << 'EOF'
[Unit]
Description=LobeChat Application
After=network.target postgresql.service

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/lobechat
EnvironmentFile=/opt/lobechat/.env.local
Environment=NODE_ENV=production
Environment=PORT=3210
ExecStart=/usr/bin/pnpm start
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable lobechat
sudo systemctl start lobechat
```

---

## Step 9: Verify Installation

**Purpose**: Confirm all services are running and get your access URLs.

**Critical**: All three services (postgresql, minio, lobechat) should show "active (running)".

```bash
# Check all services are running
sudo systemctl status postgresql --no-pager
sudo systemctl status minio --no-pager
sudo systemctl status lobechat --no-pager

# Get your access URLs
source ~/.lobechat_config
echo ""
echo "============================================"
echo "Installation Complete!"
echo "============================================"
echo "LobeChat:       http://$PUBLIC_IP:3210"
echo "MinIO Console:  http://$PUBLIC_IP:9001"
echo "============================================"
```

---

## Accessing LobeChat

1. Open `http://<PUBLIC_IP>:3210` in your browser
2. Create an account using the signup form
3. Go to Settings to add AI provider API keys (OpenRouter, OpenAI, etc.)

---

## Managing Your Instance

### From your local machine:

```bash
# Load saved config
source ~/.lobechat_aws

# SSH to instance
ssh -i ~/.ssh/lobechat-key.pem ubuntu@$PUBLIC_IP

# Stop instance (saves money when not in use)
aws ec2 stop-instances --instance-ids $INSTANCE_ID

# Start instance
aws ec2 start-instances --instance-ids $INSTANCE_ID
# Note: Public IP changes after restart!

# Terminate instance (deletes everything)
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
```

### View service logs:

```bash
# On the EC2 instance
sudo journalctl -u lobechat -f
```

---

## Cleanup (When Done) - Destroy - Terminate

**Purpose**: Delete all AWS resources to stop billing. The sandbox has limited budget.

**Critical**: Run all commands in order. Some resources can't be deleted until others are removed first.

```bash
source ~/.lobechat_aws

# Terminate instance first
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID

# Delete security group (must wait for instance termination)
aws ec2 delete-security-group --group-id $SG_ID

# Delete subnet
aws ec2 delete-subnet --subnet-id $SUBNET_ID

# Detach and delete internet gateway
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID

# Delete route table (non-main only)
RTB_ID=$(aws ec2 describe-route-tables --filters "Name=vpc-id,Values=$VPC_ID" "Name=association.main,Values=false" --query 'RouteTables[0].RouteTableId' --output text)
aws ec2 delete-route-table --route-table-id $RTB_ID

# Delete VPC
aws ec2 delete-vpc --vpc-id $VPC_ID

# Delete key pair
aws ec2 delete-key-pair --key-name lobechat-key
rm ~/.ssh/lobechat-key.pem

echo "All resources deleted!"
```

---

## Troubleshooting

### "Credentials expired"

Refresh credentials from the Innovation Sandbox portal (Step 0).

### LobeChat shows blank page

```bash
sudo journalctl -u lobechat -n 50
# Check if database connection works
```

### Can't connect to instance

```bash
# Check instance is running
aws ec2 describe-instances --instance-ids $INSTANCE_ID --query 'Reservations[0].Instances[0].State.Name'

# Check security group allows SSH
aws ec2 describe-security-groups --group-ids $SG_ID
```

### File uploads fail or show localhost error

Check that `S3_ENDPOINT` in `.env` uses the public IP, not localhost. Rebuild if you change it.
