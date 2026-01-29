# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

GitHub Actions Practice - A hands-on exercise for ESADE students to learn CI/CD workflows, conventional commits, and pull request processes.

> For EC2 deployment instructions, see branch `v1.x`.

## Repository Structure

```
.
├── .github/workflows/
│   ├── ci.yml           # Lint and type checks on push/PR
│   ├── commitlint.yml   # Validates conventional commit messages
│   └── release.yml      # Auto-creates releases on version tags
├── README.md            # Quick start and solution steps
├── HOMEWORK.md          # Student exercise instructions
├── CONTRIBUTING.md      # Contribution guidelines
├── CLAUDE.md            # This file
└── .gitignore
```

## GitHub Actions Workflows

| Workflow | File | Trigger | Purpose |
|----------|------|---------|---------|
| CI | `ci.yml` | Push/PR to v2.x | Clones LobeChat, runs type-check and lint |
| Commit Lint | `commitlint.yml` | PR to v2.x | Validates commit messages follow conventional format |
| Release | `release.yml` | Tag `v*.*.*` | Creates GitHub release with source archives |

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
feat: add new workflow
ci: update Node.js version
```

## Homework Exercise

Students practice the fork/PR workflow:

1. Fork the repository
2. Edit `HOMEWORK.md` - add name to the list
3. Commit with `docs: add <name> to homework`
4. Push and create PR to `v2.x`
5. Verify CI workflows pass (green checkmarks)

## Common Operations

```bash
# Check commit message format locally
npx commitlint --from HEAD~1 --to HEAD

# View workflow runs (requires gh CLI)
gh run list

# Create a release tag
git tag -a v2.0.0 -m "Release v2.0.0"
git push origin v2.0.0
```

## Branch Strategy

| Branch | Purpose |
|--------|---------|
| `v1.x` | EC2 deployment documentation |
| `v2.x` | GitHub Actions practice (this branch) |
