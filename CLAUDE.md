# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LobeChat AWS Infrastructure as Code - Automated deployment of LobeChat to AWS using CloudFormation and GitHub Actions.

> **Branch Goals**:
> - Pass all CI/CD tests from v2.x (lint, type-check, commitlint)
> - Deploy infrastructure to AWS via CloudFormation
> - Automate deployment through GitHub Actions workflows

## Repository Structure

```
.
├── .github/workflows/
│   ├── ci.yml           # Lint and type checks on push/PR
│   ├── commitlint.yml   # Validates conventional commit messages
│   ├── release.yml      # CI checks + auto-creates releases on tags
│   └── deploy.yml       # CloudFormation deployment to AWS
├── infra/
│   └── cloudformation.yml  # AWS infrastructure template
├── docs/
│   ├── CI-CD.md         # Detailed CI/CD pipeline documentation
│   ├── HOMEWORK.md      # Student exercise instructions
│   ├── images/          # PNG exports of diagrams
│   └── diagrams/        # Draw.io source files
├── README.md            # Quick start and solution steps
├── CONTRIBUTING.md      # Contribution guidelines
├── CLAUDE.md            # This file
└── .gitignore
```

## GitHub Actions Workflows

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| CI | `ci.yml` | Push/PR to v3.x | Clones LobeChat, runs type-check and lint |
| Commit Lint | `commitlint.yml` | PR to v3.x | Validates commit messages follow conventional format |
| Release | `release.yml` | Tag `v*.*.*` | Runs CI checks first, then creates GitHub release |
| Deploy | `deploy.yml` | Manual/Release | Deploys CloudFormation stack to AWS |

> **Note**: Release workflow waits for CI to pass before creating a release. See [docs/CI-CD.md](docs/CI-CD.md) for details.

## AWS Infrastructure

The CloudFormation template (`infra/cloudformation.yml`) creates:

| Resource | Description |
|----------|-------------|
| VPC | Isolated network (10.0.0.0/16) |
| Internet Gateway | Enables internet access |
| Public Subnet | Hosts EC2 instance (10.0.1.0/24) |
| Route Table | Routes traffic through IGW |
| Security Group | Opens ports 22 (SSH), 3210 (LobeChat), 9000 (MinIO) |
| EC2 Instance | c7a.2xlarge with Ubuntu 24.04, runs LobeChat |
| Key Pair | SSH access to instance |

### Required GitHub Secrets

| Secret | Description |
|--------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS access key for deployment |
| `AWS_SECRET_ACCESS_KEY` | AWS secret key |
| `AWS_SESSION_TOKEN` | AWS session token (for temporary credentials) |
| `AWS_REGION` | AWS region (default: eu-west-1) |

## Conventional Commits

All commits must follow the [Conventional Commits](https://conventionalcommits.org) specification:

```
<type>: <description>
```

**Valid types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `ci`, `chore`

**Examples**:
```bash
docs: add student-name to homework
fix: correct typo in README
feat: add CloudFormation template
ci: add deploy workflow
```

## Common Operations

```bash
# Check commit message format locally
npx commitlint --from HEAD~1 --to HEAD

# View workflow runs (requires gh CLI)
gh run list

# Create a release tag
git tag -a v3.0.0 -m "Release v3.0.0"
git push origin v3.0.0

# Validate CloudFormation template
aws cloudformation validate-template --template-body file://infra/cloudformation.yml

# Deploy stack manually
aws cloudformation deploy \
  --template-file infra/cloudformation.yml \
  --stack-name lobechat \
  --capabilities CAPABILITY_IAM
```

## Branch Strategy

| Branch | Purpose |
|--------|---------|
| `v1.x` | EC2 deployment documentation (manual) |
| `v2.x` | GitHub Actions practice |
| `v3.x` | Infrastructure as Code with CloudFormation (this branch) |
