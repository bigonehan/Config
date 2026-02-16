function create_task_pane --description "Split tmux pane, create jj workspace tN, cd, jj new, run codex for task N"
    if test (count $argv) -lt 1
        echo "Usage: create_task_pane <N>"
        return 2
    end

    set -l n $argv[1]

    if not set -q TMUX
        echo "Error: must be run inside tmux."
        return 2
    end

    set -l root (pwd)
    set -l base (basename $root)
    set -l parent (dirname $root)
    set -l ws_name "t$n"
    set -l ws_dir "$parent/$base-$ws_name"

    # 항상 현재 디렉터리에 있는 task.md 사용
    set -l task_abs "$root/task.md"

    tmux split-window -h -c "#{pane_current_path}"

    set -l prompt "task.md 파일($task_abs)을 읽고 task $n 의 작업을 구현하라"

    set -l cmd "jj workspace add $ws_name; and cd \"$ws_dir\"; and jj new; and codex \"$prompt\""

    tmux send-keys "$cmd" C-m
end
