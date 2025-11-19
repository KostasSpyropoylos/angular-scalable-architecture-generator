# 🤝 Contributing to Angular Scalable Architecture Generator

Thank you for your interest in contributing! This document outlines how to participate in improving this project.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Reporting Bugs](#reporting-bugs)
- [Suggesting Enhancements](#suggesting-enhancements)

---

## 🎯 Code of Conduct

We are committed to providing a welcoming and inclusive environment for all contributors. Please:

- Be respectful and constructive in all interactions
- Welcome diverse perspectives and experiences
- Focus on what's best for the community
- Report unacceptable behavior to the project maintainers

---

## 🚀 Getting Started

### 1. Fork the Repository

Click the "Fork" button on GitHub to create your own copy.

```bash
git clone https://github.com/KostasSpyropoylos/angular-scalable-architecture-generator.git
cd angular-scalable-architecture-generator
```

### 2. Add the Upstream Remote

Keep your fork in sync with the original repository:

```bash
git remote add upstream https://github.com/KostasSpyropoylos/angular-scalable-architecture-generator.git
git fetch upstream
```

### 3. Create a Feature Branch

Always create a new branch for your work:

```bash
git checkout -b feature/your-feature-name
# or for bug fixes:
git checkout -b fix/bug-description
```

### 4. Install & Test Locally

Ensure you have Node.js 18+ and the script works:

```bash
chmod +x project-generator.sh
./project-generator.sh
# Follow prompts to test the generation
```

---

## 💡 How to Contribute

### Types of Contributions We Welcome

#### 🐛 Bug Fixes
Found an issue? Let us know or submit a fix:
- Errors during app generation
- Incorrect folder structure
- Docker or Nginx configuration issues
- Authentication service bugs

#### ✨ Feature Enhancements
Ideas for new features:
- Pre-configured NgRx/Akita state management setup
- API client scaffolding (HttpClient templates)
- E2E test framework scaffolding (Cypress/Playwright)
- Environment configuration templates
- Additional component generators
- CI/CD pipeline templates (GitHub Actions, GitLab CI)

#### 📚 Documentation Improvements
- Clearer README sections
- Additional examples
- Video tutorials or walkthroughs
- Better troubleshooting guides
- Architecture decision records (ADRs)

#### 🎨 Code Quality
- Refactoring for clarity and maintainability
- Performance improvements
- Better error handling and validation
- Shell script best practices

#### 🧪 Testing
- Add test coverage for the script
- Shell script unit tests
- Generated app validation checks

---

## 🔧 Development Workflow

### Step 1: Make Your Changes

Edit `project-generator.sh` and/or related documentation.

```bash
# Example: Adding a new optional feature
nano project-generator.sh
```

### Step 2: Test Thoroughly

Test the script with various inputs:

```bash
# Test 1: Minimal setup (no optional features)
./project-generator.sh
# Answer: project name, no Docker

# Test 2: All features enabled
./project-generator.sh
# Answer: project name, yes Docker

# Test 3: Edge cases
./project-generator.sh
# Test with special characters in project name
# Test with very long project names
# Test with existing project name (should fail gracefully)
```

### Step 3: Verify Generated Output

After running the script, verify the generated app:

```bash
cd generated-project-name
ng serve --open
# Check that the app loads
# Test the mock auth service
# Verify folder structure matches expectations
```

### Step 4: Build & Run Docker (if you modified Docker setup)

```bash
cd generated-project-name
docker-compose up --build
# Visit http://localhost:8080
# Verify the app works in Docker
```

---

## 📝 Commit Guidelines

Write clear, descriptive commit messages:

### Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Code style (no logic change)
- `refactor`: Code refactoring
- `perf`: Performance improvement
- `test`: Testing improvements
- `chore`: Build, CI, dependencies

### Examples

```bash
git commit -m "feat(auth): add JWT token refresh logic to auth service"

git commit -m "fix(docker): correct Nginx SPA routing configuration"

git commit -m "docs(readme): add troubleshooting section for Docker issues"

git commit -m "refactor(script): improve error handling and user prompts"
```

---

## 🔄 Pull Request Process

### Before Submitting a PR

1. **Sync with upstream:**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Run the script end-to-end** to ensure nothing broke

3. **Test edge cases** (empty input, special characters, existing directories)

4. **Update documentation** if you changed behavior or added features

### Submitting the PR

1. Push your branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

2. Create a Pull Request on GitHub with:
   - **Clear title**: What does this PR do?
   - **Description**: Why? What changed? How to test?
   - **Link related issues**: "Closes #123"
   - **Checklist**: (see template below)

### PR Checklist

```markdown
- [ ] I have tested the script end-to-end
- [ ] I have tested edge cases and error conditions
- [ ] I have updated documentation (README, CONTRIBUTING, etc.)
- [ ] My commits follow the guidelines (clear messages, focused changes)
- [ ] I have not introduced breaking changes
- [ ] I have tested both with and without optional features
```

### Review Process

- At least one maintainer will review your PR
- We may ask for changes or clarifications
- Once approved, your PR will be merged
- Your contribution will be credited! 🎉

---

## 🧪 Testing

### Manual Testing Checklist

Before submitting a PR, test:

- [ ] Prerequisites check works (Node.js detection)
- [ ] Angular CLI installation (if not present)
- [ ] Project name validation (empty, special chars, existing dir)
- [ ] Project generation completes successfully
- [ ] Generated app structure is correct
- [ ] Auth service works (mock login with test@user.com)
- [ ] Docker build and run (if you modified Docker setup)
- [ ] Nginx routing works (SPA routes resolve correctly)
- [ ] Error messages are helpful and actionable

### Shell Script Testing (Optional but Appreciated)

If you're comfortable with shell testing:

```bash
# Use ShellCheck to lint the script
shellcheck project-generator.sh

# Fix any warnings
```

---

## 🐛 Reporting Bugs

### Before You Report

1. Check if the bug is already reported in **Issues**
2. Verify it's reproducible with a clean run of the script
3. Check your Node.js version is 18+

### Filing a Bug Report

Include:

- **Environment**: Node.js version, OS, Bash version
- **Steps to reproduce**: Exact commands you ran
- **Expected behavior**: What should happen
- **Actual behavior**: What actually happened
- **Error output**: Full error messages or logs
- **Screenshots**: If applicable

### Example Bug Report

```markdown
**Description:**
The script fails when the project name contains spaces.

**Environment:**
- Node.js: v18.16.0
- OS: macOS 13.5
- Bash: 5.1.16

**Steps to Reproduce:**
1. Run `./project-generator.sh`
2. Enter "My App" (with space) as project name
3. Confirm generation

**Expected:** Project created as "My App"
**Actual:** Error: "Failed to navigate to project directory"

**Error Output:**
```
cd: too many arguments
```

**Screenshots:**
[Paste error output]
```

---

## 💭 Suggesting Enhancements

### Before You Suggest

1. Check if the enhancement is already requested in **Issues** or **Discussions**
2. Is it aligned with the project's scope? (We focus on clean architecture scaffolding)
3. Would it benefit most users or a niche use case?

### Filing an Enhancement Suggestion

Include:

- **Description**: What would this feature do?
- **Motivation**: Why would this be useful?
- **Examples**: How would users interact with it?
- **Alternatives**: Are there other ways to solve this?

### Example Enhancement Suggestion

```markdown
**Feature Request: Pre-configured NgRx State Management**

**Description:**
Add an optional prompt to generate an NgRx store with actions, reducers, and effects 
boilerplate for common patterns (CRUD operations, auth state, etc.).

**Motivation:**
Many teams want NgRx but don't want to manually scaffold the whole store structure. 
This would save 30+ minutes of setup.

**Example Usage:**
```
🎨 Set up state management? (1: NgRx, 2: Akita, 3: Custom Signals, 4: None)
> 1
✅ NgRx store generated with sample CRUD effects
```

**Alternatives:**
- Provide NgRx schematic setup guide (less integrated)
- Let users add it manually (current approach, time-consuming)
```

---

## 📚 Resources for Contributors

### Understanding the Script

- [Bash Guide](https://www.gnu.org/software/bash/manual/)
- [Angular Documentation](https://angular.io)
- [Docker Documentation](https://docs.docker.com)
- [Nginx Configuration](https://nginx.org/en/docs/)

### Git & GitHub

- [GitHub Guides](https://guides.github.com/)
- [Git Documentation](https://git-scm.com/doc)
- [Conventional Commits](https://www.conventionalcommits.org/)

### Shell Scripting Best Practices

- [ShellCheck](https://www.shellcheck.net/) – Linter for shell scripts
- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)

---

## 🎓 First-Time Contributors

Unsure where to start? Look for issues labeled:

- `good first issue` – Perfect for newcomers
- `help wanted` – We need assistance
- `documentation` – Help improve docs
- `bug` – Fix an issue

Don't hesitate to ask questions in the issue or PR. We're here to help! 🙌

---

## 📞 Getting Help

- **Questions?** Open a Discussion or comment on an Issue
- **Need clarification?** Reach out in the PR review
- **Found a problem?** File a bug report with details
- **Have ideas?** Suggest enhancements in Discussions

---

## 🙏 Thank You!

Every contribution—no matter how small—helps make this project better. Whether you're fixing a typo, improving documentation, fixing bugs, or adding features, we appreciate your effort and look forward to collaborating with you! 

**Happy coding!** 🚀

---

**Last Updated:** November 2025  
**Maintained by:** Kostas Spyropoylos & Contributors
