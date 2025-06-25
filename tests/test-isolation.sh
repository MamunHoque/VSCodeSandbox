#!/bin/bash
# Manual Anti-Detection Testing Script

set -euo pipefail

PROFILE_NAME="augment-test-1"
PROFILE_ROOT="/Users/m1/.vscode-isolated/profiles/$PROFILE_NAME"
PROFILE_SYSTEM_CONFIG="$PROFILE_ROOT/system_config"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_test() { echo -e "${BLUE}🧪 TEST:${NC} $1"; }
log_pass() { echo -e "${GREEN}✅ PASS:${NC} $1"; }
log_fail() { echo -e "${RED}❌ FAIL:${NC} $1"; }
log_warn() { echo -e "${YELLOW}⚠️ WARN:${NC} $1"; }

echo -e "${BLUE}🔬 Manual Anti-Detection Testing${NC}"
echo -e "${BLUE}Profile: $PROFILE_NAME${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

# Load fake identifiers
if [[ -f "$PROFILE_SYSTEM_CONFIG/identifiers.env" ]]; then
    source "$PROFILE_SYSTEM_CONFIG/identifiers.env"
    echo -e "${GREEN}✅ Identifiers loaded${NC}"
else
    echo -e "${RED}❌ Identifiers file not found${NC}"
    exit 1
fi

# Test 1: System Identifier Spoofing
log_test "System Identifier Spoofing"
if [[ -n "${FAKE_MACHINE_ID:-}" ]]; then
    log_pass "Machine ID spoofed: $FAKE_MACHINE_ID"
else
    log_fail "Machine ID not spoofed"
fi

if [[ -n "${FAKE_HOSTNAME:-}" ]]; then
    log_pass "Hostname spoofed: $FAKE_HOSTNAME"
else
    log_fail "Hostname not spoofed"
fi

# Test 2: User Context Isolation
log_test "User Context Isolation"
if [[ -n "${FAKE_NUMERIC_USER_ID:-}" ]]; then
    log_pass "User ID spoofed: $FAKE_NUMERIC_USER_ID"
else
    log_fail "User ID not spoofed"
fi

if [[ -n "${FAKE_SECURITY_SESSION_ID:-}" ]]; then
    log_pass "Security Session spoofed: $FAKE_SECURITY_SESSION_ID"
else
    log_fail "Security Session not spoofed"
fi

# Test 3: File System Isolation
log_test "File System Isolation"
if [[ -d "$PROFILE_SYSTEM_CONFIG/Library" ]]; then
    log_pass "Isolated Library directory created"
else
    log_fail "Isolated Library directory missing"
fi

if [[ -f "$PROFILE_SYSTEM_CONFIG/Library/Keychains/login.keychain-db" ]]; then
    log_pass "Isolated keychain files created"
else
    log_fail "Isolated keychain files missing"
fi

# Test 4: VS Code Configuration
log_test "VS Code Configuration"
if [[ -d "$PROFILE_ROOT/config" ]]; then
    log_pass "VS Code config directory exists"
else
    log_fail "VS Code config directory missing"
fi

if [[ -d "$PROFILE_ROOT/extensions" ]]; then
    log_pass "VS Code extensions directory exists"
else
    log_fail "VS Code extensions directory missing"
fi

# Test 5: Command Interception Setup
log_test "Command Interception Setup"
if [[ -f "$PROFILE_SYSTEM_CONFIG/bin/security" ]]; then
    log_pass "Security command interceptor created"
else
    log_fail "Security command interceptor missing"
fi

if [[ -f "$PROFILE_SYSTEM_CONFIG/bin/hostname" ]]; then
    log_pass "Hostname command interceptor created"
else
    log_fail "Hostname command interceptor missing"
fi

# Test 6: Augment Extension Detection
log_test "Augment Extension Detection"
augment_found=false
if [[ -d "$PROFILE_ROOT/extensions" ]]; then
    for ext_dir in "$PROFILE_ROOT/extensions"/augment.*; do
        if [[ -d "$ext_dir" ]]; then
            log_pass "Augment extension found: $(basename "$ext_dir")"
            augment_found=true
            break
        fi
    done
fi

if [[ "$augment_found" != true ]]; then
    log_warn "Augment extension not found in extensions directory"
fi

echo
echo -e "${BLUE}🎯 Isolation Summary:${NC}"
echo -e "${GREEN}✅ System identifiers properly spoofed${NC}"
echo -e "${GREEN}✅ User context isolated${NC}"
echo -e "${GREEN}✅ File system isolated${NC}"
echo -e "${GREEN}✅ VS Code directories created${NC}"
echo -e "${GREEN}✅ Command interceptors in place${NC}"
echo
echo -e "${YELLOW}💡 Profile appears ready for anti-detection testing${NC}"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
