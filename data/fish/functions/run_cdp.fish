function run_cdp --description 'Launch WSL Chromium with a verified CDP endpoint'
    argparse \
        'p/port=' \
        'd/data-dir=' \
        'b/browser=' \
        'e/extension=' \
        'headless' \
        'no-extension' \
        'h/help' \
        -- $argv
    or return 2

    if set -q _flag_help
        echo 'Usage: run_cdp [-p PORT] [-d DATA_DIR] [-b BROWSER] [-e EXTENSION] [--headless] [--no-extension]'
        return 0
    end

    set -l port 9222
    set -l data_dir /home/tree/.config/jw-stagehand-chromium-cdp
    set -l extension_path /mnt/h/code/jw_downloader
    set -l browser_path /home/tree/.cache/ms-playwright/chromium-1243/chrome-linux64/chrome

    if set -q _flag_port
        set port $_flag_port
    end
    if set -q _flag_data_dir
        set data_dir $_flag_data_dir
    end
    if set -q _flag_extension
        set extension_path $_flag_extension
    end
    if set -q _flag_browser
        set browser_path $_flag_browser
    else if not test -x $browser_path
        set browser_path (command -v google-chrome-stable; or command -v chromium; or true)
    end

    if not string match --quiet --regex '^[0-9]+$' -- $port
        echo "run_cdp: invalid port: $port" >&2
        return 2
    end
    if test -z "$browser_path"; or not test -x $browser_path
        echo 'run_cdp: executable browser not found' >&2
        return 1
    end

    set -l endpoint "http://127.0.0.1:$port"
    set -l version_url "$endpoint/json/version"

    # This function owns the dedicated WSL profile. Close every Chrome process
    # carrying this exact profile before starting a fresh CDP session.
    set -l profile_pids
    for process in (ps -eo pid=,args=)
        set -l fields (string split -m 1 ' ' (string trim -- $process))
        set -l process_pid $fields[1]
        set -l process_args $fields[2]
        if test -n "$process_pid"; and test "$process_pid" != "$fish_pid"; and string match --quiet "*--user-data-dir=$data_dir*" -- "$process_args"
            set -a profile_pids $process_pid
        end
    end

    if test (count $profile_pids) -gt 0
        echo "run_cdp: closing existing profile processes: $data_dir"
        command kill -TERM $profile_pids 2>/dev/null
        for attempt in (seq 1 10)
            set -l remaining
            for process_pid in $profile_pids
                if command kill -0 $process_pid 2>/dev/null
                    set -a remaining $process_pid
                end
            end
            test (count $remaining) -eq 0; and break
            sleep 0.2
        end

        set -l remaining
        for process_pid in $profile_pids
            if command kill -0 $process_pid 2>/dev/null
                set -a remaining $process_pid
            end
        end
        if test (count $remaining) -gt 0
            echo "run_cdp: force-closing remaining profile processes: $data_dir"
            command kill -KILL $remaining 2>/dev/null
            sleep 0.2
        end
    end

    set -l version_response (command curl --fail --silent --show-error --max-time 1 $version_url 2>/dev/null)
    if test $status -eq 0; and string match --quiet '*webSocketDebuggerUrl*' -- "$version_response"
        echo "run_cdp: CDP endpoint is still occupied after cleanup: $endpoint" >&2
        return 1
    end

    command mkdir -p $data_dir
    or return 1

    set -l browser_args \
        --remote-debugging-address=127.0.0.1 \
        --remote-debugging-port=$port \
        '--remote-allow-origins=*' \
        --user-data-dir=$data_dir \
        --no-first-run \
        --no-default-browser-check \
        --disable-dev-shm-usage \
        --no-sandbox \
        about:blank

    if not set -q _flag_no_extension; and test -f $extension_path/manifest.json
        set browser_args \
            --load-extension=$extension_path \
            --disable-extensions-except=$extension_path \
            $browser_args
    end
    if set -q _flag_headless
        set browser_args --headless=new $browser_args
    end

    set -l log_path "/tmp/run_cdp-$port.log"
    # Keep the launcher process attached to this function so the command stays
    # alive until the owned browser exits.  `setsid -f` would fork away and
    # make `$last_pid` refer to a short-lived launcher instead of Chrome.
    command setsid $browser_path $browser_args >$log_path 2>&1 &
    set -l browser_pid $last_pid
    set -g _run_cdp_browser_pid $browser_pid
    trap 'if test -n "$_run_cdp_browser_pid"; and command kill -0 $_run_cdp_browser_pid 2>/dev/null; command kill -TERM $_run_cdp_browser_pid 2>/dev/null; end' INT TERM

    for attempt in (seq 1 20)
        sleep 0.5
        if not command kill -0 $browser_pid 2>/dev/null
            echo "run_cdp: browser exited before CDP became ready; log=$log_path" >&2
            return 1
        end
        set version_response (command curl --fail --silent --show-error --max-time 1 $version_url 2>/dev/null)
        if test $status -eq 0; and string match --quiet '*webSocketDebuggerUrl*' -- "$version_response"
            echo "run_cdp: ready pid=$browser_pid endpoint=$endpoint"
            echo "$version_response" | string match --regex '"Browser"[[:space:]]*:[[:space:]]*"[^"]+"'
            echo "run_cdp: waiting for Chrome pid=$browser_pid; interrupt to stop this session"
            wait $browser_pid
            set -l wait_status $status
            if test $wait_status -ne 0; and command kill -0 $browser_pid 2>/dev/null
                echo "run_cdp: stopping interrupted Chrome pid=$browser_pid" >&2
                command kill -TERM $browser_pid 2>/dev/null
                wait $browser_pid 2>/dev/null
            end
            trap - INT TERM
            set -e -g _run_cdp_browser_pid
            return $wait_status
        end
    end

    if command kill -0 $browser_pid 2>/dev/null
        command kill -TERM $browser_pid 2>/dev/null
        wait $browser_pid 2>/dev/null
    end
    trap - INT TERM
    set -e -g _run_cdp_browser_pid
    echo "run_cdp: CDP did not become ready at $endpoint; log=$log_path" >&2
    return 1
end
