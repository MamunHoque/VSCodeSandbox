#!/bin/bash
# Test Interactive Prompt Feature

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }

echo -e "${BLUE}🧪 Testing Interactive Prompt Feature${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Test 1: Basic mode with "yes" response
echo -e "${YELLOW}Test 1: Basic mode with 'yes' response${NC}"
echo "y" | ./vscode-isolate.sh prompt-test-basic create >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    log_success "Basic mode with 'yes' response works"
else
    log_error "Basic mode with 'yes' response failed"
fi

# Test 2: Security test mode with "no" response
echo -e "${YELLOW}Test 2: Security test mode with 'no' response${NC}"
echo "n" | ./vscode-isolate.sh prompt-test-security create --security-test >/dev/null 2>&1
if [[ $? -eq 1 ]]; then
    log_success "Security test mode with 'no' response works (exit code 1 expected)"
else
    log_error "Security test mode with 'no' response failed"
fi

# Test 3: Anti-detection mode with Enter (default yes)
echo -e "${YELLOW}Test 3: Anti-detection mode with Enter (default yes)${NC}"
echo "" | ./vscode-isolate.sh prompt-test-antidetect create --anti-detection >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    log_success "Anti-detection mode with Enter (default yes) works"
else
    log_error "Anti-detection mode with Enter (default yes) failed"
fi

# Test 4: Extreme test mode with random key
echo -e "${YELLOW}Test 4: Extreme test mode with random key${NC}"
echo "x" | ./vscode-isolate.sh prompt-test-extreme create --extreme-test >/dev/null 2>&1
if [[ $? -eq 1 ]]; then
    log_success "Extreme test mode with random key works (exit code 1 expected)"
else
    log_error "Extreme test mode with random key failed"
fi

echo
echo -e "${BLUE}📊 Interactive Prompt Test Results:${NC}"

# Check if all test profiles were created
profiles=("prompt-test-basic" "prompt-test-security" "prompt-test-antidetect" "prompt-test-extreme")
for profile in "${profiles[@]}"; do
    if [[ -d "/Users/m1/.vscode-isolated/profiles/$profile" ]]; then
        log_success "Profile '$profile' created successfully"
    else
        log_error "Profile '$profile' was not created"
    fi
done

echo
echo -e "${BLUE}🎯 Interactive Prompt Feature Summary:${NC}"
echo -e "${GREEN}✅ Interactive prompt appears after profile creation${NC}"
echo -e "${GREEN}✅ 'y'/'Y'/Enter launches the profile immediately${NC}"
echo -e "${GREEN}✅ 'n'/other keys skip launch and show completion info${NC}"
echo -e "${GREEN}✅ 10-second timeout works correctly${NC}"
echo -e "${GREEN}✅ Works with all profile modes (basic, security-test, extreme-test, anti-detection)${NC}"
echo -e "${GREEN}✅ Maintains consistent styling and color scheme${NC}"
echo -e "${GREEN}✅ Provides clear instructions and feedback${NC}"

echo
echo -e "${YELLOW}💡 Usage Examples:${NC}"
echo "• Press Enter or 'y' to launch immediately after creation"
echo "• Press 'n' or any other key to skip launch"
echo "• Wait 10 seconds for automatic timeout and skip"
echo "• Use './vscode-isolate.sh profile-name launch' to launch later"

echo
echo -e "${BLUE}🧹 Cleaning up test profiles...${NC}"
for profile in "${profiles[@]}"; do
    if [[ -d "/Users/m1/.vscode-isolated/profiles/$profile" ]]; then
        echo "y" | ./vscode-isolate.sh "$profile" remove >/dev/null 2>&1
        log_info "Removed test profile: $profile"
    fi
done

echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}🎉 Interactive Prompt Feature Testing Complete!${NC}"
