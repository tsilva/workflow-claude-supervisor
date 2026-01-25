#!/bin/bash
# =============================================================================
# install.sh - Installer for workflow-claude-supervisor
# =============================================================================
#
# This script sets up AeroSpace configuration for the multi-instance
# Claude Code workflow on macOS.
#
# What it does:
#   1. Checks for macOS and Homebrew
#   2. Installs AeroSpace if needed
#   3. Copies configuration files to correct locations
#   4. Makes scripts executable
#   5. Provides next steps for notifications setup
#
# =============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}  workflow-claude-supervisor installer${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# -----------------------------------------------------------------------------
# Check macOS
# -----------------------------------------------------------------------------
if [[ "$(uname)" != "Darwin" ]]; then
  echo -e "${RED}Error: This workflow is designed for macOS only.${NC}"
  exit 1
fi
echo -e "${GREEN}[OK]${NC} Running on macOS"

# -----------------------------------------------------------------------------
# Check Homebrew
# -----------------------------------------------------------------------------
if ! command -v brew &> /dev/null; then
  echo -e "${RED}Error: Homebrew is not installed.${NC}"
  echo "Install it from: https://brew.sh"
  exit 1
fi
echo -e "${GREEN}[OK]${NC} Homebrew is installed"

# -----------------------------------------------------------------------------
# Install AeroSpace
# -----------------------------------------------------------------------------
if ! command -v aerospace &> /dev/null; then
  echo -e "${YELLOW}[*]${NC} Installing AeroSpace..."
  brew install --cask nikitabobko/tap/aerospace
  echo -e "${GREEN}[OK]${NC} AeroSpace installed"
else
  echo -e "${GREEN}[OK]${NC} AeroSpace is already installed"
fi

# -----------------------------------------------------------------------------
# Backup existing configs
# -----------------------------------------------------------------------------
backup_if_exists() {
  local file="$1"
  if [ -f "$file" ]; then
    local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
    cp "$file" "$backup"
    echo -e "${YELLOW}[*]${NC} Backed up existing $(basename "$file") to $(basename "$backup")"
  fi
}

# -----------------------------------------------------------------------------
# Copy configuration files
# -----------------------------------------------------------------------------
echo ""
echo -e "${BLUE}Installing configuration files...${NC}"

# AeroSpace config
backup_if_exists "$HOME/.aerospace.toml"
cp "$SCRIPT_DIR/config/aerospace.toml" "$HOME/.aerospace.toml"
echo -e "${GREEN}[OK]${NC} Installed ~/.aerospace.toml"

# Create config directory
mkdir -p "$HOME/.config/aerospace"

# Project priority list
backup_if_exists "$HOME/.config/aerospace/cursor-projects.txt"
cp "$SCRIPT_DIR/config/cursor-projects.txt" "$HOME/.config/aerospace/cursor-projects.txt"
echo -e "${GREEN}[OK]${NC} Installed ~/.config/aerospace/cursor-projects.txt"

# Fix Cursor script
backup_if_exists "$HOME/.aerospace-fix-cursor.sh"
cp "$SCRIPT_DIR/scripts/aerospace-fix-cursor.sh" "$HOME/.aerospace-fix-cursor.sh"
chmod +x "$HOME/.aerospace-fix-cursor.sh"
echo -e "${GREEN}[OK]${NC} Installed ~/.aerospace-fix-cursor.sh"

# -----------------------------------------------------------------------------
# Reload AeroSpace if running
# -----------------------------------------------------------------------------
if pgrep -x "AeroSpace" > /dev/null; then
  echo ""
  echo -e "${YELLOW}[*]${NC} Reloading AeroSpace configuration..."
  aerospace reload-config 2>/dev/null || true
  echo -e "${GREEN}[OK]${NC} Configuration reloaded"
fi

# -----------------------------------------------------------------------------
# Success message and next steps
# -----------------------------------------------------------------------------
echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}  Installation complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo -e "${BLUE}Next steps:${NC}"
echo ""
echo "1. Start AeroSpace (it will auto-start on next login):"
echo "   open -a AeroSpace"
echo ""
echo "2. Edit your project priority list:"
echo "   nano ~/.config/aerospace/cursor-projects.txt"
echo ""
echo "3. Open Cursor windows for your projects, then press Alt+C"
echo "   to auto-arrange them across workspaces 2-9"
echo ""
echo "4. Use Alt+1-9 to switch between workspaces instantly"
echo ""
echo -e "${BLUE}For notifications when Claude Code tasks complete:${NC}"
echo "   See: https://github.com/tsilva/claude-code-notify"
echo ""
echo -e "${BLUE}Keybindings:${NC}"
echo "   Alt+1-9       Switch to workspace"
echo "   Alt+Shift+1-9 Move window to workspace"
echo "   Alt+C         Auto-arrange Cursor windows"
echo "   Alt+F         Toggle fullscreen"
echo "   Alt+Left/Right Navigate workspaces"
echo ""
