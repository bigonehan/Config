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
