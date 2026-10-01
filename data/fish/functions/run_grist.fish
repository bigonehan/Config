function run_grist --description 'Start the Grist video maker and concept list Vite servers'
    if test (count $argv) -ne 0
        echo 'usage: run_grist' >&2
        return 2
    end

    set -l video_dir /home/tree/extensions/grist_video_maker
    set -l concept_dir /home/tree/extensions/grist_concept_list

    for project_dir in $video_dir $concept_dir
        if not test -f "$project_dir/package.json"
            echo "run_grist: project not found: $project_dir" >&2
            return 2
        end
    end

    if not command -q npm
        echo 'run_grist: npm is required' >&2
        return 127
    end

    command npm --prefix "$video_dir" run dev -- --port 5195 &
    set -l video_pid $last_pid

    command npm --prefix "$concept_dir" run dev -- --port 5196 &
    set -l concept_pid $last_pid

    function __run_grist_stop --on-signal INT \
            --inherit-variable video_pid \
            --inherit-variable concept_pid
        command kill $video_pid $concept_pid 2>/dev/null
    end

    wait $video_pid $concept_pid
    set -l wait_status $status
    functions --erase __run_grist_stop
    return $wait_status
end
