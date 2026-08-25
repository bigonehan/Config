#!/usr/bin/env bash
set -euo pipefail

project_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
source_file="$project_root/data/fish/functions/notify.fish"
config_file="$project_root/data/fish/config.fish"

if [[ "${1:-}" == "runtime" ]]; then
  phase=${2:?phase is required}
  observation_path=${TEST_MANAGER_OBSERVATION_PATH:?TEST_MANAGER_OBSERVATION_PATH is required}
  runtime_log=$(mktemp /tmp/nf-confirmation-runtime.XXXXXX.log)
  loaded_source=$source_file

  if [[ "$phase" == "pre_fix" ]]; then
    mutant_dir=$(mktemp -d)
    loaded_source="$mutant_dir/notify.fish"
    sed \
      -e 's/Popup($message, 30, "Codex", 64)/Popup($message, 1, "Codex", 64)/' \
      -e 's/if ($result -ne 1 -and $result -ne -1) {/if ($result -ne 1) {/' \
      "$source_file" > "$loaded_source"
    chmod +x "$loaded_source"
  elif [[ "$phase" != "post_fix" ]]; then
    echo "phase must be pre_fix or post_fix" >&2
    exit 2
  fi

  set +e
  "$loaded_source" -m "nf confirmation runtime test" >"$runtime_log" 2>&1
  notify_exit=$?
  set -e

  source_hash=$(sha256sum "$source_file" | awk '{print $1}')
  if [[ "$phase" == "pre_fix" ]]; then
    outcome=failure
    test_exit=$([[ $notify_exit -ne 0 ]] && echo 1 || echo 0)
  else
    outcome=$([[ $notify_exit -eq 0 ]] && echo success || echo failure)
    test_exit=$notify_exit
  fi

  python3 - "$observation_path" "$phase" "$outcome" "$source_file" "$source_hash" "$runtime_log" "$notify_exit" <<'PY'
import json
import sys

path, phase, outcome, source, digest, runtime_log, notify_exit = sys.argv[1:]
with open(path, "w", encoding="utf-8") as handle:
    json.dump({
        "scenario_id": "nf-30-second-default-20260816",
        "phase": phase,
        "outcome": outcome,
        "observation_level": "runtime",
        "runtime": "Windows WScript.Shell popup invoked from WSL",
        "user_action": "run nf and either press confirmation or leave the popup unanswered for 30 seconds",
        "observed_consumer": "nf process exit code after the real Windows WScript.Shell popup",
        "mocked": False,
        "loaded_artifacts": [{"path": source, "sha256": digest}],
        "runtime_logs": [runtime_log],
        "uncaught_errors": [],
        "unobserved_layers": [],
        "details": {"notify_exit": int(notify_exit)},
    }, handle, ensure_ascii=False, indent=2)
PY
  exit "$test_exit"
fi

grep -Fq '$popup.Popup($message, 30, "Codex", 64)' "$source_file"
grep -Fq 'if ($result -ne 1 -and $result -ne -1)' "$source_file"

test_bin=$(mktemp -d)
trap 'rm -rf -- "$test_bin"' EXIT

cat > "$test_bin/powershell.exe" <<'EOF'
#!/usr/bin/env bash
joined="$*"
[[ "$joined" == *'$popup.Popup($message, 30, "Codex", 64)'* ]]
[[ "$joined" == *'if ($result -ne 1 -and $result -ne -1)'* ]]
EOF
chmod +x "$test_bin/powershell.exe"

PATH="$test_bin:$PATH" "$project_root/data/fish/functions/notify.fish" -m "확인 기반 알림"

tmux_log=$(mktemp)
cat > "$test_bin/tmux" <<'EOF'
#!/usr/bin/env bash
if [[ "${1:-}" == "display-message" ]]; then
  exit 0
fi
if [[ "${1:-}" == "send-keys" ]]; then
  printf '%s\n' "$*" >> "${NF_AUTO_TMUX_LOG:?}"
  exit 0
fi
exit 2
EOF
cat > "$test_bin/setsid" <<'EOF'
#!/usr/bin/env bash
[[ "${1:-}" == "-f" ]]
shift
exec "$@"
EOF
chmod +x "$test_bin/tmux" "$test_bin/setsid"

NF_AUTO_CONFIG_FILE="$config_file" \
NF_AUTO_TMUX_LOG="$tmux_log" \
TMUX_PANE='%77' \
PATH="$test_bin:$PATH" \
fish -c 'source "$NF_AUTO_CONFIG_FILE"; nf_auto --delay 0 -m "Plan 선택"'

[[ $(wc -l < "$tmux_log") -eq 1 ]]
grep -Fxq 'send-keys -t %77 C-m' "$tmux_log"

set +e
env -u TMUX_PANE \
  NF_AUTO_CONFIG_FILE="$config_file" \
  PATH="$test_bin:$PATH" \
  fish -c 'source "$NF_AUTO_CONFIG_FILE"; nf_auto --delay 0 -m "Plan 선택"' \
  >/dev/null 2>&1
missing_pane_status=$?
set -e
[[ $missing_pane_status -ne 0 ]]

if [[ -n "${TEST_MANAGER_OBSERVATION_PATH:-}" ]]; then
  printf '%s\n' '{"scenario_id":"nf-auto-plan-enter-20260816","requirement_ids":["req-nf-auto-plan-enter"],"phase":"unit","outcome":"success","observation_level":"unit","runtime":"Fish function with fake notification and tmux command boundaries","user_action":"Codex emits a proposed_plan final and invokes nf_auto from its tmux pane","observed_consumer":"nf_auto captures TMUX_PANE, preserves notification failure, and schedules one C-m with a five-second default","mocked":true,"details":{"default_delay_seconds":5,"send_keys_count":1,"target":"%77","key":"C-m"}}' > "$TEST_MANAGER_OBSERVATION_PATH"
fi
