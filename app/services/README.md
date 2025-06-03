# Services 구조

비즈니스 로직을 관리하는 디렉토리입니다.

## 구조

```
services/
├── user.py        # 사용자 관련 서비스
├── item.py        # 아이템 관련 서비스
└── common.py      # 공통 서비스
```

## 서비스 생성 방법

1. 새로운 파일 생성
2. 서비스 클래스 정의
3. CRUD 작업 구현
4. 비즈니스 로직 구현

## 예시

```python
# user.py
from typing import List, Optional
from app.schemas.user import UserCreate, UserUpdate, UserResponse
from app.crud.user import UserCRUD
from app.core.security import get_password_hash

class UserService:
    def __init__(self, user_crud: UserCRUD):
        self.user_crud = user_crud

    async def create_user(self, user: UserCreate) -> UserResponse:
        """사용자를 생성합니다."""
        user_data = user.model_dump()
        user_data["password"] = get_password_hash(user_data["password"])
        return await self.user_crud.create(user_data)

    async def get_user(self, user_id: int) -> UserResponse:
        """사용자를 조회합니다."""
        return await self.user_crud.get(user_id)

    async def update_user(
        self, user_id: int, user: UserUpdate
    ) -> UserResponse:
        """사용자를 수정합니다."""
        user_data = user.model_dump(exclude_unset=True)
        if "password" in user_data:
            user_data["password"] = get_password_hash(user_data["password"])
        return await self.user_crud.update(user_id, user_data)

    async def delete_user(self, user_id: int) -> None:
        """사용자를 삭제합니다."""
        await self.user_crud.delete(user_id)
```

## 템플릿

```python
from typing import List, Optional
from app.schemas.{feature} import {Feature}Create, {Feature}Update, {Feature}Response
from app.crud.{feature} import {Feature}CRUD

class {Feature}Service:
    def __init__(self, {feature}_crud: {Feature}CRUD):
        self.{feature}_crud = {feature}_crud

    async def create_{feature}(self, {feature}: {Feature}Create) -> {Feature}Response:
        """{feature}를 생성합니다."""
        {feature}_data = {feature}.model_dump()
        return await self.{feature}_crud.create({feature}_data)

    async def get_{feature}(self, {feature}_id: int) -> {Feature}Response:
        """{feature}를 조회합니다."""
        return await self.{feature}_crud.get({feature}_id)

    async def list_{feature}s(
        self, skip: int = 0, limit: int = 100
    ) -> List[{Feature}Response]:
        """{feature} 목록을 조회합니다."""
        return await self.{feature}_crud.list(skip=skip, limit=limit)

    async def update_{feature}(
        self, {feature}_id: int, {feature}: {Feature}Update
    ) -> {Feature}Response:
        """{feature}를 수정합니다."""
        {feature}_data = {feature}.model_dump(exclude_unset=True)
        return await self.{feature}_crud.update({feature}_id, {feature}_data)

    async def delete_{feature}(self, {feature}_id: int) -> None:
        """{feature}를 삭제합니다."""
        await self.{feature}_crud.delete({feature}_id)
``` 