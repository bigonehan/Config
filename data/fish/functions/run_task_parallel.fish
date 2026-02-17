
# ============================================================
# run_task_parallel
# 여러 task를 jj workspace에서 병렬 실행
# 인자: task_id들 (공백 구분)
# ============================================================
function run_task_parallel
    set task_ids $argv
    set jj_root (jj root 2>/dev/null)

    echo ""
    set_color cyan
    echo "⚡ 병렬 실행: $task_ids"
    set_color normal

    set workspace_list

    # ----------------------------------------
    # 각 task별 workspace 생성 + 백그라운드 실행
    # ----------------------------------------
    for task_id in $task_ids
        set workspace_name "ws_$task_id"
        set workspace_path "$jj_root/.workspaces/$workspace_name"
        set workspace_list $workspace_list $workspace_name

        mkdir -p $workspace_path
        jj workspace add $workspace_path --name $workspace_name 2>/dev/null

        # task 정보 추출
        set task_info (python3 -c "
import yaml, json
with open('plan.yaml') as f:
    plan = yaml.safe_load(f)
for t in plan.get('tasks', []):
    if t.get('id') == '$task_id':
        print(json.dumps(t, ensure_ascii=False))
        break
" 2>/dev/null)

        set spec_content ""
        if test -f spec.yaml
            set spec_content (cat spec.yaml)
        end

        set task_prompt "당신은 TypeScript 개발자입니다.
아래 task를 구현하세요.

## Task
$task_info

## 패키지 spec
$spec_content

## 작업 위치
workspace: $workspace_name
경로: $workspace_path

## 규칙
- spec.yaml의 rule 준수
- 파일은 target 패키지 경로 아래에 생성"

        # 백그라운드로 실행
        echo "   ▶ 시작: $task_id (workspace: $workspace_name)"
        begin
            cd $workspace_path
            codex "$task_prompt"
            echo $status > /tmp/task_exit_$task_id
            cd $jj_root
        end &
    end

    # ----------------------------------------
    # 모든 백그라운드 작업 완료 대기
    # ----------------------------------------
    echo ""
    echo "⏳ 모든 task 완료 대기 중..."
    wait

    # ----------------------------------------
    # 각 task 검증 + 결과 수집
    # ----------------------------------------
    set all_passed true

    for task_id in $task_ids
        set workspace_name "ws_$task_id"
        set workspace_path "$jj_root/.workspaces/$workspace_name"
        set exit_code (cat /tmp/task_exit_$task_id 2>/dev/null)

        if test "$exit_code" != "0"
            set_color red
            echo "❌ 구현 실패: $task_id"
            set_color normal
            set all_passed false
            continue
        end

        # test_task 실행
        cd $workspace_path
        test_task $task_id $workspace_name
        set test_status $status
        cd $jj_root

        if test $test_status -ne 0
            set_color red
            echo "❌ 검증 실패: $task_id"
            echo "   workspace 유지: $workspace_path"
            set_color normal
            set all_passed false
        end

        rm -f /tmp/task_exit_$task_id
    end

    # ----------------------------------------
    # 전체 통과시 순서대로 merge
    # ----------------------------------------
    if test "$all_passed" = "true"
        echo ""
        echo "🔀 순서대로 merge 중..."

        for task_id in $task_ids
            set workspace_name "ws_$task_id"
            set workspace_path "$jj_root/.workspaces/$workspace_name"

            jj squash --from $workspace_name --into @ 2>/dev/null

            if test $status -ne 0
                set_color red
                echo "❌ merge 실패: $workspace_name"
                set_color normal
                return 1
            end

            jj workspace forget $workspace_name 2>/dev/null
            rm -rf $workspace_path 2>/dev/null

            set_color green
            echo "  ✅ merge 완료: $task_id"
            set_color normal
        end
    else
        set_color red
        echo "❌ 일부 task 실패. merge 중단."
        echo "   실패한 workspace를 확인하고 수동으로 처리하세요."
        set_color normal
        return 1
    end
end
