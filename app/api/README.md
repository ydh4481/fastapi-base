# API 구조

API 엔드포인트를 관리하는 디렉토리입니다.

## 구조

```
api/
├── v1/                    # API 버전 1
│   ├── endpoints/         # API 엔드포인트
│   │   ├── health.py     # 헬스 체크
│   │   └── users.py      # 사용자 관련
│   ├── api.py            # API 라우터 설정
│   └── docs/             # API 문서
└── deps.py               # API 의존성
```

## 엔드포인트 생성 방법

1. `endpoints` 폴더에 새로운 파일 생성
2. FastAPI 라우터 설정
3. 엔드포인트 함수 작성
4. `api.py`에 라우터 등록

## 예시

```python
# endpoints/users.py
from fastapi import APIRouter, Depends
from typing import List
from app.schemas.user import UserCreate, UserResponse
from app.services.user import UserService

router = APIRouter()

@router.post("/users", response_model=UserResponse)
async def create_user(
    user: UserCreate,
    user_service: UserService = Depends()
) -> UserResponse:
    """사용자를 생성합니다."""
    return await user_service.create_user(user)

# api.py에 등록
from app.api.v1.endpoints import users
api_router.include_router(users.router, prefix="/users", tags=["users"])
```

## 템플릿

```python
from fastapi import APIRouter, Depends
from typing import List
from app.schemas.{feature} import {Feature}Create, {Feature}Response
from app.services.{feature} import {Feature}Service

router = APIRouter()

@router.get("/{feature}s", response_model=List[{Feature}Response])
async def list_{feature}s(
    {feature}_service: {Feature}Service = Depends()
) -> List[{Feature}Response]:
    """{feature} 목록을 조회합니다."""
    return await {feature}_service.list_{feature}s()

@router.post("/{feature}s", response_model={Feature}Response)
async def create_{feature}(
    {feature}: {Feature}Create,
    {feature}_service: {Feature}Service = Depends()
) -> {Feature}Response:
    """{feature}를 생성합니다."""
    return await {feature}_service.create_{feature}({feature})

@router.get("/{feature}s/{id}", response_model={Feature}Response)
async def get_{feature}(
    id: int,
    {feature}_service: {Feature}Service = Depends()
) -> {Feature}Response:
    """{feature}를 조회합니다."""
    return await {feature}_service.get_{feature}(id)

@router.put("/{feature}s/{id}", response_model={Feature}Response)
async def update_{feature}(
    id: int,
    {feature}: {Feature}Create,
    {feature}_service: {Feature}Service = Depends()
) -> {Feature}Response:
    """{feature}를 수정합니다."""
    return await {feature}_service.update_{feature}(id, {feature})

@router.delete("/{feature}s/{id}")
async def delete_{feature}(
    id: int,
    {feature}_service: {Feature}Service = Depends()
) -> None:
    """{feature}를 삭제합니다."""
    await {feature}_service.delete_{feature}(id)
``` 