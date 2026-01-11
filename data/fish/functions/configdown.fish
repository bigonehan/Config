function configdown
    function moveConfig
        set -l source_dir ~/Config/data/$argv[1]
        set -l target_dir ~/.config/

        if test -d $source_dir
            if test -d $target_dir$argv[1]
                rm -rf $target_dir$argv[1]
            end
            cp -r $source_dir $target_dir
            echo "Moved $argv[1] to ~/.config/"
        else
            echo "Source $source_dir does not exist."
        end
    end

    moveConfig nvim
    moveConfig tmux
    moveConfig fish
end
