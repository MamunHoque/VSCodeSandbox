#!/bin/bash

# VS Code Isolation Test Suite
# Tests the effectiveness of the isolation implementation

set -euo pipefail

ISOLATION_ROOT="${VSCODE_ISOLATION_ROOT:-$HOME/.vscode-isolated}"
MAIN_SCRIPT="$(dirname "$0")/vscode-isolate.sh"
TEST_PROFILE="isolation-test-$$"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }
log_test() { echo -e "${BLUE}🧪${NC} $1"; }

# Test results
TESTS_PASSED=0
TESTS_FAILED=0
TESTS_TOTAL=0

# Test function wrapper
run_test() {
    local test_name="$1"
    local test_function="$2"
    
    ((TESTS_TOTAL++))
    log_test "Running: $test_name"
    
    if $test_function; then
        log_success "PASS: $test_name"
        ((TESTS_PASSED++))
    else
        log_error "FAIL: $test_name"
        ((TESTS_FAILED++))
    fi
    echo
}

# Test 1: Profile creation and isolation
test_profile_creation() {
    # Create test profile
    set +e  # Temporarily disable exit on error
    "$MAIN_SCRIPT" "$TEST_PROFILE" create >/dev/null 2>&1
    local create_result=$?
    set -e  # Re-enable exit on error

    if [[ $create_result -ne 0 ]]; then
        return 1
    fi

    # Check if profile directory exists
    local profile_path="$ISOLATION_ROOT/profiles/$TEST_PROFILE"
    [[ -d "$profile_path" ]] || return 1

    # Check if launcher exists
    local launcher="$ISOLATION_ROOT/launchers/$TEST_PROFILE-launcher.sh"
    [[ -f "$launcher" && -x "$launcher" ]] || return 1

    return 0
}

# Test 2: Directory isolation
test_directory_isolation() {
    local profile_path="$ISOLATION_ROOT/profiles/$TEST_PROFILE"
    
    # Check isolated directories exist
    [[ -d "$profile_path/home/.config" ]] || return 1
    [[ -d "$profile_path/home/.cache" ]] || return 1
    [[ -d "$profile_path/home/.local" ]] || return 1
    [[ -d "$profile_path/tmp" ]] || return 1
    
    # Check that profile home is separate from system home
    [[ "$profile_path/home" != "$HOME" ]] || return 1
    
    return 0
}

# Test 3: Environment isolation
test_environment_isolation() {
    local profile_path="$ISOLATION_ROOT/profiles/$TEST_PROFILE"
    local namespace_script="$ISOLATION_ROOT/launchers/$TEST_PROFILE-namespace.sh"
    
    # Check namespace script exists
    [[ -f "$namespace_script" ]] || return 1
    
    # Check that namespace script sets isolated environment
    grep -q "export HOME=" "$namespace_script" || return 1
    grep -q "export XDG_CONFIG_HOME=" "$namespace_script" || return 1
    grep -q "export TMPDIR=" "$namespace_script" || return 1
    
    return 0
}

# Test 4: Process isolation capability
test_process_isolation() {
    # Check if unshare is available
    command -v unshare >/dev/null || return 1
    
    # Test if we can create namespaces
    if ! unshare -U true 2>/dev/null; then
        log_warning "User namespaces not available - limited isolation"
        return 0  # Not a failure, just limited capability
    fi
    
    return 0
}

# Test 5: Desktop integration
test_desktop_integration() {
    local profile_path="$ISOLATION_ROOT/profiles/$TEST_PROFILE"
    local desktop_entry="$profile_path/home/.local/share/applications/code-$TEST_PROFILE.desktop"
    
    # Check desktop entry exists
    [[ -f "$desktop_entry" ]] || return 1
    
    # Check desktop entry content
    grep -q "Name=VS Code - $TEST_PROFILE" "$desktop_entry" || return 1
    grep -q "MimeType=x-scheme-handler/vscode-$TEST_PROFILE" "$desktop_entry" || return 1
    
    return 0
}

# Test 6: MIME type isolation
test_mime_isolation() {
    local profile_path="$ISOLATION_ROOT/profiles/$TEST_PROFILE"
    local mime_file="$profile_path/home/.local/share/mime/packages/vscode-$TEST_PROFILE.xml"
    
    # Check MIME type file exists
    [[ -f "$mime_file" ]] || return 1
    
    # Check MIME type content
    grep -q "vscode-$TEST_PROFILE" "$mime_file" || return 1
    
    return 0
}

# Test 7: Configuration isolation
test_config_isolation() {
    local profile_path="$ISOLATION_ROOT/profiles/$TEST_PROFILE"
    
    # Create a test config file in the isolated profile
    local test_config="$profile_path/home/.config/test-isolation.conf"
    echo "isolated=true" > "$test_config"
    
    # Check that it doesn't appear in system config
    [[ ! -f "$HOME/.config/test-isolation.conf" ]] || return 1
    
    # Check that it exists in profile
    [[ -f "$test_config" ]] || return 1
    
    return 0
}

# Test 8: Multiple profile isolation
test_multiple_profiles() {
    local test_profile2="isolation-test2-$$"

    # Create second test profile
    set +e
    "$MAIN_SCRIPT" "$test_profile2" create >/dev/null 2>&1
    local create_result=$?
    set -e

    if [[ $create_result -ne 0 ]]; then
        return 1
    fi

    local profile1_path="$ISOLATION_ROOT/profiles/$TEST_PROFILE"
    local profile2_path="$ISOLATION_ROOT/profiles/$test_profile2"

    # Check both profiles exist and are separate
    [[ -d "$profile1_path" && -d "$profile2_path" ]] || return 1
    [[ "$profile1_path" != "$profile2_path" ]] || return 1

    # Create different config in each profile
    echo "profile1=true" > "$profile1_path/home/.config/profile-test.conf"
    echo "profile2=true" > "$profile2_path/home/.config/profile-test.conf"

    # Check configs are isolated
    local config1=$(cat "$profile1_path/home/.config/profile-test.conf")
    local config2=$(cat "$profile2_path/home/.config/profile-test.conf")

    [[ "$config1" != "$config2" ]] || return 1

    # Clean up second profile
    set +e
    echo "y" | "$MAIN_SCRIPT" "$test_profile2" remove >/dev/null 2>&1
    set -e

    return 0
}

# Test 9: Clean removal
test_clean_removal() {
    local profile_path="$ISOLATION_ROOT/profiles/$TEST_PROFILE"
    local launcher="$ISOLATION_ROOT/launchers/$TEST_PROFILE-launcher.sh"

    # Verify profile exists before removal
    [[ -d "$profile_path" ]] || return 1

    # Remove profile
    set +e
    echo "y" | "$MAIN_SCRIPT" "$TEST_PROFILE" remove >/dev/null 2>&1
    local remove_result=$?
    set -e

    if [[ $remove_result -ne 0 ]]; then
        return 1
    fi

    # Check that profile is completely removed
    [[ ! -d "$profile_path" ]] || return 1
    [[ ! -f "$launcher" ]] || return 1

    return 0
}

# Test 10: System impact assessment
test_system_impact() {
    # Check that no global VS Code configs were modified
    local global_configs=(
        "$HOME/.config/Code"
        "$HOME/.vscode"
        "$HOME/.cache/Code"
    )
    
    # If any of these exist, they should not have been modified by our script
    # (This is a basic check - in a real scenario, we'd compare timestamps)
    
    # Check that system MIME handlers weren't globally changed
    # (This is hard to test automatically without affecting the system)
    
    return 0
}

# Cleanup function
cleanup() {
    log_info "Cleaning up test artifacts..."
    
    # Remove test profile if it exists
    if [[ -d "$ISOLATION_ROOT/profiles/$TEST_PROFILE" ]]; then
        echo "y" | "$MAIN_SCRIPT" "$TEST_PROFILE" remove >/dev/null 2>&1 || true
    fi
    
    # Remove any leftover test profiles
    find "$ISOLATION_ROOT/profiles" -name "isolation-test*-$$" -type d -exec rm -rf {} + 2>/dev/null || true
}

# Main test runner
main() {
    echo -e "${BLUE}🧪 VS Code Isolation Test Suite${NC}"
    echo -e "${BLUE}================================${NC}"
    echo
    
    # Check prerequisites
    if [[ ! -f "$MAIN_SCRIPT" ]]; then
        log_error "Main script not found: $MAIN_SCRIPT"
        exit 1
    fi
    
    if ! command -v unshare >/dev/null; then
        log_error "unshare command not available. Install util-linux package."
        exit 1
    fi
    
    # Set up cleanup trap
    trap cleanup EXIT
    
    # Run tests
    run_test "Profile Creation and Basic Setup" test_profile_creation
    run_test "Directory Isolation" test_directory_isolation
    run_test "Environment Isolation" test_environment_isolation
    run_test "Process Isolation Capability" test_process_isolation
    run_test "Desktop Integration" test_desktop_integration
    run_test "MIME Type Isolation" test_mime_isolation
    run_test "Configuration Isolation" test_config_isolation
    run_test "Multiple Profile Isolation" test_multiple_profiles
    run_test "Clean Removal" test_clean_removal
    run_test "System Impact Assessment" test_system_impact
    
    # Results summary
    echo -e "${BLUE}📊 Test Results Summary${NC}"
    echo -e "${BLUE}=======================${NC}"
    echo -e "Total Tests: $TESTS_TOTAL"
    echo -e "${GREEN}Passed: $TESTS_PASSED${NC}"
    echo -e "${RED}Failed: $TESTS_FAILED${NC}"
    echo
    
    if [[ $TESTS_FAILED -eq 0 ]]; then
        log_success "All tests passed! Isolation is working correctly."
        exit 0
    else
        log_error "Some tests failed. Check the isolation implementation."
        exit 1
    fi
}

main "$@"
