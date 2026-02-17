function create_package_json
    # 1. spec.yaml 파일 확인
    if not test -f spec.yaml
        set_color red
        echo "❌ Error: 'spec.yaml' not found in current directory."
        set_color normal
        return 1
    end

    echo "📦 Generating package.json from spec.yaml..."

    # 2. Python 스크립트 실행
    python3 -c '
import yaml
import json
import os
import sys

def generate():
    try:
        with open("spec.yaml", "r") as f:
            spec = yaml.safe_load(f)
    except Exception as e:
        print(f"❌ YAML Error: {e}", file=sys.stderr)
        sys.exit(1)

    cwd = os.getcwd()
    path_parts = cwd.strip(os.sep).split(os.sep)
    current_folder = path_parts[-1]
    parent_folder = path_parts[-2]
    package_name = f"@{parent_folder}/{current_folder}"

    print(f"   ℹ️  Detected Package Name: {package_name}", file=sys.stderr)

    pkg = {
        "name": package_name,
        "version": "0.0.0",
        "description": spec.get("description", "").strip(),
        "main": "src/index.ts",
        "types": "src/index.ts",
        "license": "MIT",
        "scripts": {
            "test": "echo \"Error: no test specified\" && exit 1"
        },
        "dependencies": {},
        "devDependencies": {
            "typescript": "^5.0.0"
        }
    }

    # 내부 의존성 (workspace:*)
    internal_deps = spec.get("dependencies", []) or []
    for dep in internal_deps:
        pkg["dependencies"][dep] = "workspace:*"

    # 외부 라이브러리 → package.json dependencies에 추가
    external_libs = spec.get("lib", []) or []
    converted_libs = []
    for lib in external_libs:
        if ":" in lib:
            name, version = lib.split(":", 1)
            name = name.strip()
            version = version.strip()
            pkg["dependencies"][name] = version
            converted_libs.append(f"{name}@{version}")
        else:
            lib = lib.strip()
            pkg["dependencies"][lib] = "latest"
            converted_libs.append(lib)

    with open("package.json", "w") as f:
        json.dump(pkg, f, indent=2, ensure_ascii=False)

    # stdout으로 pnpm add 형식 출력
    print("|".join(converted_libs))

if __name__ == "__main__":
    generate()
' | read -l external_libs_output

    # Python 스크립트 에러 체크
    if test $status -ne 0
        set_color red
        echo "❌ Failed to generate package.json"
        set_color normal
        return 1
    end

    set_color green
    echo "✅ package.json created successfully!"
    set_color normal

    # 3. 외부 라이브러리 설치 (pnpm add)
    if test -n "$external_libs_output"
        echo "⬇️  Installing external libraries..."

        set -l libs (string split "|" $external_libs_output)

        for lib in $libs
            if test -n "$lib"
                set -l clean_lib (string trim $lib)
                echo "   Running: pnpm add $clean_lib"
                pnpm add $clean_lib
            end
        end
    else
        echo "ℹ️  No external libraries to install."
    end

    echo "✨ Setup complete."
end
