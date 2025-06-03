# FastAPI Base Project

FastAPI 기반의 프로젝트 보일러플레이트입니다.

## 기능

- FastAPI 기반의 RESTful API 서버
- PostgreSQL 데이터베이스 연동 (SQLAlchemy + asyncpg)
- Alembic을 통한 데이터베이스 마이그레이션
- Poetry를 통한 의존성 관리
- Docker 컨테이너화
- JWT 기반 인증
- CORS 설정
- 로깅 설정
  - loguru를 사용한 구조화된 로깅
  - 콘솔과 파일 동시 출력
  - 자동 로그 파일 로테이션 (500MB)
  - 로그 보관 기간 설정 (1주일)
  - FastAPI와 Uvicorn 로그 통합
- 테스트 환경 구성

## 시작하기

### 필수 요구사항

- Python 3.12 이상
- Poetry
- PostgreSQL
- Docker (선택사항)

### 설치

1. 저장소 클론:
```bash
git clone https://github.com/yourusername/fastapi-base.git
cd fastapi-base
```

2. 프로젝트 초기화:
```bash
./scripts/init_project.sh
```

3. 의존성 설치:
```bash
poetry install
```

4. 환경 변수 설정:
```bash
cp .env.example .env
# .env 파일을 편집하여 필요한 설정을 변경하세요
```

5. 데이터베이스 마이그레이션:
```bash
poetry run alembic upgrade head
```

### 실행

개발 서버 실행:
```bash
poetry run start
```

프로덕션 서버 실행:
```bash
poetry run start-prod
```

### Docker로 실행

```bash
docker-compose up -d
```

## 프로젝트 구조

```
fastapi-base/
├── app/                    # 메인 애플리케이션 패키지
│   ├── api/               # API 엔드포인트
│   │   └── v1/           # API 버전 1
│   ├── core/             # 핵심 설정
│   │   ├── config.py     # 환경 설정
│   │   └── logging.py    # 로깅 설정
│   ├── db/               # 데이터베이스 관련
│   └── main.py           # 애플리케이션 진입점
├── tests/                # 테스트 코드
├── alembic/              # 데이터베이스 마이그레이션
├── scripts/              # 유틸리티 스크립트
├── logs/                 # 로그 파일 디렉토리
├── .env                  # 환경 변수
├── .env.example          # 환경 변수 예제
├── docker-compose.yaml   # Docker Compose 설정
├── pyproject.toml        # Poetry 설정
└── README.md            # 프로젝트 문서
```

## 로깅 사용법

로깅 시스템은 `app.core.logging` 모듈을 통해 사용할 수 있습니다:

```python
from app.core.logging import get_logger

# 로거 가져오기
logger = get_logger(__name__)

# 로그 출력
logger.info("정보 메시지")
logger.error("에러 메시지")
logger.debug("디버그 메시지")
```

로그 파일은 `logs/app.log`에 저장되며, 다음과 같은 형식으로 출력됩니다:
```
2024-03-14 10:30:45.123 | INFO     | app.api.v1.endpoints.health:health_check:10 - Health check requested
```

## API 문서

- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 테스트

```bash
poetry run pytest
```

