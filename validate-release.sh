#!/bin/bash

# Release Validation Script for VS Code Sandbox v3.1.0
# Validates that all components are ready for release

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }

echo -e "${BLUE}🔍 VS Code Sandbox v3.1.0 Release Validation${NC}"
echo

# Check if we're in the right directory
if [[ ! -f "vscode-isolate.sh" ]]; then
    log_error "vscode-isolate.sh not found. Please run this script from the project root."
    exit 1
fi

# Validation checks
CHECKS_PASSED=0
TOTAL_CHECKS=0

# Function to run a check
run_check() {
    local check_name="$1"
    local check_command="$2"
    
    ((TOTAL_CHECKS++))
    echo -n "Checking $check_name... "
    
    if eval "$check_command" >/dev/null 2>&1; then
        echo -e "${GREEN}✅${NC}"
        ((CHECKS_PASSED++))
        return 0
    else
        echo -e "${RED}❌${NC}"
        return 1
    fi
}

# Check script version
echo -e "${BLUE}📋 Version Validation${NC}"
if grep -q "Version: 3.1.0" vscode-isolate.sh; then
    log_success "Script version is 3.1.0"
    ((CHECKS_PASSED++))
else
    log_error "Script version is not 3.1.0"
fi
((TOTAL_CHECKS++))

# Check script functionality
echo -e "${BLUE}🔧 Functionality Validation${NC}"
run_check "script syntax" "bash -n vscode-isolate.sh"
echo -n "Checking version command... "
if bash -c "./vscode-isolate.sh --version 2>/dev/null | grep -q '3.1.0'"; then
    echo -e "${GREEN}✅${NC}"
    ((CHECKS_PASSED++))
else
    echo -e "${RED}❌${NC}"
    echo "Debug: Version output:"
    ./vscode-isolate.sh --version 2>&1 | head -3
fi
((TOTAL_CHECKS++))

if ./vscode-isolate.sh --help 2>/dev/null | grep -q 'Cross-Platform'; then
    echo -n "Checking help command... "
    echo -e "${GREEN}✅${NC}"
    ((CHECKS_PASSED++))
else
    echo -n "Checking help command... "
    echo -e "${RED}❌${NC}"
fi
((TOTAL_CHECKS++))

# Check required files
echo -e "${BLUE}📁 File Validation${NC}"
run_check "main script" "test -f vscode-isolate.sh && test -x vscode-isolate.sh"
run_check "changelog" "test -f CHANGELOG.md && grep -q '3.1.0' CHANGELOG.md"
run_check "release notes" "test -f RELEASE_NOTES_v3.1.0.md"
run_check "git guide" "test -f GIT_RELEASE_GUIDE.md"

# Check cross-platform features
echo -e "${BLUE}🌐 Cross-Platform Validation${NC}"
run_check "macOS detection" "grep -q 'Darwin' vscode-isolate.sh"
run_check "Linux detection" "grep -q 'Linux' vscode-isolate.sh"
run_check "VS Code detection" "grep -q 'detect_vscode_binary' vscode-isolate.sh"
run_check "URI handling" "grep -q 'vscode://' vscode-isolate.sh"

# Check documentation
echo -e "${BLUE}📚 Documentation Validation${NC}"
run_check "README exists" "test -f README.md"
run_check "troubleshooting guide" "test -f docs/TROUBLESHOOTING.md"

# Test basic functionality
echo -e "${BLUE}🧪 Basic Functionality Test${NC}"
if ./vscode-isolate.sh test-validation create >/dev/null 2>&1; then
    log_success "Profile creation test passed"
    ((CHECKS_PASSED++))
    
    # Clean up test profile
    if ./vscode-isolate.sh test-validation remove >/dev/null 2>&1 <<< "y"; then
        log_success "Profile removal test passed"
        ((CHECKS_PASSED++))
    else
        log_warning "Profile removal test failed (manual cleanup may be needed)"
    fi
    ((TOTAL_CHECKS++))
else
    log_error "Profile creation test failed"
fi
((TOTAL_CHECKS++))

# Summary
echo
echo -e "${BLUE}📊 Validation Summary${NC}"
echo "Checks passed: $CHECKS_PASSED/$TOTAL_CHECKS"

if [[ $CHECKS_PASSED -eq $TOTAL_CHECKS ]]; then
    echo
    log_success "🎉 All validation checks passed! Ready for release."
    echo
    echo -e "${GREEN}Next steps:${NC}"
    echo "1. Review the changes: git status"
    echo "2. Follow the Git Release Guide: cat GIT_RELEASE_GUIDE.md"
    echo "3. Create the release: git tag -a v3.1.0"
    echo "4. Push to repository: git push origin v3.1.0"
    exit 0
else
    echo
    log_error "Some validation checks failed. Please fix issues before releasing."
    echo
    echo -e "${YELLOW}Common fixes:${NC}"
    echo "• Ensure script is executable: chmod +x vscode-isolate.sh"
    echo "• Check version number in script header"
    echo "• Verify all required files are present"
    echo "• Test script functionality manually"
    exit 1
fi
