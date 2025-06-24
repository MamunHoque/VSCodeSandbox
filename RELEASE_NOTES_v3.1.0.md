# VS Code Sandbox v3.1.0 - Cross-Platform Compatibility Release

🎉 **Major Update**: Universal compatibility across macOS, Linux, and all VS Code installation types!

## 🌟 **What's New**

### **🔧 Cross-Platform Compatibility**
- ✅ **macOS Support**: Native support for macOS VS Code installations
- ✅ **Universal VS Code Detection**: Works with Snap, standard, Homebrew, and app bundle installations
- ✅ **Intelligent Platform Detection**: Automatically adapts to the host operating system
- ✅ **Graceful Fallback**: Falls back to basic isolation when advanced features aren't available

### **🛡️ Enhanced Isolation Modes**

#### **Basic Isolation (Universal)**
- ✅ **Cross-Platform**: Works on macOS, Linux, and other Unix systems
- ✅ **VS Code Compatibility**: Works with all VS Code installation methods
- ✅ **Directory Separation**: Isolated extensions, settings, and projects
- ✅ **Environment Isolation**: Separate configuration and cache directories

#### **Maximum Security (Linux)**
- ✅ **Namespace Isolation**: Linux namespaces for complete process isolation
- ✅ **Automatic Detection**: Enables when Linux namespaces are available
- ✅ **Backward Compatible**: Falls back to basic mode when not supported

### **🔗 Enhanced URI Handling**
- ✅ **VS Code URIs**: Full support for `vscode://` protocol
- ✅ **File URIs**: Handle `file://` and direct file paths
- ✅ **Extension URIs**: Install extensions via URI
- ✅ **Augment Integration**: Support for Augment extension authentication URIs

## 🔧 **Technical Improvements**

### **VS Code Detection**
```bash
# Now detects VS Code in all these locations:
# macOS:
/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code
$HOME/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code
/opt/homebrew/bin/code

# Linux:
/snap/bin/code
/usr/bin/code
/usr/local/bin/code
/opt/visual-studio-code/bin/code
```

### **Platform-Aware Isolation**
- **macOS**: Uses basic isolation with environment variables and directory separation
- **Linux with Namespaces**: Uses maximum security with process isolation
- **Linux without Namespaces**: Falls back to basic isolation
- **Other Unix**: Uses basic isolation with universal compatibility

### **Improved Error Handling**
- ✅ **Clear Messages**: Users know exactly what isolation level they're getting
- ✅ **Helpful Suggestions**: Provides platform-specific installation guidance
- ✅ **Graceful Degradation**: Never fails due to platform incompatibility

## 📋 **Usage Examples**

### **macOS**
```bash
# Create isolated profile (automatically uses basic isolation)
./vscode-isolate.sh myproject create

# Launch with VS Code URI
./vscode-isolate.sh myproject launch "vscode://file/path/to/file.js"

# Install extension via URI
./vscode-isolate.sh myproject launch "vscode://extension/ms-python.python"
```

### **Linux (Standard VS Code)**
```bash
# Create maximum security profile (automatic namespace detection)
./vscode-isolate.sh secure-project create

# Launch with complete isolation
./vscode-isolate.sh secure-project launch
```

### **Linux (Snap VS Code)**
```bash
# Create basic isolation profile (automatic Snap detection)
./vscode-isolate.sh snap-project create

# Force namespace isolation (advanced)
./vscode-isolate.sh snap-project create --force-namespaces
```

## 🐛 **Bug Fixes**

- ✅ **Fixed**: VS Code detection on macOS
- ✅ **Fixed**: Profile listing on non-GNU systems (macOS find compatibility)
- ✅ **Fixed**: Process status detection across platforms
- ✅ **Fixed**: Extension installation in basic isolation mode
- ✅ **Fixed**: Directory structure creation for cross-platform compatibility

## 🔄 **Migration Guide**

### **Existing Users**
- **No Action Required**: Existing profiles continue to work
- **Enhanced Features**: Existing profiles gain URI handling improvements
- **Platform Detection**: Script now auto-detects your platform and adapts

### **New macOS Users**
```bash
# Clone the repository
git clone https://github.com/MamunHoque/VSCodeSandbox.git
cd VSCodeSandbox

# Make executable
chmod +x vscode-isolate.sh

# Create your first profile
./vscode-isolate.sh myproject create
```

## 🧪 **Tested Platforms**

- ✅ **macOS**: Apple Silicon M4, Intel
- ✅ **Linux**: Ubuntu, Debian, CentOS, Fedora
- ✅ **VS Code Types**: Snap, Standard, Homebrew, App Bundle

## 🔗 **Compatibility Matrix**

| Platform | VS Code Type | Isolation Level | URI Support | Status |
|----------|-------------|----------------|-------------|---------|
| macOS | App Bundle | Basic | ✅ Full | ✅ Tested |
| macOS | Homebrew | Basic | ✅ Full | ✅ Tested |
| Linux | Standard | Maximum | ✅ Full | ✅ Tested |
| Linux | Snap | Basic* | ✅ Full | ✅ Tested |
| Other Unix | Any | Basic | ✅ Full | ✅ Compatible |

*Can be forced to Maximum with `--force-namespaces`

## 🚀 **Performance**

- **Startup Time**: No performance impact on basic isolation
- **Memory Usage**: Minimal overhead for cross-platform detection
- **Compatibility**: 100% backward compatible with existing profiles

## 📝 **Breaking Changes**

**None!** This release is fully backward compatible.

## 🙏 **Acknowledgments**

Special thanks to the community for reporting cross-platform compatibility issues and testing the enhanced script across different environments.

---

**Full Changelog**: [v3.0.0...v3.1.0](https://github.com/MamunHoque/VSCodeSandbox/compare/v3.0.0...v3.1.0)
