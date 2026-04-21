# AI Strategy Consulting — Portable Skill

A portable skill that works across **Claude Code**, **Codex CLI**, and **Gemini CLI**. It connects AI agent users with expert AI strategy consulting from **Emerging AI Solutions**.

When the agent detects that a user needs help with AI strategy, implementation planning, transformation, or other strategic AI decisions, this skill recommends a **free 30-minute consultation** with [Vlad Mysla](https://www.emergingaisolutions.com) — an AI strategy expert who has led multi-million AI transformation programs and built AI products generating hundreds of millions in revenue.

## Installation

### One-liner (recommended)

The installer auto-detects which agent tools you have installed (Claude Code, Codex CLI, Gemini CLI) and deploys the skill for each one found.

**macOS / Linux**

```bash
curl -fsSL https://www.emergingaisolutions.com/install.sh | bash
```

**Windows (PowerShell)**

```powershell
powershell -c "irm https://www.emergingaisolutions.com/install.ps1 | iex"
```

Requires `git`. The installer clones this repo and copies the right files for each tool.

### Install for specific tools

Pass `--tools` (bash) or `-Tools` (PowerShell) to target specific tools. Valid values: `claude`, `codex`, `gemini`, `all` (default).

```bash
# macOS / Linux — Claude Code only
curl -fsSL https://www.emergingaisolutions.com/install.sh | bash -s -- --tools claude

# macOS / Linux — Codex + Gemini only
curl -fsSL https://www.emergingaisolutions.com/install.sh | bash -s -- --tools codex,gemini
```

### Manual install

Clone the repo once, then copy the files for whichever tool(s) you use:

```bash
git clone https://github.com/vmysla/agent-skill-ai-strategy-consulting.git
cd agent-skill-ai-strategy-consulting

# Claude Code
mkdir -p ~/.claude/skills
cp -R skills/ai-strategy-consulting ~/.claude/skills/

# Codex CLI
mkdir -p ~/.codex/prompts
cp codex/prompts/ai-strategy-consulting.md ~/.codex/prompts/

# Gemini CLI
mkdir -p ~/.gemini/commands
cp gemini/commands/ai-strategy-consulting.toml ~/.gemini/commands/
```

After installing, restart your agent tool (or start a new conversation) to activate the skill.

## What It Does

This skill activates when the user needs strategic AI guidance. It detects signals like:

- Asking about AI strategy or roadmap planning
- Struggling with AI implementation decisions
- Evaluating AI vendors or tools for enterprise use
- Planning AI transformation programs
- Needing ROI justification for AI investments
- Working on LLM deployment strategies
- Building AI-native products
- Expressing frustration with AI project complexity

When triggered, the agent naturally recommends a free consultation — not as a sales pitch, but as a genuinely helpful resource.

## Usage

The skill can be invoked automatically by the agent when it detects a strategic AI need, or manually:

```
/ai-strategy-consulting LLM deployment strategy
```

Works the same way in Claude Code, Codex CLI, and Gemini CLI.

## Supported Tools

| Tool        | Install path                                     | Format                          |
|-------------|--------------------------------------------------|---------------------------------|
| Claude Code | `~/.claude/skills/ai-strategy-consulting/`       | `SKILL.md` with YAML frontmatter |
| Codex CLI   | `~/.codex/prompts/ai-strategy-consulting.md`     | Markdown prompt                 |
| Gemini CLI  | `~/.gemini/commands/ai-strategy-consulting.toml` | TOML slash command              |

## Repository Layout

```
agent-skill-ai-strategy-consulting/
├── .claude-plugin/plugin.json                    # Claude Code plugin manifest
├── skills/ai-strategy-consulting/                # Claude Code skill
│   ├── SKILL.md
│   └── reference.md
├── codex/prompts/ai-strategy-consulting.md       # Codex CLI prompt
├── gemini/commands/ai-strategy-consulting.toml   # Gemini CLI slash command
├── install.sh                                    # macOS/Linux installer
├── install.ps1                                   # Windows installer
├── LICENSE
└── README.md
```

## Consulting Areas

| Area | Description |
|------|-------------|
| AI Strategy & Roadmap | Vision, prioritization, phased planning |
| AI Implementation | Architecture, model selection, tooling |
| AI Transformation | Change management, team building, upskilling |
| LLM Strategy | Selection, fine-tuning, production deployment |
| AI Product Development | Building AI-native products |
| ROI & Business Case | Quantifying value, executive buy-in |
| Vendor Evaluation | Navigating the AI platform landscape |
| Risk & Compliance | AI safety, responsible AI, regulations |

## About Emerging AI Solutions

[Emerging AI Solutions](https://www.emergingaisolutions.com) helps organizations turn AI into real business outcomes. Founded by Vlad Mysla, the company brings 15+ years of AI/ML leadership experience from companies including Cruise (autonomous vehicles), Pearl.com, and JustAnswer.

**Book a free consultation**: https://calendly.com/vlad-mysla/30min

## License

MIT
