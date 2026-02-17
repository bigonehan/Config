# ============================================================
# level_work
# 오케스트레이터
# task.yaml → wave 계산 → 순차/병렬 실행
# ============================================================
function level_work
    set_color cyan
    echo "⚙️  level_work 시작"
    set_color normal
    echo ""

    if not test -f task.yaml
        set_color red
        echo "❌ task.yaml 없음. level_plan을 먼저 실행하세요."
        set_color normal
        return 1
    end

    # wave 계산
    analyze_task_priority
    if test $status -ne 0; return 1; end

    # wave 순서대로 실행
    python3 -c "
import yaml
with open('/tmp/task_waves.yaml') as f:
    waves = yaml.safe_load(f)
for wave in waves.get('waves', []):
    mode = 'parallel' if wave['parallel'] else 'sequential'
    ids  = ' '.join(t['id'] for t in wave['tasks'])
    print(f\"{wave['wave']}|{mode}|{ids}\")
" | while read -l line

        set parts    (string split "|" $line)
        set wave_num $parts[1]
        set mode     $parts[2]
        set task_ids (string split " " $parts[3])

        echo ""
        set_color yellow
        echo "━━━ Wave $wave_num [$mode] ━━━━━━━━━━━━━━━━━━━━"
        set_color normal

        switch $mode
            case "sequential"
                for task_id in $task_ids
                    run_task $task_id
                    if test $status -ne 0
                        set_color red
                        echo "❌ Wave $wave_num 중단: $task_id 실패"
                        set_color normal
                        return 1
                    end
                end

            case "parallel"
                run_task_parallel $task_ids
                if test $status -ne 0
                    set_color red
                    echo "❌ Wave $wave_num 병렬 실행 실패"
                    set_color normal
                    return 1
                end
        end

        set_color green
        echo "✅ Wave $wave_num 완료"
        set_color normal
    end

    echo ""
    set_color green
    echo "🎉 level_work 완료!"
    set_color normal
    echo ""
    set_color cyan
    echo "다음 단계:"
    set_color normal
    echo "  level_feedback  # spec.yaml 업데이트 + jj 기록"
end
