# ============================================================
# init_plan_yaml
# 템플릿 복사 + spec_context 주입 + current_location 주입
# ============================================================
function init_plan_yaml
    set template_path "$HOME/ai/templates/plan.yaml"

    if not test -f $template_path
        set_color red
        echo "❌ 템플릿 없음: $template_path"
        set_color normal
        return 1
    end

    cp $template_path ./plan.yaml
    echo "✅ plan.yaml 템플릿 복사 완료"

    # spec_context 주입
    get_spec_context
    if test $status -ne 0
        return 1
    end

    # current_location 주입
    set current_location (python3 -c "
import yaml
with open('spec.yaml') as f:
    spec = yaml.safe_load(f)
print(spec.get('name', ''))
" 2>/dev/null)

    python3 -c "
import yaml
with open('plan.yaml', 'r') as f:
    plan = yaml.safe_load(f)
plan['spec_context']['current_location'] = '$current_location'
with open('plan.yaml', 'w') as f:
    yaml.dump(plan, f, allow_unicode=True, default_flow_style=False, sort_keys=False)
"
    echo "✅ spec_context 주입 완료"
    echo ""
end
