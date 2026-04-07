# Maestro

> Conduct AI agents like a CEO — orchestrate, delegate, ship.

Managing AI agents today feels like conducting an orchestra without a score. Maestro gives you the score — a growing library of battle-tested Claude Code skills that turn your agent into an executive command center.

Install a skill. Delegate the work. Stay in command.

## Install

```bash
# Install all Maestro skills
npx skills add openqa-labs/maestro

# Or install a single skill
npx skills add openqa-labs/maestro/project-kickoff
```

## Skills

| Skill | What it does |
|-------|-------------|
| [`project-kickoff`](skills/project-kickoff/) | Start any project from zero — interview, naming, repo setup, CI, README, first task |

_Coming soon: `project-monitor`, `status-report`, `product-ideation`, `feature-dev`, `product-marketing`_

## Usage

Once installed, trigger a skill directly in Claude Code:

```
/project-kickoff I want to build a SaaS for tracking team productivity
```

Claude conducts a structured intake, researches the competitive landscape, sets up the repo, configures CI, writes the README, and creates your first task — end to end.

## Why Maestro

- **End-to-end workflows** — each skill owns a complete job, not just a step
- **CEO-level thinking** — skills ask the right strategic questions up front
- **Opinionated defaults** — sensible choices baked in, easy to override
- **Quality-gated** — every skill is validated by CI on every commit

## Contributing

We welcome new skills. The bar is high — each skill must handle a complete workflow end-to-end, not just wrap a single command.

```bash
git checkout -b feat/my-skill
# Create skills/my-skill/SKILL.md with name + description frontmatter
bash scripts/validate.sh   # must pass before opening PR
```

See [CONTRIBUTING.md](CONTRIBUTING.md) for the full skill authoring guide.

## License

MIT — see [LICENSE](LICENSE) for details.
