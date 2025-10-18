#!/bin/bash
# Neovim Setup Script
# This script sets up Neovim with your dotfiles configuration

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Neovim Setup Script ===${NC}\n"

# Check Neovim version
echo -e "${YELLOW}Checking Neovim installation...${NC}"
if ! command -v nvim &> /dev/null; then
    echo -e "${RED}Neovim is not installed!${NC}"
    echo "Please install Neovim v0.10.0 or higher first."
    echo "See SETUP.md for installation instructions."
    exit 1
fi

NVIM_VERSION=$(nvim --version | head -n1 | grep -oP 'v\K[0-9.]+')
echo -e "Found Neovim version: ${GREEN}$NVIM_VERSION${NC}"

# Check required dependencies
echo -e "\n${YELLOW}Checking dependencies...${NC}"

check_dependency() {
    if command -v $1 &> /dev/null; then
        echo -e "  ✓ $1 ${GREEN}found${NC}"
        return 0
    else
        echo -e "  ✗ $1 ${RED}not found${NC}"
        return 1
    fi
}

MISSING_DEPS=0
check_dependency git || MISSING_DEPS=1
check_dependency node || MISSING_DEPS=1
check_dependency npm || MISSING_DEPS=1
check_dependency rg || MISSING_DEPS=1

if [ $MISSING_DEPS -eq 1 ]; then
    echo -e "\n${YELLOW}Some dependencies are missing. Install them with:${NC}"
    echo "sudo apt install -y git nodejs npm ripgrep fd-find"
    read -p "Continue anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# Check Node.js version for Copilot
NODE_VERSION=$(node --version | grep -oP 'v\K[0-9]+')
if [ $NODE_VERSION -lt 18 ]; then
    echo -e "${YELLOW}Warning: Node.js version is < 18. Copilot requires Node.js 18+${NC}"
fi

# Backup existing config
echo -e "\n${YELLOW}Backing up existing Neovim configuration...${NC}"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

if [ -d ~/.config/nvim ]; then
    echo "  Moving ~/.config/nvim to ~/.config/nvim.backup.$TIMESTAMP"
    mv ~/.config/nvim ~/.config/nvim.backup.$TIMESTAMP
fi

if [ -d ~/.local/share/nvim ]; then
    echo "  Moving ~/.local/share/nvim to ~/.local/share/nvim.backup.$TIMESTAMP"
    mv ~/.local/share/nvim ~/.local/share/nvim.backup.$TIMESTAMP
fi

# Create symlink
echo -e "\n${YELLOW}Creating symbolic link...${NC}"
NVIM_CONFIG_DIR="$HOME/linuxConfig/ubuntu/dotfiles/nvim"

if [ ! -d "$NVIM_CONFIG_DIR" ]; then
    echo -e "${RED}Error: Config directory not found at $NVIM_CONFIG_DIR${NC}"
    exit 1
fi

ln -s "$NVIM_CONFIG_DIR" ~/.config/nvim
echo -e "  ✓ Linked ${GREEN}$NVIM_CONFIG_DIR${NC} -> ${GREEN}~/.config/nvim${NC}"

# Install plugins
echo -e "\n${YELLOW}Installing plugins (this may take a few minutes)...${NC}"
nvim --headless "+Lazy! sync" +qa

echo -e "\n${GREEN}=== Setup Complete! ===${NC}"
echo -e "\nNext steps:"
echo -e "  1. Start Neovim: ${GREEN}nvim${NC}"
echo -e "  2. Run health check: ${GREEN}:checkhealth${NC}"
echo -e "  3. Open Mason to install LSP servers: ${GREEN}:Mason${NC}"
echo -e "  4. Setup Copilot (if you have access): ${GREEN}:Copilot auth${NC}"
echo -e "\nFor more information, see: ${GREEN}~/.config/nvim/SETUP.md${NC}"
