# VS Code Sandbox - macOS Version

🍎 **Complete VS Code isolation solution for macOS with Apple Silicon M4 optimization**

This is the macOS version of VS Code Sandbox, specifically designed for Apple Silicon Macs (M4 optimized) with native macOS integration including proper URI handling, app bundles, and Launch Services registration.

## 🚀 Quick Start

### Installation

```bash
# Download and install globally
curl -sSL https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main/vscode-sandbox-macos -o vscode-sandbox-macos
chmod +x vscode-sandbox-macos
sudo ./vscode-sandbox-macos --install
```

### Create Your First Isolated Profile

```bash
# Create a new isolated VS Code environment
vscode-sandbox-macos myproject create

# Create with project scaffolding
vscode-sandbox-macos myproject scaffold --type react --git --vscode
```

## 🛡️ macOS-Specific Features

### **Complete Isolation**
- ✅ **Separate Application Support** - Isolated `~/Library/Application Support` data
- ✅ **Separate Caches** - Isolated `~/Library/Caches` directories
- ✅ **Separate Preferences** - Isolated `~/Library/Preferences` files
- ✅ **Environment Isolation** - Separate HOME and XDG directories
- ✅ **Extension Isolation** - Each profile has its own extensions
- ✅ **Settings Isolation** - Completely separate VS Code settings

### **Native macOS Integration**
- 🍎 **App Bundles** - Each profile gets its own `.app` bundle
- 🔗 **URI Handling** - Proper vscode:// URI registration with Launch Services
- 📱 **Launch Services** - Native macOS application registration
- ⚡ **Apple Silicon Optimized** - M4 performance optimizations
- 🎨 **macOS UI** - Native macOS fonts and interface elements

### **Advanced URI Support**
- 📂 **File URIs**: `vscode://file/path/to/file.js`
- 📁 **Folder URIs**: `vscode://folder/path/to/project`
- 🧩 **Extension URIs**: `vscode://extension/ms-python.python`
- 🤖 **Augment URIs**: `vscode://augment.vscode-augment/auth/result?code=...`
- 🏷️ **Profile-specific**: `vscode-myproject://file/path/to/file.js`

## 📋 Commands

### Profile Management
```bash
# Create isolated profile
vscode-sandbox-macos myproject create

# Launch existing profile
vscode-sandbox-macos myproject launch

# Check profile status
vscode-sandbox-macos myproject status

# Check URI handler status
vscode-sandbox-macos myproject uri-status

# Remove profile
vscode-sandbox-macos myproject remove
```

### Project Scaffolding
```bash
# Create React project
vscode-sandbox-macos myproject scaffold --type react --git --vscode --docker

# Create Node.js project
vscode-sandbox-macos myproject scaffold --type node --git --vscode

# Create Python project
vscode-sandbox-macos myproject scaffold --type python --git --vscode

# Create Go project
vscode-sandbox-macos myproject scaffold --type go --git --vscode

# Create static HTML/CSS/JS project
vscode-sandbox-macos myproject scaffold --type static --git --vscode
```

### Global Commands
```bash
# List all profiles
vscode-sandbox-macos list

# Update to latest version
vscode-sandbox-macos --update

# Show version
vscode-sandbox-macos --version

# Show help
vscode-sandbox-macos --help

# Clean all profiles
vscode-sandbox-macos clean

# Completely uninstall
vscode-sandbox-macos uninstall
```

## 🔧 macOS-Specific Configuration

### System Requirements
- **macOS**: 10.15 (Catalina) or later
- **Architecture**: Apple Silicon (M1/M2/M3/M4) or Intel
- **VS Code**: Latest version installed in `/Applications/`

### File Structure
```
~/.vscode-isolated/
├── profiles/
│   └── myproject/
│       ├── config/              # VS Code user data
│       ├── extensions/          # Isolated extensions
│       ├── projects/            # Your projects
│       └── Library/             # macOS Application Support
│           ├── Application Support/
│           ├── Caches/
│           └── Preferences/
└── launchers/
    └── myproject-launcher.sh    # Profile launcher

~/Applications/
└── VSCode-myproject.app         # App bundle for URI handling
```

## 🧪 Testing URI Handling

### Test Complex Augment Authentication URI
```bash
# Test Augment authentication callback
vscode-sandbox-macos myproject launch --open-url 'vscode://augment.vscode-augment/auth/result?code=_96a93f8f41f996ed256781e5b1e2ff27&state=2085a0c5-44f3-4296-bf79-6d88a5ccb429&tenant_url=https%3A%2F%2Fd2.api.augmentcode.com%2F'

# Check URI handler status
vscode-sandbox-macos myproject uri-status
```

## 🔄 Migration from Linux Version

If you're using the Linux version and want to try the macOS version:

```bash
# The profiles are compatible - just use the macOS script
vscode-sandbox-macos existing-profile launch

# Or create new profiles specifically for macOS
vscode-sandbox-macos macos-project create
```

## 🆚 Differences from Linux Version

| Feature | Linux Version | macOS Version |
|---------|---------------|---------------|
| **Isolation Method** | Linux Namespaces | Directory + Environment |
| **URI Registration** | xdg-mime | Launch Services |
| **App Integration** | Desktop entries | App bundles |
| **Maximum Security** | ✅ (Namespaces) | ⚠️ (Directory-based) |
| **Performance** | Standard | Apple Silicon Optimized |
| **Native Integration** | Good | Excellent |

## 🐛 Troubleshooting

### URI Handlers Not Working
```bash
# Check URI status
vscode-sandbox-macos myproject uri-status

# Recreate profile to fix URI handlers
vscode-sandbox-macos myproject create
```

### VS Code Not Found
```bash
# Set custom VS Code path
export VSCODE_BINARY="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
vscode-sandbox-macos myproject create
```

### Permission Issues
```bash
# Fix permissions for global installation
sudo chown -R $(whoami) /usr/local/bin/vscode-sandbox-macos
```

## 📚 Related Documentation

- **Main README**: [README.md](README.md) - Linux version documentation
- **Installation Guide**: See main repository for detailed installation instructions
- **Contributing**: See main repository for contribution guidelines

## 🔗 Links

- **Repository**: https://github.com/MamunHoque/VSCodeSandbox
- **Issues**: https://github.com/MamunHoque/VSCodeSandbox/issues
- **VS Code**: https://code.visualstudio.com/

---

**Made with ❤️ for macOS developers using Apple Silicon M4**
