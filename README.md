<div align="center">
  <img src="logo.png" alt="workflow-claude-supervisor" width="512"/>

# workflow-claude-supervisor

[![macOS](https://img.shields.io/badge/macOS-000000?logo=apple&logoColor=white)](https://www.apple.com/macos/)
[![Claude Code](https://img.shields.io/badge/Claude_Code-Anthropic-orange)](https://claude.ai/code)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**🎛️ Supervise multiple Claude Code instances in parallel — switch contexts instantly, get notified when tasks complete 🔔**

[Quick Start](#quick-start) · [The Workflow](#the-workflow) · [Components](#components)

</div>

> **New to Claude Code?** [Claude Code](https://docs.anthropic.com/en/docs/claude-code) is Anthropic's official CLI for Claude. It runs inside your terminal — typically the integrated terminal in Cursor or VS Code — and lets you interact with Claude directly in your development environment.

## Overview

Running one Claude Code session is straightforward. Running *several* in parallel — each working on a different project — quickly becomes chaos. Which task finished? Which window was that? Where did I leave off?

**workflow-claude-supervisor** solves this by turning you into a supervisor of AI coding agents:

- **Parallel execution** — Run 5, 6, or more Claude Code instances simultaneously
- **Instant context switching** — Jump between projects with a single keystroke
- **Task completion alerts** — Get notified the moment Claude needs your attention
- **Zero cognitive overhead** — Each project lives in its own dedicated space

Instead of babysitting one session, you delegate tasks, switch away, and return when notified. This is the supervisor pattern.

## The Workflow

```mermaid
graph LR
    subgraph You["You (Supervisor)"]
        Review["Review & Direct"]
    end

    subgraph Agents["Claude Code Instances"]
        A1["Project A"]
        A2["Project B"]
        A3["Project C"]
    end

    Review -->|"Alt+2"| A1
    Review -->|"Alt+3"| A2
    Review -->|"Alt+4"| A3

    A1 -->|"Done!"| Review
    A2 -->|"Needs input"| Review
    A3 -->|"Working..."| Review
```

### The Supervisor Pattern

1. **Delegate** — Give Claude Code a task and switch away (`Alt+3` to Project B)
2. **Multiplex** — Work on another project while the first one runs
3. **Get notified** — Desktop alert when Claude finishes or needs permission
4. **Context switch** — Click notification or press `Alt+2` to jump back instantly
5. **Review & repeat** — Check output, give next task, switch to another project

This turns waiting time into productive time. While Claude thinks through a complex refactor in Project A, you're reviewing changes in Project B and delegating tests in Project C.

### What Are Workspaces?

Workspaces are virtual desktops managed by [AeroSpace](https://github.com/nikitabobko/AeroSpace), a tiling window manager for macOS. They're similar to macOS Spaces but with key differences:

- **Instant switching** — No slide animations; workspaces change immediately
- **Keyboard-driven** — Alt+1 through Alt+9 switches directly to any workspace
- **One app per workspace** — Each Claude Code instance gets its own dedicated space
- **Fullscreen by default** — Every window is maximized, zero distractions

This is what makes the supervisor pattern practical — switching between projects takes milliseconds, not seconds.

### Workspace Layout

| Workspace | Keybinding | Purpose |
|-----------|------------|---------|
| 1 | `Alt+1` | Browser, notes, documentation |
| 2-9 | `Alt+2` - `Alt+9` | One Cursor/VS Code window per workspace (each running Claude Code) |

High-priority projects get lower numbers for faster access.

## Components

This workflow combines several tools, each solving a specific problem:

### Window Management — aerospace-setup

**Problem:** macOS has no native way to instantly switch between fullscreen app instances.

**Solution:** [aerospace-setup](https://github.com/tsilva/aerospace-setup) provides AeroSpace configuration with workspaces and instant keyboard navigation.

**Key features:**
- Alt+1-9 switches workspaces in milliseconds
- Each Cursor/VS Code window gets its own fullscreen workspace
- Auto-arrange script organizes windows by project priority
- Zero gaps, zero animations, zero distractions

### Notifications — agentpong

**Problem:** You can't watch every Claude Code instance simultaneously.

**Solution:** [agentpong](https://github.com/tsilva/agentpong) sends desktop notifications when Claude needs attention.

**Key features:**
- Alerts when tasks complete ("Ready for input")
- Alerts when permission is needed
- Click notification to focus the correct window (even across workspaces)
- Notification cycling with `Alt+N` — jump to next pending notification without clicking
- Multi-IDE support — works with Claude Code, OpenCode, and other terminal-based agents
- Zero configuration required

**How it works:**
The install script configures Claude Code hooks in `~/.claude/settings.json` that trigger on `Stop` (task complete) and `PermissionRequest` (needs approval) events. When either fires, `~/.claude/notify.sh` sends a desktop notification via `terminal-notifier`. Clicking the notification runs `~/.claude/focus-window.sh`, which uses AeroSpace to locate and focus the correct IDE window — even across workspaces.

### Skills — claude-skills

**Problem:** Repeated documentation, development, and workflow tasks across repos are tedious and inconsistent.

**Solution:** [claude-skills](https://github.com/tsilva/claude-skills) provides reusable skills that Claude Code can invoke across any project.

**Key features:**
- `/project-readme-author` — Creates or updates READMEs following best practices
- `/project-logo-author` — Generates project logos with transparent backgrounds
- `/claude-skill-author` — Creates project skills for repeated Claude tasks, making future runs more efficient and deterministic
- `/mcp-author` — Bootstraps MCP servers for repeated workflows that can be encapsulated as tools

**Workflow integration:**
As you supervise multiple projects, use these skills to maintain consistency and automate repeated patterns:
- Keep documentation current with `/project-readme-author`
- Generate professional logos with `/project-logo-author`
- When you identify a repeated task on a project, use `/claude-skill-author` to create a skill so future runs are more efficient
- When you identify a repeated workflow that could be a tool, use `/mcp-author` to create an MCP server

### Sandboxed Execution — claudebox

**Problem:** Permission prompts interrupt your workflow, requiring constant attention.

**Solution:** [claudebox](https://github.com/tsilva/claudebox) runs Claude Code with full autonomy inside an isolated container — no permission prompts, no risk to your system.

**Key features:**
- Full autonomy — Claude can install packages, run commands, modify files without prompts
- Complete isolation — Container has no access to your host system except mounted project
- Same-path mounting — File paths work identically inside and outside the container
- Per-project config — Mount additional data directories via `.claudebox.json`

**Workflow integration:**
Run `claudebox` instead of `claude` in your project directory. Combined with the supervisor pattern, you can delegate tasks and switch away knowing Claude will work autonomously until completion — no prompts pulling you back.

### Idea Capture — capture

**Problem:** While supervising multiple projects, random thoughts interrupt your focus — ideas, reminders, tasks unrelated to the current work. Writing them down breaks flow; ignoring them risks forgetting.

**Solution:** [capture](https://github.com/tsilva/capture) sends thoughts to Gmail instantly via a single command or hotkey. Dump the idea, stay focused, process later.

**Key features:**
- Instant capture — Send notes to Gmail in under 2 seconds
- Multiple targets — Route messages to different inboxes (home, work)
- Hotkey ready — Alfred (macOS) integration for keyboard-triggered capture
- GTD methodology — Implements the "capture everything, process later" pattern

**Workflow integration:**
Bind `capture` to a global hotkey (e.g., `Cmd+Shift+I` via Alfred). When a random thought hits while supervising Claude instances — a grocery item, a feature idea for another project, a reminder — press the hotkey, type the thought, and return to supervising. Your inbox becomes a trusted collection point that you process during dedicated review sessions, triaging items into your todo lists.

### API Bridge — claudebridge

**Problem:** OpenRouter and other API providers charge per-token, making Opus 4.5 expensive for heavy usage.

**Solution:** [claudebridge](https://github.com/tsilva/claudebridge) creates an OpenAI-compatible API server that bridges to your Claude Max subscription — use Opus 4.5 at subscription cost instead of per-token pricing.

**Key features:**
- OpenAI-compatible — Drop-in replacement for `/v1/chat/completions` endpoint
- Uses Claude Max subscription — No separate API keys needed
- Streaming support — Server-Sent Events matching OpenAI's format
- Minimal footprint — ~200 lines of Python, few dependencies

**Workflow integration:**
For projects using OpenRouter or other OpenAI-compatible APIs, point them to `http://localhost:8000` instead. This lets you use Opus 4.5 at your subscription rate rather than per-token pricing — significant savings for heavy workflows.

## How It Works Together

The components integrate seamlessly to create a smooth supervisor experience:

1. **aerospace-setup** provides the workspace infrastructure — each Claude Code instance lives in its own dedicated workspace with instant keyboard switching
2. **agentpong** hooks into Claude Code events and sends desktop notifications when tasks complete or need input
3. **Clicking a notification** automatically switches to the correct workspace and focuses the window — or press `Alt+N` to cycle through pending notifications without reaching for the mouse
4. **claudebox** (optional) eliminates permission prompts, letting Claude work autonomously until completion

This integration means you can delegate a task, switch to another project, and be automatically brought back when Claude needs you — all without losing context or hunting for windows.

## Quick Start

The core workflow requires only two components:

### 1. Install aerospace-setup

```bash
brew install nikitabobko/tap/aerospace
git clone https://github.com/tsilva/aerospace-setup.git
cd aerospace-setup
./install.sh
```

### 2. Install agentpong

```bash
git clone https://github.com/tsilva/agentpong.git
cd agentpong
./install.sh
```

### 3. Verify the setup

```bash
# AeroSpace should be running
aerospace list-workspaces --all

# Hooks should be configured
grep -q "notify.sh" ~/.claude/settings.json && echo "✓ Hooks configured"

# Test a notification
~/.claude/notify.sh "Test notification"
```

### 4. Start supervising

1. Open Cursor/VS Code windows for each project you want to work on
2. Press `Alt+S` to auto-arrange Cursor windows across workspaces (one per workspace)
3. Use `Alt+1-9` to switch instantly between projects
4. Get notified when Claude completes tasks — click the notification or press `Alt+N` to jump back

## Example Session

Here's a concrete example of supervising three projects in parallel:

**Setup:**
```bash
# Define project priorities
cat > ~/.config/aerospace/cursor-projects.txt << 'EOF'
my-api-backend
my-web-frontend
my-mobile-app
EOF

# Open each project in Cursor, then arrange them
# Alt+S auto-assigns: my-api-backend → Alt+2, my-web-frontend → Alt+3, my-mobile-app → Alt+4
```

**Supervising:**
1. **Alt+2** — Open Claude Code in my-api-backend: "Add pagination to the /users endpoint"
2. **Alt+3** — Switch to my-web-frontend: "Update the user list component to handle paginated responses"
3. **Alt+4** — Switch to my-mobile-app: "Write unit tests for the login flow"
4. **Desktop notification:** "my-api-backend — Ready for input" — **click** to jump back
5. **Alt+2** — Review the pagination changes, then: "Now add rate limiting to that endpoint"
6. **Alt+N** — Another notification pending — jump to my-mobile-app to review tests
7. Repeat — delegate, switch, review, delegate

## Optional Enhancements

### Sandboxed Execution

**If you want Claude to work without any permission prompts:**

[claudebox](https://github.com/tsilva/claudebox) runs Claude Code inside an isolated Docker container with full autonomy — no permission prompts, no risk to your system.

```bash
git clone https://github.com/tsilva/claudebox.git
cd claudebox
./install.sh
```

Then use `claudebox` instead of `claude` in any project directory.

### Idea Capture

**If random thoughts interrupt your focus while supervising:**

[capture](https://github.com/tsilva/capture) sends thoughts to Gmail instantly. Dump the idea, stay in flow, process later.

```bash
uv tool install git+https://github.com/tsilva/capture.git
```

Requires Gmail API setup — see [capture](https://github.com/tsilva/capture) for configuration.

### API Bridge for Claude Max

**If you have a Claude Max subscription and want to avoid per-token API costs:**

[claudebridge](https://github.com/tsilva/claudebridge) creates an OpenAI-compatible API server that bridges to your subscription.

```bash
git clone https://github.com/tsilva/claudebridge.git
cd claudebridge
pip install -r requirements.txt
```

### Multi-Repo Status Overview

**If you need a bird's eye view of git status across all your projects:**

[gita](https://github.com/nosarthur/gita) consolidates git status, branches, and remote sync state into a single command.

```bash
pip install gita
```

## Configuration

### Project Priority

Edit `~/.config/aerospace/cursor-projects.txt` to control workspace assignment:

```
my-main-project      # Gets Alt+2 (fastest access)
api-backend          # Gets Alt+3
web-frontend         # Gets Alt+4
```

Projects listed first get lower workspace numbers. See [aerospace-setup](https://github.com/tsilva/aerospace-setup) for detailed configuration options.

## Keybindings

| Keybinding | Action | Provided by |
|------------|--------|-------------|
| `Alt+1` - `Alt+9` | Switch to workspace | aerospace-setup |
| `Alt+Shift+1` - `Alt+Shift+9` | Move window to workspace | aerospace-setup |
| `Alt+S` | Auto-arrange Cursor windows by priority | aerospace-setup |
| `Alt+P` | Switch between projects (Alfred) | aerospace-setup |
| `Alt+N` | Jump to next notification | agentpong |
| `Alt+C` | Quick capture to Gmail | capture |
| `Alt+F` | Toggle fullscreen | aerospace-setup |
| `Alt+Left` / `Alt+Right` | Navigate to adjacent workspace | aerospace-setup |

> **Note:** `Alt+N` and `Alt+C` keybindings are automatically enabled when aerospace-setup detects agentpong and capture during installation.

> **Note:** `Alt+S` specifically arranges Cursor windows. If you use VS Code instead, see [aerospace-setup](https://github.com/tsilva/aerospace-setup) for configuration options.

## Requirements

- **macOS** — AeroSpace only runs on macOS
- **[Homebrew](https://brew.sh)** — For installing AeroSpace and dependencies
- **[Claude Code](https://docs.anthropic.com/en/docs/claude-code)** — Anthropic's CLI for Claude
- **[Cursor](https://cursor.sh) or VS Code** — As your editor (Claude Code runs in the integrated terminal)

## Troubleshooting

**Workspace switching feels slow or animated**
Disable macOS window animations: System Settings → Accessibility → Display → Reduce motion. AeroSpace bypasses Spaces animations, but some system animations may still apply.

**Notifications not appearing**
1. Verify `terminal-notifier` is installed: `which terminal-notifier`
2. Check hooks are configured: `grep "notify.sh" ~/.claude/settings.json`
3. Check notification permissions: System Settings → Notifications → terminal-notifier → Allow Notifications
4. Test manually: `~/.claude/notify.sh "Test"`

**Notification click doesn't switch to the correct workspace**
1. Verify AeroSpace is running: `aerospace list-workspaces --all`
2. Grant Accessibility permissions: System Settings → Privacy & Security → Accessibility → AeroSpace

**Alt+S doesn't arrange windows**
1. Ensure `~/.config/aerospace/cursor-projects.txt` exists and lists your projects
2. This keybinding is Cursor-specific — see [aerospace-setup](https://github.com/tsilva/aerospace-setup) for VS Code configuration

**Hooks don't fire in standalone terminals**
Claude Code hooks only fire in IDE-integrated terminals (Cursor, VS Code). For standalone terminals like iTerm2, use the iTerm Triggers workaround — see [agentpong](https://github.com/tsilva/agentpong) for setup instructions.

## Related

- [aerospace-setup](https://github.com/tsilva/aerospace-setup) — AeroSpace configuration for the supervisor workflow
- [agentpong](https://github.com/tsilva/agentpong) — Notifications for Claude Code
- [claudebox](https://github.com/tsilva/claudebox) — Isolated execution environment for Claude Code
- [claudebridge](https://github.com/tsilva/claudebridge) — OpenAI-compatible API bridge for Claude Max subscriptions
- [claude-skills](https://github.com/tsilva/claude-skills) — Reusable skills for Claude Code
- [capture](https://github.com/tsilva/capture) — Instant thought capture to Gmail for GTD workflow
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) — Tiling window manager for macOS
- [gita](https://github.com/nosarthur/gita) — Manage multiple git repos

## License

MIT
