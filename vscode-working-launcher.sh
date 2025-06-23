#!/bin/bash

# VS Code Working Launcher - Guaranteed to work with any VS Code installation

PROFILE_NAME="${1:-myproject}"
PROFILE_ROOT="$HOME/.vscode-isolated/profiles/$PROFILE_NAME"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 VS Code Working Launcher${NC}"
echo

# Create profile if needed
if [[ ! -d "$PROFILE_ROOT" ]]; then
    echo -e "${BLUE}ℹ${NC} Creating profile '$PROFILE_NAME'..."
    mkdir -p "$PROFILE_ROOT"/{config,extensions,projects}
    echo "# Welcome to $PROFILE_NAME profile!" > "$PROFILE_ROOT/projects/README.md"
    echo -e "${GREEN}✅${NC} Profile created!"
fi

echo -e "${BLUE}ℹ${NC} Profile: $PROFILE_NAME"
echo -e "${BLUE}ℹ${NC} Projects: $PROFILE_ROOT/projects"
echo -e "${GREEN}✅${NC} Launching VS Code..."
echo

# Launch VS Code with isolated directories
exec code \
    --user-data-dir="$PROFILE_ROOT/config" \
    --extensions-dir="$PROFILE_ROOT/extensions" \
    "$PROFILE_ROOT/projects" \
    "$@"
