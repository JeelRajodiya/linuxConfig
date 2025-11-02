My linux configuration files and dotfiles repository. Suited for kde neon with plasma desktop environment.
Forked from [Codesmith28/archConfig](https://github.com/Codesmith28/archConfig) at [`cdca75b9f0bed1f009c752ff1c5fddbfe69cfb9b`](https://github.com/JeelRajodiya/linuxConfig/commits/main/?after=073f2a9e8ff1bab5237b70e13576650be662d56b+104)

This project contains personal configuration files and scripts for setting up a Linux environment.

### Contents

- **Installation Scripts**:

  - `install.sh`: Main installation script.
  - `install_plasma_plugins.sh`: Script to install plugins for the Plasma desktop environment.

- **Configuration Directories**:

  - `config_fonts/`: Configuration for system fonts.
  - `config_gnome/`: Settings specific to the GNOME desktop environment.
  - `config_kde/`: Settings specific to the KDE Plasma desktop environment.
  - `dotfiles/`: A collection of dotfiles for various applications and shells, including configurations for:
    - KDE Plasma (`kwinrc`, `plasmashellrc`, etc.)
    - Kitty terminal (`kitty.conf`)
    - Neovim (`nvim/`)
    - Starship prompt (`starship.toml`)
    - Fastfetch
    - Yazi file manager
    - Shells (`.bashrc`, `.zshrc`)

- **Scripts**:

  - `scripts/`: Miscellaneous helper scripts, including:
    - Scripts for managing battery limits.
  - `setupScripts/`: Scripts for system setup and customization, such as:
    - Configuring GRUB (`configGrub/`)
    - Customizing themes (`customizeTheme/`)
    - Setting up fingerprint authentication (`fingerprint/`)
    - Configuring the Plasma desktop environment (`plasma/`)
    - Setting up Docker (`set-docker.sh`)

- **Package Management**:

  - `packages/`: Scripts and desktop files for specific applications.
  - `manually_installed_packages.txt`: A list of packages that need to be installed manually.
