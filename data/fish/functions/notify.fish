#!/usr/bin/env fish

set MESSAGE "Build completed!"

argparse m= -- $argv
or begin
    echo 'Usage: notify.fish -m "message"'
    exit 1
end

if set -q _flag_m
    set MESSAGE $_flag_m
end

if type -q powershell.exe
    if not type -q base64
        echo "nf: base64 not found" >&2
        exit 1
    end
    set encoded_message (printf '%s' "$MESSAGE" | base64 -w 0)
    or begin
        echo "nf: message encoding failed" >&2
        exit 1
    end

    # Base64 is safe to embed in the fixed script template and preserves Unicode across WSL.
    set powershell_script '
 $ErrorActionPreference = "Stop";
$EncodedMessage = "__NF_ENCODED_MESSAGE__";
$message = [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($EncodedMessage));
$popup = New-Object -ComObject WScript.Shell -ErrorAction Stop;
$result = $popup.Popup($message, 15, "Codex", 64);
if ($result -ne 1 -and $result -ne -1) {
    throw "Unexpected popup result: $result";
}
'
    set powershell_script (string replace '__NF_ENCODED_MESSAGE__' "$encoded_message" -- "$powershell_script")
    powershell.exe -NoProfile -NonInteractive -Command "$powershell_script"
    set delivery_status $status
    if test $delivery_status -ne 0
        echo "nf: Windows popup delivery failed (exit $delivery_status)" >&2
    end
    exit $delivery_status
end

echo "nf: powershell.exe not found" >&2
exit 1
