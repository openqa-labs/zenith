---
name: skill-crystallizer
description: >
  Proactively create and improve skills from session learnings. Trigger automatically
  after any complex task (5+ tool calls), tricky bug fix, corrected approach, or
  non-obvious workflow discovery. Also trigger immediately when an existing skill is
  found to be stale, incomplete, or wrong during use.
---

# Skill Crystallizer

Turn session learnings into reusable skills — automatically, without being asked.

## When to crystallize (create a new skill)

Create a skill when ANY of these are true:

- Task took **5+ tool calls** and produced a non-obvious workflow
- You overcame an **error through investigation** — future sessions will hit the same wall
- The **user corrected your approach** and the corrected version succeeded
- The user explicitly says **"save this"**, "remember this", "make a skill for this"
- You assembled a multi-step command, config, or pattern **from scratch**

**Skip when:** the task was trivial, the answer was obvious, or it's unlikely to recur.

## When to improve (patch an existing skill)

Patch **immediately** — not after finishing the task — when you load a skill and:

- A step **failed or had wrong syntax**
- You hit a **pitfall the skill doesn't warn about**
- The skill's **description doesn't match** how you actually used it
- **Commands are version-specific** and produced errors

If you discovered something the skill missed, patch it before you finish the task. The moment passes.

## Three decisions before writing

### 1. Destination

| Location | When to use |
|----------|-------------|
| `skills/<name>/` | General enough to share publicly via skills.sh |
| `.claude/skills/<name>/` | Personal, project-specific, or experimental |

Default to `.claude/skills/` unless you're confident it's broadly reusable.

### 2. Name

Lowercase slug, hyphens only, max 64 characters. Describes the **task type**, not the outcome.

- `git-rebase-interactive` ✓
- `fixed-rebase-conflict-april` ✗

### 3. Description

Must include trigger conditions first. Pattern: `Use when <trigger>. <what it does>.`

The description is loaded into Claude's system prompt on every session — write it so Claude can self-trigger without being asked.

## Writing the SKILL.md

**Required frontmatter:**
```yaml
---
name: your-skill-name
description: Use when <trigger condition>. <what it does>.
---
```

**Body structure that works:**

1. **When to use** — specific triggers, not broad categories
2. **Numbered steps** — exact commands, no hedging ("you might want to...")
3. **Pitfalls** — the errors you hit in this session
4. **Verification** — how to confirm it worked

Load `references/skill-format-guide.md` for the full frontmatter schema and field options.

**Supporting files** (use when body would exceed ~500 lines or needs structured reference material):

- `references/` — documentation, API guides, large reference content
- `templates/` — boilerplate the skill produces
- `scripts/` — executable helpers Claude can run

## Patching an existing skill

1. **Read the existing SKILL.md first** — never patch blind
2. **Make targeted `Edit` calls** — don't rewrite the whole file
3. Add to the pitfalls section, fix a command, append a missing step
4. **Tell the user:** "I updated `<skill-name>` to add the pitfall we hit."

## Quality gate

Before writing, verify:

- [ ] Description contains a clear trigger condition (`Use when...`)
- [ ] Every step has an exact command or concrete action
- [ ] Pitfalls section covers what actually went wrong in this session
- [ ] Skill is scoped to **one task type** — if it covers unrelated things, split it

## Anti-patterns

- **No session transcripts** — skills encode *how*, not *what happened*
- **No duplicates** — if an existing skill covers the same territory, patch it instead
- **No broad descriptions** — a description that triggers on everything helps no one
- **No deferred patching** — "I'll fix the skill later" means never
