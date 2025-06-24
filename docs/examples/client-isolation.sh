#!/bin/bash

# VS Code Sandbox - Client Work Isolation Examples
# Demonstrates how to use VS Code Sandbox for complete client work separation

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🏢 VS Code Sandbox - Client Work Isolation${NC}"
echo "==========================================="
echo

echo -e "${PURPLE}Why Client Isolation Matters:${NC}"
echo "• Complete separation of client codebases and configurations"
echo "• No accidental cross-contamination of projects"
echo "• Different VS Code extensions per client"
echo "• Separate Git configurations and SSH keys"
echo "• Independent development environments"
echo "• Professional data security and privacy"
echo

# Example 1: Setting up client environments
echo -e "${GREEN}📋 Example 1: Setting Up Client Environments${NC}"
echo "============================================="
echo

cat << 'EOF'
# Create isolated environments for different clients
./vscode-isolate.sh acme-corp create
./vscode-isolate.sh globodyne-inc create
./vscode-isolate.sh startup-xyz create
./vscode-isolate.sh freelance-project-a create

# Each client gets:
# - Separate project directory
# - Independent VS Code settings
# - Isolated extensions
# - Custom Git configuration
# - Unique development environment
EOF

echo

# Example 2: Client-specific configurations
echo -e "${GREEN}⚙️ Example 2: Client-Specific Configurations${NC}"
echo "============================================"
echo

cat << 'EOF'
# After creating client profiles, you can customize each:

# For Client A (React/TypeScript focus)
./vscode-isolate.sh client-a launch
# Then install: React extensions, TypeScript, Prettier, ESLint

# For Client B (Python/Django focus)  
./vscode-isolate.sh client-b launch
# Then install: Python extensions, Django, Black formatter

# For Client C (DevOps focus)
./vscode-isolate.sh client-c launch
# Then install: Docker, Kubernetes, Terraform extensions
EOF

echo

# Example 3: Project lifecycle management
echo -e "${GREEN}🔄 Example 3: Project Lifecycle Management${NC}"
echo "=========================================="
echo

cat << 'EOF'
# Starting a new client project
./vscode-isolate.sh new-client-2024 create

# Working on the project
./vscode-isolate.sh new-client-2024 launch

# Regular backups during development
./vscode-profile-manager.sh backup new-client-2024

# Project completion - archive the environment
./vscode-profile-manager.sh backup new-client-2024
# Keep the backup, optionally remove the active profile
./vscode-isolate.sh new-client-2024 remove
EOF

echo

# Example 4: Multi-project client management
echo -e "${GREEN}🏗️ Example 4: Multi-Project Client Management${NC}"
echo "============================================="
echo

cat << 'EOF'
# Large client with multiple projects
./vscode-isolate.sh bigcorp-frontend create
./vscode-isolate.sh bigcorp-backend create
./vscode-isolate.sh bigcorp-mobile create
./vscode-isolate.sh bigcorp-devops create

# Clone base setup for similar projects
./vscode-profile-manager.sh clone bigcorp-frontend bigcorp-admin-panel
./vscode-profile-manager.sh clone bigcorp-backend bigcorp-api-v2
EOF

echo

# Example 5: Security and compliance
echo -e "${GREEN}🔒 Example 5: Security and Compliance${NC}"
echo "====================================="
echo

cat << 'EOF'
# High-security client isolation
./vscode-isolate.sh secure-client create

# Benefits for compliance:
# ✅ Complete filesystem isolation
# ✅ No shared configuration files
# ✅ Independent extension installations
# ✅ Separate Git credentials
# ✅ Isolated development history
# ✅ Clean removal without traces
EOF

echo

# Example 6: Client handover process
echo -e "${GREEN}🤝 Example 6: Client Handover Process${NC}"
echo "===================================="
echo

cat << 'EOF'
# Before project handover:
# 1. Create final backup
./vscode-profile-manager.sh backup client-project-final

# 2. Document the environment setup
./vscode-isolate.sh client-project status > client-environment-docs.txt

# 3. Export project files (they're in the isolated directory)
# Projects are in: ~/.vscode-isolated/profiles/client-project/projects/

# 4. Clean removal after handover
./vscode-isolate.sh client-project remove
EOF

echo

# Example 7: Emergency isolation
echo -e "${GREEN}🚨 Example 7: Emergency Isolation${NC}"
echo "================================"
echo

cat << 'EOF'
# If you need to quickly isolate a problematic project:
./vscode-isolate.sh quarantine-project create

# Move problematic code to isolated environment
# Work on fixes without affecting other projects
# Test solutions in complete isolation
EOF

echo

# Real-world workflow example
echo -e "${YELLOW}🌟 Real-World Client Workflow Example:${NC}"
echo

cat << 'EOF'
#!/bin/bash
# Daily client work routine

# Morning: Check available clients
./vscode-isolate.sh "" list

# Start work on Client A
./vscode-isolate.sh client-a launch

# Switch to Client B for afternoon work
./vscode-isolate.sh client-b launch

# End of week: Backup all active projects
for client in client-a client-b client-c; do
    ./vscode-profile-manager.sh backup "$client"
done

# Monthly cleanup: Remove completed projects
./vscode-isolate.sh completed-project-jan remove
EOF

echo

echo -e "${YELLOW}💼 Professional Benefits:${NC}"
echo "• Complete client data separation"
echo "• No accidental code mixing between clients"
echo "• Professional presentation (client-specific setups)"
echo "• Easy project archival and retrieval"
echo "• Compliance with data protection requirements"
echo "• Simplified billing and time tracking per client"
echo

echo -e "${BLUE}🔗 Best Practices:${NC}"
echo "1. Use clear, professional naming: 'client-company-project'"
echo "2. Regular backups before major milestones"
echo "3. Document client-specific requirements in profile"
echo "4. Clean removal after project completion"
echo "5. Keep archived backups for reference"
echo "6. Use status command to document environment setup"
