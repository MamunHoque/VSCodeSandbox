# VSCodeSandbox

🚀 **Universal VS Code isolation solution with cross-platform compatibility**

VS Code Sandbox creates completely isolated VS Code environments that work seamlessly across macOS, Linux, and all VS Code installation types. Features intelligent platform detection, automatic Augment extension installation, and adaptive security levels from basic isolation to enterprise-grade security using Linux namespaces.

## 🌟 **Key Features**

- 🌐 **Universal Compatibility**: Works on macOS, Linux, and all VS Code installation types
- 🛡️ **Intelligent Security**: Automatic platform detection with adaptive isolation levels
- 🔗 **Enhanced URI Support**: Full VS Code URL handling including Augment authentication
- 🤖 **Automatic Augment Extension**: AI-powered development assistance in every profile
- 🔒 **Complete Isolation**: Zero interference between profiles or host system
- 📦 **Cross-Platform Commands**: Unified interface across different operating systems
- 🧪 **Well Tested**: Comprehensive validation ensures compatibility across platforms
- 🚀 **Simple Installation**: Single script works everywhere - just clone and run
- 📱 **All VS Code Types**: Snap, Standard, Homebrew, App Bundle - all supported
- 🔧 **Graceful Fallback**: Automatically adapts when advanced features aren't available
- 🎯 **Backward Compatible**: Existing profiles continue to work without changes

## ⚡ **Quick Start**

```bash
# 1. Clone and run (works everywhere!)
git clone https://github.com/MamunHoque/VSCodeSandbox.git
cd VSCodeSandbox
chmod +x vscode-isolate.sh

# 2. Create your first isolated profile
./vscode-isolate.sh myproject create

# 3. That's it! VS Code opens with complete isolation
# - Separate extensions, settings, and workspace
# - Augment extension pre-installed
# - Full VS Code URI support
# - Works on macOS, Linux, and all VS Code types
```

## 🚀 **Installation Options**

### **Universal Installation (Recommended)**
Works on macOS, Linux, and all VS Code installation types:

```bash
# Clone and run - that's it!
git clone https://github.com/MamunHoque/VSCodeSandbox.git
cd VSCodeSandbox
chmod +x vscode-isolate.sh

# Create your first isolated profile
./vscode-isolate.sh myproject create
```

### **One-Line Installation**
```bash
# Download and run directly
curl -sSL https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main/vscode-isolate.sh -o vscode-isolate.sh
chmod +x vscode-isolate.sh
./vscode-isolate.sh myproject create
```

### **Platform-Specific Tools (Optional)**
For advanced features, you can also use platform-specific tools:

```bash
# Linux: Advanced namespace isolation
curl -sSL https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main/install-vscode-sandbox.sh | sudo bash

# macOS: Native app bundle integration
curl -sSL https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main/vscode-sandbox-macos -o vscode-sandbox-macos
chmod +x vscode-sandbox-macos
sudo ./vscode-sandbox-macos --install
```

## 🖥️ **Platform Support**

| Platform | VS Code Type | Isolation Level | Status |
|----------|-------------|----------------|---------|
| **macOS** | App Bundle | Basic | ✅ Fully Supported |
| **macOS** | Homebrew | Basic | ✅ Fully Supported |
| **Linux** | Standard | Maximum Security | ✅ Fully Supported |
| **Linux** | Snap | Basic* | ✅ Fully Supported |
| **Other Unix** | Any | Basic | ✅ Compatible |

*Can be forced to Maximum Security with `--force-namespaces`

### **Automatic Platform Detection**
The enhanced `vscode-isolate.sh` script automatically:
- 🔍 **Detects your platform** (macOS, Linux, Unix)
- 🔍 **Finds VS Code installation** (App Bundle, Homebrew, Snap, Standard)
- 🛡️ **Chooses optimal isolation level** (Basic or Maximum Security)
- 💬 **Provides clear feedback** about what isolation level you're getting

### **Platform-Specific Documentation**
- **Universal**: This README (works everywhere)
- **Linux Advanced**: [vscode-sandbox](vscode-sandbox) (namespace isolation)
- **macOS Advanced**: [vscode-sandbox-macos](vscode-sandbox-macos) (native integration)

## 📋 **Usage**

### **Universal Commands (Works Everywhere)**
```bash
# Create isolated profile (automatic platform detection)
./vscode-isolate.sh myproject create

# Launch isolated VS Code
./vscode-isolate.sh myproject launch

# Launch with VS Code URI support
./vscode-isolate.sh myproject launch "vscode://file/path/to/file.js"
./vscode-isolate.sh myproject launch "vscode://extension/ms-python.python"

# List all profiles
./vscode-isolate.sh "" list

# Check profile status
./vscode-isolate.sh myproject status

# Remove profile
./vscode-isolate.sh myproject remove

# Show version and help
./vscode-isolate.sh --version
./vscode-isolate.sh --help
```

### **Platform-Specific Advanced Commands**
```bash
# Linux: Maximum security with namespaces (when available)
vscode-sandbox secure-project create --max-security --desktop

# macOS: Native app bundle integration
vscode-sandbox-macos myproject create

# Force namespace isolation (Linux with Snap VS Code)
./vscode-isolate.sh myproject create --force-namespaces
```

## 🛡️ **Isolation Levels**

### **Basic Isolation (Universal - Default)**
```bash
./vscode-isolate.sh myproject create
```
**Works on**: macOS, Linux, all VS Code installation types

- ✅ **Extensions isolated** - Separate extension directories
- ✅ **Settings isolated** - Separate configuration files
- ✅ **Workspace isolated** - Separate workspace state
- ✅ **Environment isolated** - Separate configuration and cache directories
- ✅ **Augment extension** - Pre-installed AI assistance
- ✅ **URI support** - Full VS Code URL handling
- ✅ **Cross-platform** - Works everywhere VS Code works

### **Maximum Security Isolation (Linux Only)**
```bash
./vscode-isolate.sh secure-project create  # Auto-detected on Linux
```
**Works on**: Linux with standard VS Code installation

- ✅ **All basic features** PLUS:
- 🛡️ **Process isolation** - Separate PID namespace (can't see host processes)
- 🏠 **Environment isolation** - Separate HOME and XDG directories
- 🗂️ **Mount isolation** - Controlled filesystem access with read-only system mounts
- 💬 **IPC isolation** - Separate inter-process communication
- 🌐 **UTS isolation** - Separate hostname and domain name
- 📁 **Temporary file isolation** - Separate /tmp directory

### **Automatic Selection**
The script automatically chooses the best isolation level:
- **macOS**: Always uses Basic isolation (namespaces not available)
- **Linux + Standard VS Code**: Uses Maximum Security isolation
- **Linux + Snap VS Code**: Uses Basic isolation (can be forced to Maximum)
- **Other platforms**: Uses Basic isolation

### **When to Use Each**
- **Basic**: Daily development, project separation, cross-platform compatibility
- **Maximum Security**: Enterprise environments, confidential projects, compliance requirements

## 🆕 **What's New in v3.1.0**

### **🌐 Cross-Platform Compatibility**
- ✅ **Universal Support**: Single script works on macOS, Linux, and all Unix systems
- ✅ **Automatic Detection**: Finds VS Code regardless of installation method
- ✅ **Intelligent Adaptation**: Chooses optimal isolation level for your platform
- ✅ **Enhanced URI Handling**: Full support for VS Code URLs including Augment authentication

### **🔗 Enhanced VS Code URI Support**
```bash
# Open specific file in isolated profile
./vscode-isolate.sh myproject launch "vscode://file/path/to/file.js"

# Install extension via URI
./vscode-isolate.sh myproject launch "vscode://extension/ms-python.python"

# Handle Augment authentication
./vscode-isolate.sh myproject launch "vscode://augment.vscode-augment/auth/result?code=..."

# Open folder
./vscode-isolate.sh myproject launch "vscode://folder/path/to/project"
```

### **🛡️ Improved Compatibility**
- ✅ **All VS Code Types**: App Bundle, Homebrew, Snap, Standard installations
- ✅ **Graceful Fallback**: Works even when advanced features aren't available
- ✅ **Better Error Messages**: Clear guidance for platform-specific issues
- ✅ **Backward Compatible**: Existing profiles continue to work

## 🤖 **Automatic Augment Extension**

Every isolated VS Code profile automatically includes:

### **Pre-installed Extensions**
- 🤖 **Augment Extension** - AI-powered development assistance
- ⚙️ **EditorConfig** - Consistent coding styles
- 🔧 **TypeScript** - Advanced TypeScript support
- 🎨 **Tailwind CSS** - CSS framework support

### **Optimized Settings**
- **Font Configuration**: Fira Code, Cascadia Code, JetBrains Mono with ligatures
- **AI-Friendly Settings**: Optimized for Augment extension usage
- **Development Features**: Smart commit, auto-fetch, parameter hints enabled
- **Privacy Settings**: Telemetry disabled for security

## 🛡️ **Maximum Security & Snap VS Code Compatibility**

### **Snap VS Code Limitations**
VS Code Sandbox automatically detects snap-based VS Code installations and uses basic isolation due to snap package restrictions with user namespaces.

### **Force Complete Isolation**
```bash
# Override snap restrictions (advanced users)
vscode-sandbox myproject create --max-security --force-namespaces
vscode-sandbox myproject launch --force-namespaces
```

### **Recommended: Install Non-Snap VS Code**
For complete isolation without issues, install VS Code via official repository:

```bash
# Remove snap VS Code
sudo snap remove code

# Install official VS Code
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update && sudo apt install code

# Now enjoy complete isolation
vscode-sandbox myproject create --max-security
```

### **Isolation Levels**

#### **Basic Isolation (Snap VS Code)**
- ✅ Separate HOME directory and settings
- ✅ Separate extensions and projects
- ✅ Environment variable isolation
- ❌ Process and mount namespace isolation

#### **Complete Isolation (Non-Snap VS Code)**
- ✅ All basic isolation features
- ✅ Process isolation (separate PID namespace)
- ✅ Mount namespace isolation
- ✅ Complete system isolation

## 📦 **Project Scaffolding**

Create projects within isolated VS Code profiles:

### **Supported Project Types**
```bash
# React application
vscode-sandbox myproject scaffold frontend --type react --git --vscode

# Node.js/Express API
vscode-sandbox myproject scaffold backend --type node --git --docker

# Python project
vscode-sandbox myproject scaffold ml-app --type python --git --vscode

# Go application
vscode-sandbox myproject scaffold service --type go --git --docker

# Static website
vscode-sandbox myproject scaffold website --type static --git --vscode
```

### **Scaffolding Options**
- **`--git`** - Initialize Git repository with appropriate .gitignore
- **`--vscode`** - Add VS Code configuration (settings, extensions, debug config)
- **`--docker`** - Add Docker configuration (Dockerfile, docker-compose.yml)

### **Generated Project Structure**
Each project type includes:
- ✅ **Proper project structure** following best practices
- ✅ **Package configuration** (package.json, requirements.txt, go.mod, etc.)
- ✅ **Development tooling** (linting, formatting, testing setup)
- ✅ **Documentation** (README.md with getting started guide)
- ✅ **Git integration** (repository initialization and .gitignore)
- ✅ **VS Code configuration** (settings, extensions, debug configuration)

## 🔧 **System Requirements**

### **Universal Requirements**
- **Operating System**: macOS, Linux, or any Unix-like system
- **VS Code installed**: Any installation method (App Bundle, Homebrew, Snap, Standard, etc.)
- **Git**: For cloning the repository (usually pre-installed)

### **Platform-Specific Requirements**
- **macOS**: No additional requirements - works out of the box
- **Linux (Basic Isolation)**: No additional requirements
- **Linux (Maximum Security)**: util-linux package (provides `unshare` command)

### **Enable User Namespaces (if needed for maximum security)**
```bash
# Check current setting
cat /proc/sys/kernel/unprivileged_userns_clone

# Enable user namespaces (temporary)
echo 1 | sudo tee /proc/sys/kernel/unprivileged_userns_clone

# Enable permanently
echo 'kernel.unprivileged_userns_clone = 1' | sudo tee -a /etc/sysctl.conf
sudo sysctl -p
```

### **Package Installation**
```bash
# Ubuntu/Debian
sudo apt update && sudo apt install util-linux git curl

# CentOS/RHEL/Fedora
sudo dnf install util-linux git curl
```

## 📖 **Complete Command Reference**

### **Profile Commands**
```bash
# Create profiles
vscode-sandbox <profile> create                    # Basic isolation
vscode-sandbox <profile> create --max-security     # Maximum security
vscode-sandbox <profile> create --force-namespaces # Force namespaces (snap)
vscode-sandbox <profile> create --no-extensions    # Skip auto-extensions
vscode-sandbox <profile> create --desktop          # Desktop integration

# Launch profiles
vscode-sandbox <profile> launch                    # Normal launch
vscode-sandbox <profile> launch --force-namespaces # Force namespaces

# Manage profiles
vscode-sandbox <profile> status                    # Show profile info
vscode-sandbox <profile> remove                    # Remove profile
vscode-sandbox <profile> scaffold <project> --type <type> # Create project
```

### **Global Commands**
```bash
# List and manage
vscode-sandbox list                                 # List all profiles
vscode-sandbox clean                                # Remove ALL profiles
vscode-sandbox fix-namespaces                      # Fix permission issues
vscode-sandbox uninstall                           # Completely remove from system

# Tool management
vscode-sandbox --version                           # Show version
vscode-sandbox --help                              # Show help
vscode-sandbox --update                            # Update tool
vscode-sandbox --install                           # Install globally
vscode-sandbox --uninstall                         # Uninstall
```

### **Project Scaffolding**
```bash
# Create projects within profiles
vscode-sandbox <profile> scaffold <name> --type react     # React app
vscode-sandbox <profile> scaffold <name> --type node      # Node.js app
vscode-sandbox <profile> scaffold <name> --type python    # Python project
vscode-sandbox <profile> scaffold <name> --type go        # Go application
vscode-sandbox <profile> scaffold <name> --type static    # Static website

# Scaffolding options
--git                                              # Initialize Git repo
--vscode                                           # Add VS Code config
--docker                                           # Add Docker config
```

### **Advanced Options**
```bash
# Security levels
--basic                                            # Basic isolation (default)
--max-security                                     # Maximum security with namespaces
--force-namespaces                                 # Force namespaces (override snap)

# Integration options
--desktop                                          # Desktop integration (max-security)
--no-extensions                                    # Skip automatic extensions

# Environment variables
VSCODE_BINARY=/path/to/code                        # Custom VS Code binary
VSCODE_ISOLATION_ROOT=/custom/path                 # Custom isolation directory
FORCE_NAMESPACES=true                              # Force namespaces globally
```

## 📖 **Complete Usage Guide**

### **Profile Management**
```bash
# Create basic isolated profile
vscode-sandbox myproject create

# Create maximum security profile with desktop integration
vscode-sandbox secure-project create --max-security --desktop

# Create profile with forced namespace isolation (for snap VS Code)
vscode-sandbox secure-project create --max-security --force-namespaces

# Launch existing profile
vscode-sandbox myproject launch

# Launch with forced namespace isolation
vscode-sandbox myproject launch --force-namespaces

# Show detailed profile information
vscode-sandbox myproject status

# List all profiles with security levels
vscode-sandbox list

# Remove profile completely
vscode-sandbox myproject remove

# Remove ALL profiles and projects
vscode-sandbox clean

# Fix namespace permission issues
vscode-sandbox fix-namespaces
```

### **Project Creation Workflow**
```bash
# 1. Create isolated profile
vscode-sandbox client-work create

# 2. Create React frontend project
vscode-sandbox client-work scaffold frontend --type react --git --vscode

# 3. Create Node.js backend project
vscode-sandbox client-work scaffold backend --type node --git --docker

# 4. Launch VS Code with both projects
vscode-sandbox client-work launch
```

### **Global Tool Management**
```bash
# Update to latest version
vscode-sandbox --update

# Show version and installation info
vscode-sandbox --version

# Show comprehensive help
vscode-sandbox --help

# Install globally (if not already installed)
sudo vscode-sandbox --install

# Uninstall global installation
sudo vscode-sandbox --uninstall

# List all profiles
vscode-sandbox list

# Remove all profiles and projects (with confirmation)
vscode-sandbox clean

# Fix namespace permission issues for existing profiles
vscode-sandbox fix-namespaces

# Completely uninstall VS Code Sandbox from system
vscode-sandbox uninstall
```

## 🚨 **Troubleshooting**

### **Common Issues**

#### **VS Code Not Detected**
```bash
# Error: "VS Code binary not found"
# Solution: The script provides platform-specific guidance

# macOS: Install VS Code
brew install --cask visual-studio-code
# Or download from: https://code.visualstudio.com/download

# Linux: Install VS Code
sudo apt install code
# Or download from: https://code.visualstudio.com/download

# Set custom binary path if needed
export VSCODE_BINARY=/path/to/your/code
./vscode-isolate.sh myproject create
```

#### **Platform Detection Issues**
```bash
# Check what platform and VS Code the script detects
./vscode-isolate.sh --version

# This shows:
# - Current Platform: Darwin/Linux/etc.
# - VS Code Binary: path or "Not detected"
# - Isolation Root: where profiles are stored
```

#### **Extension Installation Fails**
```bash
# If Augment extension fails to install automatically
# The script will show a warning and continue
# You can install Augment manually from Extensions marketplace
```

#### **Linux Namespace Issues (Maximum Security)**
```bash
# Error: "unshare: unshare failed: Operation not permitted"
# Solution: Enable user namespaces (Linux only)
echo 1 | sudo tee /proc/sys/kernel/unprivileged_userns_clone

# Check kernel support (requires 3.8+)
uname -r

# The script automatically falls back to basic isolation if namespaces aren't available
```

#### **Snap VS Code Compatibility**
```bash
# Info: "Snap VS Code detected - using basic isolation instead of namespaces"
# This is normal and expected behavior

# Solution 1: Use basic isolation (recommended, works great)
./vscode-isolate.sh myproject create

# Solution 2: Install non-snap VS Code for maximum security
sudo snap remove code
sudo apt install code

# Solution 3: Force namespaces (advanced, may have issues)
./vscode-isolate.sh myproject create --force-namespaces
```

#### **Clean All Profiles**
```bash
# Remove all profiles and start fresh
vscode-sandbox clean

# Confirm with 'yes' when prompted
# This removes ALL profiles, projects, and settings

#### **Complete System Uninstall**
```bash
# Remove VS Code Sandbox completely from system
vscode-sandbox uninstall

# Confirm with 'UNINSTALL' when prompted
# This removes:
# - Global installation (/usr/local/bin/vscode-sandbox)
# - All profiles and data
# - Desktop integration files
# - MIME type associations
```
```

#### **Permission Denied Errors**
```bash
# Error: Cannot create namespace
# Solution: Check system limits
cat /proc/sys/user/max_user_namespaces

# Increase limits if needed
echo 10000 | sudo tee /proc/sys/user/max_user_namespaces
```

### **Performance Considerations**
- **First launch**: May be slower due to extension installation
- **Memory usage**: Slightly higher with namespace isolation
- **File I/O**: Performance unchanged
- **Resource monitoring**: Use `ps aux | grep code` to check isolated processes

## 🎯 **Use Cases & Examples**

### **Individual Developer Workflows**
```bash
# Personal development environment
vscode-sandbox personal-dev create
vscode-sandbox personal-dev scaffold side-project --type react --git

# Learning new technology
vscode-sandbox learning-rust create --max-security
vscode-sandbox learning-rust scaffold hello-world --type rust --git

# Experimental projects
vscode-sandbox experiments create
vscode-sandbox experiments scaffold test-app --type node --git
```

### **Team Development**
```bash
# Standardized team environments
vscode-sandbox team-frontend create
vscode-sandbox team-backend create
vscode-sandbox team-mobile create

# Each team member gets identical isolated environments
# with Augment extension and development tools pre-installed
```

### **Client Work Separation**
```bash
# Complete isolation between client projects
vscode-sandbox client-alpha create --max-security
vscode-sandbox client-beta create --max-security

# Each client's work is completely isolated:
# - Separate extensions and settings
# - Separate Git credentials and SSH keys
# - Separate environment variables and configurations
# - No data leakage between projects
```

### **Enterprise & Security-Critical Environments**
```bash
# Maximum security for confidential projects
vscode-sandbox confidential-project create --max-security --desktop

# Features for enterprise use:
# - Complete process isolation (separate PID namespace)
# - Environment isolation (separate HOME directory)
# - Mount isolation (controlled filesystem access)
# - Desktop integration with custom MIME types
# - Augment AI assistance in secure environment
```

### **Technology Stack Isolation**
```bash
# Different environments for different tech stacks
vscode-sandbox python-ml create      # Machine learning projects
vscode-sandbox nodejs-web create     # Web development
vscode-sandbox go-microservices create  # Microservices development
vscode-sandbox rust-systems create  # Systems programming

# Each environment has appropriate extensions and settings
```

## 🧪 **Testing & Verification**

### **Test Installation**
```bash
# Test basic profile creation
vscode-sandbox test-basic create
vscode-sandbox test-basic status
vscode-sandbox test-basic remove

# Test maximum security profile
vscode-sandbox test-secure create --max-security
vscode-sandbox test-secure status
vscode-sandbox test-secure remove

# Test project scaffolding
vscode-sandbox test-project create
vscode-sandbox test-project scaffold demo --type react --git
vscode-sandbox test-project remove
```

### **Verify Isolation**
```bash
# Check profile isolation
vscode-sandbox list

# Verify extensions are isolated
ls ~/.vscode-isolated/profiles/*/extensions/

# Check security level
vscode-sandbox myproject status
```

### **Run Comprehensive Tests**
```bash
# Run the full test suite
./vscode-isolation-test.sh
```

## 📋 Requirements

- **Linux** with namespace support
- **util-linux** package (`unshare` command)
- **VS Code** installed (any method: snap, deb, AppImage, etc.)
- **Bash 4.0+** with standard utilities

## 🛠️ **Legacy Tools (Still Available)**

For users who prefer the original separate tools:

### **`vscode-isolate.sh` - Maximum Security Engine**
```bash
# Clone repository for legacy tools
git clone https://github.com/MamunHoque/VSCodeSandbox.git
cd VSCodeSandbox
chmod +x *.sh

# Create maximum security profile
./vscode-isolate.sh secure-project create
```

### **`vscode-working-launcher.sh` - Simple Launcher**
```bash
# Create basic isolated profile
./vscode-working-launcher.sh myproject
```

### **Supporting Tools**
- **`vscode-profile-manager.sh`** - Advanced profile management
- **`vscode-isolation-test.sh`** - Comprehensive test suite
- **`install.sh`** - Legacy installation script

## 📝 **What's New**

### **Version 3.0.0 - Unified Tool with AI Integration**
- 🚀 **Unified `vscode-sandbox` Tool** - Combines all features in one command
- 🤖 **Automatic Augment Extension** - AI assistance pre-installed in every profile
- 🛡️ **Dual Security Levels** - Choose basic or maximum security as needed
- 📦 **Integrated Project Scaffolding** - Create projects within isolated environments
- 🌐 **Global Installation** - System-wide accessibility with self-update
- 🖥️ **Desktop Integration** - Custom launchers for maximum security profiles

### **Key Improvements**
- **Simplified User Experience** - One tool for all isolation needs
- **AI-Powered Development** - Augment extension automatically configured
- **Enterprise Ready** - Maximum security with Linux namespaces
- **Developer Friendly** - Optimized settings and common extensions included
- **Self-Maintaining** - Automatic updates and comprehensive error handling

## 🤝 **Contributing**

We welcome contributions! Here's how you can help:

1. **Report Issues** - Found a bug? [Open an issue](https://github.com/MamunHoque/VSCodeSandbox/issues)
2. **Feature Requests** - Have an idea? [Start a discussion](https://github.com/MamunHoque/VSCodeSandbox/discussions)
3. **Code Contributions** - Submit pull requests for improvements
4. **Documentation** - Help improve guides and examples
5. **Testing** - Test on different Linux distributions and report results

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 **Author**

**Mamun Hoque**
- GitHub: [@MamunHoque](https://github.com/MamunHoque)
- Repository: [VSCodeSandbox](https://github.com/MamunHoque/VSCodeSandbox)

## 🔗 **Links**

- **Repository**: [https://github.com/MamunHoque/VSCodeSandbox](https://github.com/MamunHoque/VSCodeSandbox)
- **Issues**: [Report bugs or request features](https://github.com/MamunHoque/VSCodeSandbox/issues)
- **Discussions**: [Community discussions](https://github.com/MamunHoque/VSCodeSandbox/discussions)

---

---

**VS Code Sandbox** - Complete isolation with AI-powered development. Because every project deserves its own secure universe. 🌌🤖

*Enhanced with automatic Augment extension integration by [Mamun Hoque](https://github.com/MamunHoque)*
