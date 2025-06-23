#!/bin/bash

# VS Code Quick Launcher - Simple, reliable launcher that works everywhere
# Auto-creates profiles and launches VS Code with the best available isolation

set -euo pipefail

# Configuration
PROFILE_NAME="${1:-myproject}"
ISOLATION_ROOT="${VSCODE_ISOLATION_ROOT:-$HOME/.vscode-isolated}"
PROFILE_ROOT="$ISOLATION_ROOT/profiles/$PROFILE_NAME"
PROFILE_HOME="$PROFILE_ROOT/home"

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_header() { echo -e "${PURPLE}🚀${NC} $1"; }

# Detect VS Code binary
detect_vscode() {
    local candidates=("/snap/bin/code" "/usr/bin/code" "/usr/local/bin/code" "$(which code 2>/dev/null || true)")
    for candidate in "${candidates[@]}"; do
        if [[ -x "$candidate" ]]; then
            echo "$candidate"
            return 0
        fi
    done
    echo ""
}

VSCODE_BINARY="$(detect_vscode)"
if [[ -z "$VSCODE_BINARY" ]]; then
    echo "❌ VS Code not found. Please install VS Code first."
    exit 1
fi

# Auto-create profile if needed
create_profile_if_needed() {
    if [[ ! -d "$PROFILE_ROOT" ]]; then
        log_info "Creating profile '$PROFILE_NAME'..."
        
        # Create directory structure
        mkdir -p "$PROFILE_HOME"/{.config,.cache,.local/{share,bin},.vscode}
        mkdir -p "$PROFILE_ROOT"/{tmp,projects}
        mkdir -p "$PROFILE_HOME/.config/Code"
        mkdir -p "$PROFILE_HOME/.cache/Code"
        mkdir -p "$PROFILE_HOME/.local/share/Code/extensions"
        
        log_success "Profile '$PROFILE_NAME' created!"
    fi
}

# Launch VS Code with best available isolation
launch_vscode() {
    log_info "Launching VS Code for profile '$PROFILE_NAME'..."
    
    # Setup isolated environment
    export HOME="$PROFILE_HOME"
    export XDG_CONFIG_HOME="$PROFILE_HOME/.config"
    export XDG_CACHE_HOME="$PROFILE_HOME/.cache"
    export XDG_DATA_HOME="$PROFILE_HOME/.local/share"
    export XDG_RUNTIME_DIR="$PROFILE_ROOT/tmp/runtime"
    export TMPDIR="$PROFILE_ROOT/tmp"
    
    # Create runtime directory
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    
    # Try namespace isolation first, fallback to basic isolation
    if command -v unshare >/dev/null 2>&1 && unshare -U true 2>/dev/null; then
        log_success "Using namespace isolation - launching VS Code..."
        exec unshare -U -i \
            "$VSCODE_BINARY" \
            --user-data-dir="$XDG_CONFIG_HOME/Code" \
            --extensions-dir="$XDG_DATA_HOME/Code/extensions" \
            --disable-gpu-sandbox \
            --no-sandbox \
            "$PROFILE_ROOT/projects" \
            "$@"
    else
        log_warning "Using basic isolation - launching VS Code..."
        exec "$VSCODE_BINARY" \
            --user-data-dir="$XDG_CONFIG_HOME/Code" \
            --extensions-dir="$XDG_DATA_HOME/Code/extensions" \
            --disable-gpu-sandbox \
            --no-sandbox \
            "$PROFILE_ROOT/projects" \
            "$@"
    fi
}

# Main function
main() {
    log_header "VS Code Quick Launcher"
    echo
    
    log_info "Profile: $PROFILE_NAME"
    log_info "VS Code: $VSCODE_BINARY"
    log_info "Projects: $PROFILE_ROOT/projects"
    echo
    
    create_profile_if_needed
    launch_vscode "$@"
}

# Show usage if no arguments
if [[ $# -eq 0 ]]; then
    echo "🚀 VS Code Quick Launcher"
    echo
    echo "Usage: $0 <profile_name>"
    echo
    echo "Examples:"
    echo "  $0 myproject     # Launch myproject profile"
    echo "  $0 client-work   # Launch client-work profile"
    echo
    exit 0
fi

# Run main function
main "$@"
