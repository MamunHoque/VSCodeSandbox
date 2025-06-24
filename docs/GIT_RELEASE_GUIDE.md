# Git Release Guide - VS Code Sandbox v3.1.0

## 🚀 **Step-by-Step Release Process**

### **1. Prepare the Release**

#### **Check Current Status**
```bash
# Check current branch and status
git status
git branch

# Ensure you're on main/master branch
git checkout main  # or master
```

#### **Review Changes**
```bash
# Review all changes made
git diff HEAD~1

# Check which files were modified
git status
```

### **2. Stage and Commit Changes**

#### **Add All Enhanced Files**
```bash
# Add the enhanced script
git add vscode-isolate.sh

# Add release documentation
git add RELEASE_NOTES_v3.1.0.md
git add CHANGELOG.md

# Add any other modified files
git add .
```

#### **Create Commit**
```bash
# Create a comprehensive commit message
git commit -m "feat: Add cross-platform compatibility support

- Add universal VS Code detection for macOS, Linux, and Unix systems
- Implement intelligent platform detection with graceful fallback
- Add dual isolation modes (basic and maximum security)
- Enhance URI handling for all VS Code URL types
- Fix macOS compatibility issues with VS Code detection
- Add version command and improved help system
- Update documentation with cross-platform usage examples

Fixes: #issue-number (if applicable)
Closes: #issue-number (if applicable)

BREAKING CHANGE: None - fully backward compatible"
```

### **3. Create and Push Tag**

#### **Create Annotated Tag**
```bash
# Create annotated tag with release notes
git tag -a v3.1.0 -m "v3.1.0 - Cross-Platform Compatibility Release

🌟 Major Features:
- Universal compatibility across macOS, Linux, and Unix systems
- Intelligent platform detection with automatic adaptation
- Enhanced VS Code URI handling for all URL types
- Dual isolation modes (basic and maximum security)

🐛 Bug Fixes:
- Fixed macOS VS Code detection and profile creation
- Fixed profile listing on non-GNU systems
- Fixed process detection across platforms
- Fixed extension installation in basic isolation mode

🔧 Technical Improvements:
- Cross-platform VS Code binary detection
- Graceful fallback when namespaces aren't available
- Enhanced error handling with platform-specific guidance
- Improved compatibility with all VS Code installation types

📋 Compatibility:
- Backward compatible with all existing profiles
- Works with Snap, Standard, Homebrew, and App Bundle VS Code
- Supports macOS (Intel/Apple Silicon), Linux, and other Unix systems"
```

#### **Push Changes and Tag**
```bash
# Push the commit
git push origin main  # or master

# Push the tag
git push origin v3.1.0
```

### **4. Create GitHub Release**

#### **Option A: Using GitHub Web Interface**
1. Go to your repository on GitHub
2. Click "Releases" in the right sidebar
3. Click "Create a new release"
4. Select tag: `v3.1.0`
5. Release title: `v3.1.0 - Cross-Platform Compatibility Release`
6. Copy content from `RELEASE_NOTES_v3.1.0.md` into description
7. Check "Set as the latest release"
8. Click "Publish release"

#### **Option B: Using GitHub CLI (if installed)**
```bash
# Install GitHub CLI if not already installed
# macOS: brew install gh
# Linux: See https://cli.github.com/

# Login to GitHub
gh auth login

# Create release with notes
gh release create v3.1.0 \
  --title "v3.1.0 - Cross-Platform Compatibility Release" \
  --notes-file RELEASE_NOTES_v3.1.0.md \
  --latest
```

### **5. Verify Release**

#### **Check Tag and Release**
```bash
# Verify tag was created
git tag -l | grep v3.1.0

# Check tag details
git show v3.1.0

# Verify remote tag
git ls-remote --tags origin | grep v3.1.0
```

#### **Test Release**
```bash
# Clone fresh copy to test
cd /tmp
git clone https://github.com/YourUsername/VSCodeSandbox.git test-release
cd test-release

# Checkout the release tag
git checkout v3.1.0

# Test the enhanced script
chmod +x vscode-isolate.sh
./vscode-isolate.sh --version
./vscode-isolate.sh test-profile create
```

### **6. Update Documentation**

#### **Update README.md (if needed)**
```bash
# Update version references in README
sed -i 's/v3\.0\.0/v3.1.0/g' README.md

# Commit documentation updates
git add README.md
git commit -m "docs: Update version references to v3.1.0"
git push origin main
```

### **7. Announce Release**

#### **Create Announcement**
- Update project documentation
- Notify users through appropriate channels
- Update any package managers or distribution channels

## 🔍 **Pre-Release Checklist**

- [ ] All tests pass
- [ ] Version number updated in script
- [ ] CHANGELOG.md updated
- [ ] Release notes created
- [ ] Documentation updated
- [ ] Backward compatibility verified
- [ ] Cross-platform testing completed

## 🎯 **Post-Release Tasks**

- [ ] Verify GitHub release is published
- [ ] Test installation from release
- [ ] Update any external documentation
- [ ] Monitor for issues or feedback
- [ ] Plan next release features

## 🚨 **Rollback Process (if needed)**

If issues are discovered after release:

```bash
# Delete tag locally
git tag -d v3.1.0

# Delete tag remotely
git push origin :refs/tags/v3.1.0

# Delete GitHub release (via web interface or CLI)
gh release delete v3.1.0

# Fix issues and create new release
```

## 📝 **Release Notes Template**

For future releases, use this template:

```markdown
# VS Code Sandbox vX.Y.Z - Release Name

## 🌟 What's New
- Feature 1
- Feature 2

## 🐛 Bug Fixes
- Fix 1
- Fix 2

## 🔧 Technical Improvements
- Improvement 1
- Improvement 2

## 📋 Compatibility
- Compatibility note 1
- Compatibility note 2
```

---

**Ready to release!** Follow these steps to publish v3.1.0 with cross-platform compatibility. 🚀
