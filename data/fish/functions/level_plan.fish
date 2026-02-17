# ============================================================
# level_plan
# 오케스트레이터
# ============================================================
function level_plan
    set_color cyan
    echo "📋 plan.yaml 작성을 시작합니다"
    set_color normal
    echo ""

    init_plan_yaml
    if test $status -ne 0; return 1; end

    collect_features
    if test $status -ne 0; return 1; end

    analyze_capabilities
    if test $status -ne 0; return 1; end

    resolve_capabilities
    if test $status -ne 0; return 1; end

    generate_tasks
    if test $status -ne 0; return 1; end

    echo ""
    set_color green
    echo "🎉 plan.yaml 작성 완료!"
    set_color normal
    echo ""
    set_color cyan
    echo "다음 단계:"
    set_color normal
    echo "  level_work  # task.yaml 생성 + 실행"
end
