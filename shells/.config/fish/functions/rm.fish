if command -q gio
    function rm
        gio trash $argv
    end
end
