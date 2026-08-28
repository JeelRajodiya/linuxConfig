Personal configuration files and dotfiles repository. The `macos` branch contains macOS-specific configs, while `main` has the original Linux (KDE Neon / Plasma) setup.
Forked from [Codesmith28/archConfig](https://github.com/Codesmith28/archConfig) at [`cdca75b9f0bed1f009c752ff1c5fddbfe69cfb9b`](https://github.com/JeelRajodiya/linuxConfig/commits/main/?after=073f2a9e8ff1bab5237b70e13576650be662d56b+104)

## Setup

> **Warning:** `dotfiles/sync.sh` replaces existing configuration files with symlinks to this repository. Back up anything you want to keep first.

```bash
git clone https://github.com/JeelRajodiya/linuxConfig.git ~/linuxConfig
cd ~/linuxConfig

# Install packages and command-line tools (Linux or macOS)
bash install.sh

# Link the dotfiles into $HOME and ~/.config
bash dotfiles/sync.sh
```

On Linux, optionally install the Plasma plugins and configure fonts:

```bash
bash install_plasma_plugins.sh
bash setupScripts/config_fonts/set.sh
```

### Contents

- **Installation Scripts**:

  - `install.sh`: Main installation script.
  - `install_plasma_plugins.sh`: Script to install plugins for the Plasma desktop environment.

- **Dotfiles (`dotfiles/`)**: A collection of dotfiles for various applications and shells, including configurations for:

  - Fastfetch
  - Ghostty terminal (`ghostty/`)
  - K9s (`k9s/`)
  - KDE Plasma (`kdeglobals`, `kwinrc`, `plasmashellrc`, etc.)
  - Kitty terminal (`kitty/`)
  - Lazygit (`lazygit/`)
  - Neovim (`nvim/`)
  - Plasma (`plasma/`)
  - Starship prompt (`starship/`)
  - Television (`television/`)
  - Tmux (`tmux/`)
  - Yazi file manager (`yazi/`)

- **Setup Scripts (`setupScripts/`)**: Scripts for system setup and customization, such as:

  - `keys.sh`: For setting up GPG and SSH keys.
  - `set-docker.sh`: For setting up Docker.
  - `config_fonts/`: For configuring system fonts.
  - `configGrub/`: For configuring GRUB.
  - `fingerprint/`: For setting up fingerprint authentication.
  - `plasma/`: For configuring the Plasma desktop environment.
  - `serviceScripts/`: For setting up systemd services.

- **Scripts (`dotfiles/scripts`)**:

  - `auto_qalc.sh`: Script for automatic calculations using `qalc`.
  - `cycle-power-mode.sh`: Script for cycling through power profiles.
  - `save-clipboard-to-aws.sh`: Script for saving clipboard content to AWS.

- **Package Management**:
  - `manually_installed_packages.txt`: A list of packages that need to be installed manually.
