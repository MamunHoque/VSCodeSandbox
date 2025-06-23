#!/bin/bash

# VS Code Sandbox - Development Environment Setup Examples
# Shows how to set up different development environments using VS Code Sandbox

set -euo pipefail

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}🛠️ VS Code Sandbox - Development Environment Setup${NC}"
echo "=================================================="
echo

# Function to create and setup a development profile
setup_dev_profile() {
    local profile_name="$1"
    local description="$2"
    
    echo -e "${GREEN}Setting up: $profile_name${NC}"
    echo "Description: $description"
    echo "Command: ./vscode-isolate.sh $profile_name create"
    echo
}

# Example 1: Frontend Development Environment
echo -e "${PURPLE}🎨 Frontend Development Environments${NC}"
echo "======================================"
setup_dev_profile "react-frontend" "React.js frontend development with modern tooling"
setup_dev_profile "vue-frontend" "Vue.js frontend development environment"
setup_dev_profile "angular-frontend" "Angular frontend development setup"
setup_dev_profile "vanilla-js" "Pure JavaScript/HTML/CSS development"
echo

# Example 2: Backend Development Environment
echo -e "${PURPLE}⚙️ Backend Development Environments${NC}"
echo "====================================="
setup_dev_profile "nodejs-backend" "Node.js backend API development"
setup_dev_profile "python-django" "Django web framework development"
setup_dev_profile "python-flask" "Flask microframework development"
setup_dev_profile "rust-backend" "Rust backend development with Actix/Warp"
setup_dev_profile "go-backend" "Go backend development environment"
echo

# Example 3: Data Science & ML Environment
echo -e "${PURPLE}📊 Data Science & Machine Learning${NC}"
echo "=================================="
setup_dev_profile "python-ml" "Python machine learning with Jupyter integration"
setup_dev_profile "r-analytics" "R statistical analysis environment"
setup_dev_profile "data-science" "Multi-language data science environment"
echo

# Example 4: Mobile Development Environment
echo -e "${PURPLE}📱 Mobile Development${NC}"
echo "===================="
setup_dev_profile "react-native" "React Native mobile development"
setup_dev_profile "flutter-dev" "Flutter mobile development environment"
setup_dev_profile "ionic-dev" "Ionic hybrid mobile development"
echo

# Example 5: DevOps & Infrastructure
echo -e "${PURPLE}🔧 DevOps & Infrastructure${NC}"
echo "=========================="
setup_dev_profile "terraform-infra" "Terraform infrastructure as code"
setup_dev_profile "ansible-config" "Ansible configuration management"
setup_dev_profile "kubernetes-dev" "Kubernetes development and deployment"
setup_dev_profile "docker-dev" "Docker containerization development"
echo

# Example 6: Client-Specific Environments
echo -e "${PURPLE}👥 Client-Specific Environments${NC}"
echo "==============================="
setup_dev_profile "client-alpha" "Client Alpha project isolation"
setup_dev_profile "client-beta" "Client Beta project isolation"
setup_dev_profile "freelance-project1" "Freelance project #1"
setup_dev_profile "consulting-work" "Consulting work environment"
echo

# Example 7: Experimental & Learning
echo -e "${PURPLE}🧪 Experimental & Learning${NC}"
echo "=========================="
setup_dev_profile "experimental" "Testing new technologies and frameworks"
setup_dev_profile "learning-rust" "Learning Rust programming language"
setup_dev_profile "learning-go" "Learning Go programming language"
setup_dev_profile "plugin-testing" "VS Code extension development and testing"
echo

# Advanced setup script example
echo -e "${YELLOW}🚀 Advanced Setup Script Example:${NC}"
cat << 'EOF'

#!/bin/bash
# Advanced development environment setup

# Create multiple related profiles
./vscode-isolate.sh myproject-frontend create
./vscode-isolate.sh myproject-backend create
./vscode-isolate.sh myproject-mobile create

# Clone a base profile for variations
./vscode-profile-manager.sh clone python-base python-web
./vscode-profile-manager.sh clone python-base python-ml

# Backup important profiles
./vscode-profile-manager.sh backup production-client
./vscode-profile-manager.sh backup main-project

# Compare development environments
./vscode-profile-manager.sh compare

EOF

echo
echo -e "${YELLOW}💡 Pro Tips:${NC}"
echo "• Use consistent naming conventions (e.g., 'project-component', 'client-type')"
echo "• Create base profiles and clone them for similar projects"
echo "• Regularly backup important profiles before major changes"
echo "• Use descriptive names that indicate the technology stack"
echo "• Consider creating profiles for different project phases (dev, staging, prod)"
echo

echo -e "${BLUE}🔗 Workflow Examples:${NC}"
echo "1. Morning routine: ./vscode-profile-manager.sh launch (select today's project)"
echo "2. Client switch: ./vscode-isolate.sh client-new launch"
echo "3. Experiment safely: ./vscode-isolate.sh experiment-$(date +%Y%m%d) create"
echo "4. Archive completed: ./vscode-profile-manager.sh backup completed-project"
echo "5. Clean workspace: ./vscode-isolate.sh old-project remove"
