#!/bin/bash

# ===== 설정 =====
SOURCE_DIR="$HOME/.config"
TARGET_DIR="$HOME/config/data"
CONFIG_FILE="$HOME/.config_manager_settings"
TEMP_SELECTION="/tmp/config_selection_$$"

# Gum 스타일 설정
export GUM_CHOOSE_CURSOR_FOREGROUND="212"
export GUM_CHOOSE_SELECTED_FOREGROUND="212"
export GUM_CONFIRM_PROMPT_FOREGROUND="212"

# ===== 함수 정의 =====

# 타이틀 표시
show_title() {
    clear
    gum style \
        --foreground 212 --border-foreground 212 --border double \
        --align center --width 60 --margin "1 2" --padding "2 4" \
        '📁 CONFIG FOLDER MANAGER' \
        'Move .config folders to ~/config/data'
    echo ""
}

# 설정 파일 로드
load_settings() {
    if [ -f "$CONFIG_FILE" ]; then
        # 설정 파일에서 제외 폴더 목록 읽기
        if [ -f "$CONFIG_FILE" ]; then
            mapfile -t EXCLUDED_FOLDERS < "$CONFIG_FILE"
        fi
        return 0
    fi
    return 1
}

# 설정 파일 저장
save_settings() {
    local folders="$1"
    echo "$folders" > "$CONFIG_FILE"
    gum style --foreground 155 "✓ 설정이 저장되었습니다."
}

# 폴더 목록 가져오기
get_folders() {
    find "$SOURCE_DIR" -maxdepth 1 -type d ! -path "$SOURCE_DIR" -exec basename {} \; | sort
}

# 제외할 폴더 선택
select_excluded_folders() {
    local all_folders=$(get_folders)
    
    gum style --foreground 226 "📝 이동하지 않을 폴더를 선택하세요 (Space로 다중 선택)"
    echo ""
    
    # 이전 설정이 있으면 표시
    if [ ${#EXCLUDED_FOLDERS[@]} -gt 0 ]; then
        gum style --foreground 99 "이전 설정에서 제외된 폴더: ${EXCLUDED_FOLDERS[*]}"
        echo ""
    fi
    
    # 다중 선택 (제외할 폴더 선택)
    local excluded=$(echo "$all_folders" | gum choose --no-limit --height 15 \
        --header "제외할 폴더 선택 (Space: 선택, Enter: 완료)")
    
    echo "$excluded"
}

# 이동할 폴더 미리보기
preview_move() {
    local excluded="$1"
    local all_folders=$(get_folders)
    
    echo ""
    gum style --foreground 212 --bold "📋 이동 계획:"
    echo ""
    
    # 이동할 폴더와 제외할 폴더 분류
    local move_folders=()
    local skip_folders=()
    
    while IFS= read -r folder; do
        if echo "$excluded" | grep -q "^$folder$"; then
            skip_folders+=("$folder")
        else
            move_folders+=("$folder")
        fi
    done <<< "$all_folders"
    
    # 이동할 폴더 표시
    if [ ${#move_folders[@]} -gt 0 ]; then
        gum style --foreground 155 "✓ 이동할 폴더 (${#move_folders[@]}개):"
        for folder in "${move_folders[@]}"; do
            echo "  → $folder"
        done
    fi
    
    echo ""
    
    # 제외할 폴더 표시
    if [ ${#skip_folders[@]} -gt 0 ]; then
        gum style --foreground 214 "⊘ 제외할 폴더 (${#skip_folders[@]}개):"
        for folder in "${skip_folders[@]}"; do
            echo "  × $folder"
        done
    fi
    
    echo ""
}

# 폴더 이동 실행
execute_move() {
    local excluded="$1"
    local all_folders=$(get_folders)
    local success_count=0
    local skip_count=0
    
    # 타겟 디렉토리 생성
    mkdir -p "$TARGET_DIR"
    
    echo ""
    gum style --foreground 212 "🚀 폴더 이동 시작..."
    echo ""
    
    while IFS= read -r folder; do
        if echo "$excluded" | grep -q "^$folder$"; then
            gum style --foreground 214 "⊘ 제외: $folder"
            skip_count=$((skip_count + 1))
        else
            # 이동 실행
            if [ -e "$TARGET_DIR/$folder" ]; then
                gum style --foreground 196 "⚠ 이미 존재: $folder"
            else
                if mv "$SOURCE_DIR/$folder" "$TARGET_DIR/" 2>/dev/null; then
                    gum style --foreground 155 "✓ 이동 완료: $folder"
                    success_count=$((success_count + 1))
                else
                    gum style --foreground 196 "✗ 이동 실패: $folder"
                fi
            fi
        fi
    done <<< "$all_folders"
    
    echo ""
    gum style --foreground 212 --border rounded --padding "1 2" \
        "완료: 이동 $success_count개, 제외 $skip_count개"
}

# 심볼릭 링크 생성
create_symlinks() {
    echo ""
    if gum confirm "호환성을 위해 심볼릭 링크를 생성하시겠습니까?"; then
        local count=0
        for dir in "$TARGET_DIR"/*; do
            if [ -d "$dir" ]; then
                local basename=$(basename "$dir")
                if [ ! -e "$SOURCE_DIR/$basename" ]; then
                    ln -s "$dir" "$SOURCE_DIR/$basename" 2>/dev/null
                    if [ $? -eq 0 ]; then
                        count=$((count + 1))
                    fi
                fi
            fi
        done
        gum style --foreground 155 "✓ $count개의 심볼릭 링크가 생성되었습니다."
    fi
}

# 메인 로직
main() {
    show_title
    
    # 설정 로드
    EXCLUDED_FOLDERS=()
    local has_settings=false
    if load_settings; then
        has_settings=true
        gum style --foreground 99 "📌 저장된 설정을 찾았습니다."
        echo ""
        
        if gum confirm "이전 설정을 사용하시겠습니까?"; then
            # 이전 설정 사용
            excluded_list=$(printf "%s\n" "${EXCLUDED_FOLDERS[@]}")
            preview_move "$excluded_list"
            
            if gum confirm "이대로 진행하시겠습니까?"; then
                gum spin --spinner dots --title "폴더 이동 중..." -- sleep 1
                execute_move "$excluded_list"
                create_symlinks
                exit 0
            fi
        fi
    fi
    
    # 새로운 설정 또는 재선택
    while true; do
        show_title
        
        # 폴더가 있는지 확인
        if [ ! -d "$SOURCE_DIR" ] || [ -z "$(get_folders)" ]; then
            gum style --foreground 196 "⚠ $SOURCE_DIR에 이동할 폴더가 없습니다."
            exit 1
        fi
        
        # 제외할 폴더 선택
        excluded_list=$(select_excluded_folders)
        
        # 미리보기
        preview_move "$excluded_list"
        
        # 확인
        echo ""
        choice=$(gum choose --height 5 \
            "✅ 전달하기" \
            "🔄 다시 선택" \
            "❌ 취소")
        
        case "$choice" in
            "✅ 전달하기")
                # 설정 저장 확인
                echo ""
                if gum confirm "이 설정을 저장하시겠습니까? (다음에 재사용)"; then
                    save_settings "$excluded_list"
                fi
                
                # 이동 실행
                echo ""
                gum spin --spinner dots --title "폴더 이동 중..." -- sleep 1
                execute_move "$excluded_list"
                
                # 심볼릭 링크 생성 옵션
                create_symlinks
                
                echo ""
                gum style --foreground 155 --bold "✨ 작업이 완료되었습니다!"
                break
                ;;
            
            "🔄 다시 선택")
                continue
                ;;
            
            "❌ 취소")
                gum style --foreground 196 "작업이 취소되었습니다."
                exit 0
                ;;
        esac
    done
}

# 종료 시 임시 파일 삭제
trap "rm -f $TEMP_SELECTION" EXIT

# 스크립트 실행
main
