# Contributing to Medical App

Thank you for your interest in contributing to the Medical App project. This document provides guidelines for contributing to the project.

## Code of Conduct

- Be respectful and professional
- Maintain confidentiality of proprietary code
- Report security vulnerabilities privately
- Collaborate constructively with team members

## Development Workflow

### 1. Feature Branch Strategy

```bash
# Create a feature branch
git checkout -b feature/feature-name
git checkout -b bugfix/bug-name
git checkout -b hotfix/hotfix-name
```

### 2. Commit Message Format

Follow conventional commits:

```
type(scope): subject

body

footer
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

**Example**:
```
feat(auth): add two-factor authentication

Implement JWT-based 2FA for enhanced security

Closes #123
```

### 3. Branch Naming

- `feature/user-authentication`
- `bugfix/login-crash`
- `hotfix/security-patch`
- `docs/api-documentation`

## Code Quality Standards

### Flutter/Dart

1. **Linting**
   ```bash
   flutter analyze
   dart fix --apply
   ```

2. **Formatting**
   ```bash
   dart format .
   ```

3. **Testing**
   ```bash
   flutter test
   ```

### Code Review Checklist

- [ ] Code follows style guide
- [ ] No console errors or warnings
- [ ] Tests added/updated
- [ ] Documentation updated
- [ ] No hardcoded values
- [ ] Performance optimized
- [ ] Security reviewed

## Pull Request Process

1. **Before submitting PR:**
   ```bash
   git pull origin develop
   flutter clean
   flutter pub get
   flutter analyze
   flutter test
   ```

2. **PR Title Format**:
   ```
   [TYPE] Short description
   ```
   Examples: `[FEATURE]`, `[BUGFIX]`, `[DOCS]`, `[REFACTOR]`

3. **PR Description**:
   - Description of changes
   - Related issues/tickets
   - Testing performed
   - Screenshots (if UI changes)

4. **Merge Requirements**:
   - ✅ All tests pass
   - ✅ Code review approved
   - ✅ No conflicts
   - ✅ Documentation updated

## Git Workflow

### Main Branches

- `main`: Production-ready code
- `develop`: Development branch for next release
- `staging`: Pre-production testing

### Working with Develop Branch

```bash
# Clone repository
git clone https://github.com/yourusername/medical_app.git
cd medical_app

# Switch to develop
git checkout develop
git pull origin develop

# Create feature branch
git checkout -b feature/my-feature

# Work on your changes...

# Commit with conventional message
git add .
git commit -m "feat(assessment): add new assessment type"

# Push to remote
git push origin feature/my-feature

# Create Pull Request on GitHub
```

## Merge Strategy

```bash
# Squash commits for cleaner history
git merge --squash feature/my-feature
```

## Version Numbering (Semantic Versioning)

- **MAJOR.MINOR.PATCH** (e.g., 1.2.3)
- MAJOR: Breaking changes
- MINOR: New features (backward compatible)
- PATCH: Bug fixes

## Documentation

- Update README.md for new features
- Add inline comments for complex logic
- Document API changes
- Include examples

## Security Guidelines

- Never commit sensitive data (keys, passwords)
- Use environment variables for secrets
- Validate all user input
- Review dependencies for vulnerabilities

## Release Process

1. Create release branch: `git checkout -b release/v1.2.0`
2. Update version in pubspec.yaml
3. Update CHANGELOG.md
4. Create Pull Request to main
5. After merge, tag release: `git tag -a v1.2.0 -m "Release version 1.2.0"`
6. Push tag: `git push origin v1.2.0`

