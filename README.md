# LobeChat AWS - GitHub Actions Practice

This branch (`v2.x`) focuses on **CI/CD practice** with GitHub Actions.

> For EC2 deployment instructions, see branch `v1.x`.

---

## Homework

**[HOMEWORK.md](HOMEWORK.md)** - Add your name to practice GitHub workflows.

### Solution Steps

```bash
# 1. Fork this repo on GitHub (click Fork button)

# 2. Clone your fork
git clone https://github.com/<YOUR-USERNAME>/lobechat-aws.git
cd lobechat-aws
git checkout v2.x

# 3. Edit HOMEWORK.md - add your name to the list

# 4. Commit with conventional message
git add HOMEWORK.md
git commit -m "docs: add <your-name> to homework"

# 5. Push to your fork
git push origin v2.x

# 6. Create Pull Request
#    - Go to your fork on GitHub
#    - Click "Contribute" → "Open pull request"
#    - Base: oriolrius/lobechat-aws v2.x ← Head: your-fork v2.x
#    - Create pull request

# 7. Watch CI workflows run in the "Checks" tab
```

---

## What You'll Learn

| Concept | Where |
|---------|-------|
| Fork & Clone | Steps 1-2 |
| Conventional Commits | Step 4 |
| Pull Requests | Steps 5-6 |
| CI/CD Pipelines | Step 7 |

---

## Workflows

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `ci.yml` | Push/PR to v2.x | Lint & type check |
| `commitlint.yml` | PR to v2.x | Validate commit messages |
| `release.yml` | Tag `v*.*.*` | Auto-create releases |

> **Deep Dive**: See [docs/CI-CD.md](docs/CI-CD.md) for detailed pipeline documentation with diagrams.

---

## Commit Convention

Messages must follow [Conventional Commits](https://conventionalcommits.org):

```
<type>: <description>
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `ci`, `chore`

Examples:
```bash
docs: add john-doe to homework
fix: correct typo in README
feat: add new workflow
```

---

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for full guidelines.

---

## Branches

| Branch | Purpose |
|--------|---------|
| `v1.x` | EC2 deployment guide |
| `v2.x` | GitHub Actions practice (this branch) |
