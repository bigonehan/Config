# ============================================================
# create_package_quick
# 도메인/Port/Adapter 패키지를 빠르게 생성
# ============================================================
function create_package_quick
    set pkg_name $argv[1]   # 예: @domain/student_high
    set pkg_desc $argv[2]   # 예: "고등학생 성적 관련 도메인"

    set jj_root (flow_ensure_jj_repo_for_cwd (pwd))
    if test $status -ne 0 -o -z "$jj_root"
        set_color red
        echo "❌ jj 저장소 준비 실패: "(pwd)
        set_color normal
        return 1
    end

    # @domain/student_high → packages/domain
    set pkg_type  (string replace "@" "" (string split "/" $pkg_name)[1])
    set pkg_short (string split "/" $pkg_name)[2]
    set target_dir "$jj_root/packages/$pkg_type"

    if not test -d "$target_dir"
        mkdir -p $target_dir
    end

    set current_dir (pwd)
    cd $target_dir

    # level_init을 비대화형으로 실행
    echo "📦 패키지 생성: $pkg_name"
    printf "$pkg_short\n$pkg_desc\n" | level_init

    cd $current_dir
    echo "✅ $pkg_name 생성 완료"
end
