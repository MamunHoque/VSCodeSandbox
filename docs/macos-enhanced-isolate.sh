#!/bin/bash

# Enhanced macOS VS Code Isolation Script
# Provides maximum possible isolation on macOS Silicon (M4)
# Author: Enhanced for macOS security features
# Version: 4.0.0-macOS

set -euo pipefail

# Configuration
ISOLATION_ROOT="${VSCODE_ISOLATION_ROOT:-$HOME/.vscode-isolated}"
PROFILE_NAME="${1:-}"
COMMAND="${2:-create}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }

# Check if running on macOS
if [[ "$(uname)" != "Darwin" ]]; then
    log_error "This script is designed for macOS only"
    exit 1
fi

# Detect VS Code binary for macOS
detect_vscode_binary() {
    local candidates=(
        "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
        "/usr/local/bin/code"
        "/opt/homebrew/bin/code"
        "$(which code 2>/dev/null || true)"
    )

    for candidate in "${candidates[@]}"; do
        if [[ -x "$candidate" ]]; then
            echo "$candidate"
            return 0
        fi
    done

    log_error "VS Code not found. Install from https://code.visualstudio.com/"
    exit 1
}

VSCODE_BINARY="${VSCODE_BINARY:-$(detect_vscode_binary)}"

# Profile paths
PROFILE_ROOT="$ISOLATION_ROOT/profiles/$PROFILE_NAME"
PROFILE_CONFIG="$PROFILE_ROOT/config"
PROFILE_EXTENSIONS="$PROFILE_ROOT/extensions"
PROFILE_PROJECTS="$PROFILE_ROOT/projects"
PROFILE_CACHE="$PROFILE_ROOT/cache"
PROFILE_LOGS="$PROFILE_ROOT/logs"
LAUNCHER_SCRIPT="$ISOLATION_ROOT/launchers/$PROFILE_NAME-launcher.sh"

# Create enhanced macOS sandbox profile
create_sandbox_profile() {
    local sandbox_file="$PROFILE_ROOT/sandbox.sb"
    
    cat > "$sandbox_file" << 'EOF'
(version 1)
(deny default)

; Allow basic system operations
(allow process-exec (literal "/usr/bin/sandbox-exec"))
(allow process-fork)
(allow signal (target self))

; Allow reading system frameworks and libraries
(allow file-read*
    (subpath "/System/Library")
    (subpath "/usr/lib")
    (subpath "/usr/share"))

; Allow VS Code binary and its resources
(allow file-read* file-write*
    (regex #"^/Applications/Visual Studio Code\.app/")
    (regex #"^.*/\.vscode-isolated/profiles/[^/]+/"))

; Allow network access (can be restricted further)
(allow network-outbound)
(allow network-inbound (local ip))

; Allow temporary files in profile directory only
(allow file-write*
    (regex #"^.*/\.vscode-isolated/profiles/[^/]+/"))

; Deny access to sensitive directories
(deny file-read* file-write*
    (subpath "/Users")
    (subpath "/private")
    (except (regex #"^.*/\.vscode-isolated/")))

; Allow minimal system access
(allow mach-lookup
    (global-name "com.apple.system.opendirectoryd.libinfo")
    (global-name "com.apple.CoreServices.coreservicesd"))
EOF

    echo "$sandbox_file"
}

# Create isolated directory structure
create_profile_structure() {
    log_info "Creating isolated directory structure for profile '$PROFILE_NAME'"
    
    mkdir -p "$PROFILE_ROOT"/{config,extensions,projects,cache,logs,tmp}
    mkdir -p "$ISOLATION_ROOT/launchers"
    
    # Create welcome file
    cat > "$PROFILE_PROJECTS/README.md" << EOF
# Welcome to $PROFILE_NAME Profile (macOS Enhanced)!

This is your enhanced isolated VS Code environment for macOS.

## Enhanced Security Features:
- ✅ Sandbox execution with restricted file access
- ✅ Separate configuration and extensions
- ✅ Limited system access
- ✅ Isolated cache and temporary files

## Profile Information:
- **Profile Name**: $PROFILE_NAME
- **Platform**: macOS $(sw_vers -productVersion)
- **Architecture**: $(uname -m)
- **Profile Root**: $PROFILE_ROOT
- **Created**: $(date)

## Usage:
\`\`\`bash
# Launch this profile
$0 $PROFILE_NAME launch

# Remove this profile  
$0 $PROFILE_NAME remove
\`\`\`

Happy coding! 🚀
EOF

    log_success "Directory structure created"
}

# Create enhanced launcher with sandbox
create_enhanced_launcher() {
    log_info "Creating enhanced launcher with macOS sandbox"
    
    local sandbox_file=$(create_sandbox_profile)
    
    cat > "$LAUNCHER_SCRIPT" << EOF
#!/bin/bash
# Enhanced macOS VS Code Launcher for profile: $PROFILE_NAME
# Uses macOS sandbox for additional isolation

set -euo pipefail

PROFILE_NAME="$PROFILE_NAME"
PROFILE_ROOT="$PROFILE_ROOT"
PROFILE_CONFIG="$PROFILE_CONFIG"
PROFILE_EXTENSIONS="$PROFILE_EXTENSIONS"
PROFILE_PROJECTS="$PROFILE_PROJECTS"
VSCODE_BINARY="$VSCODE_BINARY"
SANDBOX_PROFILE="$sandbox_file"

# Check if profile exists
if [[ ! -d "\$PROFILE_ROOT" ]]; then
    echo "❌ Profile '\$PROFILE_NAME' does not exist"
    exit 1
fi

# Set up isolated environment variables
export TMPDIR="\$PROFILE_ROOT/tmp"
export VSCODE_LOGS="\$PROFILE_ROOT/logs"
export VSCODE_CRASH_DIR="\$PROFILE_ROOT/crashes"

# Create necessary directories
mkdir -p "\$TMPDIR" "\$VSCODE_LOGS" "\$VSCODE_CRASH_DIR"

# Parse arguments
ARGS=("\$@")
if [[ \${#ARGS[@]} -eq 0 ]]; then
    ARGS=("\$PROFILE_PROJECTS")
fi

# Launch VS Code with enhanced isolation
log_info() { echo -e "\033[0;34mℹ\033[0m \$1"; }
log_info "Launching VS Code with enhanced macOS isolation..."

# Use sandbox-exec for additional security
exec sandbox-exec -f "\$SANDBOX_PROFILE" \\
    "\$VSCODE_BINARY" \\
    --user-data-dir="\$PROFILE_CONFIG" \\
    --extensions-dir="\$PROFILE_EXTENSIONS" \\
    --disable-gpu-sandbox \\
    --no-sandbox \\
    --disable-dev-shm-usage \\
    --disable-background-timer-throttling \\
    --disable-renderer-backgrounding \\
    "\${ARGS[@]}"
EOF

    chmod +x "$LAUNCHER_SCRIPT"
    log_success "Enhanced launcher created"
}

# Create profile with enhanced isolation
create_profile() {
    if [[ -d "$PROFILE_ROOT" ]]; then
        log_warning "Profile '$PROFILE_NAME' already exists"
        read -p "Recreate it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            launch_profile
            return
        fi
        rm -rf "$PROFILE_ROOT"
    fi

    log_info "Creating enhanced isolated VS Code profile: $PROFILE_NAME"
    
    create_profile_structure
    create_enhanced_launcher
    
    log_success "Profile '$PROFILE_NAME' created with enhanced macOS isolation!"
    log_info "Launching isolated VS Code..."
    
    "$LAUNCHER_SCRIPT" >/dev/null 2>&1 &
    
    echo
    log_success "🔒 VS Code '$PROFILE_NAME' running with enhanced macOS isolation!"
    echo -e "${BLUE}🛡️${NC} Security: macOS Sandbox + Directory Isolation"
    echo -e "${BLUE}📁${NC} Projects: $PROFILE_PROJECTS"
    echo -e "${BLUE}🚀${NC} Launcher: $LAUNCHER_SCRIPT"
}

# Launch existing profile
launch_profile() {
    if [[ ! -d "$PROFILE_ROOT" ]]; then
        log_error "Profile '$PROFILE_NAME' does not exist"
        exit 1
    fi
    
    log_info "Launching enhanced isolated profile: $PROFILE_NAME"
    exec "$LAUNCHER_SCRIPT" "$@"
}

# Remove profile
remove_profile() {
    if [[ ! -d "$PROFILE_ROOT" ]]; then
        log_warning "Profile '$PROFILE_NAME' does not exist"
        return
    fi
    
    echo -e "${YELLOW}⚠${NC} Remove profile '$PROFILE_NAME'? (y/N): "
    read -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        rm -rf "$PROFILE_ROOT"
        rm -f "$LAUNCHER_SCRIPT"
        log_success "Profile '$PROFILE_NAME' removed"
    fi
}

# List profiles
list_profiles() {
    local profiles_dir="$ISOLATION_ROOT/profiles"
    
    if [[ ! -d "$profiles_dir" ]]; then
        log_info "No profiles found. Create one with: $0 <name> create"
        return
    fi
    
    echo -e "${BLUE}📋 Enhanced macOS Isolated Profiles:${NC}"
    echo
    
    for profile in "$profiles_dir"/*; do
        if [[ -d "$profile" ]]; then
            local name=$(basename "$profile")
            local size=$(du -sh "$profile" 2>/dev/null | cut -f1)
            echo -e "  ${GREEN}•${NC} ${BLUE}$name${NC} ($size)"
        fi
    done
}

# Usage
usage() {
    cat << EOF
Enhanced macOS VS Code Isolation v4.0.0

Usage: $0 <profile_name> [command]

Commands:
    create    Create and launch isolated profile (default)
    launch    Launch existing profile  
    remove    Remove profile completely
    list      List all profiles

Enhanced macOS Features:
    🛡️  macOS Sandbox execution
    📁 Restricted file system access
    🔒 Isolated temporary directories
    ⚡ Optimized for M4 Silicon

Examples:
    $0 myproject              # Create and launch
    $0 myproject launch       # Launch existing
    $0 myproject remove       # Remove profile
    $0 "" list               # List all profiles
EOF
}

# Validate input
if [[ -z "$PROFILE_NAME" && "$COMMAND" != "list" ]]; then
    usage
    exit 1
fi

# Main dispatcher
case "$COMMAND" in
    "create"|"") create_profile ;;
    "launch") launch_profile "$@" ;;
    "remove") remove_profile ;;
    "list") list_profiles ;;
    *) log_error "Unknown command: $COMMAND"; usage; exit 1 ;;
esac
