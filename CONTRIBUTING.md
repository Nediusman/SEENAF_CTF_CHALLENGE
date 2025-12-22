# 🤝 Contributing to SEENAF CTF Platform

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

---

## 🎯 Ways to Contribute

- 🐛 **Report bugs** - Found a bug? Open an issue
- 💡 **Suggest features** - Have an idea? We'd love to hear it
- 📝 **Improve documentation** - Help others understand the project
- 🔧 **Fix issues** - Pick an issue and submit a PR
- 🎨 **Design improvements** - Enhance the UI/UX
- 🏆 **Add challenges** - Create new CTF challenges

---

## 🚀 Getting Started

### 1. Fork and Clone

```bash
# Fork the repository on GitHub
# Then clone your fork
git clone https://github.com/YOUR_USERNAME/seenaf-ctf-platform.git
cd seenaf-ctf-platform

# Add upstream remote
git remote add upstream https://github.com/ORIGINAL_OWNER/seenaf-ctf-platform.git
```

### 2. Set Up Development Environment

```bash
# Install dependencies
npm install

# Set up Supabase
npm run setup

# Verify setup
npm run verify

# Start development server
npm run dev
```

### 3. Create a Branch

```bash
# Create a feature branch
git checkout -b feature/your-feature-name

# Or a bugfix branch
git checkout -b fix/bug-description
```

---

## 📝 Development Guidelines

### Code Style

- **TypeScript**: Use TypeScript for all new code
- **ESLint**: Follow the ESLint configuration
- **Prettier**: Format code with Prettier
- **Naming**: Use descriptive, camelCase names

### Component Structure

```typescript
// Good component structure
import { useState } from 'react';
import { Button } from '@/components/ui/button';

interface MyComponentProps {
  title: string;
  onAction: () => void;
}

export function MyComponent({ title, onAction }: MyComponentProps) {
  const [state, setState] = useState(false);
  
  return (
    <div>
      <h2>{title}</h2>
      <Button onClick={onAction}>Action</Button>
    </div>
  );
}
```

### File Organization

```
src/
├── components/
│   ├── ui/              # Reusable UI components
│   ├── challenges/      # Challenge-specific components
│   └── layout/          # Layout components
├── pages/               # Route components
├── hooks/               # Custom React hooks
├── utils/               # Utility functions
├── types/               # TypeScript types
└── integrations/        # External integrations
```

---

## 🧪 Testing

### Before Submitting

1. **Test your changes**
   ```bash
   npm run dev
   # Test in browser
   ```

2. **Check for errors**
   ```bash
   npm run lint
   ```

3. **Build successfully**
   ```bash
   npm run build
   ```

4. **Verify setup still works**
   ```bash
   npm run verify
   ```

---

## 📤 Submitting Changes

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```bash
# Feature
git commit -m "feat: add challenge filtering by difficulty"

# Bug fix
git commit -m "fix: resolve admin panel permission issue"

# Documentation
git commit -m "docs: update setup guide with troubleshooting"

# Style changes
git commit -m "style: improve challenge card layout"

# Refactoring
git commit -m "refactor: simplify authentication logic"

# Performance
git commit -m "perf: optimize challenge loading"

# Tests
git commit -m "test: add tests for flag submission"
```

### Pull Request Process

1. **Update your branch**
   ```bash
   git fetch upstream
   git rebase upstream/main
   ```

2. **Push your changes**
   ```bash
   git push origin feature/your-feature-name
   ```

3. **Create Pull Request**
   - Go to GitHub and create a PR
   - Fill out the PR template
   - Link related issues
   - Add screenshots if UI changes

4. **PR Template**
   ```markdown
   ## Description
   Brief description of changes
   
   ## Type of Change
   - [ ] Bug fix
   - [ ] New feature
   - [ ] Documentation update
   - [ ] Performance improvement
   
   ## Testing
   - [ ] Tested locally
   - [ ] No console errors
   - [ ] Build succeeds
   
   ## Screenshots (if applicable)
   Add screenshots here
   
   ## Related Issues
   Closes #123
   ```

---

## 🏆 Adding New Challenges

### Challenge Structure

```sql
INSERT INTO challenges (
  title,
  description,
  category,
  difficulty,
  points,
  flag,
  hints,
  tags,
  author
) VALUES (
  'Challenge Title',
  'Detailed description of the challenge',
  'web',  -- web, crypto, forensics, network, reverse, pwn, osint, stego, misc
  'easy',  -- easy, medium, hard
  100,
  'flag{your_flag_here}',
  ARRAY['Hint 1', 'Hint 2'],
  ARRAY['tag1', 'tag2'],
  'Your Name'
);
```

### Challenge Guidelines

1. **Clear Description**: Explain what the user needs to do
2. **Appropriate Difficulty**: Match points to difficulty
3. **Valid Flag**: Use format `flag{...}` or `SEENAF{...}`
4. **Helpful Hints**: Provide progressive hints
5. **Educational Value**: Teach a real security concept

---

## 🐛 Reporting Bugs

### Bug Report Template

```markdown
**Describe the bug**
A clear description of what the bug is.

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What you expected to happen.

**Screenshots**
If applicable, add screenshots.

**Environment:**
- OS: [e.g., Windows 11]
- Browser: [e.g., Chrome 120]
- Node.js version: [e.g., 18.17.0]

**Additional context**
Any other relevant information.
```

---

## 💡 Feature Requests

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
A clear description of the problem.

**Describe the solution you'd like**
What you want to happen.

**Describe alternatives you've considered**
Other solutions you've thought about.

**Additional context**
Any other relevant information.
```

---

## 📚 Documentation

### Documentation Guidelines

- **Clear and Concise**: Use simple language
- **Examples**: Provide code examples
- **Screenshots**: Add visuals where helpful
- **Up-to-date**: Keep docs in sync with code
- **Organized**: Use proper headings and structure

### Documentation Files

- `README.md` - Project overview
- `SETUP_GUIDE.md` - Detailed setup instructions
- `QUICK_START.md` - Quick setup guide
- `PLATFORM_SPECIFIC_SETUP.md` - OS-specific instructions
- `DEPLOYMENT_CHECKLIST.md` - Deployment guide
- `CONTRIBUTING.md` - This file

---

## 🎨 Design Guidelines

### UI/UX Principles

- **Consistency**: Follow existing design patterns
- **Accessibility**: Ensure WCAG 2.1 AA compliance
- **Responsive**: Test on mobile, tablet, desktop
- **Performance**: Optimize images and assets
- **Dark Theme**: Maintain the hacker aesthetic

### Color Palette

```css
/* Primary Colors */
--primary: #00ff00;      /* Matrix green */
--background: #0a0a0a;   /* Dark background */
--foreground: #ffffff;   /* White text */

/* Accent Colors */
--accent: #00ffff;       /* Cyan */
--warning: #ffff00;      /* Yellow */
--error: #ff0000;        /* Red */
```

---

## 🔒 Security

### Reporting Security Issues

**DO NOT** open public issues for security vulnerabilities.

Instead:
1. Email: security@seenaf.com
2. Include detailed description
3. Provide steps to reproduce
4. Suggest a fix if possible

We'll respond within 48 hours.

---

## 📜 Code of Conduct

### Our Standards

- **Be Respectful**: Treat everyone with respect
- **Be Inclusive**: Welcome diverse perspectives
- **Be Constructive**: Provide helpful feedback
- **Be Professional**: Maintain professionalism

### Unacceptable Behavior

- Harassment or discrimination
- Trolling or insulting comments
- Personal attacks
- Publishing private information
- Other unprofessional conduct

---

## 🏅 Recognition

Contributors will be:
- Listed in `CONTRIBUTORS.md`
- Mentioned in release notes
- Credited in the application (for major contributions)

---

## 📞 Questions?

- 💬 **Discussions**: Use GitHub Discussions for questions
- 📧 **Email**: nediusman92@gmail.com
- 🐛 **Issues**: Use GitHub Issues for bugs

---

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

**Thank you for contributing to SEENAF CTF Platform! 🎉**

Your contributions help make cybersecurity education accessible to everyone.
