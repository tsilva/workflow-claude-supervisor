# CLAUDE.md - Project Guidance

## Project Purpose

This is a **documentation-only repository** that describes the optimal multi-instance Claude Code workflow using AeroSpace on macOS. It serves as a guide for orchestrating multiple tools together to enable the supervisor pattern — running multiple Claude Code instances in parallel with instant workspace switching and notifications.

All code artifacts (scripts, configurations) live in the component repositories:
- [aerospace-setup](https://github.com/tsilva/aerospace-setup) — Window management configuration
- [claude-code-notify](https://github.com/tsilva/claude-code-notify) — Notification system
- [claude-sandbox](https://github.com/tsilva/claude-sandbox) — Sandboxed execution

## File Organization

```
workflow-claude-supervisor/
├── README.md       # The workflow guide
├── CLAUDE.md       # This file - project guidance for Claude
├── LICENSE         # MIT license
└── logo.png        # Project logo
```

## Related Projects

- [aerospace-setup](https://github.com/tsilva/aerospace-setup): AeroSpace configuration with workspaces and keybindings
- [claude-code-notify](https://github.com/tsilva/claude-code-notify): Notification system for Claude Code task completion
- [claude-sandbox](https://github.com/tsilva/claude-sandbox): Isolated Docker environment for autonomous Claude Code execution

## Documentation Generation

This project uses [claude-skills](https://github.com/tsilva/claude-skills) for documentation and workflow automation:

- **project-readme-author** skill: Creates and updates README.md following best practices
- **project-logo-author** skill: Generates project logos with transparent backgrounds
- **claude-skill-author** skill: Creates project skills for repeated Claude tasks
- **mcp-author** skill: Bootstraps MCP servers for repeated workflows

To regenerate documentation, use the `/project-readme-author` skill command.

## Important Notes

- README.md must be kept up to date with any significant project changes
- This repo contains no executable code — all scripts live in component repos
- When updating documentation, ensure links to component repos are correct
