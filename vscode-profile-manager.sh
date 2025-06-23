#!/bin/bash

# VS Code Profile Manager - Advanced utilities for managing isolated profiles
# Companion script to vscode-isolate.sh

set -euo pipefail

ISOLATION_ROOT="${VSCODE_ISOLATION_ROOT:-$HOME/.vscode-isolated}"
MAIN_SCRIPT="$(dirname "$0")/vscode-isolate.sh"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ${NC} $1"; }
log_success() { echo -e "${GREEN}✅${NC} $1"; }
log_warning() { echo -e "${YELLOW}⚠${NC} $1"; }
log_error() { echo -e "${RED}❌${NC} $1"; }

# Interactive profile selector
select_profile() {
    local profiles_dir="$ISOLATION_ROOT/profiles"
    
    if [[ ! -d "$profiles_dir" ]]; then
        log_error "No profiles found. Create one first with: $MAIN_SCRIPT <name> create"
        exit 1
    fi
    
    local profiles=($(find "$profiles_dir" -maxdepth 1 -type d -not -path "$profiles_dir" -printf "%f\n" 2>/dev/null | sort))
    
    if [[ ${#profiles[@]} -eq 0 ]]; then
        log_error "No profiles found. Create one first with: $MAIN_SCRIPT <name> create"
        exit 1
    fi
    
    echo -e "${CYAN}📋 Select a profile:${NC}"
    echo
    
    for i in "${!profiles[@]}"; do
        local profile="${profiles[$i]}"
        local launcher="$ISOLATION_ROOT/launchers/$profile-launcher.sh"
        local status="❌"
        [[ -f "$launcher" ]] && status="✅"
        
        echo -e "  ${BLUE}$((i+1))${NC}) $profile $status"
    done
    
    echo
    read -p "Enter profile number (1-${#profiles[@]}): " -r choice
    
    if [[ "$choice" =~ ^[0-9]+$ ]] && [[ "$choice" -ge 1 ]] && [[ "$choice" -le "${#profiles[@]}" ]]; then
        echo "${profiles[$((choice-1))]}"
    else
        log_error "Invalid selection"
        exit 1
    fi
}

# Quick launch menu
quick_launch() {
    local profile
    profile=$(select_profile)
    
    log_info "Launching profile: $profile"
    exec "$MAIN_SCRIPT" "$profile" launch
}

# Profile comparison
compare_profiles() {
    local profiles_dir="$ISOLATION_ROOT/profiles"
    local profiles=($(find "$profiles_dir" -maxdepth 1 -type d -not -path "$profiles_dir" -printf "%f\n" 2>/dev/null | sort))
    
    if [[ ${#profiles[@]} -lt 2 ]]; then
        log_error "Need at least 2 profiles to compare"
        exit 1
    fi
    
    echo -e "${CYAN}📊 Profile Comparison${NC}"
    echo
    
    printf "%-20s %-10s %-15s %-10s %s\n" "Profile" "Status" "Size" "Extensions" "Last Modified"
    printf "%-20s %-10s %-15s %-10s %s\n" "-------" "------" "----" "----------" "-------------"
    
    for profile in "${profiles[@]}"; do
        local profile_path="$profiles_dir/$profile"
        local launcher="$ISOLATION_ROOT/launchers/$profile-launcher.sh"
        local status="❌ Broken"
        local size=$(du -sh "$profile_path" 2>/dev/null | cut -f1)
        local ext_count="0"
        local last_mod=$(stat -c %y "$profile_path" 2>/dev/null | cut -d' ' -f1)
        
        [[ -f "$launcher" ]] && status="✅ Ready"
        
        local ext_dir="$profile_path/home/.local/share/Code/extensions"
        if [[ -d "$ext_dir" ]]; then
            ext_count=$(find "$ext_dir" -maxdepth 1 -type d | wc -l)
            ((ext_count--)) # Subtract the directory itself
        fi
        
        printf "%-20s %-10s %-15s %-10s %s\n" "$profile" "$status" "$size" "$ext_count" "$last_mod"
    done
    echo
}

# Backup profile
backup_profile() {
    local profile="${1:-}"
    
    if [[ -z "$profile" ]]; then
        profile=$(select_profile)
    fi
    
    local profile_path="$ISOLATION_ROOT/profiles/$profile"
    local backup_dir="$ISOLATION_ROOT/backups"
    local timestamp=$(date +%Y%m%d_%H%M%S)
    local backup_file="$backup_dir/${profile}_${timestamp}.tar.gz"
    
    if [[ ! -d "$profile_path" ]]; then
        log_error "Profile '$profile' does not exist"
        exit 1
    fi
    
    mkdir -p "$backup_dir"
    
    log_info "Creating backup of profile '$profile'..."
    
    if tar -czf "$backup_file" -C "$ISOLATION_ROOT/profiles" "$profile" 2>/dev/null; then
        log_success "Backup created: $backup_file"
        local size=$(du -sh "$backup_file" | cut -f1)
        echo -e "${BLUE}📦${NC} Backup size: $size"
    else
        log_error "Failed to create backup"
        exit 1
    fi
}

# Restore profile from backup
restore_profile() {
    local backup_dir="$ISOLATION_ROOT/backups"
    
    if [[ ! -d "$backup_dir" ]]; then
        log_error "No backups found"
        exit 1
    fi
    
    local backups=($(find "$backup_dir" -name "*.tar.gz" -printf "%f\n" 2>/dev/null | sort -r))
    
    if [[ ${#backups[@]} -eq 0 ]]; then
        log_error "No backup files found"
        exit 1
    fi
    
    echo -e "${CYAN}📦 Select backup to restore:${NC}"
    echo
    
    for i in "${!backups[@]}"; do
        local backup="${backups[$i]}"
        local size=$(du -sh "$backup_dir/$backup" 2>/dev/null | cut -f1)
        echo -e "  ${BLUE}$((i+1))${NC}) $backup ($size)"
    done
    
    echo
    read -p "Enter backup number (1-${#backups[@]}): " -r choice
    
    if [[ ! "$choice" =~ ^[0-9]+$ ]] || [[ "$choice" -lt 1 ]] || [[ "$choice" -gt "${#backups[@]}" ]]; then
        log_error "Invalid selection"
        exit 1
    fi
    
    local selected_backup="${backups[$((choice-1))]}"
    local profile_name=$(echo "$selected_backup" | sed 's/_[0-9]*_[0-9]*.tar.gz$//')
    
    echo -e "${YELLOW}⚠${NC} This will overwrite the existing profile '$profile_name' if it exists"
    read -p "Continue? (y/N): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        log_info "Restoring profile '$profile_name' from backup..."
        
        if tar -xzf "$backup_dir/$selected_backup" -C "$ISOLATION_ROOT/profiles" 2>/dev/null; then
            log_success "Profile '$profile_name' restored successfully"
            log_info "You may need to recreate the launcher with: $MAIN_SCRIPT $profile_name create"
        else
            log_error "Failed to restore backup"
            exit 1
        fi
    else
        log_info "Restore cancelled"
    fi
}

# Clone profile
clone_profile() {
    local source_profile="${1:-}"
    local target_profile="${2:-}"
    
    if [[ -z "$source_profile" ]]; then
        echo -e "${CYAN}Select source profile to clone:${NC}"
        source_profile=$(select_profile)
    fi
    
    if [[ -z "$target_profile" ]]; then
        read -p "Enter name for new profile: " -r target_profile
    fi
    
    if [[ -z "$target_profile" ]]; then
        log_error "Target profile name cannot be empty"
        exit 1
    fi
    
    local source_path="$ISOLATION_ROOT/profiles/$source_profile"
    local target_path="$ISOLATION_ROOT/profiles/$target_profile"
    
    if [[ ! -d "$source_path" ]]; then
        log_error "Source profile '$source_profile' does not exist"
        exit 1
    fi
    
    if [[ -d "$target_path" ]]; then
        log_error "Target profile '$target_profile' already exists"
        exit 1
    fi
    
    log_info "Cloning profile '$source_profile' to '$target_profile'..."
    
    if cp -r "$source_path" "$target_path" 2>/dev/null; then
        log_success "Profile cloned successfully"
        log_info "Creating launcher for new profile..."
        
        if "$MAIN_SCRIPT" "$target_profile" create >/dev/null 2>&1; then
            log_success "New profile '$target_profile' is ready to use"
        else
            log_warning "Profile cloned but launcher creation failed"
            log_info "Run: $MAIN_SCRIPT $target_profile create"
        fi
    else
        log_error "Failed to clone profile"
        exit 1
    fi
}

# Usage
usage() {
    cat << EOF
VS Code Profile Manager - Advanced utilities for isolated profiles

Usage: $0 <command> [arguments]

Commands:
    launch              Interactive profile launcher
    compare             Compare all profiles
    backup [profile]    Backup a profile (interactive if no profile specified)
    restore             Restore profile from backup (interactive)
    clone [source] [target]  Clone a profile (interactive if arguments missing)
    
Examples:
    $0 launch           # Interactive profile selection and launch
    $0 compare          # Show comparison table of all profiles
    $0 backup myproject # Backup specific profile
    $0 restore          # Interactive restore from backup
    $0 clone            # Interactive profile cloning

EOF
}

# Main
main() {
    local command="${1:-}"
    
    case "$command" in
        "launch")
            quick_launch
            ;;
        "compare")
            compare_profiles
            ;;
        "backup")
            backup_profile "${2:-}"
            ;;
        "restore")
            restore_profile
            ;;
        "clone")
            clone_profile "${2:-}" "${3:-}"
            ;;
        "")
            usage
            ;;
        *)
            log_error "Unknown command: $command"
            usage
            exit 1
            ;;
    esac
}

main "$@"
