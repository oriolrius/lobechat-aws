# LobeChat Installation Guide (Non-Docker)

This guide is designed for **ESADE students** using the Innovation Sandbox on AWS with the **student role** (`esadeis_IsbUsersPS`). It covers deploying LobeChat with PostgreSQL and Casdoor SSO on an EC2 instance.

## Prerequisites

- Access to ESADE Innovation Sandbox on AWS
- AWS CLI installed locally (`brew install awscli` or `apt install awscli`)
- SSH client

---

## Step 0: Get AWS Credentials

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

> **Note**: Credentials expire after a few hours. You'll need to refresh them periodically.

---

## Step 1: Create VPC and Networking

The sandbox account doesn't have a default VPC. Create one:

```bash
# Create VPC
VPC_ID=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --query 'Vpc.VpcId' --output text)
aws ec2 create-tags --resources $VPC_ID --tags Key=Name,Value=lobechat-vpc
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames
echo "VPC: $VPC_ID"

# Create Internet Gateway
IGW_ID=$(aws ec2 create-internet-gateway --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
echo "Internet Gateway: $IGW_ID"

# Create public subnet
SUBNET_ID=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone eu-west-1a --query 'Subnet.SubnetId' --output text)
aws ec2 create-tags --resources $SUBNET_ID --tags Key=Name,Value=lobechat-public-subnet
aws ec2 modify-subnet-attribute --subnet-id $SUBNET_ID --map-public-ip-on-launch
echo "Subnet: $SUBNET_ID"

# Create route table and add internet route
RTB_ID=$(aws ec2 create-route-table --vpc-id $VPC_ID --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $RTB_ID --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID
aws ec2 associate-route-table --subnet-id $SUBNET_ID --route-table-id $RTB_ID
echo "Route Table: $RTB_ID"

# Create security group
SG_ID=$(aws ec2 create-security-group --group-name lobechat-sg --description "LobeChat security group" --vpc-id $VPC_ID --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 443 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 3210 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 8000 --cidr 0.0.0.0/0
echo "Security Group: $SG_ID"
```

Save these IDs for later:
```bash
echo "VPC_ID=$VPC_ID" >> ~/.lobechat_aws
echo "SUBNET_ID=$SUBNET_ID" >> ~/.lobechat_aws
echo "SG_ID=$SG_ID" >> ~/.lobechat_aws
```

---

## Step 2: Create SSH Key Pair

```bash
# Create key pair
aws ec2 create-key-pair --key-name lobechat-key --query 'KeyMaterial' --output text > ~/.ssh/lobechat-key.pem
chmod 400 ~/.ssh/lobechat-key.pem
echo "SSH key saved to ~/.ssh/lobechat-key.pem"
```

---

## Step 3: Launch EC2 Instance

```bash
# Load saved IDs (or set them manually)
source ~/.lobechat_aws 2>/dev/null || true

# Get latest Ubuntu 24.04 AMI
AMI_ID=$(aws ec2 describe-images --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*" \
  --query 'Images | sort_by(@, &CreationDate) | [-1].ImageId' --output text)
echo "AMI: $AMI_ID"

# Launch instance (t3a.small: 2 vCPU, 2GB RAM)
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --instance-type t3a.small \
  --key-name lobechat-key \
  --security-group-ids $SG_ID \
  --subnet-id $SUBNET_ID \
  --block-device-mappings '[{"DeviceName":"/dev/sda1","Ebs":{"VolumeSize":20,"VolumeType":"gp3"}}]' \
  --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=lobechat-server}]' \
  --query 'Instances[0].InstanceId' --output text)
echo "Instance: $INSTANCE_ID"

# Wait for instance to be running
echo "Waiting for instance to start..."
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

# Get public IP
PUBLIC_IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID \
  --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
echo "Public IP: $PUBLIC_IP"
echo "PUBLIC_IP=$PUBLIC_IP" >> ~/.lobechat_aws
```

---

## Step 4: Connect to Instance

Wait about 1 minute for the instance to fully boot, then connect:

```bash
source ~/.lobechat_aws
ssh -i ~/.ssh/lobechat-key.pem ubuntu@$PUBLIC_IP
```

---

## Step 5: Install PostgreSQL 16 with pgvector

Run these commands on the EC2 instance:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Add PostgreSQL repository
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update

# Install PostgreSQL 16 and pgvector
sudo apt install -y postgresql-16 postgresql-contrib-16 postgresql-16-pgvector

# Start PostgreSQL
sudo systemctl enable postgresql
sudo systemctl start postgresql
```

### Configure PostgreSQL

```bash
# Set password and create databases
sudo -u postgres psql << 'EOF'
ALTER USER postgres WITH PASSWORD 'lobechat-db-password';
CREATE DATABASE lobechat;
CREATE DATABASE casdoor;
\c lobechat
CREATE EXTENSION IF NOT EXISTS vector;
EOF
```

---

## Step 6: Install Node.js 20

```bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
node --version  # Should show v20.x.x
```

---

## Step 7: Install Casdoor

```bash
# Download Casdoor
sudo mkdir -p /opt/casdoor
cd /opt/casdoor
sudo wget https://github.com/casdoor/casdoor/releases/download/v1.778.0/linux_amd64.zip
sudo apt install -y unzip
sudo unzip linux_amd64.zip
sudo rm linux_amd64.zip
sudo chmod +x server
```

### Configure Casdoor

Get your server's public IP:
```bash
PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
echo "Server IP: $PUBLIC_IP"
```

Create configuration:
```bash
sudo mkdir -p /opt/casdoor/conf

# Generate random secrets
CLIENT_ID=$(openssl rand -hex 10)
CLIENT_SECRET=$(openssl rand -hex 20)

sudo tee /opt/casdoor/conf/app.conf << EOF
appname = casdoor
httpport = 8000
runmode = prod
driverName = postgres
dataSourceName = user=postgres password=lobechat-db-password host=localhost port=5432 sslmode=disable dbname=casdoor
origin = http://$PUBLIC_IP:8000
staticBaseUrl = "https://cdn.casbin.org"
initDataFile = "./conf/init_data.json"
EOF
```

Create initial data with LobeChat application:
```bash
sudo tee /opt/casdoor/conf/init_data.json << EOF
{
  "organizations": [
    {
      "owner": "admin",
      "name": "lobechat",
      "displayName": "LobeChat",
      "websiteUrl": "https://lobehub.com",
      "passwordType": "plain",
      "passwordOptions": ["AtLeast6"]
    }
  ],
  "applications": [
    {
      "owner": "admin",
      "name": "lobechat",
      "displayName": "LobeChat",
      "organization": "lobechat",
      "cert": "cert-built-in",
      "enablePassword": true,
      "enableSignUp": true,
      "clientId": "$CLIENT_ID",
      "clientSecret": "$CLIENT_SECRET",
      "redirectUris": ["http://$PUBLIC_IP:3210/api/auth/callback/casdoor"],
      "tokenFormat": "JWT",
      "expireInHours": 168,
      "grantTypes": ["authorization_code", "refresh_token"]
    }
  ],
  "users": [
    {
      "owner": "lobechat",
      "name": "admin",
      "type": "normal-user",
      "password": "admin123",
      "displayName": "Admin User",
      "email": "admin@example.com",
      "isAdmin": true
    }
  ]
}
EOF

# Save credentials for LobeChat setup
echo "CLIENT_ID=$CLIENT_ID" | sudo tee /opt/casdoor/.credentials
echo "CLIENT_SECRET=$CLIENT_SECRET" | sudo tee -a /opt/casdoor/.credentials
echo "PUBLIC_IP=$PUBLIC_IP" | sudo tee -a /opt/casdoor/.credentials
```

### Create Casdoor service

```bash
sudo tee /etc/systemd/system/casdoor.service << 'EOF'
[Unit]
Description=Casdoor SSO Server
After=network.target postgresql.service

[Service]
Type=simple
WorkingDirectory=/opt/casdoor
ExecStart=/opt/casdoor/server --createDatabase=true
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable casdoor
sudo systemctl start casdoor
```

Verify Casdoor is running:
```bash
sleep 5
curl -s http://localhost:8000/api/health | head -1
```

---

## Step 8: Install LobeChat

```bash
# Install git and build tools
sudo apt install -y git build-essential

# Clone and build LobeChat
sudo mkdir -p /opt/lobechat
sudo chown ubuntu:ubuntu /opt/lobechat
cd /opt/lobechat
git clone --depth 1 https://github.com/lobehub/lobe-chat.git .
npm install
npm run build
```

### Configure LobeChat

```bash
# Load Casdoor credentials
source /opt/casdoor/.credentials

# Generate secrets
NEXT_AUTH_SECRET=$(openssl rand -base64 32)
KEY_VAULTS_SECRET=$(openssl rand -base64 32)

cat > /opt/lobechat/.env.local << EOF
# App URL
APP_URL=http://$PUBLIC_IP:3210
NEXTAUTH_URL=http://$PUBLIC_IP:3210
AUTH_URL=http://$PUBLIC_IP:3210

# Database
DATABASE_URL=postgresql://postgres:lobechat-db-password@localhost:5432/lobechat

# Authentication
NEXT_AUTH_SSO_PROVIDERS=casdoor
NEXT_AUTH_SECRET=$NEXT_AUTH_SECRET
AUTH_TRUST_HOST=true

# Casdoor
AUTH_CASDOOR_ISSUER=http://$PUBLIC_IP:8000
AUTH_CASDOOR_ID=$CLIENT_ID
AUTH_CASDOOR_SECRET=$CLIENT_SECRET

# Security
KEY_VAULTS_SECRET=$KEY_VAULTS_SECRET

# Optional: OpenRouter for AI models
# OPENROUTER_API_KEY=sk-or-v1-your-key
# ENABLED_OPENROUTER=1
EOF
```

### Run database migrations

```bash
cd /opt/lobechat
npm run db:migrate
```

### Create LobeChat service

```bash
sudo tee /etc/systemd/system/lobechat.service << 'EOF'
[Unit]
Description=LobeChat Application
After=network.target postgresql.service casdoor.service

[Service]
Type=simple
User=ubuntu
WorkingDirectory=/opt/lobechat
Environment=NODE_ENV=production
Environment=PORT=3210
ExecStart=/usr/bin/npm start
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

```bash
# Check all services
sudo systemctl status postgresql --no-pager
sudo systemctl status casdoor --no-pager
sudo systemctl status lobechat --no-pager

# Get URLs
source /opt/casdoor/.credentials
echo ""
echo "============================================"
echo "Installation Complete!"
echo "============================================"
echo "LobeChat:  http://$PUBLIC_IP:3210"
echo "Casdoor:   http://$PUBLIC_IP:8000"
echo ""
echo "Default Casdoor admin: admin / admin123"
echo "(Change this password immediately!)"
echo "============================================"
```

---

## Accessing LobeChat

1. Open `http://<PUBLIC_IP>:3210` in your browser
2. Click "Sign in with Casdoor"
3. Login with: `admin` / `admin123`
4. Go to Settings to add AI provider API keys (OpenRouter, OpenAI, etc.)

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
sudo journalctl -u casdoor -f
```

---

## Cleanup (When Done)

Delete all resources to avoid charges:

```bash
source ~/.lobechat_aws

# Terminate instance
aws ec2 terminate-instances --instance-ids $INSTANCE_ID
aws ec2 wait instance-terminated --instance-ids $INSTANCE_ID

# Delete security group (wait for instance to terminate first)
aws ec2 delete-security-group --group-id $SG_ID

# Delete subnet
aws ec2 delete-subnet --subnet-id $SUBNET_ID

# Detach and delete internet gateway
aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID
aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID

# Delete route table (non-main)
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

### Casdoor login fails
Verify redirect URI matches exactly:
```bash
source /opt/casdoor/.credentials
echo "Expected: http://$PUBLIC_IP:3210/api/auth/callback/casdoor"
```
