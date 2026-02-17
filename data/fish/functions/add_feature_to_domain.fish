# ============================================================
# add_feature_to_domain
# 도메인은 있지만 기능이 없는 경우
# spec.yaml의 rule에 필요한 Port 인터페이스 추가
# ============================================================
function add_feature_to_domain
    set pkg_name  $argv[1]   # 예: @domain/student
    set port_name $argv[2]   # 예: IGetGradePort
    set port_desc $argv[3]   # 예: "학생 성적 조회 Port"

    set jj_root (jj root 2>/dev/null)

    set pkg_type  (string replace "@" "" (string split "/" $pkg_name)[1])
    set pkg_short (string split "/" $pkg_name)[2]
    set spec_path "$jj_root/packages/$pkg_type/$pkg_short/spec.yaml"

    if not test -f "$spec_path"
        set_color red
        echo "❌ spec.yaml 없음: $spec_path"
        set_color normal
        return 1
    end

    # spec.yaml의 rule에 Port 추가
    python3 -c "
import yaml

with open('$spec_path', 'r') as f:
    spec = yaml.safe_load(f)

rule = spec.get('rule', []) or []
new_rule = '$port_name: $port_desc'

if new_rule not in rule:
    rule.append(new_rule)
    spec['rule'] = rule

with open('$spec_path', 'w') as f:
    yaml.dump(spec, f, allow_unicode=True, default_flow_style=False, sort_keys=False)

print('✅ $port_name → $pkg_name 에 추가됨')
" 2>&1
end

