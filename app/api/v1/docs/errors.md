# 공통 에러 처리

이 문서는 API에서 사용되는 공통 에러 응답 형식과 처리 방법을 설명합니다.

## 에러 응답 형식

모든 에러 응답은 다음과 같은 형식을 따릅니다:

```json
{
    "error": {
        "code": "ERROR_CODE",
        "message": "사용자에게 보여질 에러 메시지",
        "details": {
            "field": "추가적인 에러 상세 정보"
        }
    }
}
```

## HTTP 상태 코드

| 상태 코드 | 설명 |
|-----------|------|
| 400 | Bad Request - 잘못된 요청 |
| 401 | Unauthorized - 인증 필요 |
| 403 | Forbidden - 권한 없음 |
| 404 | Not Found - 리소스를 찾을 수 없음 |
| 422 | Unprocessable Entity - 유효성 검사 실패 |
| 429 | Too Many Requests - 요청 제한 초과 |
| 500 | Internal Server Error - 서버 내부 오류 |

## 에러 코드

### 인증 관련 (AUTH_*)

| 코드 | HTTP 상태 | 설명 |
|------|-----------|------|
| AUTH_001 | 401 | 토큰이 만료됨 |
| AUTH_002 | 401 | 유효하지 않은 토큰 |
| AUTH_003 | 403 | 권한이 없음 |

### 유효성 검사 (VALID_*)

| 코드 | HTTP 상태 | 설명 |
|------|-----------|------|
| VALID_001 | 422 | 필수 필드 누락 |
| VALID_002 | 422 | 잘못된 데이터 형식 |
| VALID_003 | 422 | 범위를 벗어난 값 |

### 리소스 관련 (RESOURCE_*)

| 코드 | HTTP 상태 | 설명 |
|------|-----------|------|
| RESOURCE_001 | 404 | 리소스를 찾을 수 없음 |
| RESOURCE_002 | 409 | 리소스 충돌 |

### 서버 관련 (SERVER_*)

| 코드 | HTTP 상태 | 설명 |
|------|-----------|------|
| SERVER_001 | 500 | 내부 서버 오류 |
| SERVER_002 | 503 | 서비스 일시적 사용 불가 |

## 예제

### 400 Bad Request

```json
{
    "error": {
        "code": "VALID_001",
        "message": "필수 필드가 누락되었습니다",
        "details": {
            "missing_fields": ["username", "email"]
        }
    }
}
```

### 401 Unauthorized

```json
{
    "error": {
        "code": "AUTH_001",
        "message": "인증 토큰이 만료되었습니다",
        "details": {
            "expired_at": "2024-03-20T10:00:00Z"
        }
    }
}
```

### 404 Not Found

```json
{
    "error": {
        "code": "RESOURCE_001",
        "message": "요청한 리소스를 찾을 수 없습니다",
        "details": {
            "resource_type": "user",
            "resource_id": "123"
        }
    }
}
``` 