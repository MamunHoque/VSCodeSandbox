# VS Code Extension Security Testing Guide

## Enhanced Isolation Script Features

Your enhanced `vscode-isolate.sh` script now includes advanced security testing capabilities to help you test your VS Code extension's licensing system.

## New Security Testing Features

### 1. **System Identifier Spoofing**
Each profile gets unique fake identifiers:
- **Fake Machine ID**: Consistent but unique per profile
- **Fake Hostname**: Different hostname per profile  
- **Fake MAC Address**: Simulated network interface
- **Fake User/Session IDs**: Additional identifiers

### 2. **Enhanced File System Isolation**
Complete isolation of system caches and configurations:
- **XDG directories**: Separate config/cache/data directories
- **Browser caches**: Isolated Chrome, Firefox, Safari data
- **System caches**: Separate temporary and runtime directories
- **Network configs**: Isolated network configuration data

### 3. **Environment Variable Spoofing**
Modified environment variables that extensions might use:
- System paths and identifiers
- Network interface information
- User session data
- Browser data directories

## How to Use for Security Testing

### Basic Usage (Normal Isolation)
```bash
# Create normal isolated profile
./vscode-isolate.sh myproject create

# Launch normal isolated profile
./vscode-isolate.sh myproject launch
```

### Security Testing Mode (Advanced Bypass Testing)
```bash
# Enable security testing mode
export VSCODE_SECURITY_TEST=true

# Create profile with fake identifiers
VSCODE_SECURITY_TEST=true ./vscode-isolate.sh test1 create

# Create another profile with different fake identifiers
VSCODE_SECURITY_TEST=true ./vscode-isolate.sh test2 create

# Launch profiles (each will have different system fingerprints)
./vscode-isolate.sh test1 launch
./vscode-isolate.sh test2 launch
```

## Testing Your Extension's Security

### Test Scenario 1: Basic Trial Reset
1. Install your extension in normal VS Code
2. Start trial, note expiration date
3. Create isolated profile: `./vscode-isolate.sh normal_test create`
4. Check if trial resets in isolated environment

### Test Scenario 2: Advanced Bypass Testing
1. Install extension, start trial
2. Create security test profile: `VSCODE_SECURITY_TEST=true ./vscode-isolate.sh bypass_test create`
3. Check if extension detects different machine
4. Verify if trial resets with spoofed identifiers

### Test Scenario 3: Multiple Profile Testing
1. Create multiple security test profiles:
   ```bash
   VSCODE_SECURITY_TEST=true ./vscode-isolate.sh test1 create
   VSCODE_SECURITY_TEST=true ./vscode-isolate.sh test2 create
   VSCODE_SECURITY_TEST=true ./vscode-isolate.sh test3 create
   ```
2. Test if each profile gets separate trials
3. Verify your extension's abuse detection

## What Each Profile Simulates

### Normal Profile
- Same machine identifiers as host
- Isolated VS Code data only
- Tests basic isolation bypass

### Security Test Profile
- **Unique machine ID** per profile
- **Different hostname** per profile
- **Separate system caches** completely isolated
- **Fake network identifiers**
- **Isolated browser data**

## Expected Results

### If Your Extension is Secure:
- ✅ Trial status persists across all profiles
- ✅ Extension detects same physical hardware
- ✅ No trial reset possible
- ✅ Abuse detection flags multiple attempts

### If Your Extension is Vulnerable:
- ❌ Fresh trial in each isolated profile
- ❌ Extension treats each profile as new machine
- ❌ Trial can be reset indefinitely
- ❌ No detection of bypass attempts

## Advanced Testing Tips

### 1. Monitor Extension Behavior
```bash
# Check what identifiers your extension uses
# Look in VS Code Developer Tools Console
# Monitor network requests to your licensing server
```

### 2. Test Server-Side Detection
- Check if your server detects multiple trials from same IP
- Verify hardware fingerprint validation
- Test rate limiting and abuse detection

### 3. Test Edge Cases
- Network disconnection scenarios
- System clock manipulation
- Rapid profile creation/deletion

## Cleanup After Testing

```bash
# Remove all test profiles
./vscode-isolate.sh test1 remove
./vscode-isolate.sh test2 remove
./vscode-isolate.sh bypass_test remove

# List remaining profiles
./vscode-isolate.sh "" list

# Disable security testing mode
unset VSCODE_SECURITY_TEST
```

## Security Recommendations

Based on testing results, consider implementing:

1. **Hardware-based fingerprinting** (CPU, disk serials)
2. **Server-side validation** with multiple identifiers
3. **Behavioral analysis** for abuse detection
4. **Rate limiting** for trial activations
5. **Manual review** for suspicious patterns

## Important Notes

- This script is for **legitimate security testing** of your own extension
- Use in **isolated test environments** only
- **Document your findings** for security improvements
- Consider **professional security auditing** for production systems

The enhanced script helps you identify weaknesses in your licensing system so you can build more robust protection against bypass attempts.
