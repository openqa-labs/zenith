# SKILL.md Format Reference

Canonical format for Claude Code skills (agentskills.io compatible).

---

## Frontmatter schema

```yaml
---
name: skill-name              # Required. Lowercase, hyphens, max 64 chars.
description: >                # Required. Max 1024 chars. Include trigger conditions.
  Use when <trigger>. <what it does>.
version: 1.0.0                # Optional. Semver.
author: Your Name             # Optional.
license: MIT                  # Optional.
platforms: [macos, linux]     # Optional. Restrict to OS. Omit = all platforms.
                              # Valid values: macos, linux, windows
metadata:                     # Optional. Arbitrary structured data.
  hermes:
    tags: [tag1, tag2]
    related_skills: [other-skill]
---
```

**Required fields:** `name` and `description` — the validator (`bash .github/scripts/validate.sh`) fails without them.

**Description writing rules:**
- Start with the trigger: `Use when...` or `Trigger automatically when...`
- Be specific enough that Claude can self-activate without being asked
- Keep under 1024 characters (the validator doesn't check this but the skills runtime truncates)

---

## Directory layout

```
skills/
  <skill-name>/
    SKILL.md              # Required — main instructions
    README.md             # Optional — human-readable guide
    references/           # Optional — docs, API guides, large reference material
    templates/            # Optional — boilerplate the skill produces
    scripts/              # Optional — executable helpers
    assets/               # Optional — images, data files
    evals/
      evals.json          # Optional — test cases for skill evaluation
```

---

## Where skills live

| Location | Purpose |
|----------|---------|
| `skills/<name>/` | Publishable — distributed via skills.sh |
| `.claude/skills/<name>/` | Local — personal or project-specific |

The validator syncs `skills/` → `.claude/skills/` as symlinks automatically.

---

## Body conventions

**Progressive disclosure** — Claude loads content in stages:
1. **Level 1 (always):** `name` + `description` from frontmatter (~100 tokens)
2. **Level 2 (on trigger):** Full `SKILL.md` body (<500 lines target)
3. **Level 3 (as needed):** Files in `references/`, `templates/`, etc.

**Writing style:**
- Imperative form: "Read the file first." not "You should read the file."
- Explain the *why* behind rules, not just the rule itself
- Exact commands over descriptions: `` `git rebase -i HEAD~3` `` not "run a rebase"
- Pitfalls section: what went wrong during the session that generated this skill

**Keep the body lean.** If SKILL.md would exceed ~500 lines, move reference material to `references/` and link to it.

---

## Validation

```bash
bash .github/scripts/validate.sh
```

Checks: `SKILL.md` exists, `name:` present, `description:` present. Creates `.claude/skills/` symlinks.
