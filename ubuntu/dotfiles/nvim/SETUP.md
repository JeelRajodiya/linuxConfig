# Neovim Setup Guide

## Prerequisites

### 1. Install Neovim (v0.10.0 or higher required)
```bash
# Check current version
nvim --version

# If version is too old, install latest stable:
# Option 1: Using AppImage (recommended)
curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

# Option 2: Using PPA (Ubuntu/Debian)
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update
sudo apt install neovim

# Option 3: Build from source
# See: https://github.com/neovim/neovim/wiki/Building-Neovim
```

### 2. Install Required Dependencies
```bash
# Essential tools
sudo apt update
sudo apt install -y \
    git \
    curl \
    nodejs \
    npm \
    ripgrep \
    fd-find \
    python3 \
    python3-pip \
    build-essential

# Node.js version 18+ required for Copilot
node --version  # Should be v18.0.0 or higher

# If Node is too old, install latest:
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### 3. Install Optional but Recommended Tools
```bash
# For better code formatting and linting
sudo apt install -y \
    shellcheck \
    clang-format \
    black \
    prettier

# Nerd Fonts (for icons)
# Download and install a Nerd Font from: https://www.nerdfonts.com/
# Recommended: JetBrainsMono Nerd Font, FiraCode Nerd Font
```

## Installation Steps

### 1. Backup Existing Config (if any)
```bash
# Backup old config
[ -d ~/.config/nvim ] && mv ~/.config/nvim ~/.config/nvim.backup
[ -d ~/.local/share/nvim ] && mv ~/.local/share/nvim ~/.local/share/nvim.backup
[ -d ~/.local/state/nvim ] && mv ~/.local/state/nvim ~/.local/state/nvim.backup
[ -d ~/.cache/nvim ] && mv ~/.cache/nvim ~/.cache/nvim.backup
```

### 2. Link/Copy Your Config
```bash
# Option A: Create symbolic link (recommended for dotfiles repo)
ln -s ~/linuxConfig/ubuntu/dotfiles/nvim ~/.config/nvim

# Option B: Copy files
cp -r ~/linuxConfig/ubuntu/dotfiles/nvim ~/.config/nvim
```

### 3. First Launch
```bash
# Start Neovim - it will automatically:
# 1. Install lazy.nvim plugin manager
# 2. Install all plugins listed in lazy-lock.json
# 3. Setup LSP servers via Mason
nvim

# Or force plugin installation:
nvim +Lazy sync +qa
```

### 4. Post-Installation Setup

#### Setup GitHub Copilot (if you have access)
```bash
# In Neovim, run:
:Copilot auth
```

#### Install LSP Servers
```bash
# In Neovim, open Mason:
:Mason

# Common LSP servers to install:
# - lua_ls (Lua)
# - pyright or pylsp (Python)
# - tsserver (JavaScript/TypeScript)
# - gopls (Go)
# - rust_analyzer (Rust)
# - clangd (C/C++)
```

## Troubleshooting

### Plugin Installation Fails
```bash
# Clear cache and reinstall
rm -rf ~/.local/share/nvim/lazy
nvim +Lazy sync
```

### Copilot Clone Failed
```bash
# Remove corrupted directory
rm -rf ~/.local/share/nvim/lazy/copilot.lua
# Restart Neovim to retry installation
nvim
```

### LSP Not Working
```bash
# Check LSP status
:LspInfo

# Check Mason installations
:Mason

# Reinstall LSP server
:MasonUninstall <server>
:MasonInstall <server>
```

### TreeSitter Parsers Not Installing
```bash
# Install manually in Neovim
:TSInstall lua python javascript typescript rust go cpp

# Or install all maintained parsers
:TSInstall all
```

### Performance Issues
```bash
# Check startup time
nvim --startuptime startup.log
cat startup.log

# Disable unused plugins in lua/config/lazy.lua
```

## Health Check
```bash
# Run Neovim health check
nvim +checkhealth
```

## Updating

### Update All Plugins
```bash
# In Neovim:
:Lazy update
```

### Update LSP Servers
```bash
# In Neovim:
:MasonUpdate
```

## Directory Structure
```
~/.config/nvim/           # Your config (symlinked or copied)
~/.local/share/nvim/      # Plugin data
├── lazy/                 # Installed plugins
└── mason/                # LSP servers, formatters, linters

~/.local/state/nvim/      # State files
~/.cache/nvim/            # Cache files
```

## Quick Commands Reference

| Command | Description |
|---------|-------------|
| `:Lazy` | Open plugin manager |
| `:Lazy sync` | Install/update plugins |
| `:Mason` | Open LSP/tool installer |
| `:checkhealth` | Check Neovim health |
| `:LspInfo` | Show LSP status |
| `:TSUpdate` | Update TreeSitter parsers |
| `:Copilot auth` | Authenticate GitHub Copilot |

## Configuration Files

- `init.lua` - Entry point
- `lua/config/lazy.lua` - Plugin manager setup
- `lua/config/options.lua` - Neovim options
- `lua/config/keymaps.lua` - Key mappings
- `lua/config/autocmds.lua` - Auto commands
- `lua/plugins/*.lua` - Individual plugin configs

## Need Help?

1. Check `:checkhealth` first
2. Read plugin documentation
3. Check LazyVim docs: https://lazyvim.org
4. Check lazy.nvim docs: https://github.com/folke/lazy.nvim
