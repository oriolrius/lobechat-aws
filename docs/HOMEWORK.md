# Homework: Deploy LobeChat to AWS

Deploy LobeChat to AWS using CloudFormation.

> **Cost Warning**: The EC2 instance costs ~$0.35/hour (~$8.40/day).
> **Delete the stack immediately after completing this exercise!**

## Prerequisites

- Access to ESADE Innovation Sandbox on AWS
- AWS CLI installed (`brew install awscli` or `apt install awscli`)

---

## Step 1: Get AWS Credentials

1. Go to the Innovation Sandbox portal
2. Click **"Login to account"** for your lease
3. Click **"Access keys"** next to `esadeis_IsbUsersPS`
4. Copy the export commands and run them in your terminal:

```bash
export AWS_ACCESS_KEY_ID="ASIA..."
export AWS_SECRET_ACCESS_KEY="..."
export AWS_SESSION_TOKEN="..."
export AWS_DEFAULT_REGION="eu-west-1"
```

5. Verify credentials:

```bash
aws sts get-caller-identity
```

---

## Step 2: Clone the Repository

```bash
git clone https://github.com/oriolrius/lobechat-aws.git
cd lobechat-aws
git checkout v3.x
```

---

## Step 3: Create SSH Key Pair

```bash
aws ec2 create-key-pair \
  --key-name lobechat-key \
  --query 'KeyMaterial' \
  --output text > ~/.ssh/lobechat-key.pem

chmod 400 ~/.ssh/lobechat-key.pem
```

> If the key already exists, skip this step or delete it first:
> `aws ec2 delete-key-pair --key-name lobechat-key`

---

## Step 4: Deploy CloudFormation Stack

```bash
aws cloudformation deploy \
  --template-file infra/cloudformation.yml \
  --stack-name lobechat \
  --capabilities CAPABILITY_IAM
```

This creates all AWS resources (VPC, subnet, security group, EC2 instance).

---

## Step 5: Get Stack Outputs

```bash
aws cloudformation describe-stacks \
  --stack-name lobechat \
  --query 'Stacks[0].Outputs' \
  --output table
```

Note the **PublicIP** and **LobeChatURL** values.

---

## Step 6: Wait for Installation

The EC2 instance is now installing PostgreSQL, MinIO, and LobeChat. This takes **~15 minutes**.

Monitor progress via SSH:

```bash
# Get the public IP
PUBLIC_IP=$(aws cloudformation describe-stacks \
  --stack-name lobechat \
  --query 'Stacks[0].Outputs[?OutputKey==`PublicIP`].OutputValue' \
  --output text)

# Watch installation log
ssh -i ~/.ssh/lobechat-key.pem ubuntu@$PUBLIC_IP "tail -f /var/log/user-data.log"
```

Wait until you see:

```
============================================
   INSTALLATION COMPLETE!
============================================
```

---

## Step 7: Access LobeChat

Open your browser and go to:

```
http://<PUBLIC_IP>:3210
```

You should see the LobeChat login page. Create an account and start using it.

---

## Step 8: Cleanup (MANDATORY!)

> **Do not skip this step!** Leaving the stack running will consume your AWS budget.

Delete all resources:

```bash
aws cloudformation delete-stack --stack-name lobechat
```

Wait for deletion to complete:

```bash
aws cloudformation wait stack-delete-complete --stack-name lobechat
echo "Stack deleted successfully!"
```

Or verify manually:

```bash
aws cloudformation describe-stacks --stack-name lobechat
# Should return: "Stack with id lobechat does not exist"
```

---

## Cost Reference

| Resource | Cost | If left running 24h |
|----------|------|---------------------|
| EC2 c7a.2xlarge | ~$0.35/hour | ~$8.40/day |
| EBS 20GB gp3 | ~$1.60/month | ~$0.05/day |

**This exercise should cost less than $1 if you delete the stack within 2-3 hours.**

---

## Troubleshooting

### "Credentials expired"

Refresh credentials from the Innovation Sandbox portal (Step 1).

### Stack creation failed

Check the failure reason:

```bash
aws cloudformation describe-stack-events \
  --stack-name lobechat \
  --query 'StackEvents[?ResourceStatus==`CREATE_FAILED`].[LogicalResourceId,ResourceStatusReason]' \
  --output table
```

### Can't connect via SSH

1. Wait 2-3 minutes after stack creation
2. Verify security group allows port 22
3. Check instance is running:

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=lobechat-server" \
  --query 'Reservations[0].Instances[0].State.Name'
```

### LobeChat not accessible

1. Wait for installation to complete (~15 minutes)
2. Check service status:

```bash
ssh -i ~/.ssh/lobechat-key.pem ubuntu@$PUBLIC_IP "sudo systemctl status lobechat"
```

---

## Summary

| Step | Action | Time |
|------|--------|------|
| 1 | Get AWS credentials | 1 min |
| 2 | Clone repository | 1 min |
| 3 | Create SSH key | 1 min |
| 4 | Deploy stack | 3-5 min |
| 5 | Get outputs | 1 min |
| 6 | Wait for installation | 15 min |
| 7 | Access LobeChat | - |
| 8 | **Cleanup (don't skip!)** | 2 min |

**Total time**: ~25 minutes

---

## Checklist

- [ ] Deployed CloudFormation stack
- [ ] Accessed LobeChat in browser
- [ ] Created an account and tested the app
- [ ] **Deleted the stack to avoid costs**
