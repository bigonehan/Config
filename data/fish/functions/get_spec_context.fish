# ============================================================
# get_spec_context
# spec.yaml에서 dependencies와 rule을 읽어서
# plan.yaml의 spec_context를 채움
# ============================================================
function get_spec_context
    if not test -f spec.yaml
        set_color red
        echo "❌ spec.yaml not found"
        set_color normal
        return 1
    end

    if not test -f plan.yaml
        set_color red
        echo "❌ plan.yaml not found"
        set_color normal
        return 1
    end

    python3 -c "
import yaml, sys

try:
    with open('spec.yaml', 'r') as f:
        spec = yaml.safe_load(f)
except Exception as e:
    print(f'❌ spec.yaml 읽기 실패: {e}', file=sys.stderr)
    sys.exit(1)

try:
    with open('plan.yaml', 'r') as f:
        plan = yaml.safe_load(f)
except Exception as e:
    print(f'❌ plan.yaml 읽기 실패: {e}', file=sys.stderr)
    sys.exit(1)

plan['spec_context']['available_packages'] = spec.get('dependencies', []) or []
plan['spec_context']['rules']              = spec.get('rule', []) or []

with open('plan.yaml', 'w') as f:
    yaml.dump(plan, f, allow_unicode=True, default_flow_style=False, sort_keys=False)

print('✅ spec_context 주입 완료')
" 2>&1

    if test $status -ne 0
        set_color red
        echo "❌ spec_context 주입 실패"
        set_color normal
        return 1
    end
end
