# Commands to run in interactive sessions can go here
if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings
    if command -q zoxide
        zoxide init fish | source
    end
    if command -q fzf
        fzf --fish | source
    end
end
