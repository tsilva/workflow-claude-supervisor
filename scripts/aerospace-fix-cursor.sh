#!/bin/bash
# =============================================================================
# aerospace-fix-cursor.sh - Auto-arrange Cursor windows across workspaces
# =============================================================================
#
# This script distributes Cursor windows across AeroSpace workspaces based on
# a priority list. It's designed for workflows where you run multiple Claude
# Code instances in different Cursor windows, each working on a different project.
#
# Usage:
#   - Press Alt+C (or your configured keybinding) to run this script
#   - Cursor windows are moved to workspaces 2-9 based on project priority
#   - Workspace 1 is reserved for browsers, notes, and other apps
#
# Configuration:
#   Edit ~/.config/aerospace/cursor-projects.txt to set project priority order.
#   List project directory names (one per line), highest priority first.
#
# How it works:
#   1. Reads project names from config file
#   2. Lists all Cursor windows
#   3. Moves windows to workspaces 2+ in priority order
#   4. Remaining windows are placed in subsequent workspaces
#
# =============================================================================

# Read project priority order from config file
CONFIG_FILE="$HOME/.config/aerospace/cursor-projects.txt"
if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi

# Read projects into array (compatible with bash 3 on macOS)
PROJECTS=()
while IFS= read -r line || [ -n "$line" ]; do
  # Skip empty lines and comments
  [[ -z "$line" || "$line" =~ ^# ]] && continue
  PROJECTS+=("$line")
done < "$CONFIG_FILE"

# Get all Cursor windows
WINDOWS=$(aerospace list-windows --all | grep "| Cursor")

# Track which window IDs we've processed
PROCESSED_IDS=()

# Assign workspaces starting at 2 (workspace 1 is for browsers/notes)
WS=2

# First pass: move known projects in priority order
for project in "${PROJECTS[@]}"; do
  WINDOW_ID=$(echo "$WINDOWS" | grep "$project" | awk '{print $1}')
  if [ -n "$WINDOW_ID" ]; then
    aerospace move-node-to-workspace "$WS" --window-id "$WINDOW_ID"
    PROCESSED_IDS+=("$WINDOW_ID")
    ((WS++))
  fi
done

# Second pass: move any remaining Cursor windows to subsequent workspaces
ALL_IDS=$(echo "$WINDOWS" | awk '{print $1}')
for WINDOW_ID in $ALL_IDS; do
  [ -z "$WINDOW_ID" ] && continue

  # Check if this ID was already processed
  FOUND=0
  for PROCESSED in "${PROCESSED_IDS[@]}"; do
    if [ "$WINDOW_ID" = "$PROCESSED" ]; then
      FOUND=1
      break
    fi
  done

  if [ "$FOUND" -eq 0 ]; then
    aerospace move-node-to-workspace "$WS" --window-id "$WINDOW_ID"
    ((WS++))
  fi
done
