function fish_prompt
    set -l last_status $status
    set -l stat
    if test $last_status -ne 0
        set stat (set_color red)"[$last_status]"(set_color --reset)" "
    end
    string join '' -- (set_color --reverse) $USER '@' $hostname (set_color --reset) ' ' (prompt_pwd) (fish_vcs_prompt) ' ' $stat '❤︎ ' (set_color --reset) ' '
end
