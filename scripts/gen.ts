#!/usr/bin/env bun
import fs from "fs";
import path from "path";
import { readFileSync } from "fs";

const [, , adapterTypeArg] = process.argv;

if (!adapterTypeArg) {
  console.error("Usage: mygen <adapterType>");
  process.exit(1);
}

// 현재 폴더 기준 (예: /project/packages/domains/post)
const cwd = process.cwd();
const parts = cwd.split(path.sep);
const domain = parts.at(-1); // post
const parentFolder = parts.at(-2); // domains

if (!domain || parentFolder !== "domains") {
  console.error("❌ This command must be run from /packages/domains/<domain> folder");
  process.exit(1);
}

// 대문자화 도우미
const cap = (s: string) => s.charAt(0).toUpperCase() + s.slice(1);

const domainCap = cap(domain);
const adapterCap = cap(adapterTypeArg);

// Port 파일 경로
const portFilePath = path.join(cwd, `${domainCap}Port.ts`);

if (!fs.existsSync(portFilePath)) {
  console.error(`❌ Port file not found: ${portFilePath}`);
  process.exit(1);
}

// Port 파일에서 인터페이스 메서드 추출
const portContent = readFileSync(portFilePath, "utf-8");
const interfaceMatch = portContent.match(
  new RegExp(`export\\s+interface\\s+${domainCap}Port\\s*{([^}]*)}`, "s")
);

if (!interfaceMatch) {
  console.error(`❌ Could not find ${domainCap}Port interface in ${portFilePath}`);
  process.exit(1);
}

const interfaceBody = interfaceMatch[1];
// 메서드 시그니처를 파싱하여 구현 메서드 생성
const methods = interfaceBody
  .split(";")
  .map((m) => m.trim())
  .filter((m) => m.length > 0)
  .map((method) => {
    // async 키워드 제거하고 메서드 이름과 시그니처 추출
    const cleaned = method.replace(/^\s*async\s+/, "");
    const methodMatch = cleaned.match(/^(\w+)\s*\((.*?)\)\s*:\s*(.+)$/);
    
    if (methodMatch) {
      const [, name, params, returnType] = methodMatch;
      // Promise 반환 타입에서 실제 타입 추출
      const innerType = returnType.match(/Promise<(.+)>/)?.[1] || "void";
      
      let returnValue = "";
      if (innerType === "void") {
        returnValue = "";
      } else if (innerType.includes("undefined")) {
        returnValue = "return undefined;";
      } else if (innerType.includes("[]")) {
        returnValue = "return [];";
      } else {
        returnValue = `return undefined as any;`;
      }
      
      return `  async ${name}(${params}): ${returnType} {
    // TODO: implement ${name}
    ${returnValue}
  }`;
    }
    return "";
  })
  .filter((m) => m.length > 0)
  .join("\n\n");

// 어댑터 파일 경로
const adapterDir = path.join(cwd, "../../../packages/adapters", domain);
const fileName = `${domainCap}Adapter${adapterCap}.ts`;
const targetPath = path.join(adapterDir, fileName);

// 디렉토리 생성 (없는 경우)
if (!fs.existsSync(adapterDir)) {
  fs.mkdirSync(adapterDir, { recursive: true });
}

// 템플릿 생성
const content = `import { ${domainCap}, ${domainCap}Port } from "@domains/${domain}/${domainCap}Port";

export class ${domainCap}Adapter${adapterCap} implements ${domainCap}Port {
${methods}
}
`;

fs.writeFileSync(targetPath, content);
console.log("✅ Created:", targetPath);
