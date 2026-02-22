# ============================================================
# run_task
# 단일 task를 jj workspace에서 실행 (순차)
# 인자: task_id
# ============================================================
function run_task
    set task_id $argv[1]

    echo ""
    set_color cyan
    echo "▶ task 실행: $task_id"
    set_color normal

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

    if test -z "$task_info"
        set_color red
        echo "❌ task 없음: $task_id"
        set_color normal
        return 1
    end

    set workspace_name "ws_$task_id"
    set jj_root (flow_ensure_jj_repo_for_cwd (pwd))
    if test $status -ne 0 -o -z "$jj_root"
        set_color red
        echo "❌ jj 저장소 준비 실패: "(pwd)
        set_color normal
        return 1
    end
    cd $jj_root

    # ----------------------------------------
    # jj workspace 생성
    # ----------------------------------------
    set workspace_parent "$jj_root/.workspaces"
    set workspace_path "$workspace_parent/$workspace_name"
    mkdir -p $workspace_parent

    # 이전 실패로 남은 stale workspace 정리
    jj workspace forget $workspace_name 2>/dev/null
    if test -d "$workspace_path"
        rm -rf "$workspace_path" 2>/dev/null
    end

    jj workspace add $workspace_path --name $workspace_name 2>/dev/null
    if test $status -ne 0
        set_color red
        echo "❌ workspace 생성 실패: $workspace_name"
        set_color normal
        return 1
    end
    echo "✅ workspace 생성: $workspace_name"

    # ----------------------------------------
    # LLM에게 구현 요청
    # ----------------------------------------
    set dev_language "TypeScript"
    if test -f spec.yaml
        set dev_language (python3 -c "
import yaml
with open('spec.yaml') as f:
    spec = yaml.safe_load(f) or {}
language = (spec.get('language') or '').strip()
print(language)
" 2>/dev/null)
    end
    if test -z "$dev_language"
        set dev_language "TypeScript"
    end

    set spec_content ""
    if test -f spec.yaml
        set spec_content (cat spec.yaml)
    end

    set task_prompt "당신은 $dev_language 개발자입니다.
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
- 파일은 target 패키지 경로 아래에 생성
- 구현 완료 후 변경된 파일 목록 출력"

    cd $workspace_path
    codex exec "$task_prompt"
    set codex_status $status
    cd $jj_root

    if test $codex_status -ne 0
        set_color red
        echo "❌ task 구현 실패: $task_id"
        set_color normal
        jj workspace forget $workspace_name 2>/dev/null
        return 1
    end

    # ----------------------------------------
    # test_task 실행
    # ----------------------------------------
    cd $workspace_path
    test_task $task_id $workspace_name
    set test_status $status
    cd $jj_root

    if test $test_status -ne 0
        set_color red
        echo "❌ 검증 실패: $task_id"
        echo "   workspace 유지: $workspace_path"
        echo "   수동 확인 후 다시 실행하세요"
        set_color normal
        return 1
    end

    # ----------------------------------------
    # merge → main
    # ----------------------------------------
    echo ""
    echo "🔀 merge: $workspace_name → main"
    jj git fetch 2>/dev/null
    jj squash --from $workspace_name --into @ 2>/dev/null

    if test $status -ne 0
        set_color red
        echo "❌ merge 실패: $workspace_name"
        set_color normal
        return 1
    end

    # workspace 정리
    jj workspace forget $workspace_name 2>/dev/null
    rm -rf $workspace_path 2>/dev/null

    set_color green
    echo "✅ task 완료 + merge: $task_id"
    set_color normal
end
