# Contributing

## Commit Convention

This project follows [Conventional Commits](https://www.conventionalcommits.org/).

### Format

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types

| Type | Description |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `docs` | Documentation only |
| `style` | Formatting, no code change |
| `refactor` | Code change, no new feature or bug fix |
| `perf` | Performance improvement |
| `test` | Adding tests |
| `build` | Build system or dependencies |
| `ci` | CI configuration |
| `chore` | Other changes |
| `revert` | Revert previous commit |

### Examples

```bash
feat: add new installation step for Redis
fix(docs): correct typo in architecture diagram
docs: update README with cost warnings
ci: add release workflow with assets
```

## Versioning

This project uses [Semantic Versioning](https://semver.org/):

- **MAJOR** (x.0.0): Breaking changes
- **MINOR** (0.x.0): New features, backwards compatible
- **PATCH** (0.0.x): Bug fixes, backwards compatible

### Creating a Release

1. Ensure all changes are committed following the commit convention
2. Create and push a tag:
   ```bash
   git tag v2.1.0
   git push origin v2.1.0
   ```
3. The release workflow automatically:
   - Generates release notes from commits
   - Creates source archives (.zip, .tar.gz)
   - Publishes the GitHub release

## Pull Requests

1. Create a branch from `v2.x`
2. Make changes with conventional commits
3. Open PR against `v2.x`
4. CI will validate:
   - Commit messages (commitlint)
   - LobeChat type checking and linting
