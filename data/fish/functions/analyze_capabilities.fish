# ============================================================
# analyze_capabilities
# 패키지 feature 목록 수집 + 1단계 LLM 호출
# 결과: /tmp/capability_check.yaml
# ============================================================
function analyze_capabilities
    echo ""
    echo "🔍 모노레포 패키지 및 기능 스캔 중..."

    # 패키지별 feature 수집 (인라인)
    set features_context ""
    for pkg in (get_packages_mono)
        set features (get_package_features $pkg)

        if test -n "$features"
            set features_context "$features_context\n$pkg:"
            for feat in $features
                set features_context "$features_context\n  - $feat"
            end
        else
            set features_context "$features_context\n$pkg:\n  - (구현된 기능 없음)"
        end
    end

    echo ""
    echo "🤖 1단계 AI 분석 중 (capability 파악)..."

    set plan_content (cat plan.yaml)

    set pre_prompt "당신은 모노레포 설계 전문가입니다.
아래 기능 요구사항을 분석하고 필요한 capability를 파악하세요.

## 기능 요구사항
$plan_content

## 현재 모노레포 패키지 및 구현된 기능
$features_context

## 출력 형식 (YAML만, 설명 금지)

feature_summary:
  - \"학생 도메인이 성적을 조회한다\"

capabilities:
  - domain: \"@domain/student_high\"
    port: \"IGetGradePort\"
    adapter: \"@adapter/student_high\"
    description: \"고등학생 성적 조회\"
    status: \"missing_all\"
    reason: \"고등학생 성적 기반 할인 적용 필요\"

## status 기준
- missing_all:     도메인/Port/Adapter 전부 없음
- missing_feature: 도메인은 있지만 해당 Port/기능 없음
- exists:          도메인과 Adapter 모두 존재

## 주의사항
- 현재 패키지 목록에 없는 것만 missing으로 판단
- 확신 없으면 exists로"

    codex "$pre_prompt" > /tmp/capability_check.yaml

    if test $status -ne 0
        set_color red
        echo "❌ 1단계 AI 분석 실패"
        set_color normal
        return 1
    end

    echo "✅ capability 분석 완료"
end
