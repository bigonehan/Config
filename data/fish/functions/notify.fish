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
    set -lx NF_MESSAGE "$MESSAGE"

    # Use a detached PowerShell process to show a Windows balloon notification.
    powershell.exe -NoProfile -NonInteractive -Command '
$script = "Add-Type -AssemblyName System.Windows.Forms; Add-Type -AssemblyName System.Drawing; $n=New-Object System.Windows.Forms.NotifyIcon; $n.Icon=[System.Drawing.SystemIcons]::Information; $n.BalloonTipTitle=\"Codex\"; $n.BalloonTipText=$env:NF_MESSAGE; $n.Visible=$true; $n.ShowBalloonTip(4000); Start-Sleep -Seconds 5; $n.Dispose()"
Start-Process -WindowStyle Hidden powershell.exe -ArgumentList @("-NoProfile","-NonInteractive","-Command",$script) | Out-Null
' >/dev/null 2>/dev/null

    if test $status -eq 0
        exit 0
    end

    # Fallback for environments where balloon notification cannot be created.
    powershell.exe -NoProfile -NonInteractive -Command "msg * \"$MESSAGE\"" >/dev/null 2>/dev/null
    exit $status
end

echo "nf: powershell.exe not found" >&2
exit 1
