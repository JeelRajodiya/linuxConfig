#!/bin/bash

# Installation script

set -e

OS="$(uname)"
echo "Starting installation on $OS..."

# ----------------------------------------------------
# Update and Upgrade
# ----------------------------------------------------
if [ "$OS" = "Linux" ]; then
    sudo apt install software-properties-common
    sudo add-apt-repository ppa:zhangsongcui3371/fastfetch
    sudo apt-get update
    sudo apt-get full-upgrade -y
elif [ "$OS" = "Darwin" ]; then
    if ! command -v brew &> /dev/null; then
        echo "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew update
    brew upgrade
fi

# ----------------------------------------------------
# Install packages
# ----------------------------------------------------
if [ "$OS" = "Linux" ]; then
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
        cheese

    # On Debian/Ubuntu, bat and fd are installed as batcat and fdfind
    # Create symlinks so they can be referenced as bat and fd everywhere
    [ -f /usr/bin/batcat ] && sudo ln -sf /usr/bin/batcat /usr/local/bin/bat
    [ -f /usr/bin/fdfind ] && sudo ln -sf /usr/bin/fdfind /usr/local/bin/fd
elif [ "$OS" = "Darwin" ]; then
    brew install \
        curl \
        git \
        eza \
        fastfetch \
        cmatrix \
        zsh \
        fzf \
        tmux \
        bat \
        fd \
        ripgrep \
        unzip \
        wget \
        openssl

    brew install --cask xournal++
fi

# ----------------------------------------------------
# Install TPM (Tmux Plugin Manager)
# ----------------------------------------------------
if [ ! -d "$HOME/.config/tmux/plugins/tpm" ]; then
    echo "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.config/tmux/plugins/tpm"
fi

# ----------------------------------------------------
# starship
# ----------------------------------------------------
if [ "$OS" = "Linux" ]; then
    curl -sS https://starship.rs/install.sh | sh
elif [ "$OS" = "Darwin" ]; then
    brew install starship
fi

# ----------------------------------------------------
# Install nvm (Node Version Manager)
# ----------------------------------------------------
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

# ----------------------------------------------------
# Install Oh My Zsh
# ----------------------------------------------------
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" "" --unattended
fi

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# ----------------------------------------------------
# Install pnpm
# ----------------------------------------------------
# ----------------------------------------------------
# Install Bun
# ----------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if command -v nvm &> /dev/null; then
    nvm install node
    npm i -g pnpm bun
else
    echo "NVM failed to install or load. Skipping npm packages."
fi

# ----------------------------------------------------
# Install Pyenv
# ----------------------------------------------------
if [ "$OS" = "Linux" ]; then
    curl -fsSL https://pyenv.run | bash
elif [ "$OS" = "Darwin" ]; then
    brew install pyenv pyenv-virtualenv
fi

# ----------------------------------------------------
# Install Rust (Cargo)
# ----------------------------------------------------
if ! command -v cargo &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

# ----------------------------------------------------
# Install Go
# ----------------------------------------------------
if [ "$OS" = "Linux" ]; then
    sudo apt install golang
    export PATH=$PATH:/usr/local/go/bin
elif [ "$OS" = "Darwin" ]; then
    brew install go
fi

# ----------------------------------------------------
# Install television (tv)
# ----------------------------------------------------
if [ "$OS" = "Linux" ]; then
    curl -fsSL https://alexpasmantier.github.io/television/install.sh | bash
elif [ "$OS" = "Darwin" ]; then
    # Check if cargo is available to install tv, or use prebuilt binary if available
    # The install script might work on mac, but let's try to be safe or use cargo if available
    if command -v cargo &> /dev/null; then
        cargo install television
    else
        curl -fsSL https://alexpasmantier.github.io/television/install.sh | bash
    fi
fi

# ----------------------------------------------------
# Install atuin (shell history, replaces ctrl+r)
# ----------------------------------------------------
if [ "$OS" = "Linux" ]; then
    curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
elif [ "$OS" = "Darwin" ]; then
    brew install atuin
fi

# Import existing shell history into atuin's SQLite DB (idempotent — skips if already imported)
if command -v atuin &> /dev/null; then
    atuin import auto || true
fi

# ----------------------------------------------------
# Install zoxide
# ----------------------------------------------------
if [ "$OS" = "Linux" ]; then
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh
elif [ "$OS" = "Darwin" ]; then
    brew install zoxide
fi

# ----------------------------------------------------
# Install yazi and dependencies
# ----------------------------------------------------
# glow is required by the glow.yazi previewer plugin (configured in
# ~/.config/yazi/yazi.toml) to render markdown files in the preview pane.
# Without the glow binary on $PATH, yazi's markdown preview silently fails.
if [ "$OS" = "Linux" ]; then
    sudo apt install ffmpeg 7zip jq poppler-utils fd-find ripgrep fzf zoxide imagemagick glow
    unzip ./packages/yazi-x86_64-unknown-linux-gnu.zip -d ./packages/yazi-x86_64-unknown-linux-gnu
    sudo cp ./packages/yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
    sudo cp ./packages/yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/
elif [ "$OS" = "Darwin" ]; then
    brew install yazi ffmpeg sevenzip jq poppler imagemagick zoxide glow
fi

# ----------------------------------------------------
# Install Kitty
# ----------------------------------------------------
if [ "$OS" = "Linux" ]; then
    curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

    mkdir -p ~/.local/bin
    ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.local/bin/
elif [ "$OS" = "Darwin" ]; then
    brew install --cask kitty
fi
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
echo "3. ./dotfiles/sync.sh"
