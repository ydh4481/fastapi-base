# FastAPI Base Project

FastAPI 기반의 프로젝트 보일러플레이트입니다.

## 주요 특징

- FastAPI 기반의 RESTful API 서버
- PostgreSQL 데이터베이스 연동 (SQLAlchemy + asyncpg)
- Alembic을 통한 데이터베이스 마이그레이션
- Poetry를 통한 의존성 관리 (pyproject.toml, poetry.lock)
- Docker 및 Docker Compose 지원
- JWT 기반 인증
- CORS 설정
- loguru 기반 로깅
- 테스트 환경 구성

## 시작하기

### 필수 요구사항

- Python 3.12 이상
- Poetry
- Docker, Docker Compose

### 설치 및 환경설정

1. 저장소 클론:
```bash
git clone https://github.com/yourusername/fastapi-base.git
cd fastapi-base
```

2. 환경 변수 파일 준비:
```bash
cp .env.example .env
# .env 파일을 편집하여 필요한 설정을 변경하세요
```

3. 의존성 설치:
```bash
poetry install
```

4. 데이터베이스 마이그레이션:
```bash
poetry run alembic upgrade head
```

### 실행

개발 서버 실행:
```bash
poetry run uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### Docker로 실행

1. Docker 이미지 빌드 및 서비스 시작:
```bash
docker-compose up -d --build
```

2. (선택) 데이터베이스 마이그레이션:
```bash
docker-compose exec api alembic upgrade head
```

### 환경 변수 관리
- 모든 환경 변수는 `.env` 파일에서 관리합니다.
- 서비스 이름, DB 정보, 시크릿 키 등 모든 설정을 `.env`에서 일관되게 관리하세요.
- `pyproject.toml`은 Python 의존성 및 프로젝트 메타 정보만 관리합니다.

### poetry.lock 관리
- `poetry.lock` 파일은 반드시 Git에 포함하세요.
- 배포 및 개발 환경의 패키지 버전을 일치시킵니다.

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
├── logs/                 # 로그 파일 디렉토리
├── .env                  # 환경 변수
├── .env.example          # 환경 변수 예제
├── docker-compose.yaml   # Docker Compose 설정
├── pyproject.toml        # Poetry 설정
├── poetry.lock           # 의존성 버전 고정 파일
└── README.md            # 프로젝트 문서
```

## 개발 가이드라인

- Black을 사용한 코드 포맷팅
- isort를 사용한 import 정렬
- mypy를 사용한 타입 체크
- 모든 설정은 `.env`와 `pyproject.toml`에서 관리
- Docker Compose로 손쉽게 개발/운영 환경 구성

## API 문서
- Swagger UI: http://localhost:8000/docs
- ReDoc: http://localhost:8000/redoc

## 테스트
```bash
poetry run pytest
```

