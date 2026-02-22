# ============================================================
# get_package_features
# 패키지명을 받아서 해당 spec.yaml의 feature 목록 반환
#
# 사용법: get_package_features "@domain/student"
# ============================================================
function get_package_features
    set pkg_name $argv[1]

    if test -z "$pkg_name"
        set_color red
        echo "❌ 패키지명 필수 (예: get_package_features @domain/student)"
        set_color normal
        return 1
    end

    # cwd 기준 jj 대상 경로 계산
    set jj_root (flow_resolve_jj_target_from_cwd (pwd))
    if test -z "$jj_root"
        return 0
    end

    # @domain/student → packages/domain/student
    set pkg_path (string replace "@" "packages/" $pkg_name)
    set spec_path "$jj_root/$pkg_path/spec.yaml"

    if not test -f "$spec_path"
        return 0
    end

    python3 -c "
import yaml
with open('$spec_path') as f:
    spec = yaml.safe_load(f)
features = spec.get('feature', []) or []
for feat in features:
    print(feat)
" 2>/dev/null
end
