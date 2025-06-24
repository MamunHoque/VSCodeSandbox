# Changelog

All notable changes to VS Code Sandbox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [4.1.0] - 2024-06-24 - Anti-Detection System Release

### 🛡️ Added
- **Anti-Detection System**: Comprehensive bypass capabilities for sophisticated extension licensing systems
- **Realistic Identity Generation**: UUID v4 machine IDs, Apple OUI MAC addresses, realistic Mac hostnames
- **System Command Interception**: Spoofs system_profiler, ioreg, sysctl, hostname, ifconfig commands
- **Node.js Runtime Spoofing**: Overrides os module and crypto module methods for extension fingerprinting
- **VS Code Core Manipulation**: Creates fake machine ID files, global storage, and extension storage
- **Advanced Environment Spoofing**: Complete system environment variable manipulation
- **--anti-detection Flag**: New command-line option for maximum bypass capabilities

### 🔧 Enhanced
- **Machine ID Generation**: Now uses realistic UUID v4 format instead of obvious test prefixes
- **MAC Address Spoofing**: Uses real Apple OUI prefixes for realistic hardware simulation
- **Hostname Generation**: Creates realistic Mac hostnames (MacBook-Pro-xxxx.local format)
- **Extension Storage**: Pre-creates comprehensive Augment extension storage and license files
- **Command Parsing**: Improved global command syntax (./vscode-isolate.sh list instead of ./vscode-isolate.sh "" list)
- **Documentation**: Updated README with comprehensive anti-detection documentation

### 🎯 Security Testing
- **Augment Extension Targeting**: Specific anti-detection measures for Augment extension licensing
- **Hardware Fingerprint Spoofing**: Comprehensive hardware identity spoofing
- **Runtime Environment Control**: Complete control over Node.js runtime environment
- **System Call Interception**: Intercepts and spoofs system information queries

## [4.0.0] - 2024-06-24 - Security Testing Edition

### 🌟 Added
- **Security Testing Mode**: Advanced features for testing VS Code extension licensing systems
- **System Identifier Spoofing**: Each profile gets unique fake machine IDs, hostnames, and MAC addresses
- **Enhanced File System Isolation**: Complete isolation of system caches and browser data
- **License Bypass Testing**: Test VS Code extension licensing systems for vulnerabilities
- **Multiple Identity Simulation**: Create profiles that appear as different machines

## [3.1.0] - 2024-06-24 - Cross-Platform Compatibility Release

### 🌟 Added
- **Cross-Platform Compatibility**: Native support for macOS, Linux, and all VS Code installation types
- **Universal VS Code Detection**: Automatically detects VS Code installations across platforms
- **Intelligent Platform Detection**: Adapts isolation method based on host operating system
- **Enhanced URI Handling**: Full support for VS Code URIs including file, extension, and Augment URIs
- **Version Command**: Added `--version` and `--help` commands for better user experience
- **Graceful Fallback**: Falls back to basic isolation when advanced features aren't available

### 🛡️ Enhanced
- **Dual Isolation Modes**: Basic (universal) and Maximum Security (Linux namespaces)
- **VS Code Detection**: Now supports App Bundle, Homebrew, Snap, and standard installations
- **Error Handling**: Clear messages about isolation levels and platform-specific guidance
- **URI Processing**: Smart handling of vscode://, file://, and direct path arguments

### 🐛 Fixed
- **macOS Compatibility**: Fixed VS Code detection and profile creation on macOS
- **Profile Listing**: Fixed `find` command compatibility for non-GNU systems
- **Process Detection**: Fixed process status display across different platforms
- **Extension Installation**: Fixed extension installation in basic isolation mode
- **Directory Structure**: Fixed cross-platform directory creation

### 🔧 Technical
- **Platform Detection**: Added automatic platform detection with appropriate feature selection
- **Namespace Support**: Enhanced namespace detection with fallback to basic isolation
- **Cross-Platform Paths**: Updated file paths and commands for universal compatibility
- **Error Recovery**: Improved error handling and user guidance

### 📋 Compatibility
- **Backward Compatible**: All existing profiles continue to work without changes
- **Universal Support**: Works on macOS (Intel/Apple Silicon), Linux (all distributions), and other Unix systems
- **VS Code Types**: Supports all VS Code installation methods (Snap, Standard, Homebrew, App Bundle)

## [2.0.0] - 2024-06-23

### 🚀 Major Release - Complete Rewrite

This is a complete rewrite of the original VS Code isolation script with significant improvements in isolation, safety, and usability.

### ✨ Added

#### Core Features
- **Complete Linux namespace isolation** using `unshare` with mount, PID, IPC, and UTS namespaces
- **Multi-profile support** with unlimited isolated environments
- **Advanced profile management** utilities with backup, restore, and cloning
- **Comprehensive test suite** for isolation verification
- **Professional documentation** with architecture guides and troubleshooting
- **One-command installation** script with automatic setup

#### Scripts and Tools
- `vscode-isolate.sh` - Main isolation engine with namespace support
- `vscode-profile-manager.sh` - Advanced profile management utilities
- `vscode-isolation-test.sh` - Comprehensive test suite
- `vscode-working-launcher.sh` - Simple, reliable launcher for any VS Code installation
- `vscode-smart-launcher.sh` - Auto-detecting launcher with fallback options
- `vscode-quick-launcher.sh` - Namespace-aware launcher with auto-creation
- `install.sh` - Professional installation script

#### Documentation
- Complete README with quick start guide
- Detailed technical documentation (`README-Enhanced-Isolation.md`)
- Architecture overview (`docs/ARCHITECTURE.md`)
- Troubleshooting guide (`docs/TROUBLESHOOTING.md`)
- Usage examples for different scenarios
- MIT license for open source distribution

#### Profile Management
- **Auto-creation** of profiles when they don't exist
- **Interactive profile selection** and launching
- **Profile comparison** and status monitoring
- **Backup and restore** functionality with compression
- **Profile cloning** for easy duplication
- **Clean removal** with confirmation prompts

#### Isolation Features
- **Filesystem isolation** with separate home directories
- **Process isolation** using PID namespaces
- **Environment variable isolation** with custom XDG directories
- **Desktop integration** with per-profile MIME handlers
- **Extension isolation** with separate extension directories
- **Cache isolation** with independent cache directories

### 🛡️ Security Improvements

- **Non-destructive operations** - never modifies existing VS Code installations
- **Namespace-based isolation** for maximum security
- **Read-only system access** where needed
- **Complete profile separation** preventing cross-contamination
- **Safe removal** without affecting host system

### 🔧 Technical Improvements

- **Auto-detection** of VS Code binary location
- **Fallback mechanisms** for systems without namespace support
- **Snap compatibility** for snap-installed VS Code
- **Error handling** with comprehensive logging
- **System requirements checking** with helpful error messages

### 📚 Documentation Improvements

- **Professional README** with clear installation instructions
- **Architecture documentation** explaining isolation mechanisms
- **Troubleshooting guide** for common issues
- **Usage examples** for different development scenarios
- **API documentation** for advanced users

### 🧪 Testing and Quality

- **Comprehensive test suite** verifying isolation effectiveness
- **Automated testing** of namespace capabilities
- **Profile creation verification** 
- **Clean removal testing**
- **Multiple profile isolation verification**

### 🎯 Usability Improvements

- **One-command setup** with automatic installation
- **Interactive launchers** with profile selection
- **Auto-creation** of profiles when needed
- **Clear status reporting** and progress indicators
- **Helpful error messages** with solution suggestions

### 🔄 Compatibility

- **Multiple VS Code installations** (snap, deb, AppImage, custom)
- **Various Linux distributions** with namespace support
- **Fallback modes** for limited environments
- **Backward compatibility** with existing profiles

## [1.0.0] - Original Version

### Features (Original Script)
- Basic VS Code profile isolation
- Single profile support
- Manual directory setup
- Desktop integration
- Augment extension installation

### Issues (Original Script)
- **Destructive operations** - wiped existing VS Code settings globally
- **Single profile limitation** - only one profile could handle URIs
- **No error handling** - failed silently on many systems
- **Hardcoded paths** - only worked with snap VS Code
- **No backup/restore** - no way to recover profiles
- **System interference** - modified global settings

## Migration Guide

### From v1.0.0 to v2.0.0

#### Breaking Changes
- Script names have changed
- Command syntax has been updated
- Profile directory structure is different

#### Migration Steps
1. **Backup existing profiles** (if any) from the old script
2. **Remove old script** to avoid conflicts
3. **Install new version** using `install.sh`
4. **Recreate profiles** using new scripts
5. **Import projects** from old profile directories

#### New Commands
```bash
# Old way (v1.0.0)
./vscode-isolate.sh myproject

# New way (v2.0.0)
./vscode-isolate.sh myproject create
./vscode-working-launcher.sh myproject  # Recommended
```

## Upcoming Features

### Planned for v2.1.0
- [ ] **Network isolation** using network namespaces
- [ ] **Resource limits** with cgroup integration
- [ ] **Profile templates** for quick setup
- [ ] **Remote profile storage** support
- [ ] **GUI profile manager** with desktop application

### Planned for v2.2.0
- [ ] **Container integration** with Docker/Podman support
- [ ] **Encrypted profiles** for sensitive projects
- [ ] **Team collaboration** features
- [ ] **Cloud synchronization** support

## Contributing

We welcome contributions! Please see our contributing guidelines for details on:
- Reporting bugs
- Suggesting features
- Submitting pull requests
- Code style guidelines

## Support

- **GitHub Issues**: Report bugs and request features
- **Documentation**: Check the docs/ directory
- **Troubleshooting**: See TROUBLESHOOTING.md

---

**Note**: This changelog follows [Keep a Changelog](https://keepachangelog.com/) format. Each version includes the date and categorizes changes as Added, Changed, Deprecated, Removed, Fixed, or Security.
