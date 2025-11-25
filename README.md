My linux configuration files and dotfiles repository. Suited for kde neon with plasma desktop environment.
Forked from [Codesmith28/archConfig](https://github.com/Codesmith28/archConfig) at [`cdca75b9f0bed1f009c752ff1c5fddbfe69cfb9b`](https://github.com/JeelRajodiya/linuxConfig/commits/main/?after=073f2a9e8ff1bab5237b70e13576650be662d56b+104)

This project contains personal configuration files and scripts for setting up a Linux environment.

### Contents

- **Installation Scripts**:

  - `install.sh`: Main installation script.
  - `install_plasma_plugins.sh`: Script to install plugins for the Plasma desktop environment.

- **Dotfiles (`dotfiles/`)**: A collection of dotfiles organized as [GNU Stow](https://www.gnu.org/software/stow/) packages.

  - KDE Plasma (`kde/`)
  - Fastfetch (`fastfetch/`)
  - fd (`fd/`)
  - Kitty terminal (`kitty/`)
  - Neovim (`nvim/`)
  - Starship prompt (`starship/`)
  - Television (`television/`)
  - Tmux (`tmux/`)
  - Yazi file manager (`yazi/`)
  - Shells (`bash/`, `zsh/`)

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

- **Package Management**:
  - `manually_installed_packages.txt`: A list of packages that need to be installed manually.

### Usage

1. Run `./install.sh` to install packages and dependencies.
2. Run `make stow` to create symlinks for your dotfiles.
