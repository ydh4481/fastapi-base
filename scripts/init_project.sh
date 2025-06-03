#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 현재 디렉토리 확인
if [ ! -f "pyproject.toml" ]; then
    echo -e "${RED}오류: pyproject.toml 파일을 찾을 수 없습니다. 프로젝트 루트 디렉토리에서 실행해주세요.${NC}"
    exit 1
fi

# 프로젝트 이름 입력 받기
echo -e "${YELLOW}프로젝트 이름을 입력하세요 (예: my-fastapi-project):${NC}"
read project_name

# 프로젝트 이름 검증
if [[ ! $project_name =~ ^[a-z][a-z0-9-]*$ ]]; then
    echo -e "${RED}오류: 프로젝트 이름은 영문 소문자로 시작하고, 영문 소문자, 숫자, 하이픈만 사용할 수 있습니다.${NC}"
    exit 1
fi

# 데이터베이스 설정 입력 받기
echo -e "${YELLOW}데이터베이스 설정을 입력하세요:${NC}"
echo -e "${YELLOW}데이터베이스 사용자 [postgres]:${NC}"
read db_user
db_user=${db_user:-postgres}

echo -e "${YELLOW}데이터베이스 비밀번호 [postgres]:${NC}"
read -s db_password
db_password=${db_password:-postgres}

echo -e "${YELLOW}데이터베이스 호스트 [localhost]:${NC}"
read db_host
db_host=${db_host:-localhost}

echo -e "${YELLOW}데이터베이스 포트 [5432]:${NC}"
read db_port
db_port=${db_port:-5432}

# Python 버전 선택
echo -e "${YELLOW}Python 버전을 선택하세요:${NC}"
echo "1) Python 3.9"
echo "2) Python 3.10"
echo "3) Python 3.11"
echo "4) Python 3.12 (권장)"
read -p "선택 (1-4) [4]: " python_version

case $python_version in
    1)
        python_version="3.9"
        ;;
    2)
        python_version="3.10"
        ;;
    3)
        python_version="3.11"
        ;;
    4|"")
        python_version="3.12"
        ;;
    *)
        echo -e "${RED}잘못된 선택입니다. Python 3.12를 사용합니다.${NC}"
        python_version="3.12"
        ;;
esac

# pyproject.toml 수정
echo -e "${YELLOW}pyproject.toml 파일을 업데이트합니다...${NC}"
sed -i '' "s/name = \"fastapi-base\"/name = \"$project_name\"/" pyproject.toml
sed -i '' "s/requires-python = \">=3.12,<3.14\"/requires-python = \">=$python_version,<$((${python_version%.*}+1)).0\"/" pyproject.toml

# .env 파일 생성
echo -e "${YELLOW}.env 파일을 생성합니다...${NC}"
cat > .env << EOL
# Application
APP_NAME=$project_name
DEBUG=True
ENVIRONMENT=development

# Database
DATABASE_URL=postgresql+asyncpg://$db_user:$db_password@$db_host:$db_port/$project_name

# Security
SECRET_KEY=$(openssl rand -hex 32)
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# CORS
BACKEND_CORS_ORIGINS=["http://localhost:8000", "http://localhost:3000"]
EOL

# README.md 수정
echo -e "${YELLOW}README.md 파일을 업데이트합니다...${NC}"
sed -i '' "s/# fastapi-base/# $project_name/" README.md

# poetry 환경 재설정
echo -e "${YELLOW}Poetry 환경을 재설정합니다...${NC}"
poetry env remove python
poetry env use python$python_version
poetry install

# 데이터베이스 마이그레이션 초기화
echo -e "${YELLOW}데이터베이스 마이그레이션을 초기화합니다...${NC}"
alembic init alembic

# alembic.ini 수정
echo -e "${YELLOW}alembic.ini 파일을 설정합니다...${NC}"
sed -i '' "s|sqlalchemy.url = driver://user:pass@localhost/dbname|sqlalchemy.url = postgresql+asyncpg://$db_user:$db_password@$db_host:$db_port/$project_name|" alembic.ini

# alembic/env.py 수정
echo -e "${YELLOW}alembic/env.py 파일을 설정합니다...${NC}"
cat > alembic/env.py << EOL
import asyncio
from logging.config import fileConfig

from sqlalchemy import pool
from sqlalchemy.engine import Connection
from sqlalchemy.ext.asyncio import async_engine_from_config

from alembic import context

from app.core.config import settings
from app.db.base import Base

# this is the Alembic Config object, which provides
# access to the values within the .ini file in use.
config = context.config

# Interpret the config file for Python logging.
# This line sets up loggers basically.
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

# add your model's MetaData object here
# for 'autogenerate' support
target_metadata = Base.metadata

def run_migrations_offline() -> None:
    """Run migrations in 'offline' mode."""
    url = settings.DATABASE_URL
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )

    with context.begin_transaction():
        context.run_migrations()


def do_run_migrations(connection: Connection) -> None:
    context.configure(connection=connection, target_metadata=target_metadata)

    with context.begin_transaction():
        context.run_migrations()


async def run_async_migrations() -> None:
    """In this scenario we need to create an Engine
    and associate a connection with the context.
    """
    connectable = async_engine_from_config(
        config.get_section(config.config_ini_section, {}),
        prefix="sqlalchemy.",
        poolclass=pool.NullPool,
    )

    async with connectable.connect() as connection:
        await connection.run_sync(do_run_migrations)

    await connectable.dispose()


def run_migrations_online() -> None:
    """Run migrations in 'online' mode."""
    asyncio.run(run_async_migrations())


if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
EOL

# 초기 마이그레이션 생성
echo -e "${YELLOW}초기 마이그레이션을 생성합니다...${NC}"
alembic revision --autogenerate -m "Initial migration"

# 데이터베이스 마이그레이션 적용
echo -e "${YELLOW}데이터베이스 마이그레이션을 적용합니다...${NC}"
alembic upgrade head

# 테스트 실행
echo -e "${YELLOW}테스트를 실행합니다...${NC}"
poetry run pytest

# 서버 실행 테스트
echo -e "${YELLOW}서버 실행을 테스트합니다...${NC}"
echo -e "${YELLOW}서버를 시작하고 5초 후에 헬스 체크를 수행합니다...${NC}"

# 백그라운드에서 서버 실행
poetry run start &
SERVER_PID=$!

# 5초 대기
sleep 5

# 헬스 체크 수행
HEALTH_CHECK=$(curl -s http://localhost:8000/api/v1/health)
if [[ $HEALTH_CHECK == *"ok"* ]]; then
    echo -e "${GREEN}서버가 정상적으로 실행되었습니다!${NC}"
else
    echo -e "${RED}서버 실행 테스트에 실패했습니다.${NC}"
fi

# 서버 종료
kill $SERVER_PID

echo -e "${GREEN}프로젝트 초기화가 완료되었습니다!${NC}"
echo -e "${GREEN}'$project_name' 프로젝트가 Python $python_version으로 준비되었습니다.${NC}"
echo -e "${YELLOW}다음 단계:${NC}"
echo "1. .env 파일을 검토하고 필요한 설정을 변경하세요"
echo "2. 'poetry run start' 명령어로 개발 서버를 시작하세요"
echo "3. http://localhost:8000/docs 에서 API 문서를 확인하세요" 