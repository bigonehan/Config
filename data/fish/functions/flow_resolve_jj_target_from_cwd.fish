function flow_resolve_jj_target_from_cwd --argument-names start_dir
    set -l dir $start_dir
    if test -z "$dir"
        set dir (pwd)
    end

    if test -d "$dir/.jj"
        echo $dir
        return 0
    end

    set -l git_root (git -C "$dir" rev-parse --show-toplevel 2>/dev/null)
    if test -n "$git_root"
        if flow_has_monorepo_marker "$git_root"
            echo $git_root
        else
            echo $dir
        end
        return 0
    end

    set -l probe_dir $dir
    while true
        if flow_has_monorepo_marker "$probe_dir"
            echo $probe_dir
            return 0
        end

        if test "$probe_dir" = "/"
            break
        end

        set -l parent_dir (dirname "$probe_dir")
        if test "$parent_dir" = "$probe_dir"
            break
        end
        set probe_dir $parent_dir
    end

    echo $dir
    return 0
end
