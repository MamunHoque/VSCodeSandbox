# VSCodeSandbox v5.0.0 - Quick Start Guide

## 🚀 **One-Line Installation**

```bash
curl -sSL https://raw.githubusercontent.com/MamunHoque/VSCodeSandbox/main/vscode-isolate.sh -o vscode-isolate.sh && chmod +x vscode-isolate.sh
```

## 🎯 **Most Common Use Case: Extension Trial Reset**

### **Create Undetectable Profiles**
```bash
# Create first bypass profile
./vscode-isolate.sh bypass-1 create --anti-detection

# Create additional profiles (each gets unique identifiers)
./vscode-isolate.sh bypass-2 create --anti-detection
./vscode-isolate.sh bypass-3 create --anti-detection
```

### **Launch Isolated VS Code**
```bash
# Launch any profile
./vscode-isolate.sh bypass-1 launch
./vscode-isolate.sh bypass-2 launch
```

### **Verify Anti-Detection**
```bash
# Test effectiveness
./vscode-isolate.sh bypass-1 test

# Expected output:
# ✅ PASS: Machine ID spoofed
# ✅ PASS: User context isolated
# ✅ PASS: File system isolated
# ✅ PASS: Extension storage isolated
```

## 🔧 **What Each Profile Gets**

### **Unique System Identifiers**
- **Machine ID**: `61c8dbad-1a9d-4602-aafd-ea2d057afb4b` (UUID v4)
- **Hostname**: `MacBook-Pro-1aff.local` (realistic Mac)
- **MAC Address**: `00:25:00:eb:8d:fc` (Apple OUI)
- **User ID**: `516` (realistic macOS user)
- **Security Session**: `187432` (unique session)

### **Complete Isolation**
- ✅ **Keychain**: Separate credential storage
- ✅ **Extensions**: Isolated extension directories
- ✅ **Settings**: Separate VS Code configurations
- ✅ **Cache**: Isolated system caches
- ✅ **LaunchServices**: Separate app database
- ✅ **Spotlight**: Isolated search index

## 📋 **Basic Commands**

```bash
# List all profiles
./vscode-isolate.sh list

# Check profile status
./vscode-isolate.sh bypass-1 status

# Remove profile
./vscode-isolate.sh bypass-1 remove

# Launch with specific project
./vscode-isolate.sh bypass-1 launch /path/to/project

# Show help
./vscode-isolate.sh --help
```

## 🎯 **Anti-Detection Modes**

### **Maximum Anti-Detection (Recommended)**
```bash
./vscode-isolate.sh profile create --anti-detection
```
- Complete user account simulation
- Realistic system identifiers
- Maximum stealth capabilities

### **Basic Security Testing**
```bash
./vscode-isolate.sh profile create --security-test
```
- Basic identifier spoofing
- Standard file isolation

### **Extreme Testing**
```bash
./vscode-isolate.sh profile create --extreme-test
```
- Maximum spoofing
- Advanced command interception

## ✅ **Expected Results**

### **For Extension Trial Reset**
- ✅ Each profile appears as completely new user/machine
- ✅ Extensions cannot detect previous trial usage
- ✅ Trial periods reset for each new profile
- ✅ Zero cross-profile data leakage
- ✅ Augment extension sees each as fresh installation

### **Verification**
- ✅ Different machine IDs per profile
- ✅ Unique VS Code identifiers
- ✅ Separate extension installations
- ✅ Isolated system caches
- ✅ No shared configuration data

## 🔬 **Testing Your Setup**

### **Run Detection Tests**
```bash
./vscode-isolate.sh your-profile test
```

### **Manual Verification**
1. Create two profiles with `--anti-detection`
2. Check they have different machine IDs
3. Install same extension in both
4. Verify no cross-profile detection
5. Test trial functionality independently

## 🎯 **Pro Tips**

### **For Maximum Effectiveness**
- Always use `--anti-detection` mode
- Create new profiles instead of reusing
- Test with the built-in testing framework
- Verify isolation before using for trials

### **Troubleshooting**
- Run `./vscode-isolate.sh profile test` to verify setup
- Check that all tests pass before using
- Use `./vscode-isolate.sh list` to manage profiles
- Remove and recreate profiles if issues occur

## 🚀 **Ready to Use**

The enhanced VSCodeSandbox v5.0.0 provides complete anti-detection capabilities equivalent to creating new macOS user accounts. Each profile is completely undetectable by extension licensing systems like Augment.

**Start using it now:**
```bash
./vscode-isolate.sh my-bypass-profile create --anti-detection
```
