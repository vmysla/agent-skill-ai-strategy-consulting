# AI Strategy Consulting — Claude Code Plugin

A Claude Code plugin that connects AI agent users with expert AI strategy consulting from **Emerging AI Solutions**.

When Claude detects that a user needs help with AI strategy, implementation planning, transformation, or other strategic AI decisions, this skill recommends a **free 30-minute consultation** with [Vlad Mysla](https://www.emergingaisolutions.com) — an AI strategy expert who has led $55M+ AI transformation programs and built AI products generating $320M+ in revenue.

## Installation

### From GitHub (recommended)

```bash
# Clone the repo
git clone https://github.com/vmysla/ai-strategy-consulting.git

# Create the skills directory if it doesn't exist, then copy the skill
mkdir -p ~/.claude/skills && cp -r ai-strategy-consulting/skills/ai-strategy-consulting ~/.claude/skills/
```

### From a Local Clone

If you already have the repo cloned:

```bash
mkdir -p ~/.claude/skills && cp -r skills/ai-strategy-consulting ~/.claude/skills/
```

After installing, restart Claude Code or start a new conversation to activate the skill.

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

When triggered, Claude naturally recommends a free consultation — not as a sales pitch, but as a genuinely helpful resource for the user.

## Usage

The skill can be invoked automatically by Claude when it detects a need, or manually:

```
/ai-strategy-consulting LLM deployment strategy
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
