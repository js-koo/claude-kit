---
description: Audit session for security and best practices
---

# /audit - Session Audit

Perform a security and best practices audit of the current session's activities.

## Instructions

Review the session and check for:

### 1. Security Issues
- Sensitive data in commits (API keys, passwords, tokens)
- Insecure file permissions
- Hardcoded credentials in code
- Exposed secrets in logs or output

### 2. Git Hygiene
- Uncommitted changes
- Large files that should be in .gitignore
- Sensitive files in staging area
- Merge conflicts

### 3. Code Quality
- TODO/FIXME comments added
- Console.log/print statements left in
- Commented-out code blocks
- Missing error handling

### 4. File Checks
```bash
# Check for potential secrets
git diff --cached --name-only | xargs grep -l -E "(password|secret|api_key|token)" 2>/dev/null

# Check for large files
find . -type f -size +1M -not -path "./.git/*" 2>/dev/null

# Check .env files
ls -la .env* 2>/dev/null
```

## Output Format

```
Session Audit Report
====================

Security:
  [OK] No secrets detected in staged files
  [WARN] .env file exists - ensure it's in .gitignore

Git:
  [OK] No uncommitted changes
  [INFO] 3 files modified in this session

Code:
  [WARN] 2 TODO comments added
  [OK] No debug statements detected

Recommendations:
  - Review .env handling
  - Address TODO items before merging
```

## Severity Levels

- `[OK]` - No issues found
- `[INFO]` - Informational, no action needed
- `[WARN]` - Should be addressed
- `[ERROR]` - Must be fixed before proceeding
