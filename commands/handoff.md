---
description: Generate session handoff document for continuity
---

# /handoff - Session Handoff

Create a Handoff.md document that captures the current session state for seamless continuation in the next session.

## Instructions

1. If `./Handoff.md` exists, delete it first
2. Analyze the current session to understand:
   - What was the goal?
   - What has been accomplished?
   - What problems were encountered?
   - What files were modified?
   - What should be done next?
3. Create `./Handoff.md` using the template below

## Handoff.md Template

```markdown
# {Project Name} - Handoff

## Goal
{One-line summary of the current task/objective}

## Context
{Background information and why this work is being done}

## Done
- {List of completed tasks}

## Learned
### What Worked
- {Approaches that were effective}

### What Didn't Work
- {Approaches that had problems and why}

## Next
1. {Prioritized list of next steps}

## Key Files
- `{file path}` - {brief description of its role}
```

## After Creation

Display:
```
Handoff.md created successfully.

To continue in a new session:
1. Run /clear
2. Say "Read Handoff.md and continue"
```

Note: /clear must be run manually - it cannot be executed automatically.
