# ============================================================
# test_task
# task 완료 후 LLM skill로 검증
# 인자: task_id, workspace_name
# ============================================================
function test_task
    set task_id        $argv[1]
    set workspace_name $argv[2]

    echo ""
    echo "🧪 task 검증 중: $task_id ($workspace_name)"

    # task 정보 추출
    set task_info (python3 -c "
import yaml

with open('plan.yaml') as f:
    plan = yaml.safe_load(f)

tasks = plan.get('tasks', []) or []
for t in tasks:
    if t.get('id') == '$task_id':
        import json
        print(json.dumps(t, ensure_ascii=False))
        break
" 2>/dev/null)

    if test -z "$task_info"
        set_color red
        echo "❌ task 정보 없음: $task_id"
        set_color normal
        return 1
    end

    # workspace에서 변경된 파일 목록
    set changed_files (jj diff --name-only -r $workspace_name 2>/dev/null)

    set test_prompt "당신은 코드 검증 전문가입니다.
아래 task의 구현이 올바르게 완료되었는지 검증하세요.

## Task 정보
$task_info

## 변경된 파일 목록
$changed_files

## 현재 workspace의 변경 내용
(jj diff -r $workspace_name 출력)

## 검증 항목
1. task description에 명시된 작업이 실제로 구현되었는가?
2. spec_context.rules를 준수하는가?
3. 명백한 오류나 누락이 있는가?

## 출력 형식 (YAML만)
result:
  passed: true | false
  score: 0-100
  issues:
    - \"문제점 설명\"
  suggestions:
    - \"개선 제안\""

    codex "$test_prompt" > /tmp/test_result_$task_id.yaml

    # 결과 파싱
    python3 -c "
import yaml

with open('/tmp/test_result_$task_id.yaml') as f:
    result = yaml.safe_load(f)

r       = result.get('result', {})
passed  = r.get('passed', False)
score   = r.get('score', 0)
issues  = r.get('issues', []) or []
suggest = r.get('suggestions', []) or []

if passed:
    print(f'PASSED|{score}')
else:
    print(f'FAILED|{score}')

for issue in issues:
    print(f'ISSUE|{issue}')
for s in suggest:
    print(f'SUGGEST|{s}')
" | while read -l line
        set parts (string split "|" $line)
        switch $parts[1]
            case "PASSED"
                set_color green
                echo "  ✅ 검증 통과 (점수: $parts[2]/100)"
                set_color normal
            case "FAILED"
                set_color red
                echo "  ❌ 검증 실패 (점수: $parts[2]/100)"
                set_color normal
            case "ISSUE"
                set_color red
                echo "  ⚠️  $parts[2]"
                set_color normal
            case "SUGGEST"
                set_color yellow
                echo "  💡 $parts[2]"
                set_color normal
        end
    end

    # passed 여부 반환
    python3 -c "
import yaml
with open('/tmp/test_result_$task_id.yaml') as f:
    result = yaml.safe_load(f)
passed = result.get('result', {}).get('passed', False)
exit(0 if passed else 1)
"
    return $status
end

