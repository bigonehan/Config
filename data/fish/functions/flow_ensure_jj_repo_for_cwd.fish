function flow_ensure_jj_repo_for_cwd --argument-names start_dir
    set -l target_dir (flow_resolve_jj_target_from_cwd "$start_dir")
    if test -z "$target_dir"
        return 1
    end

    if not test -d "$target_dir/.jj"
        set -l old_dir (pwd)
        cd "$target_dir"
        jj git init --colocate >/dev/null 2>/dev/null
        set -l init_status $status
        cd "$old_dir"
        if test $init_status -ne 0
            return 1
        end
    end

    echo $target_dir
    return 0
end
