function tumnail --description 'Create a 1920x1080 video contact sheet on the Windows Desktop'
    if test (count $argv) -ne 1
        echo "usage: tumnail <video-file>" >&2
        return 2
    end

    set -l input $argv[1]
    if not test -f "$input"
        echo "tumnail: file not found: $input" >&2
        return 2
    end

    for cmd in ffprobe ffmpeg
        if not command -q $cmd
            echo "tumnail: required command not found: $cmd" >&2
            return 127
        end
    end

    set -l output_dir /mnt/c/users/tende/desktop
    if not test -d "$output_dir"
        echo "tumnail: output directory not found: $output_dir" >&2
        return 2
    end

    set -l duration (ffprobe -v error -show_entries format=duration -of default=nokey=1:noprint_wrappers=1 "$input")
    if test -z "$duration"; or not string match -qr '^[0-9]+(\.[0-9]+)?$' -- "$duration"
        echo "tumnail: could not read video duration: $input" >&2
        return 1
    end

    set -l base (path change-extension '' (path basename "$input"))
    set -l output "$output_dir/"$base"_thumbnail.jpg"
    set -l sample_rate (math "16 / max($duration, 1)")

    ffmpeg -hide_banner -loglevel error -y \
        -i "$input" \
        -vf "fps=$sample_rate,scale=480:270:force_original_aspect_ratio=increase,crop=480:270,tile=4x4,scale=1920:1080" \
        -frames:v 1 \
        "$output"

    set -l status_code $status
    if test $status_code -ne 0
        echo "tumnail: failed to create thumbnail sheet" >&2
        return $status_code
    end

    echo "$output"
end
