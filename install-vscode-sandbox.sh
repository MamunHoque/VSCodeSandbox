#!/bin/bash

# VS Code Sandbox Global Installation Script
# Installs the enhanced VS Code isolation tool to /usr/local/bin for global access
#
# Author: Mamun Hoque
# Repository: https://github.com/MamunHoque/VSCodeSandbox

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
SCRIPT_NAME="vscode-sandbox"
INSTALL_PATH="/usr/local/bin/$SCRIPT_NAME"
REPOSITORY_URL="https://github.com/MamunHoque/VSCodeSandbox"
REPOSITORY_RAW_URL="https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main"

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }
log_header() { echo -e "${PURPLE}🚀${NC} $1"; }
log_step() { echo -e "${CYAN}▶${NC} $1"; }

# Show banner
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║              VS Code Sandbox Installer                      ║
║              Complete VS Code Isolation Solution            ║
║                                                              ║
║  🌐 Global Installation     🔄 Self-Updating                ║
║  🔒 Complete Isolation      🏠 Fresh OS Simulation          ║
║  🚫 Zero Interference       🔄 Multiple Profiles            ║
║  🗂️ Advanced Management     🧪 Well Tested                  ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check system requirements
check_requirements() {
    log_step "Checking system requirements..."
    
    # Check if running on Linux
    if [[ "$(uname)" != "Linux" ]]; then
        log_error "This installer is designed for Linux systems"
        log_info "For other systems, manually copy the script to your PATH"
        exit 1
    fi
    
    # Check for required commands
    local required_commands=("bash" "curl" "chmod" "mkdir" "unshare")
    for cmd in "${required_commands[@]}"; do
        if ! command_exists "$cmd"; then
            if [[ "$cmd" == "unshare" ]]; then
                log_warning "unshare command not found - install util-linux package"
                log_info "Some isolation features will be limited without it"
            else
                log_error "Required command not found: $cmd"
                exit 1
            fi
        fi
    done
    
    # Check if curl or wget is available
    if ! command_exists "curl" && ! command_exists "wget"; then
        log_error "Either curl or wget is required for downloading"
        exit 1
    fi
    
    # Check for VS Code
    local vscode_found=false
    local vscode_paths=(
        "/snap/bin/code"
        "/usr/bin/code"
        "/usr/local/bin/code"
        "/opt/visual-studio-code/bin/code"
    )
    
    for path in "${vscode_paths[@]}"; do
        if [[ -x "$path" ]]; then
            vscode_found=true
            log_success "Found VS Code at: $path"
            break
        fi
    done
    
    if ! $vscode_found && ! command_exists "code"; then
        log_warning "VS Code not found in standard locations"
        log_info "You can install VS Code later or set VSCODE_BINARY environment variable"
    fi
    
    log_success "System requirements check completed"
}

# Check permissions
check_permissions() {
    log_step "Checking installation permissions..."
    
    # Check if running as root or with sudo
    if [[ $EUID -ne 0 ]]; then
        log_error "Global installation requires root privileges"
        log_info "Please run with sudo:"
        log_info "  curl -sSL https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main/install-vscode-sandbox.sh | sudo bash"
        log_info "  OR"
        log_info "  sudo $0"
        exit 1
    fi
    
    # Check if /usr/local/bin exists and is writable
    if [[ ! -d "/usr/local/bin" ]]; then
        log_step "Creating /usr/local/bin directory..."
        mkdir -p /usr/local/bin
    fi
    
    if [[ ! -w "/usr/local/bin" ]]; then
        log_error "/usr/local/bin is not writable"
        exit 1
    fi
    
    log_success "Permissions check passed"
}

# Download the script
download_script() {
    log_step "Downloading VS Code Sandbox script..." >&2

    # Create temporary file
    local temp_file=$(mktemp)

    # Download the script
    if command_exists "curl"; then
        if curl -sSL "$REPOSITORY_RAW_URL/vscode-sandbox" -o "$temp_file"; then
            log_success "Downloaded VS Code Sandbox script" >&2
        else
            log_error "Failed to download script" >&2
            rm -f "$temp_file"
            exit 1
        fi
    elif command_exists "wget"; then
        if wget -q "$REPOSITORY_RAW_URL/vscode-sandbox" -O "$temp_file"; then
            log_success "Downloaded VS Code Sandbox script" >&2
        else
            log_error "Failed to download script" >&2
            rm -f "$temp_file"
            exit 1
        fi
    fi

    # Verify the downloaded file
    if [[ ! -s "$temp_file" ]]; then
        log_error "Downloaded file is empty" >&2
        rm -f "$temp_file"
        exit 1
    fi

    # Check if it's a valid script
    if ! head -1 "$temp_file" | grep -q "#!/bin/bash"; then
        log_error "Downloaded file is not a valid bash script" >&2
        rm -f "$temp_file"
        exit 1
    fi

    echo "$temp_file"
}

# Install the script
install_script() {
    local temp_file="$1"
    
    log_step "Installing to $INSTALL_PATH..."
    
    # Backup existing installation if it exists
    if [[ -f "$INSTALL_PATH" ]]; then
        log_step "Backing up existing installation..."
        cp "$INSTALL_PATH" "${INSTALL_PATH}.backup.$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Copy script to global location
    cp "$temp_file" "$INSTALL_PATH"
    chmod +x "$INSTALL_PATH"
    
    # Clean up temporary file
    rm -f "$temp_file"
    
    # Verify installation
    if [[ -x "$INSTALL_PATH" ]]; then
        log_success "Successfully installed to $INSTALL_PATH"
    else
        log_error "Installation failed - script is not executable"
        exit 1
    fi
}

# Test the installation
test_installation() {
    log_step "Testing installation..."
    
    # Test if the script runs
    if "$INSTALL_PATH" --version >/dev/null 2>&1; then
        log_success "Installation test passed"
        
        # Show version information
        echo
        "$INSTALL_PATH" --version
    else
        log_warning "Installation test failed, but script was installed"
        log_info "You may need to restart your terminal or check your PATH"
    fi
}

# Show completion message
show_completion() {
    echo
    log_header "🎉 VS Code Sandbox Installation Complete!"
    echo
    echo -e "${GREEN}✅ Installation successful!${NC}"
    echo
    echo -e "${BLUE}📋 Quick Start:${NC}"
    echo -e "  ${CYAN}vscode-sandbox myproject create${NC}           # Create isolated profile"
    echo -e "  ${CYAN}vscode-sandbox client-work create${NC}         # Create client profile"
    echo -e "  ${CYAN}vscode-sandbox myproject launch${NC}           # Launch existing profile"
    echo -e "  ${CYAN}vscode-sandbox myproject scaffold --type react${NC} # Create React project"
    echo -e "  ${CYAN}vscode-sandbox list${NC}                       # List all profiles"
    echo -e "  ${CYAN}vscode-sandbox --help${NC}                     # Show help"
    echo -e "  ${CYAN}vscode-sandbox --update${NC}                   # Update to latest version"
    echo
    echo -e "${BLUE}📁 Installation Path:${NC} $INSTALL_PATH"
    echo -e "${BLUE}🔗 Repository:${NC} $REPOSITORY_URL"
    echo
    echo -e "${YELLOW}💡 Tip:${NC} You can now run 'vscode-sandbox' from anywhere in your terminal!"
    echo
    echo -e "${GREEN}🚀 Features:${NC}"
    echo "   • Complete VS Code isolation with separate profiles"
    echo "   • Project scaffolding within isolated environments"
    echo "   • Self-updating mechanism"
    echo "   • Global installation and management"
    echo "   • Zero interference between profiles"
    echo
}

# Uninstall function
uninstall() {
    log_header "Uninstalling VS Code Sandbox"
    
    # Check if running as root or with sudo
    if [[ $EUID -ne 0 ]]; then
        log_error "Uninstallation requires root privileges"
        log_info "Run with sudo: sudo $0 uninstall"
        exit 1
    fi
    
    if [[ -f "$INSTALL_PATH" ]]; then
        log_step "Removing $INSTALL_PATH..."
        rm -f "$INSTALL_PATH"
        log_success "VS Code Sandbox uninstalled successfully"
    else
        log_warning "VS Code Sandbox is not installed at $INSTALL_PATH"
    fi
    
    # Remove backup files
    if ls "${INSTALL_PATH}.backup."* >/dev/null 2>&1; then
        log_step "Removing backup files..."
        rm -f "${INSTALL_PATH}.backup."*
        log_success "Backup files removed"
    fi
    
    log_info "Note: Existing isolated profiles in ~/.vscode-isolated are preserved"
}

# Show usage
show_usage() {
    cat << EOF
${WHITE}USAGE:${NC}
    $0 [command]

${WHITE}COMMANDS:${NC}
    ${CYAN}install${NC}     - Install VS Code Sandbox globally (default)
    ${CYAN}uninstall${NC}   - Remove global installation
    ${CYAN}--help${NC}      - Show this help message

${WHITE}EXAMPLES:${NC}
    $0                    # Install VS Code Sandbox
    $0 install            # Install VS Code Sandbox
    $0 uninstall          # Uninstall VS Code Sandbox

${WHITE}REPOSITORY:${NC} $REPOSITORY_URL
EOF
}

# Main function
main() {
    local command="${1:-install}"
    
    case "$command" in
        "install"|"")
            show_banner
            check_requirements
            check_permissions
            local temp_file
            temp_file=$(download_script)
            install_script "$temp_file"
            test_installation
            show_completion
            ;;
        "uninstall")
            uninstall
            ;;
        "--help"|"-h"|"help")
            show_usage
            ;;
        *)
            log_error "Unknown command: $command"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
