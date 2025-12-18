#!/bin/bash

# SEENAF_CTF VS Code Setup Script
# Run this script to set up the project in VS Code

echo "🚀 SEENAF_CTF VS Code Setup Script"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Node.js is installed
check_nodejs() {
    if command -v node &> /dev/null; then
        NODE_VERSION=$(node --version)
        print_status "Node.js is installed: $NODE_VERSION"
        
        # Check if version is 18 or higher
        MAJOR_VERSION=$(echo $NODE_VERSION | cut -d'.' -f1 | sed 's/v//')
        if [ "$MAJOR_VERSION" -ge 18 ]; then
            print_status "Node.js version is compatible"
        else
            print_warning "Node.js version should be 18 or higher"
            print_info "Consider upgrading: https://nodejs.org/"
        fi
    else
        print_error "Node.js is not installed"
        print_info "Install Node.js from: https://nodejs.org/"
        exit 1
    fi
}

# Check if npm is installed
check_npm() {
    if command -v npm &> /dev/null; then
        NPM_VERSION=$(npm --version)
        print_status "npm is installed: $NPM_VERSION"
    else
        print_error "npm is not installed"
        exit 1
    fi
}

# Check if VS Code is installed
check_vscode() {
    if command -v code &> /dev/null; then
        print_status "VS Code is installed"
    else
        print_warning "VS Code is not installed"
        print_info "Install VS Code from: https://code.visualstudio.com/"
        print_info "Or run: sudo apt install code"
    fi
}

# Create project directory
setup_project() {
    read -p "Enter project directory name (default: seenaf-ctf): " PROJECT_NAME
    PROJECT_NAME=${PROJECT_NAME:-seenaf-ctf}
    
    if [ -d "$HOME/$PROJECT_NAME" ]; then
        print_warning "Directory $HOME/$PROJECT_NAME already exists"
        read -p "Do you want to continue? (y/n): " CONTINUE
        if [ "$CONTINUE" != "y" ]; then
            exit 1
        fi
    fi
    
    print_info "Setting up project in $HOME/$PROJECT_NAME"
    
    # Copy current project files
    if [ -d "/home/kali/Downloads/SEENAF_CTF_CHALLENGE" ]; then
        cp -r "/home/kali/Downloads/SEENAF_CTF_CHALLENGE" "$HOME/$PROJECT_NAME"
        print_status "Project files copied"
    else
        print_warning "Source directory not found, creating new project structure"
        mkdir -p "$HOME/$PROJECT_NAME"
    fi
    
    cd "$HOME/$PROJECT_NAME"
}

# Install dependencies
install_dependencies() {
    print_info "Installing project dependencies..."
    
    if [ -f "package.json" ]; then
        npm install
        if [ $? -eq 0 ]; then
            print_status "Dependencies installed successfully"
        else
            print_error "Failed to install dependencies"
            print_info "Try running: npm cache clean --force && npm install"
        fi
    else
        print_warning "package.json not found, initializing new project"
        npm init -y
    fi
}

# Setup environment file
setup_environment() {
    if [ -f ".env.example" ]; then
        if [ ! -f ".env" ]; then
            cp .env.example .env
            print_status "Environment file created from .env.example"
        else
            print_warning ".env file already exists"
        fi
    else
        print_info "Creating .env file template"
        cat > .env << EOF
# Supabase Configuration
VITE_SUPABASE_PROJECT_ID=your_project_id
VITE_SUPABASE_PUBLISHABLE_KEY=your_anon_key
VITE_SUPABASE_URL=https://your-project.supabase.co
EOF
        print_status ".env template created"
    fi
    
    print_warning "Don't forget to update .env with your actual Supabase credentials!"
}

# Setup VS Code configuration
setup_vscode_config() {
    print_info "Setting up VS Code configuration..."
    
    mkdir -p .vscode
    
    # Create settings.json
    cat > .vscode/settings.json << 'EOF'
{
  "typescript.preferences.importModuleSpecifier": "relative",
  "editor.formatOnSave": true,
  "editor.defaultFormatter": "esbenp.prettier-vscode",
  "editor.codeActionsOnSave": {
    "source.fixAll.eslint": true
  },
  "tailwindCSS.includeLanguages": {
    "typescript": "typescript",
    "typescriptreact": "typescriptreact"
  },
  "files.associations": {
    "*.css": "tailwindcss"
  }
}
EOF

    # Create launch.json
    cat > .vscode/launch.json << 'EOF'
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": "Launch Chrome",
      "request": "launch",
      "type": "chrome",
      "url": "http://localhost:5173",
      "webRoot": "${workspaceFolder}/src"
    }
  ]
}
EOF

    print_status "VS Code configuration created"
}

# Install VS Code extensions
install_vscode_extensions() {
    if command -v code &> /dev/null; then
        print_info "Installing recommended VS Code extensions..."
        
        extensions=(
            "bradlc.vscode-tailwindcss"
            "esbenp.prettier-vscode"
            "ms-vscode.vscode-typescript-next"
            "formulahendry.auto-rename-tag"
            "christian-kohler.path-intellisense"
            "ms-vscode.vscode-json"
        )
        
        for ext in "${extensions[@]}"; do
            code --install-extension "$ext" --force
        done
        
        print_status "VS Code extensions installed"
    else
        print_warning "VS Code not found, skipping extension installation"
    fi
}

# Main setup function
main() {
    echo
    print_info "Starting SEENAF_CTF setup for VS Code..."
    echo
    
    # Check prerequisites
    check_nodejs
    check_npm
    check_vscode
    
    echo
    
    # Setup project
    setup_project
    install_dependencies
    setup_environment
    setup_vscode_config
    install_vscode_extensions
    
    echo
    print_status "Setup completed successfully! 🎉"
    echo
    print_info "Next steps:"
    echo "1. Update .env file with your Supabase credentials"
    echo "2. Run: npm run dev"
    echo "3. Open browser to: http://localhost:5173"
    echo "4. Set up your Supabase database using the SQL scripts"
    echo
    
    # Ask if user wants to open VS Code
    read -p "Do you want to open the project in VS Code now? (y/n): " OPEN_VSCODE
    if [ "$OPEN_VSCODE" = "y" ] && command -v code &> /dev/null; then
        code .
        print_status "VS Code opened with your project"
    fi
    
    # Ask if user wants to start dev server
    read -p "Do you want to start the development server now? (y/n): " START_DEV
    if [ "$START_DEV" = "y" ]; then
        print_info "Starting development server..."
        npm run dev
    fi
}

# Run main function
main