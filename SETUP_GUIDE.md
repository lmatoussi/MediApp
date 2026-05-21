# Professional Repository Setup Guide

## Step-by-Step Instructions to Create and Push Your Medical App Repository

### Phase 1: Local Repository Setup

#### Step 1: Initialize Git Repository
```bash
cd c:\Users\PC\Desktop\medical_app
git init
```

#### Step 2: Verify .gitignore
Your .gitignore is already configured. Verify it includes:
- ✅ Flutter build artifacts
- ✅ IDE files (.idea, .vscode)
- ✅ Dependencies (.dart_tool, .pub-cache)

#### Step 3: Stage All Files
```bash
git add .
```

#### Step 4: Create Initial Commit
```bash
git commit -m "chore: initial project setup

- Add Flutter medical assessment application
- Configure multi-language support (en, fr, ar)
- Set up authentication system
- Add assessment management module
- Include admin dashboard
- Configure database layer with SQLite

Co-authored-by: Copilot <223556219+Copilot@users.noreply.github.com>"
```

---

### Phase 2: Remote Repository Setup (GitHub)

#### Step 1: Create GitHub Repository

1. Go to https://github.com/new
2. Fill in the following:
   - **Repository name**: `medical_app`
   - **Description**: "Professional medical assessment platform with Flutter"
   - **Privacy**: Select "Private" (recommended for proprietary code)
   - **DO NOT** initialize with README (we already have one)
   - **DO NOT** add .gitignore (we already have one)
   - **DO NOT** add license (unless you have one)

3. Click "Create repository"

#### Step 2: Add Remote Repository
```bash
git remote add origin https://github.com/yourusername/medical_app.git
```

Replace `yourusername` with your actual GitHub username.

#### Step 3: Create Main Branch
```bash
git branch -M main
```

#### Step 4: Push to Remote
```bash
git push -u origin main
```

---

### Phase 3: Branch Strategy Setup

#### Create Develop Branch for Development
```bash
git checkout -b develop
git push -u origin develop
```

#### Set Default Branch to Main
1. Go to GitHub repository settings
2. Under "Default branch", select "main"
3. Save

---

### Phase 4: Protect Main Branch (Recommended)

1. Go to GitHub repository → Settings → Branches
2. Click "Add rule" under "Branch protection rules"
3. Configure:
   - **Branch name pattern**: `main`
   - ✅ Require pull request reviews before merging
   - ✅ Require status checks to pass before merging
   - ✅ Require code reviews before merging
   - ✅ Dismiss stale pull request approvals
   - ✅ Require branches to be up to date before merging

---

### Phase 5: Continuous Integration Setup (Optional but Recommended)

#### Create GitHub Actions Workflow
Create file: `.github/workflows/flutter.yml`

```yaml
name: Flutter CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    
    - name: Set up Flutter
      uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.11.0'
    
    - name: Get dependencies
      run: flutter pub get
    
    - name: Analyze code
      run: flutter analyze
    
    - name: Format check
      run: dart format --set-exit-if-changed .
    
    - name: Run tests
      run: flutter test
```

---

### Phase 6: Documentation Setup

✅ Already created:
- `README.md` - Project overview and setup
- `CONTRIBUTING.md` - Contribution guidelines
- `CHANGELOG.md` - Version history

---

### Phase 7: Secrets Management

#### Add GitHub Secrets (if needed for API keys)
1. Go to Settings → Secrets and variables → Actions
2. Click "New repository secret"
3. Add required secrets:
   - `API_KEY` (if applicable)
   - `DATABASE_URL` (if applicable)

---

### Complete Git Workflow Commands

```bash
# Initial setup (run once)
cd c:\Users\PC\Desktop\medical_app
git init
git add .
git commit -m "chore: initial project setup"
git branch -M main
git remote add origin https://github.com/yourusername/medical_app.git
git push -u origin main

# Create develop branch
git checkout -b develop
git push -u origin develop

# For future feature development
git checkout -b feature/feature-name develop
# ... make changes ...
git add .
git commit -m "feat(scope): description"
git push origin feature/feature-name
# Create Pull Request on GitHub
```

---

### Best Practices Checklist

- ✅ Repository initialized with git
- ✅ .gitignore properly configured
- ✅ README.md with comprehensive documentation
- ✅ CONTRIBUTING.md for team guidelines
- ✅ CHANGELOG.md for version tracking
- ✅ Semantic versioning (1.0.0)
- ✅ Branch protection rules enabled
- ✅ Main branch as production-ready
- ✅ Develop branch for active development
- ✅ Private repository (if proprietary)
- ✅ Conventional commit messages
- ✅ Professional code review process

---

### Useful Git Commands Reference

```bash
# Check status
git status

# View commit history
git log --oneline -10

# Create new branch
git checkout -b feature/name

# Switch branches
git checkout branch-name

# Merge branch
git merge branch-name

# Push changes
git push origin branch-name

# Pull latest changes
git pull origin branch-name

# Add remote
git remote add name url

# View remotes
git remote -v

# Undo last commit (keep changes)
git reset --soft HEAD~1

# Force push (use carefully!)
git push -f origin branch-name
```

---

### Troubleshooting

**Issue**: "fatal: not a git repository"
**Solution**: Run `git init` in your project directory

**Issue**: "fatal: The current branch main has no upstream branch"
**Solution**: Run `git push -u origin main`

**Issue**: Authentication failed
**Solution**: 
- Use SSH key or Personal Access Token
- Set up SSH: https://docs.github.com/en/authentication/connecting-to-github-with-ssh

---

## Next Steps

1. ✅ Complete Phase 1-6 above
2. Set up CI/CD (GitHub Actions)
3. Configure code quality tools
4. Add team members as collaborators
5. Set up project board for issue tracking
6. Document API endpoints
7. Create release procedures

---

**Repository is now production-ready!** 🚀

