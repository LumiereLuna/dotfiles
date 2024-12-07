# $HOME/.profile

# If a distro has a default .profile with actual important commands in
# it rename it to this:
if [ -f $HOME/.distro_profile ]; then
    . $HOME/.distro_profile
fi

PATH="${PATH}:${HOME}/.local/bin"
PATH="${PATH}:${HOME}/.cargo/bin"
PATH="${PATH}:/usr/local/go/bin"
PATH="${PATH}:${HOME}/.luarocks/bin"
export PATH

export PAGER=less
export LESS=-R
export VISUAL=nvim
export EDITOR=nvim

export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
