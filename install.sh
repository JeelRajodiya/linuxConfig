#!/bin/bash

# Installation script for ubuntu

set -e

echo "Starting installation..."

# ----------------------------------------------------
# Update and Upgrade
# ----------------------------------------------------
sudo apt install -y software-properties-common
sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
sudo add-apt-repository -y ppa:neovim-ppa/unstable
sudo apt-get update
sudo apt-get full-upgrade -y

# ----------------------------------------------------
# Install packages from apt
# ----------------------------------------------------
sudo apt-get install -y \
    build-essential \
    procps \
    curl \
    file \
    git \
    eza \
    fastfetch \
    cmatrix \
    zsh \
    fzf \
    dconf-cli \
    tmux \
    bat \
    fd-find \
    ripgrep \
    unzip \
    wget \
    libssl-dev \
    net-tools \
    gnome-calculator \
    xournalpp \
    cheese \
    neovim \
    stow

# ----------------------------------------------------
# starship
# ----------------------------------------------------
curl -sS https://starship.rs/install.sh | sh -s -- -y

# ----------------------------------------------------
# Install nvm (Node Version Manager)
# ----------------------------------------------------
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
nvm install --lts

# ----------------------------------------------------
# Install Oh My Zsh
# ----------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi
git clone https://github.com/zsh-users/zsh-autosuggestions.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" || true
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" || true

# ----------------------------------------------------
# Install pnpm & Bun
# ----------------------------------------------------
npm i -g pnpm bun

# ----------------------------------------------------
# Install Pyenv
# ----------------------------------------------------
if [ ! -d "$HOME/.pyenv" ]; then
    curl -fsSL https://pyenv.run | bash
fi

# ----------------------------------------------------
# Install Go
# ----------------------------------------------------
sudo apt install -y golang
export PATH=$PATH:/usr/local/go/bin

# ----------------------------------------------------
# Install television (tv)
# ----------------------------------------------------
curl -fsSL https://alexpasmantier.github.io/television/install.sh | bash

# ----------------------------------------------------
# Install zoxide
# ----------------------------------------------------
curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

# ----------------------------------------------------
# Install yazi and dependencies
# ----------------------------------------------------
sudo apt install -y ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick
YAZI_VERSION=$(curl -s https://api.github.com/repos/sxyazi/yazi/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')
curl -L "https://github.com/sxyazi/yazi/releases/download/${YAZI_VERSION}/yazi-x86_64-unknown-linux-gnu.zip" -o yazi.zip
unzip yazi.zip
sudo cp yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
sudo cp yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/
rm -rf yazi.zip yazi-x86_64-unknown-linux-gnu

# ----------------------------------------------------
# Install Kitty
# ----------------------------------------------------
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

mkdir -p ~/.local/bin
ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
# ----------------------------------------------------

# ----------------------------------------------------
# Install Nerd Fonts
# ----------------------------------------------------
echo "Please install Nerd Fonts manually."
echo "You can download them from https://www.nerdfonts.com/font-downloads"
echo "and follow the instructions in the config_fonts/set.sh script."

echo "Installation finished."
echo "Please run the following scripts to set up the configuration files:"
echo "1. ./config_fonts/set.sh"
echo "2. ./config_gnome/config.sh"
echo "3. make stow"
