function resize500 --description 'Resize jpg/png files in the current directory to 500x500 into a target path'
    if test (count $argv) -ne 1
        echo 'Usage: resize500 <output-path>' >&2
        return 2
    end

    set -l output_path $argv[1]
    mkdir -p -- $output_path
    or return $status

    set -l files (path filter -f -- *.jpg *.jpeg *.png 2>/dev/null)
    if test (count $files) -eq 0
        echo 'resize500: no jpg/png files found in current directory' >&2
        return 1
    end

    magick mogrify -path $output_path -resize '500x500!' $files
end
