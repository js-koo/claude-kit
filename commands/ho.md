---
description: Session handoff (short alias)
---

# /ho - Session Handoff (Short)

Short alias for `/handoff`. Manage session handoff documents for seamless continuation between sessions.

## Usage

- `/ho w` - Create a Handoff.md document
- `/ho r` - Read existing Handoff.md and continue work

Running `/ho` without arguments shows this usage information.

## Commands

### /ho w

Create a Handoff.md document that captures the current session state.

**Instructions:**

1. If `./Handoff.md` exists, delete it first
2. Analyze the current session to understand:
   - What was the goal?
   - What has been accomplished?
   - What problems were encountered?
   - What files were modified?
   - What should be done next?
3. Create `./Handoff.md` using the template below

**Handoff.md Template:**

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

**After Creation:**

Display:
```
Handoff.md created successfully.

To continue:
- New session: /ho r (or /handoff read)
- This session: /clear, then /ho r
```

### /ho r

Read an existing Handoff.md and continue the work.

**Instructions:**

1. Read `./Handoff.md` in the current directory
2. If it doesn't exist, inform the user and suggest running `/ho w` first
3. Parse and understand the context:
   - Goal: What we're trying to achieve
   - Done: What's already completed
   - Learned: Approaches that worked or didn't
   - Next: What should be done now
4. Summarize the handoff content briefly
5. Ask the user which "Next" item to work on, or if they have different priorities

**After Reading:**

Display:
```
Handoff loaded: {Goal summary}

Completed: {N} items
Next steps:
1. {First next item}
2. {Second next item}
...

Which task should we start with?
```
