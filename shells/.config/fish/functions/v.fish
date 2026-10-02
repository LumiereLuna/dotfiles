if command -q nvim
    function v
        nvim $argv
    end
else if command -q vim
    function v
        vim $argv
    end
else
    function v
        vi $argv
    end
end
