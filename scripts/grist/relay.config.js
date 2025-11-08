// relay.config.js
module.exports = {
  src: ".",                  // 소스 경로 (main.ts, relay.ts가 있는 곳)
  schema: "./schema.graphql", // GraphQL 스키마 파일 (다음 단계에서 만들 거야)
  language: "typescript",     // 타입스크립트용 출력
  artifactDirectory: "__generated__", // 생성된 파일이 저장될 폴더
};

