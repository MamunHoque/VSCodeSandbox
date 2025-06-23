#!/bin/bash

# VS Code Smart Launcher - Auto-detects best isolation method and launches VS Code
# Handles namespace issues automatically and provides fallback options

set -euo pipefail

# Configuration
PROFILE_NAME="${1:-myproject}"
ISOLATION_ROOT="${VSCODE_ISOLATION_ROOT:-$HOME/.vscode-isolated}"
PROFILE_ROOT="$ISOLATION_ROOT/profiles/$PROFILE_NAME"
PROFILE_HOME="$PROFILE_ROOT/home"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }
log_header() { echo -e "${PURPLE}🚀${NC} $1"; }

# Detect VS Code binary
detect_vscode_binary() {
    local candidates=(
        "/snap/bin/code"
        "/usr/bin/code"
        "/usr/local/bin/code"
        "/opt/visual-studio-code/bin/code"
        "$(which code 2>/dev/null || true)"
    )
    
    for candidate in "${candidates[@]}"; do
        if [[ -x "$candidate" ]]; then
            echo "$candidate"
            return 0
        fi
    done
    
    log_error "VS Code binary not found. Please install VS Code."
    exit 1
}

VSCODE_BINARY="$(detect_vscode_binary)"

# Test isolation capabilities
test_isolation_capabilities() {
    log_info "Testing isolation capabilities..."
    
    # Test 1: Basic namespace support
    if ! command -v unshare >/dev/null 2>&1; then
        echo "none"
        return
    fi
    
    # Test 2: User namespace support
    if ! unshare -U true 2>/dev/null; then
        echo "basic"
        return
    fi
    
    # Test 3: Mount namespace support (without actual mounting)
    if unshare -U -m true 2>/dev/null; then
        echo "full"
        return
    fi
    
    echo "basic"
}

# Launch with full namespace isolation
launch_full_isolation() {
    log_info "Launching with full namespace isolation..."
    
    # Setup environment variables
    export HOME="$PROFILE_HOME"
    export XDG_CONFIG_HOME="$PROFILE_HOME/.config"
    export XDG_CACHE_HOME="$PROFILE_HOME/.cache"
    export XDG_DATA_HOME="$PROFILE_HOME/.local/share"
    export XDG_STATE_HOME="$PROFILE_HOME/.local/state"
    export XDG_RUNTIME_DIR="$PROFILE_ROOT/tmp/runtime"
    export TMPDIR="$PROFILE_ROOT/tmp"
    export TMP="$PROFILE_ROOT/tmp"
    export TEMP="$PROFILE_ROOT/tmp"
    
    # Create runtime directory
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    
    # Launch with namespace isolation (without mount operations)
    exec unshare -U -i -p --fork \
        "$VSCODE_BINARY" \
        --user-data-dir="$XDG_CONFIG_HOME/Code" \
        --extensions-dir="$XDG_DATA_HOME/Code/extensions" \
        --disable-gpu-sandbox \
        --no-sandbox \
        "$PROFILE_ROOT/projects" \
        "$@"
}

# Launch with basic isolation
launch_basic_isolation() {
    log_info "Launching with basic isolation..."
    
    # Setup environment variables
    export HOME="$PROFILE_HOME"
    export XDG_CONFIG_HOME="$PROFILE_HOME/.config"
    export XDG_CACHE_HOME="$PROFILE_HOME/.cache"
    export XDG_DATA_HOME="$PROFILE_HOME/.local/share"
    export XDG_STATE_HOME="$PROFILE_HOME/.local/state"
    export XDG_RUNTIME_DIR="$PROFILE_ROOT/tmp/runtime"
    export TMPDIR="$PROFILE_ROOT/tmp"
    export TMP="$PROFILE_ROOT/tmp"
    export TEMP="$PROFILE_ROOT/tmp"
    
    # Create runtime directory
    mkdir -p "$XDG_RUNTIME_DIR"
    chmod 700 "$XDG_RUNTIME_DIR"
    
    # Launch with basic isolation
    exec "$VSCODE_BINARY" \
        --user-data-dir="$XDG_CONFIG_HOME/Code" \
        --extensions-dir="$XDG_DATA_HOME/Code/extensions" \
        --disable-gpu-sandbox \
        --no-sandbox \
        "$PROFILE_ROOT/projects" \
        "$@"
}

# Launch without isolation (fallback)
launch_no_isolation() {
    log_warning "Launching without isolation (fallback mode)..."
    
    # Launch VS Code normally but with custom directories
    exec "$VSCODE_BINARY" \
        --user-data-dir="$PROFILE_ROOT/home/.config/Code" \
        --extensions-dir="$PROFILE_ROOT/home/.local/share/Code/extensions" \
        "$PROFILE_ROOT/projects" \
        "$@"
}

# Auto-create profile if it doesn't exist
auto_create_profile() {
    if [[ ! -d "$PROFILE_ROOT" ]]; then
        log_info "Profile '$PROFILE_NAME' doesn't exist. Creating it automatically..."
        
        # Create directory structure
        mkdir -p "$PROFILE_HOME"/{.config,.cache,.local/{share/{applications,mime},bin},.vscode}
        mkdir -p "$PROFILE_ROOT"/{tmp,projects}
        mkdir -p "$PROFILE_HOME/.config"/{Code,fontconfig,gtk-3.0,dconf}
        mkdir -p "$PROFILE_HOME/.cache"/{Code,fontconfig}
        mkdir -p "$PROFILE_HOME/.local/share"/{Code,applications,mime,fonts,themes,icons}
        
        # Create basic profile environment
        cat > "$PROFILE_HOME/.profile" << 'EOF'
# Isolated VS Code Profile Environment
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_RUNTIME_DIR="/tmp/runtime-$(id -u)"
mkdir -p "$XDG_RUNTIME_DIR"
chmod 700 "$XDG_RUNTIME_DIR"
EOF
        
        log_success "Profile '$PROFILE_NAME' created successfully!"
    fi
}

# Main launcher logic
main() {
    log_header "VS Code Smart Launcher"
    echo
    
    # Auto-create profile if needed
    auto_create_profile
    
    # Detect isolation capabilities
    local isolation_level
    isolation_level=$(test_isolation_capabilities)
    
    log_info "Profile: $PROFILE_NAME"
    log_info "VS Code Binary: $VSCODE_BINARY"
    log_info "Isolation Level: $isolation_level"
    log_info "Projects Directory: $PROFILE_ROOT/projects"
    echo
    
    # Launch based on capabilities
    case "$isolation_level" in
        "full")
            log_success "Full namespace isolation available!"
            launch_full_isolation "$@"
            ;;
        "basic")
            log_warning "Limited namespace support - using basic isolation"
            launch_basic_isolation "$@"
            ;;
        "none")
            log_warning "No namespace support - using fallback mode"
            launch_no_isolation "$@"
            ;;
        *)
            log_error "Unknown isolation level: $isolation_level"
            exit 1
            ;;
    esac
}

# Show usage if no arguments
if [[ $# -eq 0 ]]; then
    cat << EOF
Usage: $0 <profile_name> [vscode_arguments...]

Examples:
  $0 myproject                    # Launch myproject profile
  $0 client-work                  # Launch client-work profile
  $0 experimental --new-window    # Launch with VS Code arguments

Features:
  • Auto-detects best isolation method
  • Creates profile automatically if missing
  • Handles namespace permission issues
  • Provides fallback options
  • Launches VS Code automatically

EOF
    exit 0
fi

# Run main function
main "$@"
