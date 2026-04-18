# =====================================================
# Oh My Zsh configuration
# =====================================================
export ZSH="$HOME/.oh-my-zsh"
# plugins=(git ssh-agent zsh-autosuggestions zsh-syntax-highlighting)
plugins=(git fzf-tab zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# -----------------------------------------------------
# User configuration
# -----------------------------------------------------
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# =====================================================
# Shell options
# =====================================================
setopt sharehistory

# =====================================================
# Completion system
# =====================================================

# Completion styling (used by fzf-tab when present, otherwise native compsys)
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'

# Include hidden files in completion (scoped to compsys; does not affect glob expansions)
_comp_options+=(globdots)

# =====================================================
# Prompt
# =====================================================
eval "$(starship init zsh)"

# =====================================================
# Tool integrations
# =====================================================

# -----------------------------------------------------
# FZF support
# -----------------------------------------------------
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# -----------------------------------------------------
# Television support:
# ctrl + r -> shell history
# ctrl + t -> smart autocompletion
# -----------------------------------------------------
eval "$(tv init zsh)"

# -----------------------------------------------------
# Zoxide: use `cd` as a ranked jumper
# --hook prompt records the CWD on every prompt, so the more often
# commands are run in a directory, the higher its zoxide rank.
# -----------------------------------------------------
eval "$(zoxide init zsh --cmd cd --hook prompt)"

# -----------------------------------------------------
# NVM lazy load (NVM_DIR set in .profile)
# -----------------------------------------------------
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
    nvm $@
}
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Set default Node.js version in PATH
DEFAULT_NODE_VER_PATH="$(find $NVM_DIR/versions/node -maxdepth 1 -name "v${DEFAULT_NODE_VER#v}*" | sort -rV | head -n 1)"
[ -n "$DEFAULT_NODE_VER_PATH" ] && export PATH="$DEFAULT_NODE_VER_PATH/bin:$PATH"

# -----------------------------------------------------
# Bun completions (zsh-specific file)
# -----------------------------------------------------
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
# bun completions (linux path)
[ -s "/home/zeel/.bun/_bun" ] && source "/home/zeel/.bun/_bun"

# -----------------------------------------------------
# Pyenv init (shell-specific evals)
# -----------------------------------------------------
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
if pyenv commands | grep -q virtualenv-init; then
    eval "$(pyenv virtualenv-init -)"
fi

# -----------------------------------------------------
# SDKMAN (must be after other PATH modifications)
# -----------------------------------------------------
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# =====================================================
# zsh-specific PATH
# =====================================================
# scripts folder relative to this dotfile (zsh-specific parameter expansion)
export PATH="$PATH:${${(%):-%x}:A:h}/scripts"

# =====================================================
# zsh-specific aliases and functions
# =====================================================
alias please='sudo $(fc -ln -1)'
alias idea='open -na "IntelliJ IDEA.app" --args "$@"'
alias rover='open -na "RustRover.app" --args "$@"'
