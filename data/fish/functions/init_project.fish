function init_project --description "Create spec.md in current directory from ~/ai/templates/spec.md"
    # Options:
    #   -f / --force      overwrite existing spec.md
    #   -t / --template   custom template path (default: ~/ai/templates/spec.md)
    argparse 'f/force' 't/template=' -- $argv; or return 2

    set -l template "$HOME/ai/templates/spec.md"
    if set -q _flag_template
        set template "$_flag_template"
    end

    set -l target (pwd)/spec.md

    # (Optional) tmux check: warn only
    if not set -q TMUX
        echo "note: TMUX 환경이 아닙니다. (전제: tmux 내 작업) 그래도 spec.md 생성은 진행합니다."
    end

    if not test -f "$template"
        echo "Error: template not found: $template"
        return 1
    end

    if test -f "$target"; and not set -q _flag_force
        echo "Error: spec.md already exists: $target"
        echo "      overwrite하려면: initProject --force"
        return 1
    end

    cp "$template" "$target"
    echo "✅ Created spec.md from template"
    echo "   template: $template"
    echo "   target:   $target"
end
EOF
