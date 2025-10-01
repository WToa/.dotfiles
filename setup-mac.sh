#!/bin/bash

# macOS Development Environment Setup Script
# Installs: Homebrew, ZSH, Oh My Zsh, Powerlevel10k, Aerospace, WezTerm, Lazygit, Tig, Visual Studio Code

set -e  # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install Homebrew
install_homebrew() {
    if command_exists brew; then
        print_success "Homebrew is already installed"
    else
        print_status "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for Apple Silicon Macs
        if [[ $(uname -m) == "arm64" ]]; then
            echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
        
        print_success "Homebrew installed successfully"
    fi
}

# Install ZSH
install_zsh() {
    if command_exists zsh; then
        print_success "ZSH is already installed"
    else
        print_status "Installing ZSH..."
        brew install zsh
        print_success "ZSH installed successfully"
    fi
    
    # Set ZSH as default shell if it isn't already
    if [[ "$SHELL" != *"zsh"* ]]; then
        print_status "Setting ZSH as default shell..."
        chsh -s $(which zsh)
        print_success "ZSH set as default shell"
    fi
}

# Install Oh My Zsh
install_oh_my_zsh() {
    if [[ -d "$HOME/.oh-my-zsh" ]]; then
        print_success "Oh My Zsh is already installed"
    else
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        print_success "Oh My Zsh installed successfully"
    fi
}

# Install Powerlevel10k
install_powerlevel10k() {
    local p10k_dir="$HOME/.oh-my-zsh/custom/themes/powerlevel10k"
    
    if [[ -d "$p10k_dir" ]]; then
        print_success "Powerlevel10k is already installed"
    else
        print_status "Installing Powerlevel10k..."
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$p10k_dir"
        print_success "Powerlevel10k installed successfully"
        print_warning "Remember to set ZSH_THEME=\"powerlevel10k/powerlevel10k\" in your ~/.zshrc"
    fi
}

# Install zsh-autosuggestions plugin
install_zsh_autosuggestions() {
    local plugin_dir="$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    
    if [[ -d "$plugin_dir" ]]; then
        print_success "zsh-autosuggestions is already installed"
    else
        print_status "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$plugin_dir"
        print_success "zsh-autosuggestions installed successfully"
    fi
}

# Install Aerospace
install_aerospace() {
    if command_exists aerospace; then
        print_success "Aerospace is already installed"
    else
        print_status "Installing Aerospace..."
        brew install --cask nikitabobko/tap/aerospace
        print_success "Aerospace installed successfully"
    fi
}

# Install WezTerm
install_wezterm() {
    if command_exists wezterm; then
        print_success "WezTerm is already installed"
    else
        print_status "Installing WezTerm..."
        brew install --cask wezterm
        print_success "WezTerm installed successfully"
    fi
}

# Install Lazygit
install_lazygit() {
    if command_exists lazygit; then
        print_success "Lazygit is already installed"
    else
        print_status "Installing Lazygit..."
        brew install lazygit
        print_success "Lazygit installed successfully"
    fi
}

# Install Tig
install_tig() {
    if command_exists tig; then
        print_success "Tig is already installed"
    else
        print_status "Installing Tig..."
        brew install tig
        print_success "Tig installed successfully"
    fi
}

# Install fzf
install_fzf() {
    if command_exists fzf; then
        print_success "fzf is already installed"
    else
        print_status "Installing fzf..."
        brew install fzf
        print_success "fzf installed successfully"
    fi
}

# Install eza
install_eza() {
    if command_exists eza; then
        print_success "eza is already installed"
    else
        print_status "Installing eza..."
        brew install eza
        print_success "eza installed successfully"
    fi
}

# Install zoxide
install_zoxide() {
    if command_exists zoxide; then
        print_success "zoxide is already installed"
    else
        print_status "Installing zoxide..."
        brew install zoxide
        print_success "zoxide installed successfully"
    fi
}

# Setup aliases
setup_aliases() {
    print_status "Setting up aliases..."
    
    # Add aliases to ~/.zshrc if not already present
    if ! grep -q "alias ls='eza'" ~/.zshrc; then
        echo "alias ls='eza'" >> ~/.zshrc
    fi
    
    if ! grep -q "alias cd='z'" ~/.zshrc; then
        echo "alias cd='z'" >> ~/.zshrc
    fi
    
    # Initialize zoxide in ~/.zshrc if not present
    if ! grep -q "eval \"\$(zoxide init zsh)\"" ~/.zshrc; then
        echo "eval \"\$(zoxide init zsh)\"" >> ~/.zshrc
    fi
    
    print_success "Aliases set up successfully"
}

# Main installation function
main() {
    print_status "Starting macOS Development Environment Setup..."
    
    # Check if running on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "This script is designed for macOS only"
        exit 1
    fi
    
    # Install everything in order
    install_homebrew
    install_zsh
    install_oh_my_zsh
    install_powerlevel10k
    install_zsh_autosuggestions
    install_aerospace
    install_wezterm
    install_lazygit
    install_tig
    install_fzf
    install_eza
    install_zoxide
    setup_aliases
    
    print_success "All installations completed!"
    print_warning "Please restart your terminal or run 'source ~/.zshrc' to apply changes"
    print_warning "Run 'p10k configure' to configure Powerlevel10k theme"
}

# Run the main function
main "$@"