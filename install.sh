#!/bin/bash

# VS Code Sandbox Installation Script
# Installs and configures VS Code Sandbox for complete isolation

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }
log_header() { echo -e "${PURPLE}🚀${NC} $1"; }

# Installation directory
INSTALL_DIR="${VSCODE_SANDBOX_DIR:-$HOME/.local/bin/vscode-sandbox}"
BIN_DIR="$HOME/.local/bin"

# Create installation banner
show_banner() {
    echo -e "${CYAN}"
    cat << 'EOF'
╔══════════════════════════════════════════════════════════════╗
║                     VS Code Sandbox                         ║
║              Complete VS Code Isolation Solution            ║
║                                                              ║
║  🔒 Complete Isolation  🏠 Fresh OS Simulation              ║
║  🚫 Zero Interference   🔄 Multiple Profiles                ║
║  🗂️ Advanced Management  🧪 Well Tested                     ║
╚══════════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Check system requirements
check_requirements() {
    log_info "Checking system requirements..."
    
    # Check if running on Linux
    if [[ "$(uname)" != "Linux" ]]; then
        log_error "VS Code Sandbox requires Linux with namespace support"
        exit 1
    fi
    
    # Check for required commands
    local required_commands=("unshare" "bash" "mkdir" "chmod" "find")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" >/dev/null 2>&1; then
            log_error "Required command not found: $cmd"
            log_info "Please install the util-linux package"
            exit 1
        fi
    done
    
    # Check namespace support
    if ! unshare --help >/dev/null 2>&1; then
        log_error "unshare command not available"
        log_info "Please install util-linux package: sudo apt install util-linux"
        exit 1
    fi
    
    # Test user namespace creation
    if ! unshare -U true 2>/dev/null; then
        log_warning "User namespaces not available"
        log_warning "Some isolation features will be limited"
        log_info "Consider enabling: echo 1 | sudo tee /proc/sys/kernel/unprivileged_userns_clone"
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
    
    if ! $vscode_found && ! command -v code >/dev/null 2>&1; then
        log_warning "VS Code not found in standard locations"
        log_info "You can install VS Code later or set VSCODE_BINARY environment variable"
    fi
    
    log_success "System requirements check completed"
}

# Download or copy files
install_files() {
    log_info "Installing VS Code Sandbox files..."
    
    # Create installation directory
    mkdir -p "$INSTALL_DIR"
    
    # If we're in the source directory, copy files
    if [[ -f "vscode-isolate.sh" ]]; then
        log_info "Installing from local source..."
        cp vscode-isolate.sh vscode-profile-manager.sh vscode-isolation-test.sh "$INSTALL_DIR/"
        [[ -f "README-Enhanced-Isolation.md" ]] && cp README-Enhanced-Isolation.md "$INSTALL_DIR/"
    else
        log_info "Downloading from repository..."
        # Download files from GitHub
        local base_url="https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main"
        local files=("vscode-isolate.sh" "vscode-profile-manager.sh" "vscode-isolation-test.sh")
        
        for file in "${files[@]}"; do
            if command -v curl >/dev/null 2>&1; then
                curl -sSL "$base_url/$file" -o "$INSTALL_DIR/$file"
            elif command -v wget >/dev/null 2>&1; then
                wget -q "$base_url/$file" -O "$INSTALL_DIR/$file"
            else
                log_error "Neither curl nor wget available for downloading"
                exit 1
            fi
        done
    fi
    
    # Make scripts executable
    chmod +x "$INSTALL_DIR"/*.sh
    
    log_success "Files installed to: $INSTALL_DIR"
}

# Create symlinks in PATH
create_symlinks() {
    log_info "Creating command-line shortcuts..."
    
    # Ensure bin directory exists
    mkdir -p "$BIN_DIR"
    
    # Create symlinks
    ln -sf "$INSTALL_DIR/vscode-isolate.sh" "$BIN_DIR/vscode-sandbox"
    ln -sf "$INSTALL_DIR/vscode-profile-manager.sh" "$BIN_DIR/vscode-sandbox-manager"
    ln -sf "$INSTALL_DIR/vscode-isolation-test.sh" "$BIN_DIR/vscode-sandbox-test"
    
    log_success "Created command shortcuts:"
    echo -e "  ${BLUE}vscode-sandbox${NC}         - Main isolation script"
    echo -e "  ${BLUE}vscode-sandbox-manager${NC} - Profile management"
    echo -e "  ${BLUE}vscode-sandbox-test${NC}    - Test isolation"
}

# Setup shell integration
setup_shell_integration() {
    log_info "Setting up shell integration..."
    
    # Add to PATH if not already there
    local shell_rc=""
    if [[ -n "${BASH_VERSION:-}" ]]; then
        shell_rc="$HOME/.bashrc"
    elif [[ -n "${ZSH_VERSION:-}" ]]; then
        shell_rc="$HOME/.zshrc"
    else
        shell_rc="$HOME/.profile"
    fi
    
    if [[ -f "$shell_rc" ]] && ! grep -q "$BIN_DIR" "$shell_rc" 2>/dev/null; then
        echo "" >> "$shell_rc"
        echo "# VS Code Sandbox" >> "$shell_rc"
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$shell_rc"
        log_success "Added to PATH in $shell_rc"
        log_info "Run 'source $shell_rc' or restart your terminal"
    fi
}

# Run installation test
run_test() {
    log_info "Running installation test..."
    
    if "$INSTALL_DIR/vscode-isolation-test.sh" >/dev/null 2>&1; then
        log_success "Installation test passed!"
    else
        log_warning "Installation test had issues (this may be normal if VS Code isn't installed)"
        log_info "You can run the test manually later: vscode-sandbox-test"
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
    echo -e "  ${CYAN}vscode-sandbox myproject create${NC}     # Create isolated profile"
    echo -e "  ${CYAN}vscode-sandbox \"\" list${NC}              # List all profiles"
    echo -e "  ${CYAN}vscode-sandbox-manager launch${NC}       # Interactive launcher"
    echo -e "  ${CYAN}vscode-sandbox-test${NC}                 # Test isolation"
    echo
    echo -e "${BLUE}📁 Installation Directory:${NC} $INSTALL_DIR"
    echo -e "${BLUE}🔗 Command Shortcuts:${NC} $BIN_DIR"
    echo
    echo -e "${BLUE}📖 Documentation:${NC}"
    echo -e "  ${CYAN}README.md${NC}                    # Quick start guide"
    echo -e "  ${CYAN}README-Enhanced-Isolation.md${NC} # Technical details"
    echo
    echo -e "${YELLOW}💡 Tip:${NC} Restart your terminal or run 'source ~/.bashrc' to use the new commands"
    echo
}

# Uninstall function
uninstall() {
    log_info "Uninstalling VS Code Sandbox..."
    
    # Remove installation directory
    if [[ -d "$INSTALL_DIR" ]]; then
        rm -rf "$INSTALL_DIR"
        log_success "Removed installation directory"
    fi
    
    # Remove symlinks
    local symlinks=("$BIN_DIR/vscode-sandbox" "$BIN_DIR/vscode-sandbox-manager" "$BIN_DIR/vscode-sandbox-test")
    for symlink in "${symlinks[@]}"; do
        if [[ -L "$symlink" ]]; then
            rm -f "$symlink"
            log_success "Removed symlink: $(basename "$symlink")"
        fi
    done
    
    log_success "VS Code Sandbox uninstalled"
    log_info "Note: Existing profiles in ~/.vscode-isolated are preserved"
}

# Main installation function
main() {
    local command="${1:-install}"
    
    case "$command" in
        "install"|"")
            show_banner
            check_requirements
            install_files
            create_symlinks
            setup_shell_integration
            run_test
            show_completion
            ;;
        "uninstall")
            uninstall
            ;;
        "test")
            run_test
            ;;
        *)
            echo "Usage: $0 [install|uninstall|test]"
            exit 1
            ;;
    esac
}

main "$@"
