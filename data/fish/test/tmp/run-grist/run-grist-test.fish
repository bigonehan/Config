set -l task_dir (path resolve (path dirname (status filename)))
set -l project_root (path resolve "$task_dir/../../..")
set -l active_function /home/tree/.config/fish/functions/run_grist.fish
set -l temp_dir (mktemp -d)
set -gx RUN_GRIST_TEST_LOG "$temp_dir/npm.log"

function cleanup --on-event fish_exit --inherit-variable temp_dir
    rm -rf -- "$temp_dir"
end

ln -s "$task_dir/fake-npm" "$temp_dir/npm"
set -gx PATH "$temp_dir" $PATH

fish -n "$project_root/functions/run_grist.fish"
or exit 1

cmp -s "$project_root/functions/run_grist.fish" "$active_function"
or begin
    echo 'source and active run_grist functions differ' >&2
    exit 1
end

source "$project_root/functions/run_grist.fish"
run_grist
or exit 1

set -l actual (sort "$RUN_GRIST_TEST_LOG" | string collect)
set -l expected (string join \n -- \
    '--prefix /home/tree/extensions/grist_concept_list run dev -- --port 5196' \
    '--prefix /home/tree/extensions/grist_video_maker run dev -- --port 5195' \
    | string collect)

if test "$actual" != "$expected"
    echo 'unexpected npm calls:' >&2
    printf '%s\n' $actual >&2
    exit 1
end

if run_grist unexpected >/dev/null 2>&1
    echo 'run_grist accepted unexpected arguments' >&2
    exit 1
end

if set -q TEST_MANAGER_OBSERVATION_PATH
    set -l scenario_id RUN-GRIST-TWO-SERVERS-1
    set -l observed_consumer 'fish loads run_grist and a stub npm consumer receives the two expected project and port argument sets'
    if test "$RUN_GRIST_SCENARIO" = RUN-GRIST-TWO-SERVERS-2
        set scenario_id RUN-GRIST-TWO-SERVERS-2
    end

    printf '%s\n' \
        "{\"scenario_id\":\"$scenario_id\",\"requirement_ids\":[\"RUN-GRIST-TWO-SERVERS\"],\"phase\":\"unit\",\"outcome\":\"success\",\"observation_level\":\"unit\",\"runtime\":\"fish mock-boundary test\",\"user_action\":\"run run_grist in fish\",\"unit_observation\":\"fish loads run_grist and a stub npm consumer receives the two expected project and port argument sets\",\"observed_consumer\":\"$observed_consumer\",\"mocked\":true,\"entry_stage\":\"fish function invocation\",\"original_input\":{\"source_kind\":\"user_action\",\"source_ref\":\"/home/tree/Config/data/fish/Input.md\",\"value_type\":\"utf-8 text\",\"byte_length\":188,\"sha256\":\"e1472581c72f33a437fb42e445c2e2d85dad5e81568ebe1b5445f547f662a1de\"},\"substitutions\":[{\"component\":\"npm and Vite listeners\",\"stage\":\"child process consumer\",\"reason\":\"project rule prohibits automatically starting development servers\"}]}" \
        > "$TEST_MANAGER_OBSERVATION_PATH"
end

echo 'run_grist fish boundary test passed'
