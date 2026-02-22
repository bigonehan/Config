# ============================================================
# collect_features
# 기능명 + 시나리오 입력 루프 → plan.yaml features에 추가
# ============================================================
function collect_features
    set feature_count 0
    set max_features 5

    while true
        set feature_count (math $feature_count + 1)

        set_color yellow
        echo "── 기능 $feature_count 입력 ──────────────────────"
        set_color normal

        read -P "📌 기능명 (완료: 'done', 건너뛰기: 'pass'): " feature_name

        if test "$feature_name" = "done"
            if test $feature_count -eq 1
                set_color red
                echo "❌ 최소 1개 이상의 기능을 입력해야 합니다"
                set_color normal
                set feature_count 0
                continue
            end
            break
        end

        if test "$feature_name" = "pass"
            set_color yellow
            echo "⏭️  feature 입력을 건너뛰고 다음 단계로 진행합니다"
            set_color normal
            break
        end

        if test -z "$feature_name"
            set feature_count (math $feature_count - 1)
            continue
        end

        # 시나리오 입력
        set scenarios ""
        set scenario_count 0
        echo "   📝 시나리오 입력 ('end'로 종료)"

        while true
            set scenario_count (math $scenario_count + 1)
            read -P "   $scenario_count) " scenario

            if test "$scenario" = "end"
                break
            end

            if test -z "$scenario"
                set scenario_count (math $scenario_count - 1)
                continue
            end

            if test -z "$scenarios"
                set scenarios "$scenario"
            else
                set scenarios "$scenarios\n__SEP__$scenario"
            end
        end

        # plan.yaml features에 추가
        python3 -c "
import yaml

feature_name = '''$feature_name'''
scenarios_raw = '''$scenarios'''

scenarios = [s.strip() for s in scenarios_raw.split('__SEP__') if s.strip()] if scenarios_raw.strip() else []

with open('plan.yaml', 'r') as f:
    plan = yaml.safe_load(f)

if not plan['plan']['features']:
    plan['plan']['features'] = []

plan['plan']['features'].append({
    'name': feature_name,
    'scenarios': scenarios
})

with open('plan.yaml', 'w') as f:
    yaml.dump(plan, f, allow_unicode=True, default_flow_style=False, sort_keys=False)

print(f'   ✅ 기능 추가: {feature_name}')
"
        echo ""

        if test $feature_count -ge $max_features
            set_color yellow
            echo "⚠️  최대 $max_features 개 입력 완료"
            set_color normal
            break
        end

        read -P "➕ 기능 추가? (y/N): " add_more
        if test "$add_more" != "y"
            break
        end
        echo ""
    end
end
