# ssh spawns a login shell when creating a connection. Login shells do
# not source .bashrc files, so this is needed for that.
if [ -f $HOME/.bashrc ]; then
    . $HOME/.bashrc
fi
