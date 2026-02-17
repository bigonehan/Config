# ============================================================
# level_init
# 현재 디렉토리(부모 폴더명)를 기준으로 패키지 타입 자동 감지
# 이름과 설명만 입력받아 패키지를 초기화
#
# 사용 예시:
#   cd packages/feature && level_init
#   cd packages/domain  && level_init
# ============================================================
function level_init
    # ========================================
    # 1. 패키지 타입 자동 감지 (현재 폴더명 기준)
    # ========================================
    set package_type (basename (pwd))
    set target_base (pwd)

    set_color cyan
    echo "🚀 패키지 초기화를 시작합니다"
    echo "   타입: $package_type (자동 감지)"
    set_color normal
    echo ""

    # ========================================
    # 2. 사용자 입력 받기
    # ========================================
    set package_name $argv[1]
    if test -n "$package_name"
        echo "📦 패키지 이름: $package_name (폴더명 자동 연동)"
    else
        read -P "📦 패키지 이름 (예: auth, payment): " package_name
        if test -z "$package_name"
            set_color red
            echo "❌ 패키지 이름은 필수입니다"
            set_color normal
            return 1
        end
    end

    read -P "📝 이 패키지의 기능 설명: " package_description
    if test -z "$package_description"
        set_color red
        echo "❌ 기능 설명은 필수입니다"
        set_color normal
        return 1
    end

    set current_dir_name (basename "$target_base")
    if test "$current_dir_name" = "$package_name"
        set target_dir "$target_base"
    else
        set target_dir "$target_base/$package_name"
    end

    echo ""
    set_color yellow
    echo "📍 생성 위치: $target_dir"
    set_color normal

    # ========================================
    # 3. 폴더 생성 및 이동
    # ========================================
    if test "$target_dir" = "$target_base"
        set_color green
        echo "✅ 현재 폴더 사용: $target_dir"
        set_color normal
        echo ""
    else
        if test -d "$target_dir"
            set_color red
            echo "❌ 이미 존재하는 폴더입니다: $target_dir"
            set_color normal
            return 1
        end

        mkdir -p $target_dir
        cd $target_dir

        set_color green
        echo "✅ 폴더 생성: $target_dir"
        set_color normal
        echo ""
    end

    # ========================================
    # 4. spec.yaml 템플릿 복사
    # ========================================
    echo "📄 spec.yaml 템플릿 생성 중..."
    create_spec

    if test $status -ne 0
        set_color red
        echo "❌ spec.yaml 생성 실패"
        set_color normal
        return 1
    end

    # ========================================
    # 5. 모노레포 내 실제 패키지 목록 수집
    # ========================================
    echo ""
    echo "🔍 모노레포 패키지 스캔 중..."

    set available_packages (get_packages_mono)

    if test -n "$available_packages"
        echo "   ✓ 발견된 패키지: "(count $available_packages)"개"

        set packages_str ""
        for pkg in $available_packages
            set packages_str "$packages_str\n  - $pkg"
        end

        set dependencies_guide "dependencies 규칙:
- 반드시 아래 목록에 있는 패키지만 선택할 것
- 이 패키지 기능에 실제로 필요한 것만 포함
- 확신이 없으면 빈 배열로 남길 것
사용 가능한 패키지:$packages_str"
    else
        echo "   ℹ️  발견된 패키지 없음 → dependencies는 빈 배열"
        set dependencies_guide "dependencies 규칙:
- 현재 모노레포에 사용 가능한 패키지가 없음
- 반드시 빈 배열([])로 설정할 것"
    end

    # ========================================
    # 6. LLM이 spec.yaml 채우기
    # ========================================
    echo ""
    echo "🤖 AI가 spec.yaml 작성 중..."

    set prompt "당신은 Turborepo 모노레포 패키지 설계 전문가입니다.
현재 디렉토리의 spec.yaml 파일을 읽고, 아래 정보를 바탕으로 모든 필드를 채워서 덮어쓰세요.

## 입력 정보
- 패키지 이름: $package_name
- 패키지 타입: $package_type
- 기능 설명: $package_description

## 각 필드 작성 규칙

name:
  - 반드시 @ 로 시작
  - 형식: @$package_type/$package_name

description:
  - 사용자 설명을 바탕으로 2~4줄로 상세하게 작성

structure:
  - $package_type 타입에 맞는 실제 폴더 구조
  - src/ 로 시작하고 / 로 끝날 것

$dependencies_guide

lib:
  - 이 기능 구현에 필요한 외부 npm 패키지만
  - workspace 패키지(@로 시작)는 절대 포함하지 말 것
  - 형식: \"패키지명: ^버전\"

rule:
  - 이 패키지 타입의 코드 작성 규칙 3~5개
  - 구체적이고 실행 가능한 규칙으로 작성

feature:
  - 빈 배열([])로 설정

## 주의사항
- spec.yaml 파일을 직접 덮어쓸 것
- YAML 문법을 정확히 지킬 것
- 없는 패키지를 임의로 만들지 말 것"

    codex "$prompt"

    if test $status -ne 0
        set_color red
        echo "❌ AI 작업 실패"
        set_color normal
        return 1
    end

    # ========================================
    # 7. 생성된 spec.yaml 확인 및 승인
    # ========================================
    echo ""
    echo "📋 생성된 spec.yaml:"
    echo "──────────────────────────────────────"
    cat spec.yaml
    echo "──────────────────────────────────────"
    echo ""

    read -P "이대로 진행하시겠습니까? (y/N) > " confirm
    if test "$confirm" != "y"
        set_color yellow
        echo "⚠️  중단됨. spec.yaml 수정 후 'create_package_json' 을 직접 실행하세요."
        set_color normal
        return 0
    end

    # ========================================
    # 8. package.json 생성 + 외부 라이브러리 설치
    # ========================================
    echo ""
    echo "📦 package.json 생성 중..."
    create_package_json

    if test $status -ne 0
        set_color red
        echo "❌ package.json 생성 실패"
        set_color normal
        return 1
    end

    # ========================================
    # 9. structure 폴더 실제 생성
    # ========================================
    echo ""
    echo "📁 폴더 구조 생성 중..."

    for dir in (yq '.structure[]' spec.yaml 2>/dev/null)
        mkdir -p $dir
        touch $dir/.gitkeep
        echo "   ✓ $dir"
    end

    # ========================================
    # 10. .agents/AGENTS.md 생성
    # ========================================
    mkdir -p .agents

    set pkg_name_yaml (yq '.name' spec.yaml 2>/dev/null)
    set structure_list (yq '.structure[]' spec.yaml 2>/dev/null | string join "\n")
    set rule_list (yq '.rule[]' spec.yaml 2>/dev/null | string join "\n- ")

    echo "# $pkg_name_yaml

## Context
$package_description

## 패키지 정보
- 타입: $package_type
- 위치: $target_dir

## 작성 규칙
- $rule_list

## 현재 구조
\`\`\`
$structure_list
\`\`\`

## 의존성
- workspace 패키지: \`dependencies\` in spec.yaml 참고
- 외부 라이브러리:  \`lib\` in spec.yaml 참고

## 예시 코드
(작업 시작 전 이 섹션에 예시를 추가하세요)
" > .agents/AGENTS.md

    set_color green
    echo "✅ .agents/AGENTS.md 생성"
    set_color normal

    # ========================================
    # 11. 완료
    # ========================================
    echo ""
    set_color green
    echo "🎉 패키지 초기화 완료!"
    set_color normal
    echo ""
    echo "생성된 파일:"
    echo "  ✓ spec.yaml"
    echo "  ✓ package.json"
    echo "  ✓ .agents/AGENTS.md"
    echo "  ✓ 폴더 구조"
    echo ""
    set_color cyan
    echo "다음 단계:"
    set_color normal
    echo "  1. vim .agents/AGENTS.md  # 작업 가이드 상세화"
    echo "  2. load_plan              # 기능 계획 시작"
    echo "  3. level_plan             # 의존성 분석"
    echo "  4. level_work             # 자동 구현"
end
