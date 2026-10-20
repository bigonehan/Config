function run_grist --description 'Start the Grist video maker, concept list, and cartoon maker Vite servers'
    if test (count $argv) -ne 0
        echo 'usage: run_grist' >&2
        return 2
    end

    set -l video_dir /home/tree/extensions/grist_video_maker
    set -l concept_dir /home/tree/extensions/grist_concept_list
    set -l cartoon_dir /home/tree/extensions/grist_cartoon_maker

    for project_dir in $video_dir $concept_dir $cartoon_dir
        if not test -f "$project_dir/package.json"
            echo "run_grist: project not found: $project_dir" >&2
            return 2
        end
    end

    if not command -q npm
        echo 'run_grist: npm is required' >&2
        return 127
    end
    if not command -q bash
        echo 'run_grist: bash is required for single-key input' >&2
        return 127
    end

    command npm --prefix "$video_dir" run dev -- --port 5195 </dev/null &
    set -l video_pid $last_pid

    command npm --prefix "$concept_dir" run dev -- --port 5196 </dev/null &
    set -l concept_pid $last_pid

    command npm --prefix "$cartoon_dir" run dev -- --port 5175 </dev/null &
    set -l cartoon_pid $last_pid

    function __run_grist_stop --on-signal INT \
            --inherit-variable video_pid \
            --inherit-variable concept_pid \
            --inherit-variable cartoon_pid
        command kill -TERM -- -$video_pid -$concept_pid -$cartoon_pid 2>/dev/null
    end

    echo 'Grist servers are running. Press q to stop all servers.'
    set -l stop_requested false
    while command kill -0 $video_pid 2>/dev/null; and command kill -0 $concept_pid 2>/dev/null; and command kill -0 $cartoon_pid 2>/dev/null
        set -l key (command bash -c 'IFS= read -rsn1 -t 0.25 key && printf "%s" "$key"')
        if string match --quiet --ignore-case q -- $key
            set stop_requested true
            command kill -TERM -- -$video_pid -$concept_pid -$cartoon_pid 2>/dev/null
            break
        end
    end

    if test "$stop_requested" = false
        command kill -TERM -- -$video_pid -$concept_pid -$cartoon_pid 2>/dev/null
    end
    wait $video_pid $concept_pid $cartoon_pid
    set -l wait_status $status
    functions --erase __run_grist_stop
    if test "$stop_requested" = true
        echo 'All Grist servers stopped.'
        return 0
    end
    return $wait_status
end
