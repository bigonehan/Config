function configup
    function moveConfig
        set -l source_dir ~/.config/$argv[1]
        set -l target_dir ~/Config/data/

        if test -d $source_dir
            # ~/config/data/ 폴더가 없으면 생성
            mkdir -p $target_dir

            # 대상 경로에 동일한 이름의 디렉토리가 있으면 삭제 후 이동
            if test -d $target_dir$argv[1]
                rm -rf $target_dir$argv[1]
            end
            
            cp -r $source_dir $target_dir
            echo "Moved ~/.config/$argv[1] to ~/Config/data/"
        else
            echo "Source $source_dir does not exist."
        end
    end

    moveConfig nvim
    moveConfig tmux
    moveConfig fish
end
