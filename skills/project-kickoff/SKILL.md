---
name: project-kickoff
description: >
  Your CEO/PM assistant for starting, migrating, reviving, or bootstrapping any project — coding or non-coding.
  Use this skill whenever the user wants to: kick off a new project, set up a workspace or repo, migrate an existing project to a new repo, revive a defunct project, use an existing repo as inspiration, or bootstrap anything from scratch. This includes coding projects (Python, Node, Go, etc.), research projects, documentation, knowledge bases, note-taking systems, brainstorming workspaces, social media content workflows, video production setups, and learning projects.
  Trigger especially when the user says things like "help me set up", "start a new project", "I want to build", "kick off", "bootstrap", "migrate my project", "set up a workspace", "I found this repo and want to build on it", or describes wanting to begin something new even without saying the word "project".
  This skill handles the full setup: discovery interview → tool checks → repo setup → reference fetching → CLAUDE.md + skills + MCP config → testing setup → README → verification → first task creation.
---

# Project Kickoff

You are the user's project setup partner — part CEO, part PM, part senior engineer. Your job is to get any project from zero to "ready to work" in one structured conversation. You handle the full stack: workspace, GitHub, references, CLAUDE.md, skills, MCP servers, testing, README, and the first task.

Move through the phases in order. Never skip verification (Phase 9) or the first task (Phase 10). Always explain what you're about to do before running any command.

---

## Phase 1: Discovery Interview

Ask ALL of the following in a single, well-formatted message grouped by category. Do not ask them one at a time — that creates a tedious 30-message back-and-forth. Present them as a friendly intake form.

If the user has already provided some answers in their initial message, pre-fill those and only ask for what's missing.

```
Group A — Project Identity
  1. Project concept / rough idea? (we'll workshop the final name and description together next)
  2. Personal or professional?
  3. Category: coding / documentation / research / knowledge-base / brainstorming /
     social-media / video / note-taking / learning / other (describe)?
  4. Tech stack (if coding — language, frameworks, tools you have in mind)?
  5. Any existing project, repo, or URL you're building on or drawing inspiration from?
  6. Any branding preferences? (colors, tone — e.g. minimal, playful, technical, bold)

Group B — Workspace & Source Control
  7. Directory path where this should live? (e.g. ~/Projects/my-thing)
  8. GitHub setup:
       a) No GitHub needed
       b) New public repo
       c) New private repo
       d) Already have a GitHub repo — share the URL
       e) Clone an existing internet repo and push to my own GitHub account
  9. GitHub username? (needed for b, c, e)

Group C — References
  10. Any reference materials to pull in? (npm/pip packages, GitHub repos, URLs,
      local files, papers, documents) — these will be fetched and stored locally,
      gitignored so they never get committed.

Group D — Infrastructure
  11. Any API keys, secrets, or cloud services this project will use?
      (e.g. OpenAI, AWS, Stripe — we'll set up .env.example for these)
  12. Any MCP servers you know you'll want?
      (e.g. web search, GitHub, database, browser automation — or say "suggest")
  13. Any specific Claude Code skills to add?
      (or say "suggest" — I'll recommend based on your stack)

Group E — Project Management & Documentation
  14. How do you want to track tasks?
      (local TASKS.md / GitHub Issues / Linear / Notion / other)
  15. Where should project docs/wiki live?
      (local docs/ folder / GitHub Wiki / Notion / other)
  16. What's the very first thing you'll work on after setup?

Group F — Testing & Verification
  17. Coding projects: preferred testing framework?
      (or say "suggest" — I'll pick based on your language)
  18. Non-coding projects: how will you verify/review your work?
      (checklists, peer review, publish criteria, etc.)
  19. Do you need CI/CD? (GitHub Actions, etc.)
```

Wait for the user's responses before proceeding.

---

## Phase 2: Project Name, Description & Branding

This phase runs before touching any tooling or files. A strong project identity shapes the repo name, README, and everything else downstream.

### Step 1 — Research similar projects

Use WebSearch to look for existing projects with similar names or solving the same problem. Check:
- GitHub (search the concept)
- Product Hunt / npm / PyPI / crates.io as appropriate
- General web search for "[concept] tool", "[concept] app", "[concept] project"

Goals: avoid naming conflicts, avoid trademark/copyright collisions, understand the competitive landscape well enough to suggest differentiated names.

### Step 2 — Suggest name options

Propose **3–5 name options** that are:
- **Catchy and memorable** — easy to say, spell, and remember
- **SEO-friendly** — descriptive enough that people searching for this type of tool will find it
- **Available** — not already a major open-source project or product
- **Modern** — avoid generic or dated naming patterns

For each option provide:
- The name
- Why it works (one line)
- Suggested GitHub repo slug

Format as a quick table for easy scanning.

### Step 3 — Suggest description and tags

After the user picks a name (or proposes their own), draft:

1. **One-liner** (for README headline, GitHub description field): ~10–15 words, describes what it does and who it's for. Should contain the primary keyword naturally.
2. **Short description** (for README intro, npm/PyPI/GitHub "About"): 2–3 sentences. Lead with the problem it solves, then what it does, then why it's different.
3. **Tags / topics**: 5–8 relevant GitHub topics or keywords (lowercase, hyphenated). These improve discoverability on GitHub and search engines.

### Step 4 — Confirm with user

Present all of the above and get explicit sign-off on: final name, one-liner, and tags. Only proceed to Phase 3 once confirmed.

---

## Phase 3: Tool Availability Check

Before touching the filesystem, detect the OS and check which tools are available.

### OS Detection

```bash
case "$(uname -s 2>/dev/null)" in
  Darwin) OS_TYPE="macOS" ;;
  Linux)  OS_TYPE="Linux" ;;
  MINGW*|MSYS*|CYGWIN*) OS_TYPE="Windows" ;;
  *) OS_TYPE="Windows" ;;
esac
echo "Detected OS: $OS_TYPE"
```

### Tool Check

```bash
git --version 2>/dev/null && echo "git: OK" || echo "git: MISSING"
gh --version 2>/dev/null && echo "gh: OK" || echo "gh: MISSING"
gh auth status 2>/dev/null && echo "gh-auth: OK" || echo "gh-auth: NOT AUTHENTICATED"
node --version 2>/dev/null && echo "node: OK" || echo "node: MISSING"
npm --version 2>/dev/null && echo "npm: OK" || echo "npm: MISSING"
uv --version 2>/dev/null && echo "uv: OK" || echo "uv: MISSING"
```

**Required for all projects:** `git`, `gh` (if GitHub is involved)

If `gh-auth` is NOT AUTHENTICATED, stop and ask the user to run `gh auth login` before proceeding.

**Install commands for missing tools:**

| Tool | macOS | Linux |
|------|-------|-------|
| `git` | `brew install git` | `sudo apt install git` |
| `gh` | `brew install gh` | `sudo apt install gh` |
| `node/npm` | `brew install node` | `sudo apt install nodejs npm` |
| `uv` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | same |

Never install tools without explicit user approval.

---

## Phase 4: Repository Setup

**A — New repo (no existing code):**
```bash
mkdir -p <path> && cd <path>
git init
# Create .gitignore first
gh repo create <name> --public/--private --source=. --remote=origin --push
```

**B — Clone from internet, push to personal GitHub:**
```bash
git clone <source-url> <path> && cd <path>
git remote rename origin upstream
gh repo create <name> --public/--private
git remote add origin <new-repo-url>
git push -u origin main
```

**C — Existing local directory:**
```bash
cd <path>
git init
gh repo create <name> --public/--private --source=. --remote=origin --push
```

Create `.gitignore` early — must include:
```
opensrc/
.env
.env.*
!.env.example
node_modules/
.DS_Store
```

After creating the repo, apply topics:
```bash
gh repo edit <owner>/<repo> --add-topic <tag1> --add-topic <tag2>
```

Enable branch protection:
```bash
gh api repos/<owner>/<repo>/branches/main/protection \
  --method PUT \
  -f 'required_status_checks=null' \
  -F enforce_admins=false \
  -F 'required_pull_request_reviews[required_approving_review_count]=0' \
  -F allow_force_pushes=false \
  -F allow_deletions=false \
  -f restrictions=null
```

---

## Phase 5: Reference Fetching

For each reference the user provided:

**GitHub repo → opensrc (preferred) or git clone:**
```bash
opensrc owner/repo          # if opensrc is available
# fallback:
git clone <url> opensrc/<repo-name> --depth=1
```

**URL → WebFetch:**
Fetch and save to `references/<name>.md`.

Always ensure `opensrc/` is in `.gitignore`.

---

## Phase 6: Project Configuration

### CLAUDE.md (max ~50 lines)

```markdown
# <Project Name>

<One sentence describing what this project is and does.>

## Rules

- Never install packages globally
- [Python] Use uv: `uv venv && source .venv/bin/activate`
- Never commit `.env` files — use `.env.example`
- Always run tests before committing

## Testing

\`\`\`
<test command>
\`\`\`

## Branch Conventions

- `feat/<description>` — new features
- `fix/<description>` — bug fixes
- `chore/<description>` — maintenance

## Key Files

- `<entry point>` — <what it is>
```

### Skills

```bash
npx skills add <skill-source>
```

### MCP Servers (.mcp.json)

Only create if at least one MCP is approved. Use `${VAR_NAME}` for secrets:

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": { "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_PERSONAL_ACCESS_TOKEN}" }
    }
  }
}
```

---

## Phase 7: Testing & Verification Setup

**Python:**
```bash
uv add --dev pytest
mkdir -p tests
echo 'def test_placeholder(): assert True' > tests/test_basic.py
```

**Node/TS:**
```bash
npm install --save-dev vitest
```

**CI (`github/workflows/ci.yml`):**
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: <setup command>
      - run: <test command>
```

**Non-coding projects:** Create `CHECKLIST.md` with review criteria instead.

---

## Phase 8: README.md

```markdown
# <Project Name>

> <One-liner>

<2–3 sentence description: problem → solution → differentiator>

## Installation

\`\`\`bash
<install command>
\`\`\`

## Usage

\`\`\`bash
<usage command>
\`\`\`

## Contributing

1. Fork and create a branch
2. Make changes, run tests
3. Open a pull request

## License

MIT
```

---

## Phase 9: Verify the Setup

Run through this checklist and report results:

```
[ ] Project directory exists
[ ] git repo initialized
[ ] GitHub remote configured
[ ] GitHub topics set
[ ] .gitignore includes opensrc/ and .env*
[ ] CLAUDE.md present (under 50 lines)
[ ] README.md present
[ ] Tests run without error
[ ] First commit created
```

Fix any failures before proceeding.

---

## Phase 10: Create First Task

**GitHub Issues:**
```bash
gh issue create \
  --title "<first task>" \
  --body "## Goal\n<what done looks like>\n\n## Notes\n<context>"
```

---

## Summary Output

```
Project setup complete.

  Location:   <path>
  Repo:       <GitHub URL>
  Tests:      <test command>
  Tasks:      <GitHub Issues URL>
  First task: <task title>

Next: cd <path> && <open in editor>
```
