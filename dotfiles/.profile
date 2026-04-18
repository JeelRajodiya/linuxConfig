#    _ __  _ __ ___  / _(_) | ___
#   | '_ \| '__/ _ \| |_| | |/ _ \
#  _| |_) | | | (_) |  _| | |  __/
# (_) .__/|_|  \___/|_| |_|_|\___|
#   |_|

# -----------------------------------------------------
# PATH and environment variables (portable across shells)
# -----------------------------------------------------

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# NVM
export NVM_DIR="$HOME/.nvm"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# Go
export PATH="$PATH:$(go env GOPATH 2>/dev/null)/bin"

# SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"

# Java
export PATH="$PATH:$JAVA_HOME/bin"

# ripgrep config path
export RIPGREP_CONFIG_PATH="$HOME/.config/.ripgreprc"

# General PATH additions
export PATH="/usr/local/bin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/opt/sqlite/bin:$PATH"

# GitHub token for Claude Code (pulled from gh CLI auth)
if command -v gh >/dev/null 2>&1; then
    export GITHUB_PERSONAL_ACCESS_TOKEN="$(gh auth token 2>/dev/null)"
fi

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
PS1='[\u@\h \W]\$ '

# Define Editor
export EDITOR=nvim
export BROWSER=google-chrome-stable

# alias code='code --enable-features=UseOzonePlatform --ozone-platform=wayland'
alias ltspice='ltspice --enable-features=UseOzonePlatform --ozone-platform=wayland'
alias res_idle='~/dotfiles/hypr/scripts/restart-hypridle.sh'
alias cursor='/opt/cursor.appimage --no-sandbox >/dev/null 2>&1 & disown'

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------
alias cpwd="pwd | tr -d '\n' | xclip -sel clip && echo 'pwd copied to clipboard'"
alias c='clear'
alias e='exit'
alias q='exit'
alias nf='neofetch'
alias pf='pfetch'
alias ff='fastfetch'
alias cf='c && fastfetch'
alias ls='eza  --icons'
alias ll='eza -l --icons'
alias la='eza -a --icons'
alias lla='eza -al --icons'
lt() {
    local level=${1:-1}
    eza -a --tree --level="$level" --icons
}
alias shutdown='systemctl poweroff'
alias v='$EDITOR'
# alias vim='$EDITOR'
alias ts='~/dotfiles/scripts/snapshot.sh'
alias matrix='cmatrix -u 2'
alias wifi='nmtui'
alias od='~/private/onedrive.sh'
alias tw='~/dotfiles/waybar/toggle.sh'
alias winclass="xprop | grep 'CLASS'"
alias dot="cd ~/.config"
alias hypr="cd ~/dotfiles/hypr"
alias cleanup='~/dotfiles/scripts/cleanup.sh'
alias ml4w='~/dotfiles/apps/ML4W_Welcome-x86_64.AppImage'
alias copy='xclip -selection clipboard'
alias bat='bat --theme=base16'
alias fd='fd --hidden'
alias update_all='sudo apt update && sudo apt full-upgrade'

alias sz='source ~/.zshrc'
alias source_venv='source venv/bin/activate'
alias prime-run='env __NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia'
alias h='history'
alias hg='history | rg'

# -----------------------------------------------------
# GIT
# -----------------------------------------------------

alias gs="git status"
alias ga="git add"
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gst="git stash"
alias gsp="git stash; git pull"
alias lg='lazygit'
alias gcheck="git checkout"
alias glog="git log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(auto)%d%C(reset)' --all"
ghcs() {
    gh copilot suggest "$1"
}

# -----------------------------------------------------
# EDIT CONFIG FILES
# -----------------------------------------------------

alias confq='$EDITOR ~/dotfiles/qtile/config.py'
alias confp='$EDITOR ~/.profile'
alias confb='$EDITOR ~/.bashrc'
alias confz='$EDITOR ~/.zshrc'
alias confn='$EDITOR ~/.config/nvim'

# -----------------------------------------------------
# EDIT NOTES
# -----------------------------------------------------

alias rough='$EDITOR ~/OneDrive/OneDrive\ Documents/notes/rough.md'
alias notes='cd ~/OneDrive/OneDrive\ Documents/notes && zed .'
alias notes-path='cd ~/OneDrive/OneDrive\ Documents/notes'
alias general='$EDITOR ~/OneDrive/OneDrive\ Documents/general.md'
alias bookmarks='$EDITOR ~/OneDrive/OneDrive\ Documentsbookmarks.md'

# -----------------------------------------------------
# SYSTEM
# -----------------------------------------------------

alias update-grub='sudo grub-mkconfig -o /boot/grub/grub.cfg'
alias setkb='setxkbmap us;echo "Keyboard set back to us."'
# mntd() {
#     command -v ntfs-3g >/dev/null 2>&1 || {
#         echo >&2 "ntfs-3g is not installed. Installing..."
#         yay -S ntfs-3g
#     }
#     [ -d "/media/zeel/D" ] || mkdir -p /media/zeel/D
#     sudo mount /dev/nvme0n1p4 /home/run/media/localdiskD && echo "Disk successfully mounted at /home/run/media/localdiskD"
# }
alias D='cd /media/zeel/D'
fixD() {
    sudo umount /media/zeel/D && echo "Disk unmounted."
}
alias battery='upower -i /org/freedesktop/UPower/devices/battery_BAT0 | cat'
# alias netrs='sudo systemctl restart NetworkManager && sudo systemctl restart iwd'
netrs() {
    sudo systemctl restart NetworkManager && echo "NetworkManager restarted."
    # sudo systemctl restart iwd && echo "iwd restarted."
}

# -----------------------------------------------------
# STARSHIP export
# -----------------------------------------------------

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"

# -----------------------------------------------------
# DOCKER
# -----------------------------------------------------

export DOCKER_HOST=unix:///var/run/docker.sock

# Set blinking underline cursor (only when not in Neovim)
if [ "$TERM" = "xterm-256color" ] && [ -z "$VIM" ]; then
    echo -ne '\e[3 q'
fi

alias pj='cd "/media/zeel/Local Disc 1/languages"'
alias thunar='setsid thunar'
alias files='setsid $BROWSER'
alias obsidian='setsid obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland'
alias obsi='setsid obsidian --enable-features=UseOzonePlatform --ozone-platform=wayland && exit -f'
alias fzf='fzf --preview="bat --theme=base16 -n  --color=always --style=header,grid --line-range :500 {}"'
# alias ivm='$EDITOR $(fzf -m --preview="bat --color=always --style=header,grid --line-range :500 {}")'
alias ivm='f() { local file; file=$(tv); [ -n "$file" ] && "$EDITOR" "$file"; }; f'


# -----------------------------------------------------
# Yazi file manager exit on quit:
# -----------------------------------------------------

function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
        builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}



#   -----------------------------------------------------
#   GEMINI api Key
#   -----------------------------------------------------
# Load only GEMINI_API_KEY from .env, without leaking other variables
if [ -f "$HOME/.env" ]; then
    export GEMINI_API_KEY="$(grep '^GEMINI_API_KEY=' "$HOME/.env" | cut -d '=' -f2- | sed 's/^"//;s/"$//')"
fi
. "$HOME/.cargo/env"

#  -----------------------------------------------------
#  fix kitty on ssh
#  -----------------------------------------------------

[ "$TERM" = "xterm-kitty" ] && export TERM=xterm-256color

# -----------------------------------------------------
# Run commands from history
# hrun storage <- this will grep from the last comamnd that contains the word storage and run it.
# it has another optional argument hrun storate [index from tail, default is first index]
# # -----------------------------------------------------
hrun() {
    local pattern="$1"
    local n="${2:-1}"
    eval "$(history | rg "$pattern" | rg -v 'hrun|hpeek|hg|^[ 0-9]*cd ' | tail -"$n" | head -1 | sed 's/^ *[0-9]* *//')"
}
# -----------------------------------------------------
# peak commands from history
# # -----------------------------------------------------

hpeek() {
    local pattern="$1"
    local n="${2:-1}"
    history | rg "$pattern" | rg -v 'hrun|hpeek|hg|^[ 0-9]*cd ' | tail -"$n" | head -1 | sed 's/^ *[0-9]* *//'
}
