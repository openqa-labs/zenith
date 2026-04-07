# Zenith

An agent command center. Skills are the first major component — a curated library distributed via [skills.sh](https://skills.sh). Future components may extend beyond skills. Issues tracked at https://github.com/openqa-labs/zenith/issues.

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
bash .github/scripts/validate.sh
```

Checks: SKILL.md present, required frontmatter fields (`name`, `description`), markdownlint passes.

## Branch Conventions

- `feat/<skill-name>` — new skill
- `fix/<skill-name>` — fix existing skill
- `chore/<short-description>` — maintenance, tooling
- `docs/<short-description>` — documentation only

## Key Files

- `skills/` — publishable skills (distributed via skills.sh)
- `.claude/skills/` — two kinds of skills live here: (1) dev tooling skills needed to work on zenith itself (e.g. writing-skills, claude-md-improver), and (2) symlinks into `skills/` so zenith's own published skills are auto-loaded for dogfooding/testing
- `skills-lock.json` — tracks installed skill versions
- `.github/workflows/validate.yml` — CI skill validator
