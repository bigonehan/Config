function get_packages_mono
    # 1. cwd 기준 jj 대상 경로 계산
    set jj_root (flow_resolve_jj_target_from_cwd (pwd))

    # 2. packages/ 폴더 존재 확인
    if not test -d "$jj_root/packages"
        echo ""
        return 0
    end
    
    # 3. packages/ 내부 package.json의 name 필드 수집
    set package_list
    
    for pkg_json in $jj_root/packages/**/package.json
        set pkg_name (cat $pkg_json | python3 -c "
import json, sys
data = json.load(sys.stdin)
name = data.get('name', '')
if name:
    print(name)
" 2>/dev/null)
        
        if test -n "$pkg_name"
            set package_list $package_list $pkg_name
        end
    end
    
    # 4. 리스트 반환 (줄바꿈으로 구분)
    for pkg in $package_list
        echo $pkg
    end
end
