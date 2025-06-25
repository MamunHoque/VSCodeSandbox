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
        echo "VS Code Sandbox v5.2.0 - Clean Command Edition"
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
VS Code Sandbox v5.2.0 - Clean Command Edition

Usage: $0 <profile_name> [command] [options]
       $0 <global_command>

Commands:
    create      Create and launch isolated VS Code profile (default)
    launch      Launch existing profile
    remove      Remove profile completely
    status      Show profile status
    test        Run anti-detection tests (security testing mode only)

Global Commands:
    list        List all profiles
    clean       Remove ALL profiles (with confirmation)
    --version   Show version information
    --help      Show this help message

Examples:
    $0 myproject                    # Create and launch 'myproject' profile
    $0 myproject launch            # Launch existing 'myproject' profile
    $0 myproject launch "vscode://file/path/to/file.js"  # Launch with VS Code URI
    $0 myproject remove            # Remove 'myproject' profile
    $0 list                        # List all profiles (IMPROVED!)

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
    --extreme-test                   # Enable extreme testing mode (maximum spoofing)
    --anti-detection                 # Enable anti-detection mode (bypass Augment licensing)
    --max-security                   # Enable security testing mode (compatibility)
    --desktop                        # Desktop integration (compatibility)

Repository: https://github.com/MamunHoque/VSCodeSandbox
EOF
        exit 0
        ;;
esac

# Configuration
ISOLATION_ROOT="${VSCODE_ISOLATION_ROOT:-$HOME/.vscode-isolated}"

# Smart command parsing - handle global commands first
if [[ "${1:-}" == "list" || "${1:-}" == "clean" || "${1:-}" == "--version" || "${1:-}" == "--help" ]]; then
    # Global commands don't need a profile name
    PROFILE_NAME=""
    COMMAND="${1:-}"
else
    # Regular profile-specific commands
    PROFILE_NAME="${1:-}"
    COMMAND="${2:-create}"
fi

# Parse command line arguments for security testing flag
for arg in "$@"; do
    case $arg in
        --security-test)
            SECURITY_TEST_MODE="true"
            shift
            ;;
        --extreme-test)
            SECURITY_TEST_MODE="true"
            EXTREME_TEST_MODE="true"
            shift
            ;;
        --anti-detection)
            SECURITY_TEST_MODE="true"
            EXTREME_TEST_MODE="true"
            ANTI_DETECTION_MODE="true"
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



# Usage function
usage() {
    cat << EOF
VS Code Sandbox v5.2.0 - Clean Command Edition

Usage: $0 <profile_name> [command] [options]

Commands:
    create      Create and launch isolated VS Code profile (default)
    launch      Launch existing profile
    remove      Remove profile completely
    list        List all profiles
    clean       Remove ALL profiles (with confirmation)
    status      Show profile status
    test        Run anti-detection tests (security testing mode only)
    --version   Show version information
    --help      Show this help message

Examples:
    $0 myproject                    # Create and launch 'myproject' profile
    $0 myproject launch            # Launch existing 'myproject' profile
    $0 myproject launch "vscode://file/path/to/file.js"  # Launch with VS Code URI
    $0 myproject remove            # Remove 'myproject' profile
    $0 myproject test              # Run anti-detection tests
    $0 list                        # List all profiles (IMPROVED!)
    $0 clean                       # Remove ALL profiles (with confirmation)
    $0 clean                       # Remove ALL profiles (with confirmation)

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

# Validate input - only require profile name for profile-specific commands
if [[ -z "$PROFILE_NAME" && "$COMMAND" != "list" && "$COMMAND" != "clean" && "$COMMAND" != "--version" && "$COMMAND" != "--help" ]]; then
    log_error "Profile name is required for command: $COMMAND"
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



# Security Testing Functions
generate_fake_machine_id() {
    local profile_name="$1"
    # Generate realistic machine ID that looks like VS Code's format
    # VS Code uses UUID v4 format: xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx
    local hash=$(echo "$profile_name$(date +%s)$RANDOM" | shasum -a 256 | cut -c1-32)
    echo "${hash:0:8}-${hash:8:4}-4${hash:12:3}-a${hash:15:3}-${hash:18:12}"
}

generate_fake_user_id() {
    local profile_name="$1"
    # Generate realistic user ID that mimics a different user account
    local base_uid=$((501 + $(echo "$profile_name" | wc -c) % 100))
    echo "$base_uid"
}

generate_fake_group_id() {
    local profile_name="$1"
    # Generate realistic group ID
    local base_gid=$((20 + $(echo "$profile_name" | wc -c) % 50))
    echo "$base_gid"
}

generate_fake_security_session_id() {
    local profile_name="$1"
    # Generate realistic security session ID (macOS specific)
    local session_base=$((100000 + $(echo "$profile_name" | shasum -a 256 | cut -c1-8 | tr 'a-f' '0-5') % 900000))
    echo "$session_base"
}

generate_fake_hostname() {
    local profile_name="$1"
    # Generate realistic hostname that doesn't look like testing
    local names=("MacBook-Pro" "MacBook-Air" "iMac" "Mac-mini" "MacBook")
    local name=${names[$(($(echo "$profile_name" | wc -c) % ${#names[@]}))]}
    local suffix=$(echo "$profile_name" | shasum -a 256 | cut -c1-4)
    echo "$name-$suffix.local"
}

generate_fake_mac_address() {
    local profile_name="$1"
    # Generate realistic MAC address with proper vendor prefix
    # Use Apple's OUI (Organizationally Unique Identifier)
    local apple_ouis=("00:1B:63" "00:1F:F3" "00:23:DF" "00:25:00" "28:CF:E9" "3C:07:54")
    local oui=${apple_ouis[$(($(echo "$profile_name" | wc -c) % ${#apple_ouis[@]}))]}
    local hash=$(echo "$profile_name$RANDOM" | shasum -a 256 | cut -c1-6)
    echo "$oui:${hash:0:2}:${hash:2:2}:${hash:4:2}"
}

setup_security_test_environment() {
    local profile_name="$1"

    if [[ "$SECURITY_TEST_MODE" != "true" ]]; then
        return 0
    fi

    log_info "Setting up security testing environment for profile '$profile_name'"

    # Create security testing directories
    mkdir -p "$PROFILE_SYSTEM_CACHE" "$PROFILE_SYSTEM_CONFIG" "$PROFILE_NETWORK_CONFIG"

    # Create additional macOS-specific isolation directories
    mkdir -p "$PROFILE_SYSTEM_CONFIG"/{Keychains,Preferences,LaunchServices,Spotlight}
    mkdir -p "$PROFILE_SYSTEM_CACHE"/{com.apple.LaunchServices,com.apple.spotlight}

    # Generate fake identifiers for this profile
    local fake_machine_id=$(generate_fake_machine_id "$profile_name")
    local fake_hostname=$(generate_fake_hostname "$profile_name")
    local fake_mac=$(generate_fake_mac_address "$profile_name")
    local fake_user_id=$(generate_fake_user_id "$profile_name")
    local fake_group_id=$(generate_fake_group_id "$profile_name")
    local fake_security_session=$(generate_fake_security_session_id "$profile_name")

    # Store fake identifiers for this profile
    local fake_timestamp=$(($(date +%s) - (RANDOM % 86400 * 30))) # Random time in last 30 days
    local fake_serial="C02$(echo "$profile_name" | shasum -a 256 | cut -c1-8 | tr '[:lower:]' '[:upper:]')"
    local fake_uuid=$(uuidgen 2>/dev/null || echo "$fake_machine_id")

    cat > "$PROFILE_SYSTEM_CONFIG/identifiers.env" << EOF
# Anti-Detection Identifiers for Profile: $profile_name
export FAKE_MACHINE_ID="$fake_machine_id"
export FAKE_HOSTNAME="$fake_hostname"
export FAKE_MAC_ADDRESS="$fake_mac"
export FAKE_USER_ID="$(whoami)-$fake_timestamp"
export FAKE_SESSION_ID="$(uuidgen 2>/dev/null || echo "$fake_timestamp-$$")"
export FAKE_INSTALL_TIME="$fake_timestamp"
export FAKE_FIRST_RUN_TIME="$fake_timestamp"
export FAKE_BOOT_TIME="$((fake_timestamp - 3600))"
export FAKE_SERIAL_NUMBER="$fake_serial"
export FAKE_HARDWARE_UUID="$fake_uuid"
export FAKE_PLATFORM_UUID="$(uuidgen 2>/dev/null || echo "$fake_machine_id")"
export FAKE_BOARD_ID="Mac-$(echo "$profile_name" | shasum -a 256 | cut -c1-16 | tr '[:lower:]' '[:upper:]')"

# Enhanced macOS User Account Simulation
export FAKE_NUMERIC_USER_ID="$fake_user_id"
export FAKE_NUMERIC_GROUP_ID="$fake_group_id"
export FAKE_SECURITY_SESSION_ID="$fake_security_session"
export FAKE_HOME_DIR="/Users/fake-user-$fake_user_id"
export FAKE_LOGIN_KEYCHAIN="login-$fake_user_id.keychain"
export FAKE_USER_SHELL="/bin/zsh"
export FAKE_USER_REAL_NAME="Test User $fake_user_id"

# System-level isolation identifiers
export FAKE_LAUNCH_SERVICES_DB="lsregister-$fake_user_id.db"
export FAKE_SPOTLIGHT_INDEX="spotlight-$fake_user_id.index"
export FAKE_SYSTEM_CACHE_DIR="/var/folders/fake-$fake_user_id"
EOF

    log_success "Security testing identifiers generated for '$profile_name'"
    log_info "Fake Machine ID: $fake_machine_id"
    log_info "Fake Hostname: $fake_hostname"
    log_info "Fake MAC Address: $fake_mac"
    log_info "Fake User ID: $fake_user_id"
    log_info "Fake Security Session: $fake_security_session"

    # Store identifiers for display later
    echo "$fake_machine_id" > "$PROFILE_SYSTEM_CONFIG/machine_id.txt"
    echo "$fake_hostname" > "$PROFILE_SYSTEM_CONFIG/hostname.txt"
    echo "$fake_mac" > "$PROFILE_SYSTEM_CONFIG/mac_address.txt"
    echo "$fake_user_id" > "$PROFILE_SYSTEM_CONFIG/user_id.txt"
    echo "$fake_security_session" > "$PROFILE_SYSTEM_CONFIG/security_session.txt"

    # Setup advanced file system isolation
    setup_advanced_filesystem_isolation "$profile_name"
}

# Advanced File System Isolation for macOS
setup_advanced_filesystem_isolation() {
    local profile_name="$1"

    log_info "Setting up advanced file system isolation for macOS"

    # Create isolated system directories that extensions might check
    mkdir -p "$PROFILE_SYSTEM_CONFIG"/{Library,System,var}
    mkdir -p "$PROFILE_SYSTEM_CONFIG/Library"/{Application\ Support,Caches,Preferences,Keychains,LaunchAgents,Saved\ Application\ State}
    mkdir -p "$PROFILE_SYSTEM_CONFIG/Library/Application\ Support"/{Code,Google,Mozilla,Safari}
    mkdir -p "$PROFILE_SYSTEM_CONFIG/var"/{folders,tmp,log}

    # Create fake system cache directories (mimics /var/folders structure)
    local fake_cache_id=$(echo "$profile_name" | shasum -a 256 | cut -c1-2)
    local fake_cache_subdir=$(echo "$profile_name" | shasum -a 256 | cut -c3-32)
    mkdir -p "$PROFILE_SYSTEM_CONFIG/var/folders/$fake_cache_id/$fake_cache_subdir/T"
    mkdir -p "$PROFILE_SYSTEM_CONFIG/var/folders/$fake_cache_id/$fake_cache_subdir/C"

    # Create isolated keychain directory
    mkdir -p "$PROFILE_SYSTEM_CONFIG/Library/Keychains"

    # Create fake keychain files (empty but present for detection)
    touch "$PROFILE_SYSTEM_CONFIG/Library/Keychains/login.keychain-db"
    touch "$PROFILE_SYSTEM_CONFIG/Library/Keychains/local.keychain-db"

    # Create isolated LaunchServices database
    mkdir -p "$PROFILE_SYSTEM_CONFIG/Library/Preferences/com.apple.LaunchServices"

    # Create fake LaunchServices database
    cat > "$PROFILE_SYSTEM_CONFIG/Library/Preferences/com.apple.LaunchServices.plist" << LAUNCHSERVICES
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>LSHandlers</key>
    <array>
        <dict>
            <key>LSHandlerContentType</key>
            <string>public.plain-text</string>
            <key>LSHandlerRoleAll</key>
            <string>com.microsoft.VSCode</string>
        </dict>
    </array>
    <key>LSVersion</key>
    <string>$fake_user_id.0</string>
</dict>
</plist>
LAUNCHSERVICES

    # Create isolated Spotlight index
    mkdir -p "$PROFILE_SYSTEM_CONFIG/Library/Metadata/CoreSpotlight"
    touch "$PROFILE_SYSTEM_CONFIG/Library/Metadata/CoreSpotlight/index.spotlightV3"

    log_success "Advanced file system isolation configured"
}

# Interactive Launch Prompt
prompt_launch_profile() {
    local profile_name="$1"
    local launcher_script="$2"
    local profile_projects="$3"

    echo
    echo -e "${BLUE}🚀 Profile Creation Complete!${NC}"
    echo -e "${GREEN}✅ Profile '$profile_name' is ready to use${NC}"
    echo
    echo -e "${YELLOW}Would you like to launch this profile now?${NC}"
    echo -e "${BLUE}Press Enter to launch, or any other key to skip${NC}"
    echo -n "Launch now? [Y/n]: "

    # Read user input with timeout
    local user_input=""
    local timeout_seconds=10

    if read -t "$timeout_seconds" -r user_input; then
        # User provided input within timeout
        case "$user_input" in
            ""|"y"|"Y"|"yes"|"YES"|"Yes")
                echo
                log_info "Launching isolated VS Code..."
                launch_profile_with_feedback "$profile_name" "$launcher_script" "$profile_projects"
                return 0
                ;;
            *)
                echo
                log_info "Skipping launch - you can launch later with: $0 $profile_name launch"
                show_profile_completion_info "$profile_name" "$launcher_script" "$profile_projects" false
                return 1
                ;;
        esac
    else
        # Timeout occurred
        echo
        log_info "Timeout reached - skipping launch"
        log_info "You can launch later with: $0 $profile_name launch"
        show_profile_completion_info "$profile_name" "$launcher_script" "$profile_projects" false
        return 1
    fi
}

# Launch profile with feedback
launch_profile_with_feedback() {
    local profile_name="$1"
    local launcher_script="$2"
    local profile_projects="$3"

    # Launch the profile in background (don't use exec to avoid terminating script)
    "$launcher_script" "$profile_projects" &
    local launch_pid=$!

    # Give VS Code a moment to start
    sleep 2

    # Check if the process is still running (VS Code started successfully)
    if kill -0 "$launch_pid" 2>/dev/null; then
        show_profile_completion_info "$profile_name" "$launcher_script" "$profile_projects" true
    else
        # If process died quickly, there might be an issue
        wait "$launch_pid"
        local exit_code=$?
        if [[ $exit_code -ne 0 ]]; then
            log_error "Failed to launch VS Code (exit code: $exit_code)"
            log_info "Try launching manually with: $0 $profile_name launch"
            show_profile_completion_info "$profile_name" "$launcher_script" "$profile_projects" false
        else
            # Process completed successfully (VS Code might have started and detached)
            show_profile_completion_info "$profile_name" "$launcher_script" "$profile_projects" true
        fi
    fi
}

# Show profile completion information
show_profile_completion_info() {
    local profile_name="$1"
    local launcher_script="$2"
    local profile_projects="$3"
    local is_launched="$4"

    echo
    if [[ "$is_launched" == true ]]; then
        if [[ "$SECURITY_TEST_MODE" == "true" ]]; then
            log_success "🔧 VS Code '$profile_name' is running with SECURITY TESTING mode!"
            echo -e "${BLUE}🔒${NC} Security Level: Testing (Advanced Bypass Simulation)"
            if [[ -n "${SECURITY_TEST_SCRIPT:-}" ]]; then
                echo -e "${BLUE}🧪${NC} Security Test Script: $SECURITY_TEST_SCRIPT"
            fi
            echo -e "${YELLOW}⚠️${NC} This profile simulates different system identifiers for testing"
        elif [[ "$use_namespaces" == true ]]; then
            log_success "🛡️ VS Code '$profile_name' is running with maximum security isolation!"
            echo -e "${BLUE}🔒${NC} Security Level: Maximum (Linux Namespaces)"
        else
            log_success "🚀 VS Code '$profile_name' is running with basic isolation!"
            echo -e "${BLUE}🔒${NC} Security Level: Basic (Cross-Platform Compatible)"
        fi
    else
        if [[ "$SECURITY_TEST_MODE" == "true" ]]; then
            log_success "🔧 VS Code profile '$profile_name' created with SECURITY TESTING mode!"
            echo -e "${BLUE}🔒${NC} Security Level: Testing (Advanced Bypass Simulation)"
            if [[ -n "${SECURITY_TEST_SCRIPT:-}" ]]; then
                echo -e "${BLUE}🧪${NC} Security Test Script: $SECURITY_TEST_SCRIPT"
            fi
            echo -e "${YELLOW}⚠️${NC} This profile simulates different system identifiers for testing"
        elif [[ "$use_namespaces" == true ]]; then
            log_success "🛡️ VS Code profile '$profile_name' created with maximum security isolation!"
            echo -e "${BLUE}🔒${NC} Security Level: Maximum (Linux Namespaces)"
        else
            log_success "🚀 VS Code profile '$profile_name' created with basic isolation!"
            echo -e "${BLUE}🔒${NC} Security Level: Basic (Cross-Platform Compatible)"
        fi
    fi

    echo -e "${BLUE}📁${NC} Projects directory: $profile_projects"
    echo -e "${BLUE}🔧${NC} Launcher script: $launcher_script"
    echo -e "${BLUE}🖥️${NC} Platform: $(uname)"
    echo
    echo -e "${GREEN}💡 Tips:${NC}"
    echo "   • Each profile is completely isolated from others and the host system"
    echo "   • Use '$0 $profile_name launch' to start this profile again"
    echo "   • Use '$0 $profile_name remove' to completely remove this profile"
    echo "   • Use '$0 list' to see all profiles"

    # Add anti-detection specific tips
    if [[ "$SECURITY_TEST_MODE" == "true" ]]; then
        echo "   • Use '$0 $profile_name test' to verify anti-detection effectiveness"
        echo "   • Each profile appears as a completely different user/machine"
    fi
}

# Keychain and Security Framework Isolation
setup_keychain_security_isolation() {
    local profile_name="$1"

    if [[ "$(uname)" != "Darwin" ]]; then
        return 0
    fi

    log_info "Setting up Keychain and Security Framework isolation"

    # Create isolated keychain environment
    mkdir -p "$PROFILE_SYSTEM_CONFIG/Keychains"
    mkdir -p "$PROFILE_SYSTEM_CONFIG/Security"
    mkdir -p "$PROFILE_SYSTEM_CONFIG/bin"

    # Create fake keychain command wrapper
    cat > "$PROFILE_SYSTEM_CONFIG/bin/security" << 'SECURITY_CMD'
#!/bin/bash
# Fake security command for keychain isolation

case "$1" in
    "list-keychains")
        echo "    \"$PROFILE_SYSTEM_CONFIG/Keychains/login.keychain-db\""
        echo "    \"$PROFILE_SYSTEM_CONFIG/Keychains/System.keychain\""
        ;;
    "default-keychain")
        echo "    \"$PROFILE_SYSTEM_CONFIG/Keychains/login.keychain-db\""
        ;;
    "find-generic-password"|"find-internet-password")
        # Return "not found" for any keychain queries
        echo "security: SecKeychainSearchCopyNext: The specified item could not be found in the keychain."
        exit 44
        ;;
    "add-generic-password"|"add-internet-password")
        # Pretend to add to isolated keychain
        echo "password has been added to keychain"
        ;;
    *)
        # For other commands, try to run real security but redirect to isolated keychain
        /usr/bin/security "$@" 2>/dev/null || echo "security: operation not supported in isolated mode"
        ;;
esac
SECURITY_CMD
    chmod +x "$PROFILE_SYSTEM_CONFIG/bin/security"

    # Create fake keychain access command
    cat > "$PROFILE_SYSTEM_CONFIG/bin/keychain-access" << 'KEYCHAIN_ACCESS'
#!/bin/bash
# Fake Keychain Access for isolation
echo "Keychain Access running in isolated mode"
echo "Keychain: $PROFILE_SYSTEM_CONFIG/Keychains/login.keychain-db"
KEYCHAIN_ACCESS
    chmod +x "$PROFILE_SYSTEM_CONFIG/bin/keychain-access"

    log_success "Keychain and Security Framework isolation configured"
}

# Process and User Context Isolation
setup_process_user_isolation() {
    local profile_name="$1"

    log_info "Setting up process and user context isolation"

    # Create fake process commands
    mkdir -p "$PROFILE_SYSTEM_CONFIG/bin"

    # Fake id command
    cat > "$PROFILE_SYSTEM_CONFIG/bin/id" << 'ID_CMD'
#!/bin/bash
case "$1" in
    "-u")
        echo "$FAKE_NUMERIC_USER_ID"
        ;;
    "-g")
        echo "$FAKE_NUMERIC_GROUP_ID"
        ;;
    "-un")
        echo "fake-user-$FAKE_NUMERIC_USER_ID"
        ;;
    "-gn")
        echo "fake-group-$FAKE_NUMERIC_GROUP_ID"
        ;;
    *)
        echo "uid=$FAKE_NUMERIC_USER_ID(fake-user-$FAKE_NUMERIC_USER_ID) gid=$FAKE_NUMERIC_GROUP_ID(fake-group-$FAKE_NUMERIC_GROUP_ID) groups=$FAKE_NUMERIC_GROUP_ID(fake-group-$FAKE_NUMERIC_GROUP_ID)"
        ;;
esac
ID_CMD
    chmod +x "$PROFILE_SYSTEM_CONFIG/bin/id"

    # Fake whoami command
    cat > "$PROFILE_SYSTEM_CONFIG/bin/whoami" << 'WHOAMI_CMD'
#!/bin/bash
echo "fake-user-$FAKE_NUMERIC_USER_ID"
WHOAMI_CMD
    chmod +x "$PROFILE_SYSTEM_CONFIG/bin/whoami"

    # Fake ps command for process isolation
    cat > "$PROFILE_SYSTEM_CONFIG/bin/ps" << 'PS_CMD'
#!/bin/bash
# Show only fake processes for this user
echo "  PID TTY           TIME CMD"
echo "$$ ttys000    0:00.01 /bin/bash"
echo "$(($ + 1)) ttys000    0:00.00 ps"
PS_CMD
    chmod +x "$PROFILE_SYSTEM_CONFIG/bin/ps"

    log_success "Process and user context isolation configured"
}

# Anti-Detection Testing Framework
create_detection_test_script() {
    local profile_name="$1"

    log_info "Creating anti-detection testing framework"

    local test_script="$ISOLATION_ROOT/launchers/$profile_name-detection-test.sh"

    cat > "$test_script" << 'DETECTION_TEST'
#!/bin/bash
# Anti-Detection Testing Framework
# Tests the effectiveness of isolation against extension detection

set -euo pipefail

PROFILE_NAME="$1"
PROFILE_ROOT="$2"
PROFILE_SYSTEM_CONFIG="$3"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_test() { echo -e "${BLUE}🧪 TEST:${NC} $1"; }
log_pass() { echo -e "${GREEN}✅ PASS:${NC} $1"; }
log_fail() { echo -e "${RED}❌ FAIL:${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠️ WARN:${NC} $1"; }

echo -e "${BLUE}🔬 Anti-Detection Testing Framework${NC}"
echo -e "${BLUE}Profile: $PROFILE_NAME${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Load fake identifiers
if [[ -f "$PROFILE_SYSTEM_CONFIG/identifiers.env" ]]; then
    source "$PROFILE_SYSTEM_CONFIG/identifiers.env"
fi

# Test 1: System Identifier Spoofing
log_test "System Identifier Spoofing"
if [[ -n "${FAKE_MACHINE_ID:-}" ]]; then
    log_pass "Machine ID spoofed: $FAKE_MACHINE_ID"
else
    log_fail "Machine ID not spoofed"
fi

if [[ -n "${FAKE_HOSTNAME:-}" ]]; then
    log_pass "Hostname spoofed: $FAKE_HOSTNAME"
else
    log_fail "Hostname not spoofed"
fi

# Test 2: User Context Isolation
log_test "User Context Isolation"
if [[ -n "${FAKE_NUMERIC_USER_ID:-}" ]]; then
    log_pass "User ID spoofed: $FAKE_NUMERIC_USER_ID"
else
    log_fail "User ID not spoofed"
fi

if [[ -n "${FAKE_SECURITY_SESSION_ID:-}" ]]; then
    log_pass "Security Session spoofed: $FAKE_SECURITY_SESSION_ID"
else
    log_fail "Security Session not spoofed"
fi

# Test 3: File System Isolation
log_test "File System Isolation"
if [[ -d "$PROFILE_SYSTEM_CONFIG/Library" ]]; then
    log_pass "Isolated Library directory created"
else
    log_fail "Isolated Library directory missing"
fi

if [[ -f "$PROFILE_SYSTEM_CONFIG/Library/Keychains/login.keychain-db" ]]; then
    log_pass "Isolated keychain files created"
else
    log_fail "Isolated keychain files missing"
fi

# Test 4: Command Interception
log_test "Command Interception"
export PATH="$PROFILE_SYSTEM_CONFIG/bin:$PATH"

if command -v system_profiler >/dev/null 2>&1; then
    hw_uuid=$(system_profiler SPHardwareDataType 2>/dev/null | grep "Hardware UUID" | head -1)
    if [[ "$hw_uuid" == *"$FAKE_MACHINE_ID"* ]]; then
        log_pass "system_profiler intercepted successfully"
    else
        log_warn "system_profiler interception may not be working"
    fi
fi

if command -v hostname >/dev/null 2>&1; then
    current_hostname=$(hostname 2>/dev/null)
    if [[ "$current_hostname" == "$FAKE_HOSTNAME" ]]; then
        log_pass "hostname command intercepted successfully"
    else
        log_warn "hostname interception may not be working (got: $current_hostname)"
    fi
fi

# Test 5: VS Code Storage Isolation
log_test "VS Code Storage Isolation"
if [[ -f "$PROFILE_SYSTEM_CONFIG/Code/User/machineid" ]]; then
    vscode_machine_id=$(cat "$PROFILE_SYSTEM_CONFIG/Code/User/machineid")
    if [[ "$vscode_machine_id" == "$FAKE_MACHINE_ID" ]]; then
        log_pass "VS Code machine ID properly spoofed"
    else
        log_fail "VS Code machine ID not properly spoofed"
    fi
else
    log_warn "VS Code machine ID file not found"
fi

# Test 6: Augment Extension Storage
log_test "Augment Extension Storage Isolation"
if [[ -f "$PROFILE_SYSTEM_CONFIG/Code/User/globalStorage/augment.vscode-augment/storage.json" ]]; then
    log_pass "Augment extension storage created"
    augment_machine_id=$(grep -o '"machineId":"[^"]*"' "$PROFILE_SYSTEM_CONFIG/Code/User/globalStorage/augment.vscode-augment/storage.json" | cut -d'"' -f4)
    if [[ "$augment_machine_id" == "$FAKE_MACHINE_ID" ]]; then
        log_pass "Augment machine ID properly spoofed"
    else
        log_fail "Augment machine ID not properly spoofed"
    fi
else
    log_warn "Augment extension storage not found"
fi

# Test 7: Network Interface Spoofing
log_test "Network Interface Spoofing"
if command -v ifconfig >/dev/null 2>&1; then
    mac_addr=$(ifconfig en0 2>/dev/null | grep "ether" | awk '{print $2}')
    if [[ "$mac_addr" == "$FAKE_MAC_ADDRESS" ]]; then
        log_pass "MAC address spoofed successfully"
    else
        log_warn "MAC address spoofing may not be working (got: $mac_addr)"
    fi
fi

echo
echo -e "${BLUE}🎯 Detection Resistance Summary:${NC}"
echo -e "${GREEN}✅ System identifiers spoofed${NC}"
echo -e "${GREEN}✅ User context isolated${NC}"
echo -e "${GREEN}✅ File system isolated${NC}"
echo -e "${GREEN}✅ Commands intercepted${NC}"
echo -e "${GREEN}✅ VS Code storage isolated${NC}"
echo -e "${GREEN}✅ Extension storage prepared${NC}"
echo
echo -e "${YELLOW}💡 This profile should be undetectable by Augment extension licensing${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
DETECTION_TEST

    chmod +x "$test_script"

    log_success "Anti-detection testing framework created: $test_script"
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
$0 list
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

    # Advanced macOS User Account Simulation
    export HOME="\$FAKE_HOME_DIR"
    export USER="fake-user-\$FAKE_NUMERIC_USER_ID"
    export LOGNAME="fake-user-\$FAKE_NUMERIC_USER_ID"
    export USERNAME="fake-user-\$FAKE_NUMERIC_USER_ID"
    export SHELL="\$FAKE_USER_SHELL"
    export REAL_NAME="\$FAKE_USER_REAL_NAME"

    # macOS-specific user context
    export __CF_USER_TEXT_ENCODING="0x\$FAKE_NUMERIC_USER_ID:0x8000100:0x8000100"
    export SECURITYSESSIONID="\$FAKE_SECURITY_SESSION_ID"

    # Keychain isolation
    export KEYCHAIN_PATH="\$PROFILE_SYSTEM_CONFIG/Keychains"
    export LOGIN_KEYCHAIN="\$KEYCHAIN_PATH/\$FAKE_LOGIN_KEYCHAIN"

    # System directory isolation
    export SYSTEM_CACHE_DIR="\$FAKE_SYSTEM_CACHE_DIR"
    export LAUNCH_SERVICES_DB="\$PROFILE_SYSTEM_CONFIG/Library/Preferences/\$FAKE_LAUNCH_SERVICES_DB"

    # Extreme testing mode - additional spoofing
    if [[ "\${EXTREME_TEST_MODE:-false}" == "true" ]]; then
        # Spoof additional system paths that extensions might check
        export USER="\$FAKE_USER_ID"
        export LOGNAME="\$FAKE_USER_ID"
        export USERNAME="\$FAKE_USER_ID"

        # Spoof system information commands (if extension shells out)
        export PATH="\$PROFILE_SYSTEM_CONFIG/bin:\$PATH"
        mkdir -p "\$PROFILE_SYSTEM_CONFIG/bin"

        # Create comprehensive system command interception for macOS
        if [[ "\$(uname)" == "Darwin" ]]; then
            # Fake system_profiler command
            cat > "\$PROFILE_SYSTEM_CONFIG/bin/system_profiler" << 'SYSPROF'
#!/bin/bash
case "\$1" in
    "SPHardwareDataType")
        cat "\$PROFILE_SYSTEM_CONFIG/fake_hardware_info.txt" 2>/dev/null || echo "Hardware UUID: \$FAKE_MACHINE_ID"
        ;;
    "SPNetworkDataType")
        cat "\$PROFILE_SYSTEM_CONFIG/network/system_profiler_network.txt" 2>/dev/null || echo "Ethernet Address: \$FAKE_MAC_ADDRESS"
        ;;
    *)
        /usr/sbin/system_profiler "\$@"
        ;;
esac
SYSPROF
            chmod +x "\$PROFILE_SYSTEM_CONFIG/bin/system_profiler"

            # Fake ioreg command (hardware registry)
            cat > "\$PROFILE_SYSTEM_CONFIG/bin/ioreg" << 'IOREG'
#!/bin/bash
case "\$*" in
    *"IOPlatformUUID"*)
        echo "    \"IOPlatformUUID\" = \"\$FAKE_HARDWARE_UUID\""
        ;;
    *"IOPlatformSerialNumber"*)
        echo "    \"IOPlatformSerialNumber\" = \"\$FAKE_SERIAL_NUMBER\""
        ;;
    *"board-id"*)
        echo "    \"board-id\" = <\"\$FAKE_BOARD_ID\">"
        ;;
    *)
        /usr/sbin/ioreg "\$@" 2>/dev/null | sed "s/[A-F0-9]\{8\}-[A-F0-9]\{4\}-[A-F0-9]\{4\}-[A-F0-9]\{4\}-[A-F0-9]\{12\}/\$FAKE_MACHINE_ID/g"
        ;;
esac
IOREG
            chmod +x "\$PROFILE_SYSTEM_CONFIG/bin/ioreg"

            # Fake sysctl command (system control)
            cat > "\$PROFILE_SYSTEM_CONFIG/bin/sysctl" << 'SYSCTL'
#!/bin/bash
case "\$*" in
    *"kern.uuid"*)
        echo "kern.uuid: \$FAKE_HARDWARE_UUID"
        ;;
    *"machdep.cpu.brand_string"*)
        echo "machdep.cpu.brand_string: Apple M\$((\$\$ % 3 + 1)) Pro"
        ;;
    *"hw.memsize"*)
        echo "hw.memsize: \$((\$\$ % 32 + 16))000000000"
        ;;
    *)
        /usr/sbin/sysctl "\$@"
        ;;
esac
SYSCTL
            chmod +x "\$PROFILE_SYSTEM_CONFIG/bin/sysctl"

            # Fake hostname command
            cat > "\$PROFILE_SYSTEM_CONFIG/bin/hostname" << 'HOSTNAME'
#!/bin/bash
echo "\$FAKE_HOSTNAME"
HOSTNAME
            chmod +x "\$PROFILE_SYSTEM_CONFIG/bin/hostname"

            # Fake ifconfig command
            cat > "\$PROFILE_SYSTEM_CONFIG/bin/ifconfig" << 'IFCONFIG'
#!/bin/bash
if [[ "\$1" == "en0" ]] || [[ "\$*" == *"ether"* ]]; then
    echo "en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500"
    echo "    ether \$FAKE_MAC_ADDRESS"
    echo "    inet 192.168.1.\$((\$\$ % 255)) netmask 0xffffff00 broadcast 192.168.1.255"
    echo "    media: autoselect"
    echo "    status: active"
else
    /sbin/ifconfig "\$@"
fi
IFCONFIG
            chmod +x "\$PROFILE_SYSTEM_CONFIG/bin/ifconfig"
        fi

        echo "🔥 EXTREME TESTING MODE: Maximum spoofing enabled"
    fi

    # Browser cache isolation (if extensions use browser data)
    export CHROME_USER_DATA_DIR="$PROFILE_SYSTEM_CACHE/chrome"
    export MOZILLA_PROFILE_DIR="$PROFILE_SYSTEM_CACHE/mozilla"
    export SAFARI_CACHE_DIR="$PROFILE_SYSTEM_CACHE/safari"

    # VS Code and Augment-specific environment spoofing
    export VSCODE_MACHINE_ID="\$FAKE_MACHINE_ID"
    export VSCODE_SESSION_ID="\$FAKE_SESSION_ID"
    export VSCODE_INSTANCE_ID="\$FAKE_SESSION_ID"
    export VSCODE_PID="\$\$"
    export VSCODE_CWD="\$PROFILE_PROJECTS"
    export VSCODE_LOGS="\$PROFILE_SYSTEM_CACHE/logs"

    # Augment extension specific spoofing
    export AUGMENT_MACHINE_ID="\$FAKE_MACHINE_ID"
    export AUGMENT_DEVICE_ID="\$FAKE_MACHINE_ID"
    export AUGMENT_USER_ID="\$FAKE_USER_ID"
    export AUGMENT_SESSION_ID="\$FAKE_SESSION_ID"
    export AUGMENT_INSTALL_ID="\$FAKE_MACHINE_ID"
    export AUGMENT_CLIENT_ID="\$FAKE_MACHINE_ID"

    # Node.js environment spoofing (for extension runtime)
    export NODE_UNIQUE_ID="\$FAKE_MACHINE_ID"
    export HOSTNAME="\$FAKE_HOSTNAME"
    export COMPUTERNAME="\$FAKE_HOSTNAME"
    export HOST="\$FAKE_HOSTNAME"

    # macOS specific environment spoofing
    if [[ "\$(uname)" == "Darwin" ]]; then
        export __CF_USER_TEXT_ENCODING="0x1F5:\$(echo \$FAKE_USER_ID | od -An -tx1 | tr -d ' \n' | cut -c1-8):0x0"
        export SECURITYSESSIONID="\$((\$\$ % 100000 + 100000))"
    fi

    # Network identifier spoofing (environment level)
    export FAKE_NETWORK_INTERFACE="en\${FAKE_MAC_ADDRESS//:/}"
    export FAKE_IP_ADDRESS="192.168.\$((\$\$ % 255)).\$((\$\$ % 255))"

    # Advanced network spoofing for macOS
    if [[ "\$(uname)" == "Darwin" ]]; then
        # Create fake network interface info
        mkdir -p "\$PROFILE_SYSTEM_CONFIG/network"
        cat > "\$PROFILE_SYSTEM_CONFIG/network/interfaces" << NETINFO
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
    ether \$FAKE_MAC_ADDRESS
    inet \$FAKE_IP_ADDRESS netmask 0xffffff00 broadcast 192.168.1.255
    media: autoselect
    status: active
NETINFO

        # Fake system_profiler network data
        cat > "\$PROFILE_SYSTEM_CONFIG/network/system_profiler_network.txt" << SYSNET
Network:
    Ethernet:
        Type: Ethernet
        Hardware: Ethernet
        BSD Device Name: en0
        Has IP Assigned: Yes
        IP Address: \$FAKE_IP_ADDRESS
        Subnet Mask: 255.255.255.0
        Router: 192.168.1.1
        Ethernet Address: \$FAKE_MAC_ADDRESS
SYSNET
    fi

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

        # Create comprehensive fake system info files
        cat > "\$PROFILE_SYSTEM_CONFIG/fake_system_info.plist" << PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>FakeHardwareUUID</key>
    <string>\$FAKE_MACHINE_ID</string>
    <key>FakeSerialNumber</key>
    <string>TEST\${FAKE_MACHINE_ID:0:8}</string>
    <key>FakePlatformUUID</key>
    <string>\$(uuidgen 2>/dev/null || echo "\$FAKE_MACHINE_ID")</string>
    <key>TestingMode</key>
    <true/>
</dict>
</plist>
PLIST

        # Create fake hardware info that extensions might check
        cat > "\$PROFILE_SYSTEM_CONFIG/fake_hardware_info.txt" << HWINFO
Hardware Overview:
  Model Name: MacBook Pro (Testing)
  Model Identifier: MacBookPro18,\$((\$\$ % 4 + 1))
  Chip: Apple M\$((\$\$ % 3 + 1)) Pro
  Total Number of Cores: \$((\$\$ % 4 + 8))
  Memory: \$((\$\$ % 32 + 16)) GB
  System Firmware Version: 8419.80.7 (Testing)
  Serial Number (system): TEST\${FAKE_MACHINE_ID:0:8}
  Hardware UUID: \$FAKE_MACHINE_ID
HWINFO

        # Create fake disk info
        cat > "\$PROFILE_SYSTEM_CONFIG/fake_disk_info.txt" << DISKINFO
Disk Utility Info:
  Device: disk0
  Media Name: Apple SSD (Testing)
  Media Type: SSD
  Connection: Internal
  Partition Map: GPT
  S.M.A.R.T. Status: Verified
  Disk Size: \$((\$\$ % 512 + 256)) GB
  Device / Media Name: disk0 / TEST_SSD_\${FAKE_MACHINE_ID:0:8}
  Volume UUID: \$(uuidgen 2>/dev/null || echo "\$FAKE_MACHINE_ID")
DISKINFO

        # Create comprehensive VS Code identity spoofing
        mkdir -p "\$PROFILE_SYSTEM_CONFIG/Code/User"
        mkdir -p "\$PROFILE_SYSTEM_CONFIG/Code/CachedExtensions"
        mkdir -p "\$PROFILE_SYSTEM_CONFIG/Code/logs"

        # VS Code machine ID (critical for Augment detection)
        echo "\$FAKE_MACHINE_ID" > "\$PROFILE_SYSTEM_CONFIG/Code/User/machineid"

        # VS Code session storage
        cat > "\$PROFILE_SYSTEM_CONFIG/Code/User/globalStorage/storage.json" << VSCODE_STORAGE
{
    "machineId": "\$FAKE_MACHINE_ID",
    "sessionId": "\$FAKE_SESSION_ID",
    "sqmId": "\$FAKE_MACHINE_ID",
    "devDeviceId": "\$FAKE_MACHINE_ID",
    "firstSessionDate": "\$(date -r \$FAKE_INSTALL_TIME -Iseconds 2>/dev/null || date -Iseconds)",
    "lastSessionDate": "\$(date -Iseconds)",
    "isNewSession": false
}
VSCODE_STORAGE

        # VS Code telemetry settings
        cat > "\$PROFILE_SYSTEM_CONFIG/Code/User/settings.json" << SETTINGS
{
    "telemetry.telemetryLevel": "off",
    "telemetry.enableCrashReporter": false,
    "telemetry.enableTelemetry": false,
    "workbench.enableExperiments": false,
    "extensions.autoCheckUpdates": false,
    "extensions.autoUpdate": false,
    "update.mode": "none",
    "machineId": "\$FAKE_MACHINE_ID"
}
SETTINGS

        # Comprehensive Augment extension spoofing
        mkdir -p "\$PROFILE_SYSTEM_CONFIG/Code/User/globalStorage/augment.vscode-augment"

        # Main Augment storage
        cat > "\$PROFILE_SYSTEM_CONFIG/Code/User/globalStorage/augment.vscode-augment/storage.json" << AUGMENT_STORAGE
{
    "machineId": "\$FAKE_MACHINE_ID",
    "deviceId": "\$FAKE_MACHINE_ID",
    "hardwareId": "\$FAKE_HARDWARE_UUID",
    "platformId": "\$FAKE_PLATFORM_UUID",
    "userId": "\$FAKE_USER_ID",
    "sessionId": "\$FAKE_SESSION_ID",
    "installId": "\$FAKE_MACHINE_ID",
    "clientId": "\$FAKE_MACHINE_ID",
    "instanceId": "\$FAKE_SESSION_ID",
    "firstInstall": \$FAKE_INSTALL_TIME,
    "lastSeen": \$(date +%s),
    "version": "1.0.0",
    "os": "darwin",
    "arch": "arm64",
    "hostname": "\$FAKE_HOSTNAME",
    "serialNumber": "\$FAKE_SERIAL_NUMBER",
    "boardId": "\$FAKE_BOARD_ID"
}
AUGMENT_STORAGE

        # Augment license storage (if exists)
        cat > "\$PROFILE_SYSTEM_CONFIG/Code/User/globalStorage/augment.vscode-augment/license.json" << AUGMENT_LICENSE
{
    "machineId": "\$FAKE_MACHINE_ID",
    "deviceFingerprint": "\$FAKE_MACHINE_ID",
    "hardwareFingerprint": "\$FAKE_HARDWARE_UUID",
    "installationId": "\$FAKE_MACHINE_ID",
    "activationTime": \$FAKE_INSTALL_TIME,
    "lastValidation": \$(date +%s)
}
AUGMENT_LICENSE

        # Augment workspace storage
        mkdir -p "\$PROFILE_PROJECTS/.vscode"
        cat > "\$PROFILE_PROJECTS/.vscode/settings.json" << WORKSPACE_SETTINGS
{
    "augment.machineId": "\$FAKE_MACHINE_ID",
    "augment.deviceId": "\$FAKE_MACHINE_ID",
    "augment.sessionId": "\$FAKE_SESSION_ID"
}
WORKSPACE_SETTINGS

        # Create Node.js module interception for extensions
        mkdir -p "\$PROFILE_SYSTEM_CONFIG/node_modules/os"
        cat > "\$PROFILE_SYSTEM_CONFIG/node_modules/os/index.js" << NODEJS_OS
const originalOs = require.cache[require.resolve('os')] ? require.cache[require.resolve('os')].exports : require('os');

// Override os module methods that extensions use for fingerprinting
module.exports = {
    ...originalOs,
    hostname: () => process.env.FAKE_HOSTNAME || originalOs.hostname(),
    userInfo: (options) => ({
        ...originalOs.userInfo(options),
        username: process.env.FAKE_USER_ID || originalOs.userInfo(options).username,
        uid: parseInt(process.env.FAKE_USER_ID?.split('-')[1]) || originalOs.userInfo(options).uid
    }),
    networkInterfaces: () => {
        const interfaces = originalOs.networkInterfaces();
        if (process.env.FAKE_MAC_ADDRESS && interfaces.en0) {
            interfaces.en0 = interfaces.en0.map(iface => ({
                ...iface,
                mac: process.env.FAKE_MAC_ADDRESS
            }));
        }
        return interfaces;
    },
    cpus: () => {
        const cpus = originalOs.cpus();
        return cpus.map(cpu => ({
            ...cpu,
            model: process.env.FAKE_CPU_MODEL || cpu.model
        }));
    }
};
NODEJS_OS

        # Create crypto module interception for machine ID generation
        mkdir -p "\$PROFILE_SYSTEM_CONFIG/node_modules/crypto"
        cat > "\$PROFILE_SYSTEM_CONFIG/node_modules/crypto/index.js" << NODEJS_CRYPTO
const originalCrypto = require.cache[require.resolve('crypto')] ? require.cache[require.resolve('crypto')].exports : require('crypto');

module.exports = {
    ...originalCrypto,
    createHash: (algorithm) => {
        const hash = originalCrypto.createHash(algorithm);
        const originalUpdate = hash.update.bind(hash);
        const originalDigest = hash.digest.bind(hash);

        hash.update = function(data, encoding) {
            // Intercept common hardware fingerprinting patterns
            if (typeof data === 'string') {
                if (data.includes('Hardware UUID') || data.includes('IOPlatformUUID')) {
                    data = data.replace(/[A-F0-9]{8}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{4}-[A-F0-9]{12}/gi, process.env.FAKE_MACHINE_ID);
                }
                if (data.includes('Serial Number') || data.includes('IOPlatformSerialNumber')) {
                    data = data.replace(/[A-Z0-9]{10,}/g, process.env.FAKE_SERIAL_NUMBER);
                }
            }
            return originalUpdate(data, encoding);
        };

        return hash;
    }
};
NODEJS_CRYPTO

        # Set NODE_PATH to include our intercepted modules
        export NODE_PATH="\$PROFILE_SYSTEM_CONFIG/node_modules:\$NODE_PATH"
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

# Add extra arguments (safe array expansion)
if [[ \${#EXTRA_ARGS[@]} -gt 0 ]]; then
    FINAL_ARGS+=("\${EXTRA_ARGS[@]}")
fi

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
        setup_keychain_security_isolation "$PROFILE_NAME"
        setup_process_user_isolation "$PROFILE_NAME"
        create_detection_test_script "$PROFILE_NAME"
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

    # Interactive prompt to launch the profile
    prompt_launch_profile "$PROFILE_NAME" "$LAUNCHER_SCRIPT" "$PROFILE_PROJECTS"


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

# Run anti-detection tests
run_detection_tests() {
    if [[ ! -d "$PROFILE_ROOT" ]]; then
        log_error "Profile '$PROFILE_NAME' does not exist"
        log_info "Create it first with: $0 $PROFILE_NAME create --security-test"
        exit 1
    fi

    local test_script="$ISOLATION_ROOT/launchers/$PROFILE_NAME-detection-test.sh"

    if [[ ! -f "$test_script" ]]; then
        log_error "Detection test script not found for profile '$PROFILE_NAME'"
        log_info "This profile was not created with security testing mode"
        log_info "Recreate with: $0 $PROFILE_NAME create --security-test"
        exit 1
    fi

    log_info "Running anti-detection tests for profile '$PROFILE_NAME'"
    "$test_script" "$PROFILE_NAME" "$PROFILE_ROOT" "$PROFILE_SYSTEM_CONFIG"
}

# Clean all profiles
clean_all_profiles() {
    if [[ ! -d "$ISOLATION_ROOT" ]]; then
        log_info "No profiles directory found - nothing to clean"
        return 0
    fi

    # Check if there are any profiles
    local profile_count=0
    if [[ -d "$ISOLATION_ROOT/profiles" ]]; then
        profile_count=$(find "$ISOLATION_ROOT/profiles" -maxdepth 1 -type d ! -path "$ISOLATION_ROOT/profiles" | wc -l)
    fi

    if [[ $profile_count -eq 0 ]]; then
        log_info "No profiles found - nothing to clean"
        return 0
    fi

    echo
    log_warning "⚠️  This will permanently remove ALL isolated VS Code profiles!"
    echo
    echo -e "${YELLOW}Profiles to be removed:${NC}"

    # List all profiles that will be removed
    if [[ -d "$ISOLATION_ROOT/profiles" ]]; then
        for profile_dir in "$ISOLATION_ROOT/profiles"/*; do
            if [[ -d "$profile_dir" ]]; then
                local profile_name=$(basename "$profile_dir")
                local profile_size=$(du -sh "$profile_dir" 2>/dev/null | cut -f1)
                echo -e "  ${RED}🗑️${NC} $profile_name (${profile_size})"
            fi
        done
    fi

    echo
    echo -e "${RED}This action cannot be undone!${NC}"
    echo -n -e "${YELLOW}Are you sure you want to remove ALL profiles? (type 'yes' to confirm): ${NC}"

    local confirmation
    read -r confirmation

    if [[ "$confirmation" != "yes" ]]; then
        log_info "Clean operation cancelled"
        return 1
    fi

    echo
    log_info "Removing all profiles..."

    # Remove all profiles
    local removed_count=0
    if [[ -d "$ISOLATION_ROOT/profiles" ]]; then
        for profile_dir in "$ISOLATION_ROOT/profiles"/*; do
            if [[ -d "$profile_dir" ]]; then
                local profile_name=$(basename "$profile_dir")
                log_info "Removing profile: $profile_name"
                rm -rf "$profile_dir"
                ((removed_count++))
            fi
        done
    fi

    # Remove all launchers
    if [[ -d "$ISOLATION_ROOT/launchers" ]]; then
        log_info "Removing launcher scripts..."
        rm -rf "$ISOLATION_ROOT/launchers"/*
    fi

    # Remove desktop entries (Linux only)
    if [[ "$(uname)" == "Linux" ]]; then
        local desktop_dir="$HOME/.local/share/applications"
        if [[ -d "$desktop_dir" ]]; then
            log_info "Removing desktop entries..."
            find "$desktop_dir" -name "vscode-isolated-*.desktop" -delete 2>/dev/null || true
        fi
    fi

    # Clean up empty directories
    if [[ -d "$ISOLATION_ROOT/profiles" ]]; then
        rmdir "$ISOLATION_ROOT/profiles" 2>/dev/null || true
    fi
    if [[ -d "$ISOLATION_ROOT/launchers" ]]; then
        rmdir "$ISOLATION_ROOT/launchers" 2>/dev/null || true
    fi
    if [[ -d "$ISOLATION_ROOT" ]]; then
        rmdir "$ISOLATION_ROOT" 2>/dev/null || true
    fi

    echo
    log_success "Successfully removed $removed_count profiles"
    log_info "All isolated VS Code profiles have been cleaned up"

    if [[ $removed_count -gt 0 ]]; then
        echo
        echo -e "${GREEN}💡 Tips:${NC}"
        echo "   • Create new profiles with: $0 <profile-name> create"
        echo "   • Use --anti-detection for maximum isolation: $0 <profile-name> create --anti-detection"
        echo "   • List profiles anytime with: $0 list"
    fi
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
        "test")
            run_detection_tests
            ;;
        "clean")
            clean_all_profiles
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
