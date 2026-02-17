# ============================================================
# level_start
# 진입점 함수
# 1. 프로젝트 폴더명 입력 → 폴더 생성 → 이동
# 2. jj repo 확인 및 생성
# 3. 현재 상태 감지 → 적절한 단계부터 시작
#
# 사용법:
#   level_start   # 어디서든 실행
# ============================================================
function level_start
    set_color cyan
    echo "╔══════════════════════════════════════╗"
    echo "║           level_start                ║"
    echo "╚══════════════════════════════════════╝"
    set_color normal
    echo ""

    # ========================================
    # 1. 프로젝트 폴더 생성 및 이동
    # ========================================
    read -P "📁 프로젝트 폴더명 (현재 폴더 사용: '.'): " project_name
    set init_package_name ""

    if test "$project_name" != "."
        if test -z "$project_name"
            set_color red
            echo "❌ 폴더명을 입력하세요"
            set_color normal
            return 1
        end

        if test -d "$project_name"
            set_color yellow
            echo "⚠️  이미 존재하는 폴더: $project_name"
            set_color normal
            read -P "   기존 폴더로 이동하시겠습니까? (y/N): " use_existing
            if test "$use_existing" != "y"
                return 1
            end
        else
            mkdir -p $project_name
            set_color green
            echo "✅ 폴더 생성: $project_name"
            set_color normal
        end

        cd $project_name
        set init_package_name $project_name
    end

    echo "📍 현재 위치: "(pwd)
    echo ""

    # ========================================
    # 2. jj repo 확인 및 생성
    # ========================================
    jj root 2>/dev/null 1>/dev/null
    if test $status -ne 0
        set_color yellow
        echo "⚠️  jj 저장소가 없습니다"
        set_color normal
        echo ""
        read -P "현재 위치에 jj 저장소를 생성하시겠습니까? (y/N): " init_jj

        if test "$init_jj" != "y"
            set_color red
            echo "❌ jj 저장소 없이는 진행할 수 없습니다"
            echo "   jj git init --colocate 으로 직접 생성하세요"
            set_color normal
            return 1
        end

        jj git init --colocate

        if test $status -ne 0
            set_color red
            echo "❌ jj 저장소 생성 실패"
            set_color normal
            return 1
        end

        set_color green
        echo "✅ jj 저장소 생성 완료: "(jj root)
        set_color normal
        echo ""
    else
        echo "✅ jj 저장소 확인: "(jj root)
        echo ""
    end

    # ========================================
    # 3. 현재 상태 감지
    # ========================================
    set has_spec (test -f spec.yaml; and echo "true"; or echo "false")
    set has_task (test -f task.yaml; and echo "true"; or echo "false")

    echo "현재 상태:"
    echo "  spec.yaml : $has_spec"
    echo "  task.yaml : $has_task"
    echo ""

    # ========================================
    # 4. 패키지 초기화 (spec.yaml 없을 때)
    # ========================================
    if test "$has_spec" = "false"
        set_color yellow
        echo "📦 spec.yaml 없음 → level_init 시작"
        set_color normal
        echo ""

        if test -n "$init_package_name"
            level_init $init_package_name
        else
            level_init
        end
        if test $status -ne 0
            set_color red
            echo "❌ level_init 실패"
            set_color normal
            return 1
        end

        echo ""
        echo "──────────────────────────────────────"
        cat spec.yaml
        echo "──────────────────────────────────────"
        echo ""
        read -P "✅ spec.yaml 확인 완료. 계속하시겠습니까? (y/N): " go
        if test "$go" != "y"
            set_color yellow
            echo "⏸  중단됨. 다시 시작하려면 level_start 를 실행하세요."
            set_color normal
            return 0
        end
    end

    # ========================================
    # 5. 계획 수립 (task.yaml 없을 때)
    # ========================================
    if test "$has_task" = "false"
        set_color yellow
        echo "📋 task.yaml 없음 → level_plan 시작"
        set_color normal
        echo ""

        level_plan
        if test $status -ne 0
            set_color red
            echo "❌ level_plan 실패"
            set_color normal
            return 1
        end

        echo ""
        echo "──────────────────────────────────────"
        cat task.yaml
        echo "──────────────────────────────────────"
        echo ""
        read -P "✅ task.yaml 확인 완료. 실행하시겠습니까? (y/N): " go
        if test "$go" != "y"
            set_color yellow
            echo "⏸  중단됨. task.yaml 수정 후 level_start 를 다시 실행하세요."
            set_color normal
            return 0
        end
    end

    # ========================================
    # 6. 실행
    # ========================================
    set_color yellow
    echo "⚙️  level_work 시작"
    set_color normal
    echo ""

    level_work
    if test $status -ne 0
        set_color red
        echo "❌ level_work 실패"
        echo "   수정 후 level_start 를 다시 실행하면 level_work부터 재시작합니다."
        set_color normal
        return 1
    end

    # ========================================
    # 7. 피드백
    # ========================================
    set_color yellow
    echo "📝 level_feedback 시작"
    set_color normal
    echo ""

    level_feedback
    if test $status -ne 0
        set_color red
        echo "❌ level_feedback 실패"
        set_color normal
        return 1
    end

    # ========================================
    # 완료
    # ========================================
    echo ""
    set_color green
    echo "╔══════════════════════════════════════╗"
    echo "║        🎉 모든 단계 완료!             ║"
    echo "╚══════════════════════════════════════╝"
    set_color normal
    echo ""
    echo "  jj log          # 작업 히스토리 확인"
    echo "  cat spec.yaml   # 업데이트된 feature 확인"
end
