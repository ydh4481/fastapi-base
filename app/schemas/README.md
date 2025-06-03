# Schemas 구조

Pydantic 모델을 관리하는 디렉토리입니다.

## 구조

```
schemas/
├── user.py        # 사용자 관련 스키마
├── item.py        # 아이템 관련 스키마
└── common.py      # 공통 스키마
```

## 스키마 생성 방법

1. 새로운 파일 생성
2. Pydantic 모델 정의
3. 필요한 경우 공통 스키마 상속

## 예시

```python
# user.py
from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    """사용자 기본 스키마"""
    email: EmailStr
    username: str
    full_name: Optional[str] = None

class UserCreate(UserBase):
    """사용자 생성 스키마"""
    password: str

class UserUpdate(UserBase):
    """사용자 수정 스키마"""
    password: Optional[str] = None

class UserResponse(UserBase):
    """사용자 응답 스키마"""
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True
```

## 템플릿

```python
from pydantic import BaseModel
from typing import Optional, List
from datetime import datetime

class {Feature}Base(BaseModel):
    """{feature} 기본 스키마"""
    name: str
    description: Optional[str] = None

class {Feature}Create({Feature}Base):
    """{feature} 생성 스키마"""
    pass

class {Feature}Update({Feature}Base):
    """{feature} 수정 스키마"""
    pass

class {Feature}Response({Feature}Base):
    """{feature} 응답 스키마"""
    id: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True

class {Feature}List(BaseModel):
    """{feature} 목록 응답 스키마"""
    items: List[{Feature}Response]
    total: int
``` 