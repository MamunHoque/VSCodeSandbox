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

# Create your first isolated VS Code profile
./vscode-isolate.sh myproject create

# List all profiles
./vscode-isolate.sh "" list

# Launch profile management interface
./vscode-profile-manager.sh launch
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

- **`vscode-isolate.sh`** - Main isolation engine
- **`vscode-profile-manager.sh`** - Advanced profile management
- **`vscode-isolation-test.sh`** - Comprehensive test suite
- **`install.sh`** - Easy installation script

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

## 🔗 Links

- **Repository**: [https://github.com/MamunHoque/VSCodeSandbox](https://github.com/MamunHoque/VSCodeSandbox)
- [Detailed Documentation](README.md)
- [Architecture Overview](docs/ARCHITECTURE.md)
- [Troubleshooting Guide](docs/TROUBLESHOOTING.md)

---

**VS Code Sandbox** - Because every project deserves its own universe. 🌌

*Created with ❤️ by [Mamun Hoque](https://github.com/MamunHoque)*
# VSCodeSandbox
