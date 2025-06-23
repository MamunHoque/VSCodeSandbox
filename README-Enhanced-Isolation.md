# Enhanced VS Code Isolation Solution

This enhanced isolation solution creates completely sandboxed VS Code environments that simulate fresh OS installations with no shared state, cache, or configuration bleeding between profiles or affecting the host system.

## 🚀 Key Improvements Over Original Script

### **Complete Isolation Architecture**
- **Filesystem Isolation**: Uses Linux namespaces with bind mounts for complete filesystem separation
- **Process Isolation**: PID namespaces prevent processes from seeing each other
- **Environment Isolation**: Complete environment variable sandboxing
- **IPC Isolation**: Separate IPC namespaces for D-Bus and shared memory
- **Desktop Integration**: Per-profile XDG directories and MIME handlers
- **Reversible Setup**: Clean removal without affecting host system

### **Multiple Profile Support**
- Unlimited isolated profiles can coexist without conflicts
- Each profile has its own URI scheme (`vscode-profilename://`)
- Independent desktop entries and MIME handlers
- Separate project directories and configurations

### **Enhanced Safety**
- **No destructive operations** on host system VS Code installations
- **Backup and restore** capabilities for profiles
- **Profile cloning** for easy duplication
- **Clean removal** with confirmation prompts

## 📁 File Structure

```
~/.vscode-isolated/
├── profiles/
│   ├── profile1/
│   │   ├── home/                    # Isolated home directory
│   │   │   ├── .config/            # VS Code configs
│   │   │   ├── .cache/             # VS Code cache
│   │   │   ├── .local/             # Extensions & data
│   │   │   └── .profile            # Environment setup
│   │   ├── tmp/                    # Isolated temp directory
│   │   └── projects/               # Project files
│   └── profile2/...
├── launchers/
│   ├── profile1-launcher.sh        # Profile launcher
│   ├── profile1-namespace.sh       # Namespace setup
│   └── ...
└── backups/                        # Profile backups
    ├── profile1_20231201_120000.tar.gz
    └── ...
```

## 🛠️ Scripts Overview

### 1. `vscode-working-launcher.sh` - Recommended Launcher ⭐
**Simple, reliable launcher that works with any VS Code installation**

**Usage:**
```bash
./vscode-working-launcher.sh <profile_name>
```

**Features:**
- ✅ Auto-creates profiles if they don't exist
- ✅ Works with snap, deb, AppImage VS Code installations
- ✅ No permission or namespace issues
- ✅ Launches VS Code automatically
- ✅ Perfect isolation using VS Code's built-in features
- ✅ Snap-compatible (no HOME directory changes)

**Examples:**
```bash
./vscode-working-launcher.sh myproject      # Auto-create and launch
./vscode-working-launcher.sh client-work    # Launch client profile
./vscode-working-launcher.sh experimental   # Launch experimental profile
```

### 2. `vscode-isolate.sh` - Advanced Isolation Engine
Enhanced version with comprehensive isolation using Linux namespaces.

**Usage:**
```bash
./vscode-isolate.sh <profile_name> [command]

Commands:
  create    Create and launch isolated profile (default)
  launch    Launch existing profile
  remove    Remove profile completely
  list      List all profiles
  status    Show profile status
```

**Examples:**
```bash
./vscode-isolate.sh myproject                # Create & launch
./vscode-isolate.sh myproject launch        # Launch existing
./vscode-isolate.sh myproject remove        # Remove profile
./vscode-isolate.sh "" list                 # List all profiles
```

### 3. `vscode-profile-manager.sh` - Advanced Management
Provides advanced utilities for profile management.

**Usage:**
```bash
./vscode-profile-manager.sh <command>

Commands:
  launch              Interactive profile launcher
  compare             Compare all profiles
  backup [profile]    Backup a profile
  restore             Restore from backup
  clone [src] [dst]   Clone a profile
```

### 4. `vscode-isolation-test.sh` - Test Suite
Comprehensive test suite to verify isolation effectiveness.

**Usage:**
```bash
./vscode-isolation-test.sh
```

### 5. Additional Launchers

#### `vscode-smart-launcher.sh` - Auto-Detecting Launcher
Automatically detects the best isolation method available on your system.

#### `vscode-quick-launcher.sh` - Namespace-Aware Launcher
Uses namespace isolation when available, with fallback options.

## 🔒 Isolation Features

### **Filesystem Isolation**
- Complete separation of VS Code directories
- Isolated `/tmp` and cache directories
- Bind mounts for system access (read-only)
- No interference with host VS Code installations

### **Process Isolation**
- Separate PID namespaces
- Isolated IPC mechanisms
- Independent D-Bus sessions
- Process visibility limited to profile

### **Environment Isolation**
- Custom environment variables per profile
- Isolated XDG directories
- Profile-specific PATH modifications
- Independent font and theme configurations

### **Desktop Integration**
- Profile-specific desktop entries
- Custom MIME type handlers per profile
- Independent URI scheme handling
- Application menu integration

## 🎯 Use Cases

### **Development Projects**
```bash
./vscode-isolate.sh client-project create
./vscode-isolate.sh personal-project create
./vscode-isolate.sh experimental-project create
```

### **Different Development Environments**
```bash
./vscode-isolate.sh python-dev create
./vscode-isolate.sh nodejs-dev create
./vscode-isolate.sh rust-dev create
```

### **Client Work Isolation**
```bash
./vscode-isolate.sh client-a create
./vscode-isolate.sh client-b create
# Each client's work completely isolated
```

## 🔧 Advanced Features

### **Profile Backup & Restore**
```bash
# Backup a profile
./vscode-profile-manager.sh backup myproject

# Restore from backup (interactive)
./vscode-profile-manager.sh restore
```

### **Profile Cloning**
```bash
# Clone existing profile
./vscode-profile-manager.sh clone myproject myproject-v2
```

### **Profile Comparison**
```bash
# Compare all profiles
./vscode-profile-manager.sh compare
```

### **Interactive Management**
```bash
# Interactive profile launcher
./vscode-profile-manager.sh launch
```

## ⚙️ Configuration

### **Environment Variables**
- `VSCODE_ISOLATION_ROOT`: Root directory for profiles (default: `~/.vscode-isolated`)
- `VSCODE_BINARY`: Path to VS Code binary (auto-detected)

### **Custom Configuration**
```bash
export VSCODE_ISOLATION_ROOT="/custom/path"
export VSCODE_BINARY="/custom/vscode/path"
./vscode-isolate.sh myproject create
```

## 🛡️ Security & Safety

### **Non-Destructive**
- Never modifies existing VS Code installations
- No global system changes
- Reversible operations with clean removal

### **Isolation Verification**
- Comprehensive test suite included
- Filesystem separation verification
- Process isolation testing
- Environment variable isolation checks

### **Backup Protection**
- Automatic backup capabilities
- Profile versioning support
- Safe removal with confirmations

## 🚨 Requirements

- Linux system with namespace support
- `unshare` command (util-linux package)
- VS Code installed (snap, deb, or custom)
- Bash 4.0+ with standard utilities

### **Optional Enhancements**
```bash
# Enable user namespaces (if not already enabled)
echo 1 | sudo tee /proc/sys/kernel/unprivileged_userns_clone
```

## 🔍 Troubleshooting

### **Namespace Issues**
If you get namespace-related errors:
```bash
# Check namespace support
unshare --help

# Test user namespace creation
unshare -U true
```

### **VS Code Detection**
If VS Code isn't detected:
```bash
export VSCODE_BINARY="/path/to/your/code"
```

### **Permission Issues**
Ensure scripts are executable:
```bash
chmod +x vscode-isolate.sh vscode-profile-manager.sh vscode-isolation-test.sh
```

## 📊 Testing Isolation

Run the comprehensive test suite:
```bash
./vscode-isolation-test.sh
```

This verifies:
- Profile creation and isolation
- Directory separation
- Environment isolation
- Process isolation capabilities
- Desktop integration
- MIME type isolation
- Configuration isolation
- Multiple profile isolation
- Clean removal
- System impact assessment

## 🎉 Benefits

1. **Complete Isolation**: Each profile behaves like a fresh OS installation
2. **No Conflicts**: Multiple profiles coexist without interference
3. **Easy Management**: Simple commands for all operations
4. **Reversible**: Clean removal without system impact
5. **Scalable**: Support for unlimited profiles
6. **Safe**: No destructive operations on host system
7. **Feature-Rich**: Backup, restore, clone, and compare capabilities
8. **Well-Tested**: Comprehensive test suite included

This solution provides the ultimate VS Code isolation experience, ensuring each profile operates in complete independence while maintaining ease of use and powerful management capabilities.
