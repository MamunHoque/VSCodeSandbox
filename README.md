# VSCodeSandbox

🚀 **Complete VS Code isolation solution with enterprise-grade security and AI integration**

VS Code Sandbox creates completely isolated VS Code environments that simulate fresh OS installations with zero shared state between profiles. Features automatic Augment extension installation, project scaffolding, and enterprise-grade security using Linux namespaces.

## 🌟 **Key Features**

- 🛡️ **Dual Security Levels**: Basic isolation or maximum security with Linux namespaces
- 🤖 **Automatic Augment Extension**: AI-powered development assistance in every profile
- 📦 **Project Scaffolding**: Create React, Node.js, Python, Go, and static projects
- 🌐 **Global Installation**: Install once, use anywhere with self-update capability
- 🔒 **Complete Isolation**: Zero interference between profiles or host system
- 🖥️ **Desktop Integration**: Custom launchers and MIME types for maximum security
- 🧪 **Well Tested**: Comprehensive test suite ensures isolation effectiveness

## 🚀 **Quick Installation**

### **Recommended: Unified Tool (One-Line Install)**
```bash
curl -sSL https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main/install-vscode-sandbox.sh | sudo bash
```

### **Manual Installation**
```bash
git clone https://github.com/MamunHoque/VSCodeSandbox.git
cd VSCodeSandbox
chmod +x *.sh
sudo ./install-vscode-sandbox.sh
```

## 📋 **Usage**

### **Basic Commands**
```bash
# Create isolated profile (basic security)
vscode-sandbox myproject create

# Create maximum security profile
vscode-sandbox secure-project create --max-security --desktop

# Create project within isolated profile
vscode-sandbox myproject scaffold my-app --type react --git --vscode

# Launch isolated VS Code
vscode-sandbox myproject launch

# List all profiles
vscode-sandbox list

# Update tool
vscode-sandbox --update
```

## 🛡️ **Security Levels**

### **Basic Isolation (Default)**
```bash
vscode-sandbox myproject create
```
- ✅ **Extensions isolated** - Separate extension directories
- ✅ **Settings isolated** - Separate configuration files
- ✅ **Workspace isolated** - Separate workspace state
- ✅ **Augment extension** - Pre-installed AI assistance
- ✅ **Project scaffolding** - Integrated project creation
- ✅ **Universal compatibility** - Works on any Linux system

### **Maximum Security Isolation**
```bash
vscode-sandbox secure-project create --max-security --desktop
```
- ✅ **All basic features** PLUS:
- 🛡️ **Process isolation** - Separate PID namespace (can't see host processes)
- 🏠 **Environment isolation** - Separate HOME and XDG directories
- 🗂️ **Mount isolation** - Controlled filesystem access with read-only system mounts
- 💬 **IPC isolation** - Separate inter-process communication
- 🌐 **UTS isolation** - Separate hostname and domain name
- 📁 **Temporary file isolation** - Separate /tmp directory
- 🖥️ **Desktop integration** - Custom MIME types and launchers

### **When to Use Each**
- **Basic**: Daily development, project separation, team environments
- **Maximum Security**: Enterprise environments, confidential projects, compliance requirements

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

### **Skip Auto-Installation**
```bash
# Create profile without automatic extensions
vscode-sandbox manual-setup create --no-extensions
```

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

## 🔧 **Installation & System Requirements**

### **System Requirements**
- **Linux Operating System** (Ubuntu 18.04+, Debian 10+, CentOS 8+, etc.)
- **VS Code installed** (any method: snap, deb, AppImage, etc.)
- **For Maximum Security**: util-linux package (provides `unshare` command)

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

## 📖 **Complete Usage Guide**

### **Profile Management**
```bash
# Create basic isolated profile
vscode-sandbox myproject create

# Create maximum security profile with desktop integration
vscode-sandbox secure-project create --max-security --desktop

# Launch existing profile
vscode-sandbox myproject launch

# Show detailed profile information
vscode-sandbox myproject status

# List all profiles with security levels
vscode-sandbox list

# Remove profile completely
vscode-sandbox myproject remove
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
```

## 🚨 **Troubleshooting**

### **Common Issues**

#### **User Namespaces Not Available**
```bash
# Error: "Operation not permitted" when creating maximum security profiles
# Solution: Enable user namespaces
echo 1 | sudo tee /proc/sys/kernel/unprivileged_userns_clone

# Check kernel support (requires 3.8+)
uname -r
```

#### **VS Code Won't Launch**
```bash
# Error: VS Code fails to start in isolated environment
# Solution: Check VS Code binary detection
which code

# Set custom binary path if needed
export VSCODE_BINARY=/snap/bin/code
vscode-sandbox myproject create
```

#### **Extension Installation Fails**
```bash
# If Augment extension fails to install automatically
# Solution: Install manually or skip auto-installation
vscode-sandbox myproject create --no-extensions
# Then install Augment manually from Extensions marketplace
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
