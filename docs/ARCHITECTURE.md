# LobeChat AWS Architecture

This document describes the AWS infrastructure deployed by the CloudFormation template.

## Architecture Diagram

![LobeChat AWS Architecture](images/architecture.png)

## Components

### Networking

| Component | Description | Configuration |
|-----------|-------------|---------------|
| **VPC** | Isolated virtual network | CIDR: 10.0.0.0/16, DNS enabled |
| **Internet Gateway** | Enables internet connectivity | Attached to VPC |
| **Public Subnet** | Hosts the EC2 instance | CIDR: 10.0.1.0/24, AZ: eu-west-1b |
| **Route Table** | Routes traffic to internet | 0.0.0.0/0 → Internet Gateway |

### Security

| Component | Description | Rules |
|-----------|-------------|-------|
| **Security Group** | Firewall for EC2 instance | Inbound ports: 22, 3210, 9000, 9001 |

#### Open Ports

| Port | Service | Purpose |
|------|---------|---------|
| 22 | SSH | Remote administration |
| 3210 | LobeChat | Web application |
| 9000 | MinIO S3 API | File storage API |
| 9001 | MinIO Console | Storage management UI |

### Compute

| Component | Description | Specifications |
|-----------|-------------|----------------|
| **EC2 Instance** | Application server | c7a.2xlarge (8 vCPU, 16GB RAM) |
| **OS** | Operating system | Ubuntu 24.04 LTS |
| **Storage** | Root volume | 20GB gp3 EBS |

### Application Stack

The EC2 instance runs three services:

| Service | Version | Purpose |
|---------|---------|---------|
| **PostgreSQL** | 16 | Database with pgvector extension for AI embeddings |
| **MinIO** | Latest | S3-compatible object storage for file uploads |
| **LobeChat** | Latest | AI chat application (Next.js) |

## Data Flow

1. **User** accesses LobeChat via browser at `http://<PUBLIC_IP>:3210`
2. Traffic enters AWS through the **Internet Gateway**
3. **Route Table** directs traffic to the **Public Subnet**
4. **Security Group** allows traffic on port 3210
5. **EC2 Instance** serves the LobeChat application
6. LobeChat stores data in **PostgreSQL** and files in **MinIO**

## CloudFormation Template

The infrastructure is defined in [`infra/cloudformation.yml`](../infra/cloudformation.yml).

### Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| `InstanceType` | c7a.2xlarge | EC2 instance size |
| `KeyPairName` | lobechat-key | SSH key pair name |
| `VolumeSize` | 20 | EBS volume size (GB) |
| `DBPassword` | lobechat-db-password | PostgreSQL password |
| `MinIOPassword` | lobechat-minio-secret | MinIO root password |

### Outputs

| Output | Description |
|--------|-------------|
| `PublicIP` | EC2 instance public IP address |
| `LobeChatURL` | LobeChat application URL |
| `MinIOConsoleURL` | MinIO management console URL |
| `SSHCommand` | SSH connection command |

## Cost Considerations

| Resource | Approximate Cost |
|----------|------------------|
| EC2 c7a.2xlarge | ~$0.35/hour |
| EBS 20GB gp3 | ~$1.60/month |
| Data transfer | Varies by usage |

**Tip**: Stop the EC2 instance when not in use to save costs. The public IP will change after restart.
