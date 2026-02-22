function flow_has_monorepo_marker --argument-names dir
    if test -z "$dir"
        return 1
    end

    if test -f "$dir/pnpm-workspace.yaml" \
        -o -f "$dir/turbo.json" \
        -o -f "$dir/lerna.json" \
        -o -f "$dir/nx.json" \
        -o -f "$dir/rush.json" \
        -o -f "$dir/go.work" \
        -o -f "$dir/WORKSPACE" \
        -o -f "$dir/WORKSPACE.bazel"
        return 0
    end

    if test -f "$dir/Cargo.toml"
        if rg -n '^\s*\[workspace\]\s*$' "$dir/Cargo.toml" >/dev/null 2>/dev/null
            return 0
        end
    end

    return 1
end
