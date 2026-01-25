# CLAUDE.md - Project Guidance

## Project Purpose

This repository documents the optimal multi-instance Claude Code workflow using AeroSpace on macOS. It enables developers to run multiple Claude Code instances in parallel, each in its own workspace, with instant switching via keyboard shortcuts.

## File Organization

```
workflow-claude-supervisor/
├── README.md                      # Main documentation
├── CLAUDE.md                      # This file - project guidance for Claude
├── LICENSE                        # MIT license
├── config/
│   ├── aerospace.toml             # AeroSpace window manager configuration
│   └── cursor-projects.txt        # Project priority list for window arrangement
├── scripts/
│   └── aerospace-fix-cursor.sh    # Script to auto-arrange Cursor windows
└── install.sh                     # Unified installer script
```

## Key Files

- **config/aerospace.toml**: AeroSpace configuration with keybindings and auto-assign rules
- **config/cursor-projects.txt**: User-configurable list of project names in priority order
- **scripts/aerospace-fix-cursor.sh**: Bash script that distributes Cursor windows across workspaces
- **install.sh**: One-command installer that sets up everything

## Related Projects

- [claude-code-notify](https://github.com/tsilva/claude-code-notify): Notification system for Claude Code task completion

## Documentation Generation

This project uses [claude-skills](https://github.com/anthropics/claude-skills) for documentation:

- **readme-generator** skill: Creates and updates README.md following best practices
- **repo-logo-generator** skill: Generates project logos with transparent backgrounds

To regenerate documentation, use the `/readme-generator` skill command.

## Important Notes

- README.md must be kept up to date with any significant project changes
- Test changes by running `./install.sh` in a fresh environment
