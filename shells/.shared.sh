export PATH="${PATH}:${HOME}/.local/bin:${HOME}/.cargo/bin:/usr/local/go/bin:${HOME}/.luarocks/bin"
export PAGER=less
export LESS=-R
export VISUAL=vi
export EDITOR=vi

alias ls='ls --color=auto --group-directories-first --human-readable --file-type'
alias la='ls --almost-all'
alias ll='ls -l'
alias lla='ls -l --almost-all'
if [ $(command -v gio) ]; then
    alias open='gio open'
    alias rm='gio trash'
fi
alias g='git'
alias e='emacsclient --alternate-editor emacs --tty'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
