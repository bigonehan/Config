# ============================================================
# generate_tasks
# plan.yaml의 analysis + features를 읽고
# task.yaml 생성 (level_work의 실행 단위)
# codex가 task.yaml 파일을 직접 저장
# ============================================================
function generate_tasks
    echo ""
    echo "🤖 2단계 AI: task.yaml 생성 중..."

    set updated_packages (string join "\n  - " (get_packages_mono))
    set plan_content (cat plan.yaml)

    set main_prompt "당신은 Turborepo 모노레포 기능 설계 전문가입니다.
아래 plan.yaml을 읽고 현재 디렉토리에 task.yaml 파일을 생성하세요.

## 현재 plan.yaml
$plan_content

## 현재 모노레포 패키지
  - $updated_packages

## task.yaml 형식
tasks:
  - id: \"t-1\"
    name: \"Task 이름\"
    type: \"feat\"        # feat | fix | refactor | domain
    target: \"\"          # 위 패키지 목록 또는 current_location
    description: \"구체적인 작업 내용\"
    related_features:
      - \"관련 feature 이름\"
	todos: \"순차적으로 진행해야하는 하나의 작업 단위들의 리스트\" 

## 작성 규칙
- plan.features의 각 기능을 구현 단위로 분해
- id는 t-1, t-2, t-3 순서
- type domain은 반드시 앞 순서 배치
- target은 반드시 위 패키지 목록 또는 current_location 중 하나
- spec_context.rules 준수
- 구현 순서: 도메인 → 기능 → 검증

## 주의사항
- 현재 디렉토리에 task.yaml 파일로 저장할 것
- plan.yaml은 수정하지 말 것
- 목록에 없는 패키지를 target에 넣지 말 것
- YAML 문법 준수"

    codex exec "$main_prompt"

    if test $status -ne 0
        set_color red
        echo "❌ task.yaml 생성 실패"
        set_color normal
        return 1
    end

    # 파일 생성 확인
    if not test -f task.yaml
        set_color red
        echo "❌ task.yaml 파일이 생성되지 않음"
        set_color normal
        return 1
    end

    echo ""
    echo "📋 생성된 task.yaml:"
    echo "──────────────────────────────────────"
    cat task.yaml
    echo "──────────────────────────────────────"

    set_color green
    echo "✅ task.yaml 생성 완료"
    set_color normal
end
