#!/bin/bash

# WSL Arch 설정을 Docker 이미지용으로 저장하는 스크립트

BACKUP_DIR="./docker-interview-setup"
mkdir -p "$BACKUP_DIR/dotfiles"

echo "🔍 WSL 설정 백업 시작..."

# 1. 패키지 목록 저장
echo "📦 패키지 목록 저장 중..."
pacman -Qe | awk '{print $1}' > "$BACKUP_DIR/pkglist.txt"
pacman -Qm | awk '{print $1}' > "$BACKUP_DIR/aur-pkglist.txt"

# 2. Dotfiles 백업
echo "⚙️  Dotfiles 백업 중..."
DOTFILES=(
    ".bashrc"
    ".zshrc"
    ".vimrc"
    ".gitconfig"
    ".tmux.conf"
)

for file in "${DOTFILES[@]}"; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_DIR/dotfiles/"
        echo "  ✓ $file"
    fi
done

# .config 디렉토리 (nvim, 기타 설정들)
if [ -d "$HOME/.config/nvim" ]; then
    mkdir -p "$BACKUP_DIR/dotfiles/.config"
    cp -r "$HOME/.config/nvim" "$BACKUP_DIR/dotfiles/.config/"
    echo "  ✓ .config/nvim"
fi

# 3. Git 설정 정보 추출
echo "🔧 Git 설정 정보..."
git config --global user.name > "$BACKUP_DIR/git-username.txt"
git config --global user.email > "$BACKUP_DIR/git-email.txt"

# 4. Shell 종류 확인
echo "🐚 현재 셸: $SHELL" > "$BACKUP_DIR/shell-info.txt"

# 5. 설치된 언어/도구 버전 정보
echo "📊 개발 환경 버전 정보 저장 중..."
{
    echo "=== Python ==="
    python --version 2>&1 || echo "Not installed"
    echo ""
    echo "=== Node.js ==="
    node --version 2>&1 || echo "Not installed"
    npm --version 2>&1 || echo "Not installed"
    echo ""
    echo "=== Rust ==="
    rustc --version 2>&1 || echo "Not installed"
    echo ""
    echo "=== Go ==="
    go version 2>&1 || echo "Not installed"
    echo ""
    echo "=== Java ==="
    java -version 2>&1 || echo "Not installed"
} > "$BACKUP_DIR/versions.txt"

# 6. 사용자 정의 aliases 및 functions 추출
echo "🔖 Aliases 및 Functions 추출 중..."
if [ -f "$HOME/.bashrc" ]; then
    grep -E "^alias |^function " "$HOME/.bashrc" > "$BACKUP_DIR/custom-commands.txt" 2>/dev/null
fi

# 7. Dockerfile 생성 템플릿에 패키지 반영
echo "📝 Dockerfile 업데이트 준비..."
echo "# 자동 생성된 패키지 목록" > "$BACKUP_DIR/packages.txt"
echo "# 아래 패키지들을 Dockerfile에 추가하세요:" >> "$BACKUP_DIR/packages.txt"
cat "$BACKUP_DIR/pkglist.txt" | grep -v "^#" | head -30 >> "$BACKUP_DIR/packages.txt"

# 8. README 생성
cat > "$BACKUP_DIR/README.md" << 'EOF'
# Docker Interview Environment Setup

이 디렉토리는 WSL Arch 환경에서 백업된 설정입니다.

## 파일 구조
- `pkglist.txt`: 명시적으로 설치된 패키지 목록
- `dotfiles/`: 개인 설정 파일들
- `versions.txt`: 설치된 도구 버전 정보
- `custom-commands.txt`: 사용자 정의 aliases와 functions

## 사용 방법
1. `Dockerfile`을 편집하여 필요한 패키지 추가
2. `dotfiles/`의 설정 파일들 확인 및 수정
3. Git 저장소에 커밋
4. `docker-compose up --build` 실행

## 보안 주의사항
- `.gitconfig`에서 민감한 정보 제거
- SSH 키는 절대 포함하지 마세요
- API 토큰이나 비밀번호 확인
EOF

echo ""
echo "✅ 백업 완료!"
echo "📁 저장 위치: $BACKUP_DIR"
echo ""
echo "다음 단계:"
echo "1. $BACKUP_DIR/dotfiles 내 파일에서 민감 정보 제거"
echo "2. Git 저장소 생성 및 커밋"
echo "3. Dockerfile에 필요한 패키지 추가"
echo "4. docker-compose.yml 설정 확인"
