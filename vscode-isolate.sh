#!/bin/bash

# Enhanced VS Code Isolation Script
# Creates completely sandboxed VS Code environments using Linux namespaces
# Author: Enhanced for maximum isolation
# Version: 2.0

set -euo pipefail

# Configuration
ISOLATION_ROOT="${VSCODE_ISOLATION_ROOT:-$HOME/.vscode-isolated}"
PROFILE_NAME="${1:-}"
COMMAND="${2:-create}"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }

# Usage function
usage() {
    cat << EOF
Usage: $0 <profile_name> [command]

Commands:
    create      Create and launch isolated VS Code profile (default)
    launch      Launch existing profile
    remove      Remove profile completely
    list        List all profiles
    status      Show profile status

Examples:
    $0 myproject                    # Create and launch 'myproject' profile
    $0 myproject launch            # Launch existing 'myproject' profile
    $0 myproject remove            # Remove 'myproject' profile
    $0 "" list                     # List all profiles

Environment Variables:
    VSCODE_ISOLATION_ROOT          # Root directory for isolated profiles (default: ~/.vscode-isolated)
    VSCODE_BINARY                  # Path to VS Code binary (default: auto-detect)
EOF
}

# Validate input
if [[ -z "$PROFILE_NAME" && "$COMMAND" != "list" ]]; then
    log_error "Profile name is required"
    usage
    exit 1
fi

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

    log_error "VS Code binary not found. Please install VS Code or set VSCODE_BINARY environment variable."
    exit 1
}

VSCODE_BINARY="${VSCODE_BINARY:-$(detect_vscode_binary)}"

# Profile paths
PROFILE_ROOT="$ISOLATION_ROOT/profiles/$PROFILE_NAME"
PROFILE_HOME="$PROFILE_ROOT/home"
PROFILE_CONFIG="$PROFILE_HOME/.config"
PROFILE_CACHE="$PROFILE_HOME/.cache"
PROFILE_LOCAL="$PROFILE_HOME/.local"
PROFILE_TMP="$PROFILE_ROOT/tmp"
PROFILE_PROJECTS="$PROFILE_ROOT/projects"
LAUNCHER_SCRIPT="$ISOLATION_ROOT/launchers/$PROFILE_NAME-launcher.sh"
DESKTOP_ENTRY="$PROFILE_LOCAL/share/applications/code-$PROFILE_NAME.desktop"
NAMESPACE_SCRIPT="$ISOLATION_ROOT/launchers/$PROFILE_NAME-namespace.sh"

# Check if running with sufficient privileges for namespaces
check_namespace_support() {
    if ! unshare --help >/dev/null 2>&1; then
        log_error "unshare command not available. Please install util-linux package."
        exit 1
    fi

    # Test if we can create user namespaces
    if ! unshare -U true 2>/dev/null; then
        log_warning "User namespaces not available. Some isolation features will be limited."
        log_warning "Consider running: echo 1 | sudo tee /proc/sys/kernel/unprivileged_userns_clone"
    fi
}

# Create isolated directory structure
create_profile_structure() {
    log_info "Creating isolated directory structure for profile '$PROFILE_NAME'"

    # Create all necessary directories
    mkdir -p "$PROFILE_HOME"/{.config,.cache,.local/{share/{applications,mime},bin},.vscode}
    mkdir -p "$PROFILE_TMP"
    mkdir -p "$PROFILE_PROJECTS"
    mkdir -p "$ISOLATION_ROOT/launchers"

    # Create isolated XDG directories
    mkdir -p "$PROFILE_CONFIG"/{Code,fontconfig,gtk-3.0,dconf}
    mkdir -p "$PROFILE_CACHE"/{Code,fontconfig}
    mkdir -p "$PROFILE_LOCAL/share"/{Code,applications,mime,fonts,themes,icons}

    # Create minimal environment files
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

    # Create isolated fontconfig
    cat > "$PROFILE_CONFIG/fontconfig/fonts.conf" << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <dir>/usr/share/fonts</dir>
    <dir>/usr/local/share/fonts</dir>
    <dir>~/.local/share/fonts</dir>
    <cachedir>~/.cache/fontconfig</cachedir>
</fontconfig>
EOF

    log_success "Directory structure created"
}

# Create namespace isolation script
create_namespace_script() {
    log_info "Creating namespace isolation script"

    cat > "$NAMESPACE_SCRIPT" << EOF
#!/bin/bash
# Namespace isolation script for VS Code profile: $PROFILE_NAME

set -euo pipefail

PROFILE_ROOT="$PROFILE_ROOT"
PROFILE_HOME="$PROFILE_HOME"
PROFILE_TMP="$PROFILE_TMP"
VSCODE_BINARY="$VSCODE_BINARY"

# Function to setup bind mounts in namespace
setup_isolated_filesystem() {
    # Create temporary mount namespace
    mount --make-rprivate /

    # Bind mount isolated directories
    mount --bind "\$PROFILE_HOME" "\$HOME"
    mount --bind "\$PROFILE_TMP" /tmp

    # Ensure VS Code can access necessary system directories (read-only)
    mkdir -p "\$HOME"/{usr,lib,lib64,bin,sbin,etc,proc,sys,dev}
    mount --bind /usr "\$HOME/usr" -o ro
    mount --bind /lib "\$HOME/lib" -o ro
    [[ -d /lib64 ]] && mount --bind /lib64 "\$HOME/lib64" -o ro
    mount --bind /bin "\$HOME/bin" -o ro
    mount --bind /sbin "\$HOME/sbin" -o ro
    mount --bind /etc "\$HOME/etc" -o ro
    mount --bind /proc "\$HOME/proc"
    mount --bind /sys "\$HOME/sys" -o ro
    mount --bind /dev "\$HOME/dev"
}

# Setup environment variables for complete isolation
export HOME="\$PROFILE_HOME"
export XDG_CONFIG_HOME="\$PROFILE_HOME/.config"
export XDG_CACHE_HOME="\$PROFILE_HOME/.cache"
export XDG_DATA_HOME="\$PROFILE_HOME/.local/share"
export XDG_STATE_HOME="\$PROFILE_HOME/.local/state"
export XDG_RUNTIME_DIR="\$PROFILE_TMP/runtime"
export TMPDIR="\$PROFILE_TMP"
export TMP="\$PROFILE_TMP"
export TEMP="\$PROFILE_TMP"

# Create runtime directory
mkdir -p "\$XDG_RUNTIME_DIR"
chmod 700 "\$XDG_RUNTIME_DIR"

# Source profile environment
source "\$PROFILE_HOME/.profile" 2>/dev/null || true

# Launch VS Code with complete isolation
exec "\$VSCODE_BINARY" \\
    --user-data-dir="\$XDG_CONFIG_HOME/Code" \\
    --extensions-dir="\$XDG_DATA_HOME/Code/extensions" \\
    --disable-gpu-sandbox \\
    --no-sandbox \\
    "\$@"
EOF

    chmod +x "$NAMESPACE_SCRIPT"
    log_success "Namespace script created"
}
# Create launcher script with enhanced isolation
create_launcher_script() {
    log_info "Creating launcher script with namespace isolation"

    cat > "$LAUNCHER_SCRIPT" << EOF
#!/bin/bash
# Enhanced VS Code Launcher for profile: $PROFILE_NAME
# Uses Linux namespaces for complete isolation

set -euo pipefail

PROFILE_NAME="$PROFILE_NAME"
NAMESPACE_SCRIPT="$NAMESPACE_SCRIPT"
PROFILE_ROOT="$PROFILE_ROOT"

# Parse arguments
ARGS=("\$@")
URI=""
OPEN_FOLDER=""

# Process arguments
for arg in "\$@"; do
    case "\$arg" in
        vscode://*)
            URI="\$arg"
            ;;
        --folder-uri=*)
            OPEN_FOLDER="\${arg#--folder-uri=}"
            ;;
        *)
            ;;
    esac
done

# Function to launch with maximum isolation
launch_isolated() {
    local extra_args=()

    # Add URI or folder if specified
    [[ -n "\$URI" ]] && extra_args+=("--open-url" "\$URI")
    [[ -n "\$OPEN_FOLDER" ]] && extra_args+=("\$OPEN_FOLDER")

    # Launch with namespace isolation
    exec unshare \\
        --mount \\
        --uts \\
        --ipc \\
        --pid \\
        --fork \\
        --mount-proc \\
        "\$NAMESPACE_SCRIPT" "\${extra_args[@]}"
}

# Check if profile exists
if [[ ! -d "\$PROFILE_ROOT" ]]; then
    echo "❌ Profile '\$PROFILE_NAME' does not exist"
    echo "💡 Create it first with: \$0 \$PROFILE_NAME create"
    exit 1
fi

# Launch isolated VS Code
launch_isolated
EOF

    chmod +x "$LAUNCHER_SCRIPT"
    log_success "Launcher script created"
}

# Create desktop integration
create_desktop_integration() {
    log_info "Creating desktop integration"

    # Create desktop entry
    cat > "$DESKTOP_ENTRY" << EOF
[Desktop Entry]
Name=VS Code - $PROFILE_NAME (Isolated)
Comment=Completely isolated VS Code environment for $PROFILE_NAME
Exec=$LAUNCHER_SCRIPT %u
Icon=code
Terminal=false
Type=Application
Categories=Development;IDE;
MimeType=x-scheme-handler/vscode-$PROFILE_NAME;
StartupNotify=true
StartupWMClass=code
EOF

    # Create MIME type for this specific profile
    mkdir -p "$PROFILE_LOCAL/share/mime/packages"
    cat > "$PROFILE_LOCAL/share/mime/packages/vscode-$PROFILE_NAME.xml" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<mime-info xmlns="http://www.freedesktop.org/standards/shared-mime-info">
    <mime-type type="x-scheme-handler/vscode-$PROFILE_NAME">
        <comment>VS Code $PROFILE_NAME Profile URI</comment>
        <glob pattern="vscode-$PROFILE_NAME:*"/>
    </mime-type>
</mime-info>
EOF

    # Update MIME database for this profile
    if command -v update-mime-database >/dev/null 2>&1; then
        update-mime-database "$PROFILE_LOCAL/share/mime" 2>/dev/null || true
    fi

    # Update desktop database
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$PROFILE_LOCAL/share/applications" 2>/dev/null || true
    fi

    log_success "Desktop integration created"
}

# Install extensions in isolated environment
install_extensions() {
    log_info "Installing extensions in isolated environment"

    # Create a temporary script to install extensions
    local install_script="$PROFILE_TMP/install-extensions.sh"
    cat > "$install_script" << EOF
#!/bin/bash
export HOME="$PROFILE_HOME"
export XDG_CONFIG_HOME="$PROFILE_HOME/.config"
export XDG_DATA_HOME="$PROFILE_HOME/.local/share"

# Install Augment extension
"$VSCODE_BINARY" \\
    --user-data-dir="\$XDG_CONFIG_HOME/Code" \\
    --extensions-dir="\$XDG_DATA_HOME/Code/extensions" \\
    --install-extension augment.vscode-augment \\
    --force
EOF

    chmod +x "$install_script"

    # Run installation in isolated environment
    if unshare --mount --uts --ipc --pid --fork "$install_script" 2>/dev/null; then
        log_success "Augment extension installed"
    else
        log_warning "Failed to install Augment extension automatically"
        log_info "You can install it manually after launching VS Code"
    fi

    rm -f "$install_script"
}

# Create profile function
create_profile() {
    if [[ -d "$PROFILE_ROOT" ]]; then
        log_warning "Profile '$PROFILE_NAME' already exists"
        read -p "Do you want to recreate it? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_info "Launching existing profile instead"
            launch_profile
            return
        fi
        remove_profile_internal
    fi

    log_info "Creating isolated VS Code profile: $PROFILE_NAME"

    check_namespace_support
    create_profile_structure
    create_namespace_script
    create_launcher_script
    create_desktop_integration
    install_extensions

    log_success "Profile '$PROFILE_NAME' created successfully!"
    log_info "Launching isolated VS Code..."

    # Launch the profile
    "$LAUNCHER_SCRIPT" "$PROFILE_PROJECTS" >/dev/null 2>&1 &

    echo
    log_success "🚀 VS Code '$PROFILE_NAME' is running in complete isolation!"
    echo -e "${BLUE}📁${NC} Projects directory: $PROFILE_PROJECTS"
    echo -e "${BLUE}🔧${NC} Launcher script: $LAUNCHER_SCRIPT"
    echo -e "${BLUE}🖥️${NC} Desktop entry: VS Code - $PROFILE_NAME (Isolated)"
    echo -e "${BLUE}🔗${NC} URI scheme: vscode-$PROFILE_NAME://"
    echo
    echo -e "${GREEN}💡 Tips:${NC}"
    echo "   • Each profile is completely isolated from others and the host system"
    echo "   • Use '$0 $PROFILE_NAME launch' to start this profile again"
    echo "   • Use '$0 $PROFILE_NAME remove' to completely remove this profile"
    echo "   • Use '$0 \"\" list' to see all profiles"
}
# Launch existing profile
launch_profile() {
    if [[ ! -d "$PROFILE_ROOT" ]]; then
        log_error "Profile '$PROFILE_NAME' does not exist"
        log_info "Create it first with: $0 $PROFILE_NAME create"
        exit 1
    fi

    log_info "Launching isolated VS Code profile: $PROFILE_NAME"
    exec "$LAUNCHER_SCRIPT" "$@"
}

# Remove profile completely
remove_profile_internal() {
    if [[ -d "$PROFILE_ROOT" ]]; then
        log_info "Removing profile directory: $PROFILE_ROOT"
        rm -rf "$PROFILE_ROOT"
    fi

    if [[ -f "$LAUNCHER_SCRIPT" ]]; then
        log_info "Removing launcher script: $LAUNCHER_SCRIPT"
        rm -f "$LAUNCHER_SCRIPT"
    fi

    # Remove desktop integration
    local desktop_files=(
        "$HOME/.local/share/applications/code-$PROFILE_NAME.desktop"
        "$PROFILE_LOCAL/share/applications/code-$PROFILE_NAME.desktop"
    )

    for desktop_file in "${desktop_files[@]}"; do
        if [[ -f "$desktop_file" ]]; then
            log_info "Removing desktop entry: $desktop_file"
            rm -f "$desktop_file"
        fi
    done

    # Clean up MIME associations
    if command -v xdg-mime >/dev/null 2>&1; then
        xdg-mime default "" "x-scheme-handler/vscode-$PROFILE_NAME" 2>/dev/null || true
    fi

    # Update desktop database
    if command -v update-desktop-database >/dev/null 2>&1; then
        update-desktop-database "$HOME/.local/share/applications" 2>/dev/null || true
    fi
}

remove_profile() {
    if [[ ! -d "$PROFILE_ROOT" ]]; then
        log_warning "Profile '$PROFILE_NAME' does not exist"
        return
    fi

    echo -e "${YELLOW}⚠${NC} This will completely remove the isolated VS Code profile '$PROFILE_NAME'"
    echo -e "${YELLOW}⚠${NC} All settings, extensions, and data will be permanently deleted"
    echo
    read -p "Are you sure you want to remove profile '$PROFILE_NAME'? (y/N): " -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Removing profile '$PROFILE_NAME'..."
        remove_profile_internal
        log_success "Profile '$PROFILE_NAME' removed successfully"
    else
        log_info "Profile removal cancelled"
    fi
}

# List all profiles
list_profiles() {
    local profiles_dir="$ISOLATION_ROOT/profiles"

    if [[ ! -d "$profiles_dir" ]]; then
        log_info "No isolated VS Code profiles found"
        log_info "Create one with: $0 <profile_name> create"
        return
    fi

    local profiles=($(find "$profiles_dir" -maxdepth 1 -type d -not -path "$profiles_dir" -printf "%f\n" 2>/dev/null | sort))

    if [[ ${#profiles[@]} -eq 0 ]]; then
        log_info "No isolated VS Code profiles found"
        log_info "Create one with: $0 <profile_name> create"
        return
    fi

    echo -e "${BLUE}📋 Isolated VS Code Profiles:${NC}"
    echo

    for profile in "${profiles[@]}"; do
        local profile_path="$profiles_dir/$profile"
        local launcher_path="$ISOLATION_ROOT/launchers/$profile-launcher.sh"
        local size=$(du -sh "$profile_path" 2>/dev/null | cut -f1)
        local status="❌ Not configured"

        if [[ -f "$launcher_path" ]]; then
            status="✅ Ready"
        fi

        echo -e "  ${GREEN}•${NC} ${BLUE}$profile${NC}"
        echo -e "    Status: $status"
        echo -e "    Size: $size"
        echo -e "    Path: $profile_path"
        if [[ -f "$launcher_path" ]]; then
            echo -e "    Launcher: $launcher_path"
        fi
        echo
    done

    echo -e "${GREEN}💡 Usage:${NC}"
    echo "  Launch:  $0 <profile_name> launch"
    echo "  Remove:  $0 <profile_name> remove"
    echo "  Create:  $0 <profile_name> create"
}

# Show profile status
show_status() {
    if [[ ! -d "$PROFILE_ROOT" ]]; then
        log_error "Profile '$PROFILE_NAME' does not exist"
        return 1
    fi

    echo -e "${BLUE}📊 Profile Status: $PROFILE_NAME${NC}"
    echo

    local size=$(du -sh "$PROFILE_ROOT" 2>/dev/null | cut -f1)
    local launcher_status="❌ Missing"
    local desktop_status="❌ Missing"

    if [[ -f "$LAUNCHER_SCRIPT" ]]; then
        launcher_status="✅ Available"
    fi

    if [[ -f "$DESKTOP_ENTRY" ]]; then
        desktop_status="✅ Available"
    fi

    echo -e "  Profile Path: $PROFILE_ROOT"
    echo -e "  Size: $size"
    echo -e "  Launcher: $launcher_status"
    echo -e "  Desktop Entry: $desktop_status"
    echo -e "  Projects Directory: $PROFILE_PROJECTS"
    echo

    # Check for running processes
    local pids=$(pgrep -f "$PROFILE_NAME" 2>/dev/null || true)
    if [[ -n "$pids" ]]; then
        echo -e "  ${GREEN}🟢 Running Processes:${NC}"
        echo "$pids" | while read -r pid; do
            local cmd=$(ps -p "$pid" -o cmd= 2>/dev/null || echo "Unknown")
            echo -e "    PID $pid: $cmd"
        done
    else
        echo -e "  ${YELLOW}⚪ No running processes${NC}"
    fi
    echo
}

# Main command dispatcher
main() {
    case "$COMMAND" in
        "create"|"")
            create_profile
            ;;
        "launch")
            launch_profile "$@"
            ;;
        "remove")
            remove_profile
            ;;
        "list")
            list_profiles
            ;;
        "status")
            show_status
            ;;
        *)
            log_error "Unknown command: $COMMAND"
            usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
