# Contributing to Maestro

## What makes a good Maestro skill

Maestro skills handle **complete workflows**, not single commands. Before writing a skill, ask: does this take a user from a starting state to a finished state with no manual steps in between?

Good: "Set up a new project from zero to first commit"
Not good: "Run git init"

## Skill structure

Every skill lives in its own directory under `skills/`:

```
skills/
  my-skill/
    SKILL.md        # required
    README.md       # strongly recommended
    evals/
      evals.json    # recommended — test cases for the skill
```

## SKILL.md format

```markdown
---
name: my-skill
description: >
  One or two sentences describing what the skill does and when to trigger it.
  Include trigger phrases (e.g. "when the user says X or Y").
---

# My Skill

Your skill instructions here. Be specific, structured, and exhaustive.
The skill should handle the complete workflow start to finish.
```

The `name` and `description` fields are required. The description is what users see on skills.sh and what Claude Code uses to decide when to invoke the skill.

## Validation

Run the validator locally before pushing:

```bash
bash scripts/validate.sh
```

This checks:
- `SKILL.md` exists in every skill directory
- Required frontmatter fields (`name`, `description`) are present
- All markdown files pass markdownlint

CI runs the same checks on every pull request.

## Pull request process

1. Fork the repo
2. Create a branch: `git checkout -b feat/skill-name`
3. Write your skill in `skills/<skill-name>/SKILL.md`
4. Run `bash scripts/validate.sh` — must pass
5. Open a pull request with a clear description of what the skill does

## Code of conduct

Be direct, be helpful, keep PRs focused. One skill per PR.
