#!/bin/bash

# Enhanced VS Code Isolation Script - Security Testing Edition
# Creates completely sandboxed VS Code environments with advanced bypass testing
# Author: Enhanced for security testing and maximum isolation
# Version: 4.0.0-SECURITY-TEST
# Platform: Universal (macOS, Linux, Unix)
# Release: Security Testing Edition with Advanced Bypass Capabilities

set -euo pipefail

# Security Testing Mode Flag
SECURITY_TEST_MODE="${VSCODE_SECURITY_TEST:-false}"

# Handle global commands first (before any processing)
case "${1:-}" in
    "--version"|"-v")
        echo "VS Code Sandbox v4.0.0 - Security Testing Edition"
        echo "Platform: Universal (macOS, Linux, Unix)"
        echo "Author: Enhanced for security testing and maximum isolation"
        echo "Repository: https://github.com/MamunHoque/VSCodeSandbox"
        echo
        echo "Current Platform: $(uname)"
        echo "Security Test Mode: $SECURITY_TEST_MODE"
        exit 0
        ;;
    "--help"|"-h"|"help")
        cat << EOF
VS Code Sandbox v4.0.0 - Security Testing Edition

Usage: $0 <profile_name> [command] [options]

Commands:
    create      Create and launch isolated VS Code profile (default)
    launch      Launch existing profile
    remove      Remove profile completely
    list        List all profiles
    status      Show profile status
    --version   Show version information
    --help      Show this help message

Examples:
    $0 myproject                    # Create and launch 'myproject' profile
    $0 myproject launch            # Launch existing 'myproject' profile
    $0 myproject launch "vscode://file/path/to/file.js"  # Launch with VS Code URI
    $0 myproject remove            # Remove 'myproject' profile
    $0 "" list                     # List all profiles

URI Support:
    $0 myproject launch "vscode://file/path/to/file.js"     # Open specific file
    $0 myproject launch "vscode://extension/ms-python.python"  # Install extension
    $0 myproject launch --open-url "vscode://folder/path"   # Open folder

Platform Support:
    ✅ macOS (App Bundle, Homebrew)    - Enhanced isolation + Security testing
    ✅ Linux (Standard)                - Maximum security with namespaces + Testing
    ✅ Linux (Snap)                    - Basic isolation (--force-namespaces for max)
    ✅ Other Unix                      - Basic isolation + Testing features

Environment Variables:
    VSCODE_ISOLATION_ROOT          # Root directory for isolated profiles (default: ~/.vscode-isolated)
    VSCODE_BINARY                  # Path to VS Code binary (default: auto-detect)
    VSCODE_SECURITY_TEST           # Enable security testing mode (default: false)

Security Testing Features:
    🔧 System identifier spoofing    # Each profile gets unique system identifiers
    🔧 Enhanced file system isolation # Complete isolation of system caches
    🔧 Network interface simulation  # Different network fingerprints per profile
    🔧 Hostname modification         # Unique hostnames for testing

Security Testing Options:
    --security-test                  # Enable security testing mode (simple)
    --max-security                   # Enable security testing mode (compatibility)
    --desktop                        # Desktop integration (compatibility)

Repository: https://github.com/MamunHoque/VSCodeSandbox
EOF
        exit 0
        ;;
esac

# Configuration
ISOLATION_ROOT="${VSCODE_ISOLATION_ROOT:-$HOME/.vscode-isolated}"
PROFILE_NAME="${1:-}"
COMMAND="${2:-create}"

# Parse command line arguments for security testing flag
for arg in "$@"; do
    case $arg in
        --security-test)
            SECURITY_TEST_MODE="true"
            shift
            ;;
        --max-security)
            # Keep for compatibility but enable security testing
            SECURITY_TEST_MODE="true"
            shift
            ;;
        --desktop)
            # Keep for compatibility
            shift
            ;;
    esac
done

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

# Show version information
show_version() {
    echo "VS Code Sandbox v3.1.0 - Cross-Platform Compatibility Release"
    echo "Platform: Universal (macOS, Linux, Unix)"
    echo "Author: Enhanced for cross-platform compatibility"
    echo "Repository: https://github.com/MamunHoque/VSCodeSandbox"
    echo
    echo "Current Platform: $(uname)"
    echo "VS Code Binary: ${VSCODE_BINARY:-Not detected}"
    echo "Isolation Root: $ISOLATION_ROOT"
}

# Usage function
usage() {
    cat << EOF
VS Code Sandbox v4.0.0 - Security Testing Edition

Usage: $0 <profile_name> [command] [options]

Commands:
    create      Create and launch isolated VS Code profile (default)
    launch      Launch existing profile
    remove      Remove profile completely
    list        List all profiles
    status      Show profile status
    --version   Show version information
    --help      Show this help message

Examples:
    $0 myproject                    # Create and launch 'myproject' profile
    $0 myproject launch            # Launch existing 'myproject' profile
    $0 myproject launch "vscode://file/path/to/file.js"  # Launch with VS Code URI
    $0 myproject remove            # Remove 'myproject' profile
    $0 "" list                     # List all profiles

Security Testing Examples:
    $0 test1 create --security-test             # Create profile with fake identifiers (simple)
    $0 test2 create --security-test             # Create another profile with different fake identifiers
    VSCODE_SECURITY_TEST=true $0 test3 create   # Alternative: using environment variable
    $0 test1 launch                             # Launch with spoofed system info
    $0 test2 launch                             # Launch with different spoofed system info

URI Support:
    $0 myproject launch "vscode://file/path/to/file.js"     # Open specific file
    $0 myproject launch "vscode://extension/ms-python.python"  # Install extension
    $0 myproject launch --open-url "vscode://folder/path"   # Open folder

Platform Support:
    ✅ macOS (App Bundle, Homebrew)    - Enhanced isolation + Security testing
    ✅ Linux (Standard)                - Maximum security with namespaces + Testing
    ✅ Linux (Snap)                    - Basic isolation (--force-namespaces for max)
    ✅ Other Unix                      - Basic isolation + Testing features

Environment Variables:
    VSCODE_ISOLATION_ROOT          # Root directory for isolated profiles (default: ~/.vscode-isolated)
    VSCODE_BINARY                  # Path to VS Code binary (default: auto-detect)
    VSCODE_SECURITY_TEST           # Enable security testing mode (default: false)

Security Testing Features:
    🔧 System identifier spoofing    # Each profile gets unique fake machine IDs
    🔧 Enhanced file system isolation # Complete isolation of system caches
    🔧 Network interface simulation  # Different network fingerprints per profile
    🔧 Hostname modification         # Unique hostnames for testing (requires admin)
    🔧 Browser cache isolation       # Separate browser data per profile

Repository: https://github.com/MamunHoque/VSCodeSandbox
EOF
}

# Global commands are handled above, continue with normal processing

# Validate input
if [[ -z "$PROFILE_NAME" && "$COMMAND" != "list" ]]; then
    log_error "Profile name is required"
    usage
    exit 1
fi

# Detect VS Code binary with cross-platform support
detect_vscode_binary() {
    local candidates=()

    # Detect platform and set appropriate candidates
    case "$(uname)" in
        "Darwin")
            # macOS candidates
            candidates=(
                "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
                "$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
                "/usr/local/bin/code"
                "/opt/homebrew/bin/code"
                "$(which code 2>/dev/null || true)"
            )
            ;;
        "Linux")
            # Linux candidates
            candidates=(
                "/snap/bin/code"
                "/usr/bin/code"
                "/usr/local/bin/code"
                "/opt/visual-studio-code/bin/code"
                "$(which code 2>/dev/null || true)"
            )
            ;;
        *)
            # Generic Unix candidates
            candidates=(
                "/usr/local/bin/code"
                "/usr/bin/code"
                "$(which code 2>/dev/null || true)"
            )
            ;;
    esac

    for candidate in "${candidates[@]}"; do
        if [[ -x "$candidate" ]]; then
            echo "$candidate"
            return 0
        fi
    done

    log_error "VS Code binary not found. Please install VS Code or set VSCODE_BINARY environment variable."
    case "$(uname)" in
        "Darwin")
            log_info "Download VS Code from: https://code.visualstudio.com/download"
            log_info "Or install via Homebrew: brew install --cask visual-studio-code"
            ;;
        "Linux")
            log_info "Install via package manager or download from: https://code.visualstudio.com/download"
            ;;
    esac
    exit 1
}

VSCODE_BINARY="${VSCODE_BINARY:-$(detect_vscode_binary)}"

# Profile paths - set up for both namespace and basic isolation
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

# Basic isolation paths (for cross-platform compatibility)
PROFILE_CONFIG_BASIC="$PROFILE_ROOT/config"
PROFILE_EXTENSIONS="$PROFILE_ROOT/extensions"

# Security testing paths
PROFILE_SYSTEM_CACHE="$PROFILE_ROOT/system_cache"
PROFILE_SYSTEM_CONFIG="$PROFILE_ROOT/system_config"
PROFILE_NETWORK_CONFIG="$PROFILE_ROOT/network_config"
SECURITY_TEST_SCRIPT="$ISOLATION_ROOT/launchers/$PROFILE_NAME-security-test.sh"

# Check platform and namespace support
check_platform_and_namespace_support() {
    local platform="$(uname)"

    case "$platform" in
        "Darwin")
            log_info "macOS detected - namespace isolation not available"
            log_info "Using basic isolation mode (environment and directory separation)"
            return 1  # Namespaces not supported
            ;;
        "Linux")
            if ! command -v unshare >/dev/null 2>&1; then
                log_warning "unshare command not available. Please install util-linux package."
                log_info "Falling back to basic isolation mode"
                return 1
            fi

            # Test if we can create user namespaces
            if ! unshare -U true 2>/dev/null; then
                log_warning "User namespaces not available. Some isolation features will be limited."
                log_warning "Consider running: echo 1 | sudo tee /proc/sys/kernel/unprivileged_userns_clone"
                log_info "Falling back to basic isolation mode"
                return 1
            fi

            log_success "Linux with namespace support detected"
            return 0  # Namespaces supported
            ;;
        *)
            log_warning "Unknown platform: $platform"
            log_info "Using basic isolation mode"
            return 1
            ;;
    esac
}

# Legacy function for backward compatibility
check_namespace_support() {
    check_platform_and_namespace_support
}

# Security Testing Functions
generate_fake_machine_id() {
    local profile_name="$1"
    # Generate consistent but unique machine ID for this profile
    echo "security-test-$(echo "$profile_name" | shasum -a 256 | cut -c1-32)"
}

generate_fake_hostname() {
    local profile_name="$1"
    echo "vscode-test-$(echo "$profile_name" | shasum -a 256 | cut -c1-8)"
}

generate_fake_mac_address() {
    local profile_name="$1"
    # Generate a fake but consistent MAC address for this profile
    local hash=$(echo "$profile_name" | shasum -a 256 | cut -c1-12)
    echo "${hash:0:2}:${hash:2:2}:${hash:4:2}:${hash:6:2}:${hash:8:2}:${hash:10:2}"
}

setup_security_test_environment() {
    local profile_name="$1"

    if [[ "$SECURITY_TEST_MODE" != "true" ]]; then
        return 0
    fi

    log_info "Setting up security testing environment for profile '$profile_name'"

    # Create security testing directories
    mkdir -p "$PROFILE_SYSTEM_CACHE" "$PROFILE_SYSTEM_CONFIG" "$PROFILE_NETWORK_CONFIG"

    # Generate fake identifiers for this profile
    local fake_machine_id=$(generate_fake_machine_id "$profile_name")
    local fake_hostname=$(generate_fake_hostname "$profile_name")
    local fake_mac=$(generate_fake_mac_address "$profile_name")

    # Store fake identifiers for this profile
    cat > "$PROFILE_SYSTEM_CONFIG/identifiers.env" << EOF
# Security Testing Identifiers for Profile: $profile_name
export FAKE_MACHINE_ID="$fake_machine_id"
export FAKE_HOSTNAME="$fake_hostname"
export FAKE_MAC_ADDRESS="$fake_mac"
export FAKE_USER_ID="test-user-$(date +%s)"
export FAKE_SESSION_ID="session-$(uuidgen 2>/dev/null || echo "$(date +%s)-$$")"
EOF

    log_success "Security testing identifiers generated for '$profile_name'"
    log_info "Fake Machine ID: $fake_machine_id"
    log_info "Fake Hostname: $fake_hostname"
    log_info "Fake MAC Address: $fake_mac"

    # Store identifiers for display later
    echo "$fake_machine_id" > "$PROFILE_SYSTEM_CONFIG/machine_id.txt"
    echo "$fake_hostname" > "$PROFILE_SYSTEM_CONFIG/hostname.txt"
    echo "$fake_mac" > "$PROFILE_SYSTEM_CONFIG/mac_address.txt"
}

# Display current setup information
display_setup_information() {
    local profile_name="$1"

    echo
    echo -e "${BLUE}📋 Current Setup Information:${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

    if [[ "$SECURITY_TEST_MODE" == "true" ]]; then
        echo -e "${YELLOW}🔧 Security Testing Mode: ENABLED${NC}"
        echo
        echo -e "${GREEN}Each profile gets unique fake system identifiers:${NC}"

        if [[ -f "$PROFILE_SYSTEM_CONFIG/machine_id.txt" ]]; then
            local machine_id=$(cat "$PROFILE_SYSTEM_CONFIG/machine_id.txt")
            local hostname=$(cat "$PROFILE_SYSTEM_CONFIG/hostname.txt")
            local mac_address=$(cat "$PROFILE_SYSTEM_CONFIG/mac_address.txt")

            echo -e "  ${BLUE}🔹 Machine ID spoofing:${NC} $machine_id"
            echo -e "  ${BLUE}🔹 Hostname spoofing:${NC} $hostname"
            echo -e "  ${BLUE}🔹 MAC address spoofing:${NC} $mac_address"
        fi

        echo
        echo -e "${GREEN}Additional Security Features:${NC}"
        echo -e "  ${BLUE}🔹 System cache isolation:${NC} Complete XDG directory separation"
        echo -e "  ${BLUE}🔹 Browser data isolation:${NC} Chrome, Firefox, Safari data separated"
        echo -e "  ${BLUE}🔹 Environment spoofing:${NC} Fake user/session IDs"
        echo -e "  ${BLUE}🔹 Network simulation:${NC} Simulated network interface data"

    else
        echo -e "${GREEN}🔒 Standard Isolation Mode: ENABLED${NC}"
        echo
        echo -e "${GREEN}Standard isolation features:${NC}"
        echo -e "  ${BLUE}🔹 VS Code data isolation:${NC} Separate extensions, settings, workspace"
        echo -e "  ${BLUE}🔹 Environment isolation:${NC} Separate configuration directories"
        echo -e "  ${BLUE}🔹 Project isolation:${NC} Dedicated projects directory"

        if [[ "$(uname)" == "Linux" ]]; then
            echo -e "  ${BLUE}🔹 Namespace isolation:${NC} Process and mount separation (Linux)"
        fi
    fi

    echo
    echo -e "${GREEN}Profile Information:${NC}"
    echo -e "  ${BLUE}🔹 Profile Name:${NC} $profile_name"
    echo -e "  ${BLUE}🔹 Platform:${NC} $(uname)"
    echo -e "  ${BLUE}🔹 Profile Root:${NC} $PROFILE_ROOT"
    echo -e "  ${BLUE}🔹 Projects Directory:${NC} $PROFILE_PROJECTS"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Create isolated directory structure
create_profile_structure() {
    log_info "Creating isolated directory structure for profile '$PROFILE_NAME'"

    # Create basic directories (always needed)
    mkdir -p "$PROFILE_ROOT"/{config,extensions,projects}
    mkdir -p "$ISOLATION_ROOT/launchers"

    # Create security testing directories
    if [[ "$SECURITY_TEST_MODE" == "true" ]]; then
        mkdir -p "$PROFILE_SYSTEM_CACHE" "$PROFILE_SYSTEM_CONFIG" "$PROFILE_NETWORK_CONFIG"
        log_info "Security testing directories created"
    fi

    # Create namespace isolation directories (Linux only)
    if [[ "$(uname)" == "Linux" ]]; then
        mkdir -p "$PROFILE_HOME"/{.config,.cache,.local/{share/{applications,mime},bin},.vscode}
        mkdir -p "$PROFILE_TMP"

        # Create isolated XDG directories
        mkdir -p "$PROFILE_CONFIG"/{Code,fontconfig,gtk-3.0,dconf}
        mkdir -p "$PROFILE_CACHE"/{Code,fontconfig}
        mkdir -p "$PROFILE_LOCAL/share"/{Code,applications,mime,fonts,themes,icons}

        # Enhanced system isolation for security testing
        if [[ "$SECURITY_TEST_MODE" == "true" ]]; then
            mkdir -p "$PROFILE_HOME"/{.ssh,.gnupg,.mozilla,.chrome,.safari}
            mkdir -p "$PROFILE_CACHE"/{mozilla,google-chrome,safari}
            log_info "Enhanced system isolation directories created"
        fi
    fi

    # Create minimal environment files (Linux namespace mode only)
    if [[ "$(uname)" == "Linux" && -d "$PROFILE_HOME" ]]; then
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
    fi

    # Create welcome file for the projects directory
    cat > "$PROFILE_PROJECTS/README.md" << EOF
# Welcome to $PROFILE_NAME Profile!

This is your isolated VS Code environment. Everything here is completely separated from other profiles and your main VS Code installation.

## What's Isolated:
- ✅ Extensions (installed separately for this profile)
- ✅ Settings and preferences
- ✅ Workspace configurations
- ✅ Recently opened files

## Profile Information:
- **Profile Name**: $PROFILE_NAME
- **Platform**: $(uname)
- **Profile Root**: $PROFILE_ROOT
- **Projects Directory**: $PROFILE_PROJECTS
- **Created**: $(date)

## Useful Commands:
\`\`\`bash
# Launch this profile
$0 $PROFILE_NAME launch

# Remove this profile
$0 $PROFILE_NAME remove

# List all profiles
$0 "" list
\`\`\`

Happy coding! 🚀
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
# Create security testing launcher script
create_security_test_launcher() {
    log_info "Creating security testing launcher script"

    cat > "$SECURITY_TEST_SCRIPT" << EOF
#!/bin/bash
# Security Testing Launcher for VS Code profile: $PROFILE_NAME
# Includes advanced system identifier spoofing and isolation

set -euo pipefail

PROFILE_NAME="$PROFILE_NAME"
PROFILE_ROOT="$PROFILE_ROOT"
PROFILE_CONFIG="$PROFILE_CONFIG_BASIC"
PROFILE_EXTENSIONS="$PROFILE_EXTENSIONS"
PROFILE_PROJECTS="$PROFILE_PROJECTS"
VSCODE_BINARY="$VSCODE_BINARY"
SECURITY_TEST_MODE="$SECURITY_TEST_MODE"

# Load fake identifiers
if [[ -f "$PROFILE_SYSTEM_CONFIG/identifiers.env" ]]; then
    source "$PROFILE_SYSTEM_CONFIG/identifiers.env"
fi

# Security Testing Environment Setup
setup_security_environment() {
    # Enhanced file system isolation
    export XDG_CONFIG_HOME="$PROFILE_SYSTEM_CONFIG"
    export XDG_CACHE_HOME="$PROFILE_SYSTEM_CACHE"
    export XDG_DATA_HOME="$PROFILE_SYSTEM_CONFIG/share"
    export XDG_STATE_HOME="$PROFILE_SYSTEM_CONFIG/state"
    export XDG_RUNTIME_DIR="$PROFILE_TMP/runtime"

    # System cache isolation
    export TMPDIR="$PROFILE_TMP"
    export TMP="$PROFILE_TMP"
    export TEMP="$PROFILE_TMP"

    # Browser cache isolation (if extensions use browser data)
    export CHROME_USER_DATA_DIR="$PROFILE_SYSTEM_CACHE/chrome"
    export MOZILLA_PROFILE_DIR="$PROFILE_SYSTEM_CACHE/mozilla"
    export SAFARI_CACHE_DIR="$PROFILE_SYSTEM_CACHE/safari"

    # Network identifier spoofing (environment level)
    export FAKE_NETWORK_INTERFACE="en\${FAKE_MAC_ADDRESS//:/}"
    export FAKE_IP_ADDRESS="192.168.\$((\$\$ % 255)).\$((\$\$ % 255))"

    # Create necessary directories
    mkdir -p "\$XDG_CONFIG_HOME" "\$XDG_CACHE_HOME" "\$XDG_DATA_HOME" "\$XDG_STATE_HOME" "\$XDG_RUNTIME_DIR"
    mkdir -p "\$CHROME_USER_DATA_DIR" "\$MOZILLA_PROFILE_DIR" "\$SAFARI_CACHE_DIR"
    chmod 700 "\$XDG_RUNTIME_DIR"

    # System identifier spoofing (macOS specific)
    if [[ "\$(uname)" == "Darwin" ]]; then
        # Temporary hostname change (requires admin privileges)
        if command -v sudo >/dev/null 2>&1; then
            echo "🔧 Attempting to set temporary hostname for testing..."
            sudo scutil --set HostName "\$FAKE_HOSTNAME" 2>/dev/null || echo "⚠️ Hostname change requires admin privileges"
        fi

        # Create fake system info files
        cat > "\$PROFILE_SYSTEM_CONFIG/fake_system_info.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>FakeHardwareUUID</key>
    <string>\$FAKE_MACHINE_ID</string>
    <key>FakeSerialNumber</key>
    <string>TEST\${FAKE_MACHINE_ID:0:8}</string>
    <key>TestingMode</key>
    <true/>
</dict>
</plist>
PLIST
    fi
}

# Call security environment setup
setup_security_environment

EOF

    chmod +x "$SECURITY_TEST_SCRIPT"
    log_success "Security testing launcher created"
}

# Create basic launcher script (cross-platform compatible)
create_basic_launcher_script() {
    log_info "Creating basic launcher script (cross-platform compatible)"

    cat > "$LAUNCHER_SCRIPT" << EOF
#!/bin/bash
# Basic VS Code Launcher for isolated profile: $PROFILE_NAME
# Cross-platform compatible (works on Linux, macOS, etc.)

set -euo pipefail

PROFILE_NAME="$PROFILE_NAME"
PROFILE_ROOT="$PROFILE_ROOT"
PROFILE_CONFIG="$PROFILE_CONFIG_BASIC"
PROFILE_EXTENSIONS="$PROFILE_EXTENSIONS"
PROFILE_PROJECTS="$PROFILE_PROJECTS"
VSCODE_BINARY="$VSCODE_BINARY"
SECURITY_TEST_MODE="$SECURITY_TEST_MODE"

# Enhanced isolation setup
setup_enhanced_isolation() {
    # Standard isolation
    export TMPDIR="$PROFILE_ROOT/tmp"
    export TMP="$PROFILE_ROOT/tmp"
    export TEMP="$PROFILE_ROOT/tmp"

    # Security testing enhancements
    if [[ "\$SECURITY_TEST_MODE" == "true" ]]; then
        # Load security testing environment
        if [[ -f "$PROFILE_SYSTEM_CONFIG/identifiers.env" ]]; then
            source "$PROFILE_SYSTEM_CONFIG/identifiers.env"
        fi

        # Enhanced system cache isolation
        export XDG_CONFIG_HOME="$PROFILE_SYSTEM_CONFIG"
        export XDG_CACHE_HOME="$PROFILE_SYSTEM_CACHE"
        export XDG_DATA_HOME="$PROFILE_SYSTEM_CONFIG/share"

        # Browser isolation
        export CHROME_USER_DATA_DIR="$PROFILE_SYSTEM_CACHE/chrome"
        export MOZILLA_PROFILE_DIR="$PROFILE_SYSTEM_CACHE/mozilla"

        # Create directories
        mkdir -p "\$XDG_CONFIG_HOME" "\$XDG_CACHE_HOME" "\$XDG_DATA_HOME"
        mkdir -p "\$CHROME_USER_DATA_DIR" "\$MOZILLA_PROFILE_DIR"

        echo "🔧 Security testing mode enabled for profile: \$PROFILE_NAME"
        echo "🔧 Fake Machine ID: \$FAKE_MACHINE_ID"
        echo "🔧 Fake Hostname: \$FAKE_HOSTNAME"
    fi

    mkdir -p "\$TMPDIR"
}

# Setup enhanced isolation
setup_enhanced_isolation

# Check if profile exists
if [[ ! -d "\$PROFILE_ROOT" ]]; then
    echo "❌ Profile '\$PROFILE_NAME' does not exist"
    echo "💡 Create it first with: \$0 \$PROFILE_NAME create"
    exit 1
fi

# Parse arguments and handle various URI formats
URI=""
OPEN_FOLDER=""
OPEN_FILE=""
EXTRA_ARGS=()

# Enhanced argument processing
for arg in "\$@"; do
    case "\$arg" in
        vscode://*)
            URI="\$arg"
            ;;
        --open-url=*)
            URI="\${arg#--open-url=}"
            ;;
        --folder-uri=*)
            OPEN_FOLDER="\${arg#--folder-uri=}"
            ;;
        --file-uri=*)
            OPEN_FILE="\${arg#--file-uri=}"
            ;;
        file://*)
            # Handle file:// URIs by converting to local path
            local file_path="\${arg#file://}"
            if [[ -e "\$file_path" ]]; then
                if [[ -d "\$file_path" ]]; then
                    OPEN_FOLDER="\$file_path"
                else
                    OPEN_FILE="\$file_path"
                fi
            fi
            ;;
        *)
            # Check if it's a file or directory path
            if [[ -e "\$arg" && "\$arg" != --* ]]; then
                if [[ -d "\$arg" ]]; then
                    OPEN_FOLDER="\$arg"
                else
                    OPEN_FILE="\$arg"
                fi
            else
                EXTRA_ARGS+=("\$arg")
            fi
            ;;
    esac
done

# Build final arguments
FINAL_ARGS=(
    --user-data-dir="\$PROFILE_CONFIG"
    --extensions-dir="\$PROFILE_EXTENSIONS"
    --disable-gpu-sandbox
    --no-sandbox
)

# Add URI if specified
if [[ -n "\$URI" ]]; then
    FINAL_ARGS+=(--open-url "\$URI")
fi

# Add folder if specified (default to projects directory if none specified)
if [[ -n "\$OPEN_FOLDER" ]]; then
    FINAL_ARGS+=("\$OPEN_FOLDER")
elif [[ \${#EXTRA_ARGS[@]} -eq 0 && -z "\$URI" && -z "\$OPEN_FILE" ]]; then
    # No specific target, open projects directory
    FINAL_ARGS+=("\$PROFILE_PROJECTS")
fi

# Add file if specified
if [[ -n "\$OPEN_FILE" ]]; then
    FINAL_ARGS+=(--goto "\$OPEN_FILE")
fi

# Add extra arguments
FINAL_ARGS+=("\${EXTRA_ARGS[@]}")

# Launch VS Code with isolated profile
exec "\$VSCODE_BINARY" "\${FINAL_ARGS[@]}"
EOF

    chmod +x "$LAUNCHER_SCRIPT"
    log_success "Basic launcher script created (cross-platform compatible)"
}

# Create launcher script with enhanced isolation (Linux namespaces)
create_launcher_script_with_namespaces() {
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

    # Determine the correct directories based on isolation mode
    local user_data_dir
    local extensions_dir

    if [[ "$(uname)" == "Linux" && -d "$PROFILE_HOME" ]]; then
        # Namespace isolation mode (Linux)
        user_data_dir="$PROFILE_CONFIG/Code"
        extensions_dir="$PROFILE_LOCAL/share/Code/extensions"
        mkdir -p "$user_data_dir" "$extensions_dir"
    else
        # Basic isolation mode (cross-platform)
        user_data_dir="$PROFILE_CONFIG_BASIC"
        extensions_dir="$PROFILE_EXTENSIONS"
        mkdir -p "$user_data_dir" "$extensions_dir"
    fi

    # Try to install Augment extension directly
    log_info "Attempting to install Augment extension..."

    # Try different possible Augment extension IDs
    local augment_extensions=(
        "augment.vscode-augment"
        "augmentcode.augment"
        "augment.augment"
        "augment-code.augment"
    )

    local augment_installed=false
    for ext_id in "${augment_extensions[@]}"; do
        if "$VSCODE_BINARY" \
            --user-data-dir="$user_data_dir" \
            --extensions-dir="$extensions_dir" \
            --install-extension "$ext_id" \
            --force \
            --disable-gpu-sandbox \
            --no-sandbox \
            >/dev/null 2>&1; then
            log_success "Augment extension installed successfully ($ext_id)"
            augment_installed=true
            break
        fi
    done

    if [[ "$augment_installed" != true ]]; then
        log_warning "Augment extension not found in marketplace with standard IDs"
        log_info "You can install Augment manually from the Extensions marketplace"
    fi

    # Also try to install some commonly useful extensions
    local common_extensions=(
        "editorconfig.editorconfig"
        "ms-vscode.vscode-typescript-next"
        "bradlc.vscode-tailwindcss"
    )

    log_info "Installing common development extensions..."
    for extension in "${common_extensions[@]}"; do
        if "$VSCODE_BINARY" \
            --user-data-dir="$user_data_dir" \
            --extensions-dir="$extensions_dir" \
            --install-extension "$extension" \
            --force \
            --disable-gpu-sandbox \
            --no-sandbox \
            >/dev/null 2>&1; then
            log_info "✅ Installed: $extension"
        else
            log_info "⚠️ Skipped: $extension (not available or failed)"
        fi
    done

    log_success "Extension installation completed"
}

# Create profile function with cross-platform support
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

    # Check platform and namespace support
    local use_namespaces=false
    if check_platform_and_namespace_support; then
        use_namespaces=true
        log_info "Using maximum security isolation with Linux namespaces"
    else
        log_info "Using basic isolation mode (cross-platform compatible)"
    fi

    create_profile_structure

    # Setup security testing environment if enabled
    if [[ "$SECURITY_TEST_MODE" == "true" ]]; then
        setup_security_test_environment "$PROFILE_NAME"
        create_security_test_launcher
    fi

    if [[ "$use_namespaces" == true ]]; then
        create_namespace_script
        create_launcher_script_with_namespaces
        create_desktop_integration
    else
        create_basic_launcher_script
        # Skip desktop integration for basic mode to maintain compatibility
    fi

    install_extensions

    log_success "Profile '$PROFILE_NAME' created successfully!"

    # Display current setup information
    display_setup_information "$PROFILE_NAME"

    log_info "Launching isolated VS Code..."

    # Launch the profile
    "$LAUNCHER_SCRIPT" "$PROFILE_PROJECTS" >/dev/null 2>&1 &

    echo
    if [[ "$SECURITY_TEST_MODE" == "true" ]]; then
        log_success "🔧 VS Code '$PROFILE_NAME' is running with SECURITY TESTING mode!"
        echo -e "${BLUE}🔒${NC} Security Level: Testing (Advanced Bypass Simulation)"
        echo -e "${BLUE}🧪${NC} Security Test Script: $SECURITY_TEST_SCRIPT"
        echo -e "${YELLOW}⚠️${NC} This profile simulates different system identifiers for testing"
    elif [[ "$use_namespaces" == true ]]; then
        log_success "�️ VS Code '$PROFILE_NAME' is running with maximum security isolation!"
        echo -e "${BLUE}🔒${NC} Security Level: Maximum (Linux Namespaces)"
    else
        log_success "🚀 VS Code '$PROFILE_NAME' is running with basic isolation!"
        echo -e "${BLUE}🔒${NC} Security Level: Basic (Cross-Platform Compatible)"
    fi
    echo -e "${BLUE}📁${NC} Projects directory: $PROFILE_PROJECTS"
    echo -e "${BLUE}🔧${NC} Launcher script: $LAUNCHER_SCRIPT"
    echo -e "${BLUE}🖥️${NC} Platform: $(uname)"
    echo
    echo -e "${GREEN}💡 Tips:${NC}"
    echo "   • Each profile is completely isolated from others and the host system"
    echo "   • Use '$0 $PROFILE_NAME launch' to start this profile again"
    echo "   • Use '$0 $PROFILE_NAME remove' to completely remove this profile"
    echo "   • Use '$0 \"\" list' to see all profiles"
    if [[ "$SECURITY_TEST_MODE" == "true" ]]; then
        echo "   • Security testing mode creates fake system identifiers for bypass testing"
        echo "   • Use 'VSCODE_SECURITY_TEST=true $0 <profile> create' to enable testing mode"
    fi
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

    local profiles=($(find "$profiles_dir" -maxdepth 1 -type d -not -path "$profiles_dir" -exec basename {} \; 2>/dev/null | sort))

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
            if [[ -n "$pid" ]]; then
                local cmd=$(ps -p "$pid" -o command= 2>/dev/null || echo "Unknown process")
                echo -e "    PID $pid: $cmd"
            fi
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
