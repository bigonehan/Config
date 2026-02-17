# ============================================================
# level_feedback
# level_work 완료 후 호출
# 1. LLM이 완료된 tasks를 읽고 spec.yaml feature 업데이트
# 2. jj에 작업 내용을 커밋 메시지로 기록
# ============================================================
function level_feedback
    echo ""
    set_color cyan
    echo "📝 level_feedback 시작"
    set_color normal

    if not test -f plan.yaml
        set_color red
        echo "❌ plan.yaml 없음"
        set_color normal
        return 1
    end

    if not test -f spec.yaml
        set_color red
        echo "❌ spec.yaml 없음"
        set_color normal
        return 1
    end

    # ========================================
    # 1. LLM이 완료된 tasks → spec.yaml feature 업데이트
    # ========================================
    echo ""
    echo "🤖 AI가 완료된 기능을 spec.yaml에 기록 중..."

    set plan_content (cat plan.yaml)
    set spec_content (cat spec.yaml)
    set today (date +%Y-%m-%d)

    set feature_prompt "당신은 모노레포 패키지 관리 전문가입니다.
아래 plan.yaml의 완료된 tasks를 읽고
spec.yaml의 feature 목록에 추가할 항목을 생성하세요.

## 완료된 plan.yaml
$plan_content

## 현재 spec.yaml
$spec_content

## 오늘 날짜
$today

## 출력 형식 (YAML만, 설명 금지)
new_features:
  - \"기능명 ($today)\"
  - \"기능명 ($today)\"

## 규칙
- tasks의 name과 description을 바탕으로 간결하게 작성
- 이미 spec.yaml feature에 있는 항목은 제외
- 날짜는 반드시 포함"

    codex "$feature_prompt" > /tmp/new_features.yaml

    if test $status -ne 0
        set_color red
        echo "❌ feature 생성 실패"
        set_color normal
        return 1
    end

    # spec.yaml feature에 추가
    python3 -c "
import yaml
from datetime import date

# 새 feature 목록
with open('/tmp/new_features.yaml') as f:
    result = yaml.safe_load(f)

new_features = result.get('new_features', []) or []

if not new_features:
    print('ℹ️  추가할 feature 없음')
    exit(0)

# spec.yaml 업데이트
with open('spec.yaml', 'r') as f:
    spec = yaml.safe_load(f)

existing = spec.get('feature', []) or []
added = []

for feat in new_features:
    if feat not in existing:
        existing.append(feat)
        added.append(feat)

spec['feature'] = existing

with open('spec.yaml', 'w') as f:
    yaml.dump(spec, f, allow_unicode=True, default_flow_style=False, sort_keys=False)

for feat in added:
    print(f'  ✅ {feat}')
"

    if test $status -ne 0
        set_color red
        echo "❌ spec.yaml 업데이트 실패"
        set_color normal
        return 1
    end

    set_color green
    echo "✅ spec.yaml feature 업데이트 완료"
    set_color normal

    # ========================================
    # 2. jj 커밋 메시지 생성 + 기록
    # ========================================
    echo ""
    echo "📌 jj 커밋 메시지 작성 중..."

    set commit_prompt "당신은 개발 기록 전문가입니다.
아래 plan.yaml을 읽고 jujutsu 커밋 메시지를 작성하세요.

## 완료된 plan.yaml
$plan_content

## 출력 형식 (텍스트만, YAML 아님)
첫 줄: 제목 (50자 이내, 한국어)
빈 줄
본문:
  - 구현된 기능 목록
  - 영향받은 패키지
  - 주요 변경사항

## 예시
feat: 티켓 소각 시스템 구현

- 티켓 소각 도메인 규칙 정의 (t-1)
- 소각 처리 유스케이스 구현 (t-2)
- 소각 후 상태 검증 추가 (t-3)

영향 패키지: @feature/ticket
관련 기능: 소각 시스템"

    set commit_message (codex "$commit_prompt")

    if test $status -ne 0
        set_color yellow
        echo "⚠️  커밋 메시지 생성 실패 → 기본 메시지 사용"
        set commit_message "feat: level_work 완료\n\nplan.yaml 참고"
    end

    # jj describe로 커밋 메시지 기록
    echo $commit_message | jj describe --stdin 2>/dev/null

    if test $status -ne 0
        set_color yellow
        echo "⚠️  jj describe 실패"
        set_color normal
    else
        set_color green
        echo "✅ jj 커밋 메시지 기록 완료"
        set_color normal
    end

    # ========================================
    # 3. 완료 요약
    # ========================================
    echo ""
    echo "──────────────────────────────────────"
    set_color green
    echo "🎉 level_feedback 완료"
    set_color normal
    echo ""
    echo "업데이트된 내용:"
    echo "  ✓ spec.yaml feature 갱신"
    echo "  ✓ jj 커밋 메시지 기록"
    echo ""
    set_color cyan
    echo "jj log 로 히스토리를 확인하세요"
    set_color normal
end
