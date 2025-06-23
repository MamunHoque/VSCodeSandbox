# VS Code Sandbox Troubleshooting Guide

This guide helps you resolve common issues with VS Code Sandbox.

## 🚨 Common Issues

### 1. Namespace Creation Fails

**Error:** `unshare: Operation not permitted`

**Causes & Solutions:**

```bash
# Check if user namespaces are enabled
cat /proc/sys/kernel/unprivileged_userns_clone
# Should return 1

# If it returns 0, enable user namespaces:
echo 1 | sudo tee /proc/sys/kernel/unprivileged_userns_clone

# Make it permanent by adding to /etc/sysctl.conf:
echo "kernel.unprivileged_userns_clone = 1" | sudo tee -a /etc/sysctl.conf
```

**Alternative:** Some distributions disable user namespaces by default. Check your distribution's documentation.

### 2. VS Code Not Found

**Error:** `VS Code binary not found`

**Solutions:**

```bash
# Check if VS Code is installed
which code

# If not found, install VS Code:
# Ubuntu/Debian:
sudo apt update && sudo apt install code

# Or via snap:
sudo snap install code --classic

# Set custom VS Code path:
export VSCODE_BINARY="/path/to/your/code"
./vscode-isolate.sh myproject create
```

### 3. Permission Denied Errors

**Error:** `Permission denied` when creating directories

**Solutions:**

```bash
# Check permissions on isolation root
ls -la ~/.vscode-isolated/

# Fix permissions if needed
chmod 755 ~/.vscode-isolated/
chmod -R 755 ~/.vscode-isolated/profiles/

# Check disk space
df -h ~
```

### 4. Desktop Integration Issues

**Error:** Desktop entries not appearing or URI handling not working

**Solutions:**

```bash
# Update desktop database manually
update-desktop-database ~/.local/share/applications

# Check XDG directories
echo $XDG_DATA_HOME
echo $XDG_CONFIG_HOME

# Refresh MIME database
update-mime-database ~/.local/share/mime

# Log out and back in to refresh desktop environment
```

### 5. Profile Launch Fails

**Error:** Profile launches but VS Code doesn't start

**Solutions:**

```bash
# Check profile status
./vscode-isolate.sh myproject status

# Verify launcher script
cat ~/.vscode-isolated/launchers/myproject-launcher.sh

# Test namespace creation manually
unshare -U true

# Check VS Code can start normally
code --version

# Launch with debugging
bash -x ~/.vscode-isolated/launchers/myproject-launcher.sh
```

## 🔧 Debugging Commands

### Check System Compatibility

```bash
# Check Linux version
uname -a

# Check namespace support
unshare --help

# Test namespace creation
unshare -U -m -i -p --fork echo "Namespaces working"

# Check VS Code installation
code --version
which code
```

### Profile Diagnostics

```bash
# List all profiles
./vscode-isolate.sh "" list

# Check specific profile
./vscode-isolate.sh myproject status

# Verify directory structure
find ~/.vscode-isolated/profiles/myproject -type d | head -20

# Check launcher script
cat ~/.vscode-isolated/launchers/myproject-launcher.sh
```

### Process Debugging

```bash
# Check running VS Code processes
ps aux | grep code

# Check namespace processes
ps aux | grep unshare

# Monitor profile launch
strace -f ./vscode-isolate.sh myproject launch 2>&1 | grep -E "(open|exec|clone)"
```

## 🛠️ Advanced Troubleshooting

### 1. Filesystem Issues

```bash
# Check mount points
mount | grep vscode-isolated

# Verify bind mounts
findmnt | grep vscode-isolated

# Check filesystem permissions
namei -l ~/.vscode-isolated/profiles/myproject/home/.config/Code
```

### 2. Environment Problems

```bash
# Check environment in profile
./vscode-isolate.sh myproject launch -- --version

# Verify environment variables
env | grep XDG

# Test environment isolation
./vscode-isolate.sh myproject launch -- -c 'env | grep HOME'
```

### 3. Extension Issues

```bash
# Check extension directory
ls -la ~/.vscode-isolated/profiles/myproject/home/.local/share/Code/extensions/

# Manually install extension
./vscode-isolate.sh myproject launch -- --install-extension ms-python.python

# Reset extensions
rm -rf ~/.vscode-isolated/profiles/myproject/home/.local/share/Code/extensions/
```

## 🔍 Log Analysis

### Enable Verbose Logging

```bash
# Run with debug output
bash -x ./vscode-isolate.sh myproject create

# VS Code verbose logging
./vscode-isolate.sh myproject launch -- --verbose --log debug
```

### Common Log Patterns

**Successful Launch:**
```
ℹ Creating isolated VS Code profile: myproject
✅ Directory structure created
✅ Namespace script created
✅ Launcher script created
✅ Desktop integration created
✅ Profile 'myproject' created successfully!
```

**Namespace Error:**
```
unshare: unshare failed: Operation not permitted
```

**VS Code Error:**
```
code: command not found
```

## 🚑 Recovery Procedures

### 1. Corrupted Profile Recovery

```bash
# Backup corrupted profile
cp -r ~/.vscode-isolated/profiles/myproject ~/.vscode-isolated/profiles/myproject.backup

# Remove corrupted profile
./vscode-isolate.sh myproject remove

# Restore from backup if available
./vscode-profile-manager.sh restore

# Or recreate profile
./vscode-isolate.sh myproject create
```

### 2. Complete Reset

```bash
# Backup all profiles
./vscode-profile-manager.sh backup-all

# Remove all profiles
rm -rf ~/.vscode-isolated/

# Reinstall VS Code Sandbox
./install.sh

# Restore profiles from backup
./vscode-profile-manager.sh restore
```

### 3. System Cleanup

```bash
# Kill all VS Code processes
pkill -f "code.*vscode-isolated"

# Clean up mount points
sudo umount ~/.vscode-isolated/profiles/*/home 2>/dev/null || true

# Remove temporary files
rm -rf /tmp/vscode-sandbox-*
```

## 📞 Getting Help

### 1. Information to Collect

Before reporting issues, collect:

```bash
# System information
uname -a
lsb_release -a

# VS Code Sandbox version
head -5 ./vscode-isolate.sh

# VS Code version
code --version

# Namespace support
unshare --help | head -5

# Error logs
./vscode-isolate.sh myproject create 2>&1 | tee error.log
```

### 2. Common Solutions Summary

| Issue | Quick Fix |
|-------|-----------|
| Namespace permission denied | `echo 1 \| sudo tee /proc/sys/kernel/unprivileged_userns_clone` |
| VS Code not found | `export VSCODE_BINARY="/path/to/code"` |
| Desktop integration broken | `update-desktop-database ~/.local/share/applications` |
| Profile won't launch | `./vscode-isolate.sh profile remove && ./vscode-isolate.sh profile create` |
| Permission errors | `chmod -R 755 ~/.vscode-isolated/` |

### 3. When to Reinstall

Consider reinstalling if:
- Multiple profiles are corrupted
- System-wide namespace issues
- Major VS Code Sandbox updates
- Persistent unexplained errors

```bash
# Clean reinstall
rm -rf ~/.vscode-isolated/
./install.sh
```

Remember: VS Code Sandbox is designed to be safe and reversible. When in doubt, remove and recreate profiles - your project files in the `projects/` directory will be preserved.
