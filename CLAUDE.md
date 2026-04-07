# Maestro

A curated collection of Claude Code skills for running AI agents at the executive level. Skills are installed via [skills.sh](https://skills.sh) and tracked in GitHub Issues.

## Rules

- Skills live in `skills/<skill-name>/SKILL.md` — one skill per directory
- Every SKILL.md must have `name:` and `description:` frontmatter fields
- `opensrc/` is gitignored — use it for all local reference material:
  - **Before working with a package or external repo**, fetch its source for context: `npx opensrc <package-or-owner/repo>`
  - **To save reference docs, specs, or web pages**, fetch and save them as `opensrc/<name>.md`
  - Check `opensrc/sources.json` to see what's already been fetched before fetching again
  - Never edit files inside `opensrc/` — read-only context only
- Run the validator before committing: `bash .github/scripts/validate.sh`
- All task tracking happens in GitHub Issues at https://github.com/openqa-labs/zenith/issues

## Skill Structure

```
skills/
  <skill-name>/
    SKILL.md        # required — the skill prompt (with YAML frontmatter)
    README.md       # optional — human-readable usage guide
    evals/          # optional — eval test cases
```

## Validation

```bash
bash scripts/validate.sh
```

Checks: SKILL.md present, required frontmatter fields (`name`, `description`), markdownlint passes.

## Branch Conventions

- `feat/<skill-name>` — new skill
- `fix/<skill-name>` — fix existing skill
- `chore/<short-description>` — maintenance, tooling
- `docs/<short-description>` — documentation only

## Key Files

- `skills/` — publishable skills (distributed via skills.sh)
- `.claude/skills/` — local skills used while developing maestro (dogfooding)
- `skills-lock.json` — tracks installed skill versions
- `.github/workflows/validate.yml` — CI skill validator
