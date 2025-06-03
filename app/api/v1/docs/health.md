# Health Check API

```
GET /api/v1/health
```

서버의 상태를 확인합니다.

## Request
- Headers: `Accept: application/json`
- Parameters: 없음
- Body: 없음

## Response
```json
{
    "status": "ok"
}
```

## Error
```json
{
    "status": "error",
    "message": "Service is not healthy"
}
```

## Notes

- 이 엔드포인트는 인증이 필요하지 않습니다.
- 응답 시간은 100ms 이내여야 합니다.
- 주기적인 모니터링에 사용할 수 있습니다.

## Related

- [API 버전 관리](../README.md)
- [에러 처리](../errors.md) 