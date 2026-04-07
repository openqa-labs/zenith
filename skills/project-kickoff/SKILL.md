---
name: project-kickoff
description: >
  Your CEO/PM assistant for starting, migrating, reviving, or bootstrapping any project — coding or non-coding.
  Use this skill whenever the user wants to: kick off a new project, set up a workspace or repo, migrate an existing project to a new repo, revive a defunct project, use an existing repo as inspiration, or bootstrap anything from scratch. This includes coding projects (Python, Node, Go, etc.), research projects, documentation, knowledge bases, note-taking systems, brainstorming workspaces, social media content workflows, video production setups, and learning projects.
  Trigger especially when the user says things like "help me set up", "start a new project", "I want to build", "kick off", "bootstrap", "migrate my project", "set up a workspace", "I found this repo and want to build on it", or describes wanting to begin something new even without saying the word "project".
  This skill handles the full setup: research & inference → discovery confirmation → tool checks → repo setup → reference fetching → CLAUDE.md + skills + MCP config → testing setup → README → verification → first task creation.
---

# Project Kickoff

You are the user's project setup partner — part CEO, part PM, part senior engineer. Your job is to get any project from zero to "ready to work" in one structured conversation.

**Core principle:** Research first, ask second. Before presenting any questions, spend ~30 seconds researching and inferring answers. Then present a pre-filled confirmation block — not a blank form. The user should be confirming your work, not doing it themselves.

---

## Phase 0: Research & Inference

Run this phase silently before presenting any questions. Do not announce it — just do the work.

### Step 1 — Extract from user's message

Parse the user's initial message and extract every fact explicitly stated or strongly implied:
- Project concept / domain
- Tech stack hints (language names, framework names, tool names)
- Personal vs professional signals ("side project", "my team", "startup", "work")
- GitHub preferences (public/private mentioned, username/org mentioned, repo URL mentioned)
- Directory path (if mentioned)
- Any API services mentioned (OpenAI, Stripe, AWS, etc.)
- **References to fetch** — build an explicit queue for Phase 5:
  - npm packages mentioned (e.g. "using zod and express") → `npx opensrc <package>`
  - GitHub repos mentioned as inspiration or reference → `npx opensrc owner/repo`
  - URLs mentioned (docs, blog posts, papers) → WebFetch → `references/<name>.md`
  - If the user says "I want to build something like X" where X is a known repo → add X to the fetch queue

### Step 2 — WebSearch the concept

Run 2–3 targeted searches to understand the domain and infer sensible defaults:
1. `"[concept] github open source"` — find existing tools, understand naming patterns, assess landscape
2. `"[concept] [inferred language] best practices"` — confirm tech stack defaults
3. (optional) `"[concept] site:github.com stars:>100"` — find popular reference repos

Use the results to:
- Understand what already exists (avoids naming conflicts in Phase 2)
- Confirm or refine the inferred tech stack
- Identify common patterns, testing frameworks, and tooling conventions for this type of project

### Step 3 — Build draft answers

For every question in Phase 1, assign a confidence tier:

| Tier | Confidence | Action |
|------|-----------|--------|
| HIGH | 90%+ | Mark as `[Pre-filled]` — present in confirmation block, user just confirms |
| MEDIUM | 60–90% | Mark as `[Suggested]` — show with brief reasoning, easy to override |
| UNKNOWN | <60% | Mark as `[Needed]` — ask directly with 2–3 concrete examples |

Typical inference rules:
- "side project" / "personal" / "fun" → Personal
- "my team" / "company" / "startup" / "work" / "we" / API keys → Professional
- Language/framework explicitly named → HIGH confidence stack
- Common patterns from WebSearch → MEDIUM confidence stack
- No stack mentioned, ambiguous domain → UNKNOWN, ask with examples
- GitHub username/org mentioned → HIGH
- No path mentioned → suggest `~/Projects/<inferred-name>`

---

## Phase 1: Discovery Confirmation

Present a single pre-filled confirmation block. Do NOT send a blank form. Every question must have either a pre-filled value, a suggestion, or a clear "Needed" marker.

**Opening line:** "Here's what I found — confirm or correct anything:"

**Format for each item:**
- `[Pre-filled]` — high confidence, shown without question mark
- `[Suggested: X — reason]` — medium confidence, shown as a proposal
- `[Needed]` — unknown, shown with examples to reduce typing

**Use `AskUserQuestion` tool** for any binary or small-choice questions (personal vs professional, public vs private, task tracker choice) where the user can click rather than type.

**Example confirmation block:**

```
Here's what I found — confirm or correct anything:

── Project Identity ──────────────────────────────
1. Concept:    CLI tool that converts Markdown files to PDF
               [Pre-filled — from your message]

2. Type:       Personal side project
               [Suggested — you said "side project"]

3. Category:   Coding — Python CLI tool
               [Suggested — Markdown/PDF processing is typically Python]

4. Stack:      Python 3.11+, Click (CLI), weasyprint (PDF), pytest
               [Suggested — standard stack for this type of tool; alternatives: pypandoc, reportlab]

5. Inspiration: None mentioned
               [Pre-filled — let me know if you have a reference repo]

6. Branding:   Minimal / technical
               [Suggested — CLI tools default to this tone]

── Workspace & Source Control ────────────────────
7. Directory:  ~/Projects/md-to-pdf
               [Suggested — based on your project concept]

8. GitHub:     New private repo
               [Pre-filled — you said "private"]

9. Username:   [Needed — please provide your GitHub username or org]

── References ────────────────────────────────────
10. References: Will fetch with opensrc in Phase 5:
                - <repo-or-package-1>  →  npx opensrc <repo-or-package-1>
                - <repo-or-package-2>  →  npx opensrc <repo-or-package-2>
                [Pre-filled — from your message; add more repos, packages, or URLs]
                (or: None mentioned — let me know if you want any pulled in as context)

── Infrastructure ────────────────────────────────
11. API keys:  None
               [Suggested — no external services implied]

12. MCP servers: None
                 [Suggested — not needed for a local CLI tool]

13. Skills:    None beyond project-kickoff
               [Suggested]

── Project Management ────────────────────────────
14. Tasks:     GitHub Issues
               [Suggested — standard for public/private repos]

15. Docs:      Local docs/ folder
               [Suggested]

16. First task: "Implement core markdown→PDF conversion"
               [Suggested — most natural starting point]

── Testing ───────────────────────────────────────
17. Framework: pytest
               [Pre-filled — standard for Python]

18. Verification: Run pytest, all tests pass
                  [Pre-filled]

19. CI/CD:     GitHub Actions — lightweight test runner
               [Suggested]

────────────────────────────────────────────────
Reply with corrections to any items above (e.g. "9: gurvinder, 7: ~/Work/md-to-pdf").
Items with [Pre-filled] are confirmed unless you say otherwise.
```

### Handling the response

- If the user replies "looks good" or similar → proceed with all pre-filled/suggested values
- If the user corrects specific items → update those items, proceed
- If the user asks "what about X" → answer and update
- The ONLY item that always requires explicit input: GitHub username/org (item 9), unless it was extracted from the initial message

---

## Phase 2: Project Name, Description & Branding

**Use the research already done in Phase 0** — do not repeat the same WebSearch. Pull from the landscape findings.

### Suggest name options

Propose **3–5 name options** based on the concept and competitive landscape already researched:
- **Catchy and memorable** — easy to say, spell, recall
- **SEO-friendly** — contains the primary keyword naturally
- **Available** — not already a major project (check Phase 0 findings)
- **Modern** — no generic or dated patterns

Format as a table: name | why it works | GitHub slug

### Suggest one-liner and tags

After name confirmation:
1. **One-liner** (~12 words): what it does + who it's for, keyword-rich
2. **Short description** (2–3 sentences): problem → solution → differentiator
3. **Tags** (5–8): lowercase, hyphenated GitHub topics

Get explicit sign-off before proceeding to Phase 3.

---

## Phase 3: Tool Availability Check

```bash
case "$(uname -s 2>/dev/null)" in
  Darwin) OS_TYPE="macOS" ;;
  Linux)  OS_TYPE="Linux" ;;
  MINGW*|MSYS*|CYGWIN*) OS_TYPE="Windows" ;;
  *) OS_TYPE="Windows" ;;
esac

git --version 2>/dev/null && echo "git: OK" || echo "git: MISSING"
gh --version 2>/dev/null && echo "gh: OK" || echo "gh: MISSING"
gh auth status 2>/dev/null && echo "gh-auth: OK" || echo "gh-auth: NOT AUTHENTICATED"
node --version 2>/dev/null && echo "node: OK" || echo "node: MISSING"
npm --version 2>/dev/null && echo "npm: OK" || echo "npm: MISSING"
uv --version 2>/dev/null && echo "uv: OK" || echo "uv: MISSING"
```

Stop if `gh-auth` is NOT AUTHENTICATED — ask the user to run `gh auth login`.

Install commands for missing tools:

| Tool | macOS | Linux |
|------|-------|-------|
| `git` | `brew install git` | `sudo apt install git` |
| `gh` | `brew install gh` | `sudo apt install gh` |
| `node/npm` | `brew install node` | `sudo apt install nodejs npm` |
| `uv` | `curl -LsSf https://astral.sh/uv/install.sh \| sh` | same |

Never install without explicit user approval.

---

## Phase 4: Repository Setup

**A — New repo:**
```bash
mkdir -p <path> && cd <path>
git init
# Create .gitignore first
gh repo create <name> --public/--private --source=. --remote=origin --push
```

**B — Clone from internet, push to own GitHub:**
```bash
git clone <source-url> <path> && cd <path>
git remote rename origin upstream
gh repo create <name> --public/--private
git remote add origin <new-repo-url>
git push -u origin main
```

**C — Existing local directory:**
```bash
cd <path> && git init
gh repo create <name> --public/--private --source=. --remote=origin --push
```

Minimum `.gitignore`:
```
opensrc/
.env
.env.*
!.env.example
node_modules/
.DS_Store
```

After creating the repo:
```bash
# Set topics
gh repo edit <owner>/<repo> --add-topic <tag1> --add-topic <tag2>

# Branch protection
gh api repos/<owner>/<repo>/branches/main/protection --method PUT --input - <<'EOF'
{"required_status_checks":null,"enforce_admins":false,"required_pull_request_reviews":null,"restrictions":null,"allow_force_pushes":false,"allow_deletions":false}
EOF
```

---

## Phase 5: Reference Fetching

**Always run this phase** — for new projects and existing projects alike. References give Claude Code deep implementation context (actual source, not just docs). Never skip it when the user has mentioned any package, repo, or URL.

### Step 1 — Verify .gitignore has opensrc/

Before fetching anything:
```bash
grep -q "opensrc/" .gitignore || echo "opensrc/" >> .gitignore
```

### Step 2 — Fetch packages and repos with opensrc

Use `npx opensrc` for every npm package and GitHub repo in the Phase 0 fetch queue. No global install needed — `npx` works everywhere.

```bash
# npm package — auto-detects version from lockfile if present
npx opensrc <package-name>
npx opensrc <package-name>@<version>     # specific version

# GitHub repo
npx opensrc owner/repo
npx opensrc owner/repo@v1.2.3            # specific tag

# Multiple at once
npx opensrc react react-dom next

# Full GitHub URL also works
npx opensrc https://github.com/owner/repo
```

On first run, opensrc may offer to update `.gitignore` and create `AGENTS.md` — accept both.

opensrc stores sources under `opensrc/` with a `sources.json` index for agent discovery.

**Fallback if npx/npm is unavailable:**
```bash
git clone https://github.com/<owner>/<repo> opensrc/<owner>--<repo> --depth=1
```

### Step 3 — Fetch URLs with WebFetch

For each URL, doc page, or paper in the fetch queue:
1. Use the WebFetch tool to retrieve the content
2. Save to `references/<descriptive-name>.md`
3. Add a 2–3 line summary of what it contains at the top of the file

### Step 4 — Document in CLAUDE.md

Add a **Key References** section to CLAUDE.md listing what was fetched:

```markdown
## Key References

- `opensrc/owner--repo/` — <why it's useful>
- `references/<name>.md` — <what it contains>
```

### For existing projects

When invoked on a project that already exists (Phase 4 scenario C or D), still run this phase fully if the user mentioned any packages, repos, or URLs. Do not skip because the project is already set up — references are always additive context.

---

## Phase 6: Project Configuration

### CLAUDE.md (max ~50 lines)

```markdown
# <Project Name>

<One sentence: what this project is and does.>

## Rules

- Never install packages globally
- [Python] Use uv: `uv venv && source .venv/bin/activate`
- Never commit `.env` — use `.env.example`
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

Only create if at least one MCP was confirmed. Use `${VAR_NAME}` for all secrets:

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

**CI (`.github/workflows/ci.yml`):**
```yaml
name: CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: <setup>
      - run: <test command>
```

**Non-coding:** Create `CHECKLIST.md` with review criteria.

---

## Phase 8: README.md

```markdown
# <Project Name>

> <One-liner>

<2–3 sentences: problem → solution → differentiator>

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

Fix any failures before Phase 10.

---

## Phase 10: Create First Task

```bash
gh issue create \
  --title "<first task from Phase 1 item 16>" \
  --body "## Goal\n<what done looks like>\n\n## Notes\n<context from setup>"
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

Next: cd <path>
```

---

## Gotchas

- **Personal vs professional signal mismatch:** User says "personal" but mentions API keys, a team, or "we" → treat as professional. Professional affects `.env.example` depth and CI rigor.
- **Org repos:** If the repo is under a GitHub org (not personal account), `gh repo create <org>/<name>` requires the user to be an org member with repo creation rights. Confirm org membership if unsure.
- **SSH vs HTTPS:** If `git push` fails with "Permission denied (publickey)", the user's git protocol is SSH but no key is configured. Switch remote to HTTPS: `git remote set-url origin https://github.com/<owner>/<repo>.git`
- **Windows paths:** `mkdir -p` does not exist — use `mkdir` or `New-Item -ItemType Directory -Force`. Always branch on `$OS_TYPE` from Phase 3.
- **Phase 0 WebSearch failure:** If WebSearch is unavailable, skip it and lower all confidence tiers by one level (HIGH → MEDIUM, MEDIUM → UNKNOWN). Still present a confirmation block, but with fewer pre-filled items.
- **User provides very little context:** If the initial message is 5 words or fewer (e.g. "new python project"), set everything to UNKNOWN and ask — but still use AskUserQuestion tool for binary choices.
