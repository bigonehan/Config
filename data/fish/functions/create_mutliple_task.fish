function create_multiple_task
    if not test -f task.md
        echo "task.md not found in current directory"
        return 2
    end

    # task 1, task 2 같은 패턴 추출
    set -l nums (grep -E -i '(^|\b)task[[:space:]]*[0-9]+' task.md \
        | sed -E 's/.*\btask[[:space:]]*([0-9]+).*/\1/i' \
        | sort -n | uniq)

    if test (count $nums) -eq 0
        echo "No task numbers found in task.md"
        return 2
    end

    for n in $nums
        create_task_pane $n
        /bin/sleep 0.05
    end
end

