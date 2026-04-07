# project-kickoff

Start any project from zero — discovery interview, naming, repo setup, CI, README, and first task — in one structured conversation.

## Install

```bash
npx skills add openqa-labs/maestro/project-kickoff
```

## What it does

Triggers a structured 10-phase workflow:

1. **Discovery interview** — asks all setup questions in one grouped message
2. **Naming & branding** — researches competitors, suggests names, confirms one-liner
3. **Tool check** — verifies git, gh, node, uv are available before touching anything
4. **Repo setup** — creates the directory, git init, GitHub repo, branch protection, topics
5. **Reference fetching** — pulls in repos/URLs as local context via opensrc or git clone
6. **Project config** — writes CLAUDE.md, installs skills, configures MCP servers
7. **Testing scaffold** — sets up pytest/vitest + CI workflow (GitHub Actions)
8. **README** — writes a complete, well-structured README
9. **Verification** — runs a checklist to confirm every step succeeded
10. **First task** — creates the first GitHub Issue / TASKS.md entry

## When to use

Trigger with `/project-kickoff` or naturally:

- "Help me set up a new project"
- "I want to build a SaaS for X"
- "Kick off a Python CLI tool"
- "Bootstrap a research knowledge base"
- "I found this repo and want to build on it"

Works for coding projects (Python, Node, Go, etc.) and non-coding projects (research, docs, knowledge bases, content workflows).

## Example

```
/project-kickoff I want to build a CLI tool that converts markdown to PDF.
Personal project. Python. Private GitHub repo.
```

The skill runs the full intake interview, sets up the repo, scaffolds pytest, writes README and CLAUDE.md, and creates the first GitHub issue — no further input needed until each decision point.
