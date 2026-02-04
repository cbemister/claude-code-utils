#!/bin/bash

# Install Claude Code Skills
# Copies skill sources from this repo to ~/.claude/skills/

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
SKILLS_SRC="$REPO_DIR/.claude/skills"
SKILLS_DEST="$HOME/.claude/skills"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo ""
echo -e "${BLUE}Claude Code Skills Installer${NC}"
echo "=============================="
echo ""

# Check if skills source directory exists
if [ ! -d "$SKILLS_SRC" ]; then
  echo "Error: Skills source directory not found: $SKILLS_SRC"
  exit 1
fi

# Count available skills
SKILL_COUNT=$(find "$SKILLS_SRC" -maxdepth 1 -type d -not -name ".*" | wc -l)
SKILL_COUNT=$((SKILL_COUNT - 1))  # Subtract the parent directory itself
echo "Found $SKILL_COUNT skills in $SKILLS_SRC"
echo ""

# Parse arguments
INSTALL_ALL=false
SKILL_NAME=""

if [ "$1" == "--all" ] || [ -z "$1" ]; then
  INSTALL_ALL=true
elif [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
  echo "Usage:"
  echo "  $0              # Install all skills (default)"
  echo "  $0 --all        # Install all skills"
  echo "  $0 <skill-name> # Install specific skill"
  echo "  $0 --list       # List available skills"
  echo ""
  exit 0
elif [ "$1" == "--list" ]; then
  echo "Available skills:"
  for dir in "$SKILLS_SRC"/*; do
    if [ -d "$dir" ] && [ -f "$dir/SKILL.md" ]; then
      skill=$(basename "$dir")
      echo "  - $skill"
    fi
  done
  echo ""
  exit 0
else
  SKILL_NAME="$1"
fi

# Function to install a single skill
install_skill() {
  local skill_dir="$1"
  local skill_name=$(basename "$skill_dir")

  # Skip if not a directory or no SKILL.md
  if [ ! -d "$skill_dir" ] || [ ! -f "$skill_dir/SKILL.md" ]; then
    return
  fi

  local dest_dir="$SKILLS_DEST/$skill_name"

  # Create destination directory
  mkdir -p "$dest_dir"

  # Copy skill file
  cp "$skill_dir/SKILL.md" "$dest_dir/SKILL.md"

  echo -e "  ${GREEN}✓${NC} Installed: $skill_name"
}

# Install skills
if [ "$INSTALL_ALL" == true ]; then
  echo "Installing all skills to: $SKILLS_DEST"
  echo ""

  for skill_dir in "$SKILLS_SRC"/*; do
    install_skill "$skill_dir"
  done
else
  # Install specific skill
  skill_dir="$SKILLS_SRC/$SKILL_NAME"

  if [ ! -d "$skill_dir" ] || [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "Error: Skill not found: $SKILL_NAME"
    echo ""
    echo "Available skills:"
    for dir in "$SKILLS_SRC"/*; do
      if [ -d "$dir" ] && [ -f "$dir/SKILL.md" ]; then
        skill=$(basename "$dir")
        echo "  - $skill"
      fi
    done
    exit 1
  fi

  echo "Installing skill: $SKILL_NAME"
  echo ""
  install_skill "$skill_dir"
fi

echo ""
echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. Restart Claude Code (close and reopen VSCode)"
echo "  2. Skills will appear as slash commands (e.g., /create-plan)"
echo ""
echo "Installed skills location: $SKILLS_DEST"
echo ""
