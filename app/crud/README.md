# CRUD 구조

데이터베이스 CRUD 작업을 관리하는 디렉토리입니다.

## 구조

```
crud/
├── user.py        # 사용자 관련 CRUD
├── item.py        # 아이템 관련 CRUD
└── base.py        # 기본 CRUD 클래스
```

## CRUD 생성 방법

1. `base.py`의 `CRUDBase` 클래스 상속
2. 필요한 경우 커스텀 메서드 추가
3. 모델과 스키마 타입 지정

## 예시

```python
# user.py
from typing import Optional, List
from sqlalchemy.ext.asyncio import AsyncSession
from app.crud.base import CRUDBase
from app.models.user import User
from app.schemas.user import UserCreate, UserUpdate

class UserCRUD(CRUDBase[User, UserCreate, UserUpdate]):
    async def get_by_email(
        self, db: AsyncSession, email: str
    ) -> Optional[User]:
        """이메일로 사용자를 조회합니다."""
        result = await db.execute(
            select(User).where(User.email == email)
        )
        return result.scalar_one_or_none()

    async def get_multi(
        self, db: AsyncSession, *, skip: int = 0, limit: int = 100
    ) -> List[User]:
        """사용자 목록을 조회합니다."""
        result = await db.execute(
            select(User).offset(skip).limit(limit)
        )
        return result.scalars().all()

user_crud = UserCRUD(User)
```

## 템플릿

```python
from typing import Optional, List
from sqlalchemy.ext.asyncio import AsyncSession
from app.crud.base import CRUDBase
from app.models.{feature} import {Feature}
from app.schemas.{feature} import {Feature}Create, {Feature}Update

class {Feature}CRUD(CRUDBase[{Feature}, {Feature}Create, {Feature}Update]):
    async def get_by_name(
        self, db: AsyncSession, name: str
    ) -> Optional[{Feature}]:
        """이름으로 {feature}를 조회합니다."""
        result = await db.execute(
            select({Feature}).where({Feature}.name == name)
        )
        return result.scalar_one_or_none()

    async def get_multi(
        self, db: AsyncSession, *, skip: int = 0, limit: int = 100
    ) -> List[{Feature}]:
        """{feature} 목록을 조회합니다."""
        result = await db.execute(
            select({Feature}).offset(skip).limit(limit)
        )
        return result.scalars().all()

{feature}_crud = {Feature}CRUD({Feature})
```

## 기본 CRUD 작업

`CRUDBase` 클래스는 다음 작업을 제공합니다:

- `create`: 새 레코드 생성
- `get`: ID로 레코드 조회
- `update`: 레코드 수정
- `delete`: 레코드 삭제
- `list`: 레코드 목록 조회 