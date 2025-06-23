# VSCodeSandbox

🚀 **Complete VS Code isolation solution using Linux namespaces for maximum sandboxing**

VS Code Sandbox creates completely isolated VS Code environments that simulate fresh OS installations with zero shared state between profiles or interference with your host system.

## ✨ Features

- 🔒 **Complete Isolation**: Each profile runs in its own Linux namespace sandbox
- 🏠 **Fresh OS Simulation**: Every profile behaves like a brand new operating system
- 🚫 **Zero Interference**: No impact on existing VS Code installations
- 🔄 **Multiple Profiles**: Unlimited isolated environments that coexist peacefully
- 🗂️ **Advanced Management**: Backup, restore, clone, and compare profiles
- 🧪 **Well Tested**: Comprehensive test suite ensures isolation effectiveness
- 🛡️ **Safe Operations**: Non-destructive with clean removal capabilities

## 🚀 Quick Start

```bash
# Clone the repository
git clone git@github.com:MamunHoque/VSCodeSandbox.git
cd VSCodeSandbox

# Make scripts executable
chmod +x *.sh

# Create and launch your first isolated VS Code profile (Recommended)
./vscode-working-launcher.sh myproject

# Alternative: Use the advanced isolation engine
./vscode-isolate.sh myproject create

# List all profiles
./vscode-isolate.sh "" list

# Launch profile management interface
./vscode-profile-manager.sh launch
```

### 🎯 Recommended Workflow
```bash
# For most users - simple and reliable:
./vscode-working-launcher.sh client-work    # Auto-creates and launches
./vscode-working-launcher.sh personal-dev   # Another isolated environment
./vscode-working-launcher.sh experimental   # Safe testing environment
```

## 🎯 Use Cases

### **Development Project Isolation**
```bash
./vscode-isolate.sh frontend-project create
./vscode-isolate.sh backend-project create
./vscode-isolate.sh mobile-app create
```

### **Client Work Separation**
```bash
./vscode-isolate.sh client-alpha create
./vscode-isolate.sh client-beta create
# Complete isolation between client projects
```

### **Technology Stack Environments**
```bash
./vscode-isolate.sh python-ml create
./vscode-isolate.sh nodejs-web create
./vscode-isolate.sh rust-systems create
```

## 🛠️ Scripts Overview

### `vscode-working-launcher.sh` - Recommended Launcher ⭐
**Simple, reliable launcher that works with any VS Code installation**

```bash
./vscode-working-launcher.sh <profile_name>
```

**Features:**
- ✅ Auto-creates profiles if they don't exist
- ✅ Works with snap, deb, AppImage VS Code
- ✅ No permission issues
- ✅ Launches VS Code automatically
- ✅ Perfect isolation using VS Code's built-in features

### Other Scripts
- **`vscode-isolate.sh`** - Advanced isolation engine with namespace support
- **`vscode-profile-manager.sh`** - Advanced profile management utilities
- **`vscode-isolation-test.sh`** - Comprehensive test suite
- **`install.sh`** - Professional installation script

## 📋 Requirements

- **Linux** with namespace support
- **util-linux** package (`unshare` command)
- **VS Code** installed (any method: snap, deb, AppImage, etc.)
- **Bash 4.0+** with standard utilities

## 🔧 Installation

### Automatic Installation
```bash
curl -sSL https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main/install.sh | bash
```

### Manual Installation
```bash
git clone git@github.com:MamunHoque/VSCodeSandbox.git
cd VSCodeSandbox
chmod +x *.sh
./vscode-isolation-test.sh  # Verify installation
```

## 🧪 Testing

Run the comprehensive test suite:
```bash
./vscode-isolation-test.sh
```

## 👨‍💻 Author

**Mamun Hoque**
- GitHub: [@MamunHoque](https://github.com/MamunHoque)
- Repository: [VSCodeSandbox](https://github.com/MamunHoque/VSCodeSandbox)

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📝 What's New

### Version 2.0.0 - Major Release
- ✅ **New recommended launcher** - `vscode-working-launcher.sh`
- ✅ **Complete rewrite** with enhanced isolation
- ✅ **Multiple launcher options** for different needs
- ✅ **Professional documentation** and troubleshooting
- ✅ **Comprehensive test suite** for reliability
- ✅ **One-command installation** with automatic setup

See [CHANGELOG.md](CHANGELOG.md) for complete details.

## 🔗 Links

- **Repository**: [https://github.com/MamunHoque/VSCodeSandbox](https://github.com/MamunHoque/VSCodeSandbox)
- [Changelog](CHANGELOG.md) - What's new and version history
- [Detailed Documentation](README-Enhanced-Isolation.md) - Technical details
- [Architecture Overview](docs/ARCHITECTURE.md) - How it works
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md) - Common issues

---

**VS Code Sandbox** - Because every project deserves its own universe. 🌌

*Created with ❤️ by [Mamun Hoque](https://github.com/MamunHoque)*
