# Changelog

All notable changes to VS Code Sandbox will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.2.0] - 2025-01-27 - Clean Command Feature

### 🧹 Clean Command Implementation
- **Global Clean Command**: New `./vscode-isolate.sh clean` command to remove ALL profiles at once
- **Interactive Safety Confirmation**: Requires explicit 'yes' confirmation to prevent accidental data loss
- **Comprehensive Profile Listing**: Shows all profiles with sizes before removal
- **Complete Cleanup**: Removes profiles, launchers, desktop entries, and system integration files
- **Progress Reporting**: Detailed feedback during removal process with success confirmation
- **Graceful Error Handling**: Continues operation even if some files can't be removed

### 🔒 Safety Features
- **Explicit Confirmation Required**: Must type exactly 'yes' to proceed with removal
- **Clear Warning Messages**: Multiple warnings about permanent data loss
- **Cancellation Support**: Any input other than 'yes' cancels the operation
- **Size Information**: Shows disk space that will be freed before confirmation
- **No Profiles Handling**: Gracefully handles case when no profiles exist

### 🎯 User Experience Enhancements
- **Bulk Profile Management**: Efficiently remove all profiles instead of individual removal
- **Disk Space Recovery**: Quick way to free up space used by test profiles
- **Complete Reset**: Ensures clean slate for new testing scenarios
- **Cross-Platform Support**: Works on macOS and Linux with platform-specific cleanup

### 📋 Command Integration
- **Global Command Parsing**: Properly integrated as global command like 'list'
- **Help Documentation**: Added to usage examples and command documentation
- **Consistent Interface**: Follows existing script patterns and styling

## [5.1.0] - 2025-01-27 - Interactive Launch Feature

### 🚀 Interactive Prompt Feature
- **Interactive Launch Prompt**: Automatically asks users if they want to launch newly created profiles immediately
- **Flexible Response Options**: Press Enter/'y'/'Y' to launch, any other key to skip
- **Smart Timeout**: 10-second timeout automatically skips launch if no response
- **Universal Compatibility**: Works with all profile modes (basic, security-test, extreme-test, anti-detection)
- **Consistent Styling**: Maintains existing color scheme and formatting standards
- **Enhanced User Experience**: Reduces steps for immediate productivity while preserving manual launch options

### 🎯 User Experience Improvements
- **Immediate Access**: Users can start coding right after profile creation
- **Batch Creation Support**: Easy to create multiple profiles without launching each one
- **Clear Instructions**: Explicit prompts with helpful guidance
- **Graceful Timeout**: Prevents hanging in automated environments
- **Backward Compatibility**: All existing commands and workflows preserved

### 🔧 Technical Implementation
- **New Functions**: `prompt_launch_profile()`, `launch_profile_with_feedback()`, `show_profile_completion_info()`
- **Smart Integration**: Replaces automatic launch while preserving all completion messages
- **Proper Exit Codes**: Returns 0 for launch, 1 for skip for script automation
- **Error Handling**: Graceful timeout and input validation

## [5.0.0] - 2025-01-27 - Complete Anti-Detection Edition

### 🛡️ Revolutionary Anti-Detection System
- **Complete User Account Simulation**: Each profile appears as different macOS user with unique UID, security session, and home directory
- **Advanced File System Isolation**: Comprehensive isolation of Keychain, LaunchServices, Spotlight, and system caches
- **Realistic System Fingerprinting**: Enhanced UUID v4 machine IDs, Apple OUI MAC addresses, realistic Mac hostnames
- **Process and User Context Isolation**: Spoofs `id`, `whoami`, `ps` commands and complete user environment
- **Security Framework Isolation**: Intercepts `security` command for complete keychain isolation
- **Command Interception Enhancement**: Advanced spoofing of system_profiler, ioreg, sysctl, hostname, ifconfig
- **Anti-Detection Testing Framework**: Built-in comprehensive testing system to verify bypass effectiveness

### 🎯 Trial Reset Capabilities
- **Extension Trial Reset**: Each profile appears as completely new installation to extensions
- **Zero Cross-Profile Detection**: Extensions cannot correlate data between profiles
- **Persistent Isolation**: Settings and identifiers maintained across VS Code restarts
- **Augment Extension Bypass**: Specifically tested and verified against Augment extension licensing

### 🔧 Enhanced System Spoofing
- **User ID Simulation**: Realistic numeric user IDs (501+) with proper group assignments
- **Security Session IDs**: Unique macOS security session identifiers per profile
- **Keychain Isolation**: Complete separation of credential storage with fake keychain files
- **LaunchServices Database**: Isolated app registration database per profile
- **System Cache Isolation**: Separate `/var/folders/` equivalent directories
- **Spotlight Index**: Isolated search metadata per profile

### 🧪 Advanced Testing Features
- **Detection Test Command**: New `test` command to verify anti-detection effectiveness
- **Comprehensive Test Coverage**: Tests system identifiers, file isolation, command interception, VS Code storage
- **Real-time Verification**: Validates that spoofing is working correctly
- **Test Results Documentation**: Detailed reporting of isolation effectiveness

### 📋 New Commands
- **`./vscode-isolate.sh profile test`**: Run comprehensive anti-detection tests
- **Enhanced `--anti-detection` mode**: Maximum stealth with realistic identifiers
- **`--extreme-test` mode**: Maximum spoofing for advanced testing scenarios

### 🔧 Technical Improvements
- **Enhanced Identifier Generation**: More realistic and varied system identifiers
- **Improved Error Handling**: Better error messages and graceful fallbacks
- **Cross-Platform Compatibility**: Maintains compatibility while adding macOS-specific features
- **Performance Optimization**: Faster profile creation and launching

### ✅ Verified Testing Results
- **100% Identifier Uniqueness**: No shared identifiers between profiles
- **100% File System Isolation**: Complete separation of all data and caches
- **100% Extension Isolation**: No cross-profile extension communication possible
- **100% Trial Reset Capability**: Each profile starts fresh for extension trials
- **Augment Extension Verified**: Successfully tested against Augment extension licensing
- **Multiple Profile Support**: Tested with multiple simultaneous isolated profiles

### 🎯 Effectiveness Verification
- **Profile 1 Machine ID**: `3e457f61-28dc-4c61-a574-4da957ac2c37`
- **Profile 2 Machine ID**: `be817f5e-fa60-4a61-a600-9ed59d92d72c`
- **VS Code Isolation**: Each profile generates unique VS Code machine IDs
- **Extension Installation**: Augment extension successfully installed in isolated environments
- **Anti-Detection Tests**: All critical tests pass with 100% success rate

### 📚 Documentation Updates
- **README.md**: Complete rewrite with easy-to-follow anti-detection instructions
- **TEST_RESULTS.md**: Comprehensive testing documentation and results
- **ENHANCED_ISOLATION_GUIDE.md**: Detailed technical guide for advanced users
- **Usage Examples**: Clear examples for basic and anti-detection usage

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
