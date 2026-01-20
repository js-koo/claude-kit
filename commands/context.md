---
description: Show current project context and status
---

# /context - Project Context

Display comprehensive information about the current project state.

## Instructions

Gather and display the following information:

### 1. Git Status
```bash
git status --short
git branch --show-current
git log --oneline -5
```

### 2. Project Structure
- Show top-level directories
- Identify project type (Node.js, Python, Go, etc.)
- List configuration files present

### 3. Recent Activity
- Recently modified files (last 24 hours)
- Uncommitted changes summary

### 4. Environment
- Current working directory
- Active branch
- Remote repository URL

## Output Format

```
Project: {project name}
Type: {Node.js/Python/Go/etc}
Branch: {current branch}
Remote: {origin URL}

Recent Commits:
  {hash} {message}
  ...

Modified Files:
  M {file}
  A {file}
  ...

Key Files:
  - package.json / pyproject.toml / go.mod
  - README.md
  - .env.example
```

Keep the output concise and scannable.
