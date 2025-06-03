# 테스트 구조

프로젝트의 테스트 코드를 관리하는 디렉토리입니다.

## 구조

```
tests/
├── conftest.py           # 테스트 설정 및 픽스처
├── test_health.py        # 헬스 체크 테스트
└── test_users.py         # 사용자 관련 테스트
```

## 테스트 작성 방법

1. `conftest.py`에 필요한 픽스처 정의
2. 테스트 파일 생성
3. 테스트 케이스 작성
4. 비동기 테스트는 `pytest.mark.asyncio` 데코레이터 사용

## 예시

```python
# test_health.py
import pytest
from fastapi.testclient import TestClient
from app.main import app

client = TestClient(app)

def test_health_check():
    """헬스 체크 엔드포인트 테스트"""
    response = client.get("/api/v1/health")
    assert response.status_code == 200
    assert response.json() == {"status": "ok"}

# test_users.py
import pytest
from httpx import AsyncClient
from app.core.security import create_access_token
from app.models.user import User

@pytest.mark.asyncio
async def test_create_user(async_client: AsyncClient):
    """사용자 생성 테스트"""
    user_data = {
        "email": "test@example.com",
        "username": "testuser",
        "password": "testpass123"
    }
    response = await async_client.post("/api/v1/users", json=user_data)
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == user_data["email"]
    assert data["username"] == user_data["username"]
```

## 픽스처 예시

```python
# conftest.py
import pytest
from typing import AsyncGenerator
from httpx import AsyncClient
from sqlalchemy.ext.asyncio import AsyncSession
from app.main import app
from app.db.session import get_db
from app.core.config import settings

@pytest.fixture
async def async_client() -> AsyncGenerator[AsyncClient, None]:
    """비동기 테스트 클라이언트"""
    async with AsyncClient(app=app, base_url="http://test") as client:
        yield client

@pytest.fixture
async def db_session() -> AsyncGenerator[AsyncSession, None]:
    """테스트용 데이터베이스 세션"""
    async for session in get_db():
        yield session
        await session.rollback()

@pytest.fixture
def test_user(db_session: AsyncSession) -> User:
    """테스트용 사용자"""
    user = User(
        email="test@example.com",
        username="testuser",
        hashed_password="hashedpass"
    )
    db_session.add(user)
    db_session.commit()
    return user

@pytest.fixture
def test_token(test_user: User) -> str:
    """테스트용 JWT 토큰"""
    return create_access_token({"sub": str(test_user.id)})
```

## 테스트 실행

```bash
# 모든 테스트 실행
poetry run pytest

# 특정 테스트 파일 실행
poetry run pytest tests/test_health.py

# 특정 테스트 함수 실행
poetry run pytest tests/test_health.py::test_health_check

# 자세한 출력
poetry run pytest -v

# 실패한 테스트의 전체 트레이스백
poetry run pytest -vv
```

## 테스트 작성 가이드라인

1. **테스트 격리**
   - 각 테스트는 독립적으로 실행되어야 함
   - 데이터베이스 상태를 초기화하거나 롤백
   - 외부 의존성은 모킹

2. **테스트 구조**
   - Arrange: 테스트 데이터 준비
   - Act: 테스트할 동작 실행
   - Assert: 결과 검증

3. **명명 규칙**
   - 테스트 파일: `test_*.py`
   - 테스트 함수: `test_*`
   - 픽스처: 명확한 이름 사용

4. **비동기 테스트**
   - `pytest.mark.asyncio` 데코레이터 사용
   - `AsyncClient` 사용
   - 비동기 컨텍스트 매니저 활용 