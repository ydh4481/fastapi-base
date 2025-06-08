# API 버전 관리

이 문서는 API 버전 관리 정책과 가이드라인을 설명합니다.

## 버전 관리 정책

### URL 기반 버전 관리

API 버전은 URL에 포함되어 있습니다:

```
/api/v1/...
/api/v2/...
```

## API 문서 구조

각 API 버전의 문서는 다음과 같은 구조로 작성됩니다:

```
app/api/v1/docs/
├── README.md           # 버전 관리 정책
├── errors.md          # 공통 에러 처리
├── health.md          # 헬스 체크 API
└── {feature}/         # 기능별 API 문서
    ├── README.md      # 기능 개요
    └── {endpoint}.md  # 개별 엔드포인트 문서
```

## API 문서 템플릿

각 API 문서는 다음 형식을 따릅니다:

```markdown
# API 이름

```
HTTP_METHOD /api/v1/endpoint
```

간단한 API 설명 (1-2줄)

## Request
- Headers: `Header-Name: value`
- Parameters: 파라미터 설명
- Body: 요청 본문 예시

## Response
```json
{
    "field": "value"
}
```

## Error
```json
{
    "error": {
        "code": "ERROR_CODE",
        "message": "에러 메시지"
    }
}
```

### 템플릿 규칙

1. **간결성**
   - API 설명은 1-2줄로 제한
   - 불필요한 섹션 제외
   - 예제는 실제 사용 사례만 포함

2. **일관성**
   - 모든 API 문서는 동일한 구조 사용
   - 섹션 순서 유지
   - JSON 형식 통일

3. **가독성**
   - 마크다운 형식 사용
   - 코드 블록은 적절한 언어 지정
   - 중요 정보는 강조

## 문서 작성 가이드라인

1. **일관된 형식**
   - 모든 API 문서는 동일한 템플릿을 따릅니다
   - 마크다운 형식을 사용합니다

2. **필수 섹션**
   - Endpoint
   - Description
   - Request/Response
   - Examples
   - Error Responses 