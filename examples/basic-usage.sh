#!/bin/bash

# VS Code Sandbox - Basic Usage Examples
# Demonstrates common usage patterns for VS Code Sandbox

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${BLUE}🚀 VS Code Sandbox - Basic Usage Examples${NC}"
echo "=============================================="
echo

# Example 1: Create a simple project profile
echo -e "${GREEN}Example 1: Creating a simple project profile${NC}"
echo "Command: ./vscode-isolate.sh my-web-project create"
echo "This creates a completely isolated VS Code environment for your web project"
echo

# Example 2: Launch an existing profile
echo -e "${GREEN}Example 2: Launching an existing profile${NC}"
echo "Command: ./vscode-isolate.sh my-web-project launch"
echo "This launches the isolated VS Code environment for your project"
echo

# Example 3: List all profiles
echo -e "${GREEN}Example 3: List all profiles${NC}"
echo "Command: ./vscode-isolate.sh \"\" list"
echo "This shows all your isolated VS Code profiles and their status"
echo

# Example 4: Remove a profile
echo -e "${GREEN}Example 4: Remove a profile${NC}"
echo "Command: ./vscode-isolate.sh my-web-project remove"
echo "This completely removes the isolated profile (with confirmation)"
echo

# Example 5: Interactive profile management
echo -e "${GREEN}Example 5: Interactive profile management${NC}"
echo "Command: ./vscode-profile-manager.sh launch"
echo "This opens an interactive menu to select and launch profiles"
echo

# Example 6: Compare profiles
echo -e "${GREEN}Example 6: Compare profiles${NC}"
echo "Command: ./vscode-profile-manager.sh compare"
echo "This shows a comparison table of all your profiles"
echo

# Example 7: Backup a profile
echo -e "${GREEN}Example 7: Backup a profile${NC}"
echo "Command: ./vscode-profile-manager.sh backup my-web-project"
echo "This creates a backup of your profile that can be restored later"
echo

# Example 8: Clone a profile
echo -e "${GREEN}Example 8: Clone a profile${NC}"
echo "Command: ./vscode-profile-manager.sh clone my-web-project my-web-project-v2"
echo "This creates an exact copy of an existing profile"
echo

echo -e "${YELLOW}💡 Tips:${NC}"
echo "• Each profile is completely isolated - no shared settings or extensions"
echo "• Profiles don't interfere with your existing VS Code installation"
echo "• You can have unlimited profiles for different projects or clients"
echo "• Use descriptive names for profiles (e.g., 'client-alpha', 'python-ml', 'react-frontend')"
echo "• Profiles include their own project directories, settings, and extensions"
echo

echo -e "${BLUE}🔗 Next Steps:${NC}"
echo "1. Try creating your first profile: ./vscode-isolate.sh test-profile create"
echo "2. Explore the profile manager: ./vscode-profile-manager.sh launch"
echo "3. Run the test suite: ./vscode-isolation-test.sh"
echo "4. Check out development-setup.sh for advanced examples"
