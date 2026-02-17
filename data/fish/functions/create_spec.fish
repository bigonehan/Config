function create_spec
    # 1. 템플릿 경로와 타겟 파일명 설정
    # (우리가 합의한 YAML 포맷을 기본값으로 사용합니다)
    set -l template_path "$HOME/ai/templates/spec.yaml"
    set -l target_file "spec.yaml"

    # 2. 템플릿 파일 존재 여부 확인
    if not test -f $template_path
        set_color red
        echo "❌ Error: Template not found!"
        echo "   Path: $template_path"
        set_color normal
        return 1
    end

    # 3. 현재 위치에 이미 파일이 있는지 확인 (덮어쓰기 방지)
    if test -f $target_file
        set_color yellow
        echo "⚠️  Warning: '$target_file' already exists in current directory."
        set_color normal
        
        read -P "   Overwrite it? (y/N) > " confirm
        if test "$confirm" != "y"
            echo "   Aborted."
            return 0
        end
    end

    # 4. 복사 실행
    cp "$template_path" "$target_file"

    set_color green
    echo "✅ Successfully initialized '$target_file'!"
    set_color normal
    
    # 5. (선택) 파일 내용 살짝 보여주기
    echo "----------------------------------------"
    head -n 5 $target_file
    echo "..."
    echo "----------------------------------------"
end
