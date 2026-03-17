# Homework: Deploy LobeChat to AWS

Deploy LobeChat to AWS using CloudFormation and Ansible.

---

> **IMPORTANT: DELETE YOUR STACK WHEN FINISHED**
>
> The EC2 instance costs **~$0.35/hour** (~$8.40/day). Delete the stack immediately after completing this exercise!
>
> ```bash
> aws cloudformation delete-stack --stack-name lobechat
> ```
>
> **Do not leave the stack running overnight!**

---

## Prerequisites

- Access to ESADE Innovation Sandbox on AWS
- AWS CLI installed (`brew install awscli` or `apt install awscli`)
- uv installed (`curl -LsSf https://astral.sh/uv/install.sh | sh`)

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
git checkout v5.x
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

## Step 4: Deploy CloudFormation Stack (~3-4 min)

```bash
aws cloudformation deploy \
  --template-file infra/cloudformation.yml \
  --stack-name lobechat \
  --capabilities CAPABILITY_IAM
```

This creates the AWS infrastructure (VPC, subnet, security group, EC2 instance).

---

## Step 5: Get Stack Outputs

```bash
aws cloudformation describe-stacks \
  --stack-name lobechat \
  --query 'Stacks[0].Outputs' \
  --output table
```

Note the **PublicIP** value.

---

## Step 6: Create Ansible Inventory

```bash
PUBLIC_IP=$(aws cloudformation describe-stacks \
  --stack-name lobechat \
  --query 'Stacks[0].Outputs[?OutputKey==`PublicIP`].OutputValue' \
  --output text)

sed "s/<PUBLIC_IP>/$PUBLIC_IP/" ansible/inventory.yml.template > ansible/inventory.yml

echo "Inventory created with IP: $PUBLIC_IP"
```

---

## Step 7: Run Ansible Playbook (~12-15 min)

Wait 1-2 minutes for the EC2 instance to be ready, then run:

```bash
uv run ansible-playbook -i ansible/inventory.yml ansible/playbook.yml
```

This will:
- Install PostgreSQL 16 with pgvector (~2 min)
- Install and configure MinIO (~1 min)
- Install Node.js, pnpm, and bun (~2 min)
- Clone LobeChat repository (~1 min)
- Install dependencies with `pnpm install` (~3 min)
- Build LobeChat with `pnpm build` (~5-6 min)
- Run database migrations and start services (~1 min)

Watch the real-time progress. When complete, you'll see:

```
============================================
   INSTALLATION COMPLETE!
============================================

LobeChat is now running at:
   http://<PUBLIC_IP>:3210
```

---

## Step 8: Access LobeChat

Open your browser and go to:

```
http://<PUBLIC_IP>:3210
```

You should see the LobeChat login page. Create an account and start using it.

---

## Step 9: Capture Evidence for Submission

> **Do this BEFORE deleting the stack!**

### What to Submit on eCampus (Moodle)

Take the following screenshots and upload them to the assignment on eCampus:

1. **Ansible PLAY RECAP** — Terminal screenshot showing the final recap with `ok`, `changed`, and `failed=0` counts.

2. **LobeChat running in the browser** — Screenshot of the LobeChat interface at `http://<PUBLIC_IP>:3210` showing a working session (e.g., the chat page after creating an account).

3. **Stack deletion confirmation** — Screenshot of the terminal after running the cleanup commands, showing the stack no longer exists.

---

## Step 10: Cleanup (MANDATORY!)

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

### Ansible connection refused

1. Wait 2-3 minutes after stack creation for the instance to boot
2. Verify the IP in inventory.yml matches the stack output
3. Test SSH manually:

```bash
ssh -i ~/.ssh/lobechat-key.pem ubuntu@$PUBLIC_IP
```

### Ansible playbook fails

Re-run the playbook (Ansible is idempotent):

```bash
uv run ansible-playbook -i ansible/inventory.yml ansible/playbook.yml
```

Check specific task output for errors.

### LobeChat not accessible after Ansible completes

1. Wait 1-2 minutes for services to start
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
| 4 | Deploy CloudFormation stack | 3-4 min |
| 5 | Get stack outputs | 1 min |
| 6 | Create Ansible inventory | 1 min |
| 7 | Run Ansible playbook | 12-15 min |
| 8 | Access LobeChat | - |
| 9 | **Capture screenshots for submission** | 2 min |
| 10 | **Cleanup (don't skip!)** | 2 min |

**Total time: ~20-25 minutes**

---

## Checklist

- [ ] Deployed CloudFormation stack
- [ ] Ran Ansible playbook successfully
- [ ] Accessed LobeChat in browser
- [ ] Created an account and tested the app
- [ ] **Captured screenshots for eCampus submission**
- [ ] **Deleted the stack to avoid costs**
