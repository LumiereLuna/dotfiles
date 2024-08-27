PATH="$PATH:$HOME/.manual-install/fzf/bin"

if [ $(command -v fdfind) ]; then
	FD='fdfind'
        export FZF_DEFAULT_COMMAND="$FD --hidden"
        export FZF_ALT_C_COMMAND="$FD --hidden --type d"
elif [ $(command -v fd) ]; then
	FD='fd'
        export FZF_DEFAULT_COMMAND="$FD --hidden"
        export FZF_ALT_C_COMMAND="$FD --hidden --type d"
else
        export FZF_DEFAULT_COMMAND="find --hidden"
        export FZF_ALT_C_COMMAND="find . -type d -iname '.*'"
fi
