# Oh My Zsh configuration
export ZSH="$HOME/.oh-my-zsh"
# plugins=(git ssh-agent zsh-autosuggestions zsh-syntax-highlighting)
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# User configuration
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile'

# Starship prompt
eval "$(starship init zsh)"

# FZF support
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Television support:
# ctrl + r -> shell history
# ctrl + t -> smart autocompletion
eval "$(tv init zsh)"

# NVM lazy load (NVM_DIR set in .profile)
nvm() {
    unset -f nvm
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" --no-use
    nvm $@
}
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Set default Node.js version in PATH
DEFAULT_NODE_VER_PATH="$(find $NVM_DIR/versions/node -maxdepth 1 -name "v${DEFAULT_NODE_VER#v}*" | sort -rV | head -n 1)"
[ -n "$DEFAULT_NODE_VER_PATH" ] && export PATH="$DEFAULT_NODE_VER_PATH/bin:$PATH"

# Bun completions (zsh-specific file)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Pyenv init (shell-specific evals)
eval "$(pyenv init --path)"
eval "$(pyenv init -)"
if pyenv commands | grep -q virtualenv-init; then
    eval "$(pyenv virtualenv-init -)"
fi

# SDKMAN (must be after other PATH modifications)
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# zoxide initialization, use zoxide as cd alias, and the --hook prompt will make zoxide record the directory
# every time a command is run in that directory. Meaning, the more I run commands in a directory, the higher the
# rank of that directory in zoxide's database.
eval "$(zoxide init zsh --cmd cd --hook prompt)"


# zsh specific aliases and functions

alias please='sudo $(fc -ln -1)'
# bun completions (linux path)
[ -s "/home/zeel/.bun/_bun" ] && source "/home/zeel/.bun/_bun"
alias idea='open -na "IntelliJ IDEA.app" --args "$@"'
alias rover='open -na "RustRover.app" --args "$@"'
# scripts folder relative to this dotfile (zsh-specific parameter expansion)
export PATH="$PATH:${${(%):-%x}:A:h}/scripts"
