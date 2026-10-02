if command -q gio
    function open
        gio open $argv
    end
end
