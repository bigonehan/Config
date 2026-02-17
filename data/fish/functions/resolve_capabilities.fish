# ============================================================
# resolve_capabilities
# capability_check.yaml 읽어서 분기 처리
# missing_all     → create_package_quick
# missing_feature → add_feature_to_domain
# exists          → impact_scope 추가
# ============================================================
function resolve_capabilities
    echo ""
    echo "📊 capability 분석 결과:"
    echo "──────────────────────────────────────"

    python3 -c "
import yaml

with open('/tmp/capability_check.yaml') as f:
    result = yaml.safe_load(f)

caps = result.get('capabilities', []) or []
for cap in caps:
    status  = cap.get('status', 'exists')
    domain  = cap.get('domain', '')
    port    = cap.get('port', '')
    adapter = cap.get('adapter', '')
    desc    = cap.get('description', '')
    print(f'{status}|{domain}|{port}|{adapter}|{desc}')
" | while read -l line

        set parts       (string split "|" $line)
        set cap_status  $parts[1]
        set cap_domain  $parts[2]
        set cap_port    $parts[3]
        set cap_adapter $parts[4]
        set cap_desc    $parts[5]

        switch $cap_status
            case "missing_all"
                set_color red
                echo "  ❌ [전체 없음] $cap_domain"
                echo "     Port:    $cap_port"
                echo "     Adapter: $cap_adapter"
                echo "     설명:    $cap_desc"
                set_color normal

                read -P "     생성하시겠습니까? (y/N): " do_create
                if test "$do_create" = "y"
                    create_package_quick $cap_domain "$cap_desc 도메인"
                    create_package_quick $cap_adapter "$cap_desc Adapter"
                    echo "  ✅ $cap_domain + $cap_adapter 생성 완료"
                end

            case "missing_feature"
                set_color yellow
                echo "  ⚠️  [기능 없음] $cap_domain 존재하지만 $cap_port 없음"
                echo "     설명: $cap_desc"
                set_color normal

                read -P "     Port를 추가하시겠습니까? (y/N): " do_add
                if test "$do_add" = "y"
                    add_feature_to_domain $cap_domain $cap_port "$cap_desc"
                    echo "  ✅ $cap_port → $cap_domain 추가 완료"
                end

            case "exists"
                set_color green
                echo "  ✅ [존재] $cap_domain ($cap_desc)"
                set_color normal

                # impact_scope에 자동 추가
                python3 -c "
import yaml
with open('plan.yaml', 'r') as f:
    plan = yaml.safe_load(f)
scope = plan.get('analysis', {}).get('impact_scope', []) or []
if '$cap_domain' not in scope:
    scope.append('$cap_domain')
    plan['analysis']['impact_scope'] = scope
with open('plan.yaml', 'w') as f:
    yaml.dump(plan, f, allow_unicode=True, default_flow_style=False, sort_keys=False)
" 2>/dev/null
        end

        echo ""
    end

    echo "──────────────────────────────────────"
end


