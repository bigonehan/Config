return {
  -- 프로젝트 루트 감지 패턴
  root_patterns = { "package.json", "pnpm-workspace.yaml", ".git" },
  
  -- 템플릿 설정
  templates = {
    adapter = {
      import_template = 'import { %s, %sPort } from "@domains/%s/%sPort";',
      class_template = "export class %sAdapter%s implements %sPort {",
    },
  },
  
  -- 경로 설정
  paths = {
    domains = "packages/domains",
    adapters = "packages/adapters",
  },
}
