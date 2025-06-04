export PATH="${PATH}:${HOME}/.local/bin:${HOME}/.cargo/bin:/usr/local/go/bin:${HOME}/.luarocks/bin:${HOME}/.manual-install/lua-language-server/bin"
export PAGER=less
export LESS=-R
export VISUAL=vi
export EDITOR=vi

alias ls='ls --color=auto --group-directories-first --human-readable --file-type -v'
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

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

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

giftoavif() {
    local f
    local total_frames
    local duration
    local fps
    for f in "$@"; do
        total_frames="$(exiftool "$f" -b -FrameCount)"
        duration="$(exiftool "$f" -b -Duration)"
        fps="$(echo "$total_frames/$duration" | bc)"
        mkdir /tmp/giftoavif
        magick "$f" -compress none /tmp/giftoavif/%d.png
        ffmpeg -y -i /tmp/giftoavif/%d.png -strict -1 -pix_fmt yuva444p -f yuv4mpegpipe - | avifenc --stdin --fps $fps "$(basename "$f" .gif).avif"
        command rm -rf /tmp/giftoavif
    done
}

vidtoavif() {
    local input="$1"
    local start="$2"
    local end="$3"
    local output="$4"
    local fps="$(exiftool "$input" -b -VideoFrameRate)"
    local optargs=()
    if [[ "$(exiftool "$input" -b -ImageHeight)" -gt 720 ]]; then
        optargs+=("-vf" "scale=-1:720")
    fi
    ffmpeg -y -i "${input}" -ss "${start}" -t "${end}" -strict -1 -pix_fmt yuva444p -f yuv4mpegpipe "${optargs[@]}" - | avifenc --stdin --fps "${fps}" "${output}"
}
