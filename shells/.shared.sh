export PATH="${PATH}:${HOME}/.local/bin:${HOME}/.cargo/bin:/usr/local/go/bin:${HOME}/.luarocks/bin"
export PAGER=less
export LESS=-R
export VISUAL=nvim
export EDITOR=nvim

alias la='ls --almost-all'
alias ll='ls -l'
alias lla='ls -l --almost-all'
alias open='xdg-open'
if [ $(command -v gio) ]; then
    alias rm='gio trash'
fi
alias g='git'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
