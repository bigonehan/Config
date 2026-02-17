# ============================================================
# analyze_task_priority
# plan.yaml의 tasks를 읽어서 wave 계산
# 결과: /tmp/task_waves.yaml
#
# wave 계산 기준:
#   type: domain → wave 1 (항상 먼저)
#   related_features 동일 → 같은 wave 후보
#   target 충돌 없으면 → 병렬 가능
# ============================================================
function analyze_task_priority
    echo ""
    echo "📊 task 우선순위 분석 중..."

    if not test -f plan.yaml
        set_color red
        echo "❌ plan.yaml 없음"
        set_color normal
        return 1
    end

    python3 -c "
import yaml, json

with open('plan.yaml') as f:
    plan = yaml.safe_load(f)

tasks = plan.get('tasks', []) or []

# Wave 계산
# - domain 타입은 wave 1
# - 같은 target을 가진 task는 순차 (충돌 방지)
# - 나머지는 wave 2+ 에서 병렬 가능

waves = {}
target_seen = {}   # target → wave 번호 추적
task_wave   = {}   # task id → wave 번호

for task in tasks:
    tid    = task.get('id', '')
    ttype  = task.get('type', 'feat')
    target = task.get('target', '')

    if ttype == 'domain':
        wave = 1
    elif target in target_seen:
        # 같은 target이면 이전 wave + 1 (순차)
        wave = target_seen[target] + 1
    else:
        wave = 2

    target_seen[target] = wave
    task_wave[tid] = wave

    if wave not in waves:
        waves[wave] = []
    waves[wave].append(task)

# 결과 출력
result = {
    'waves': []
}

for wave_num in sorted(waves.keys()):
    wave_tasks = waves[wave_num]
    parallel   = len(wave_tasks) > 1

    result['waves'].append({
        'wave':     wave_num,
        'parallel': parallel,
        'tasks':    wave_tasks
    })

with open('/tmp/task_waves.yaml', 'w') as f:
    yaml.dump(result, f, allow_unicode=True, default_flow_style=False, sort_keys=False)

# 결과 출력
for wave in result['waves']:
    mode = '병렬' if wave['parallel'] else '순차'
    print(f\"  Wave {wave['wave']} [{mode}]\")
    for t in wave['tasks']:
        print(f\"    - {t['id']}: {t['name']} → {t.get('target', '')}\")
"

    if test $status -ne 0
        set_color red
        echo "❌ task 우선순위 분석 실패"
        set_color normal
        return 1
    end

    echo "✅ task_waves.yaml 생성 완료"
end
