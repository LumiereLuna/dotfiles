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
    alias rm='gio trash'
    open() {
        (gio open $@ &)
    }
fi
alias e='emacsclient --alternate-editor emacs --tty'
if [ $(command -v nvim) ]; then
    alias v='nvim'
elif [ $(command -v vim) ]; then
    alias v='vim'
else
    alias v='vi'
fi
alias g='git'
alias lg='lazygit'

git-gh-deploy() {
    if [ -z "$1" ]; then
        echo "Which folder do you want to deploy to GitHub Pages?"
        exit 1
    fi
    git subtree push --prefix $1 origin gh-pages
}

mirror-website() {
    wget --mirror --convert-links --adjust-extension --page-requisites --no-parent --timestamping $@
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
