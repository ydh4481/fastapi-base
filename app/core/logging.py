import logging
import sys
from pathlib import Path
from types import FrameType
from typing import Any, Dict, Optional

from loguru import logger


class InterceptHandler(logging.Handler):
    def emit(self, record: logging.LogRecord) -> None:
        try:
            level = logger.level(record.levelname).name
        except ValueError:
            level = record.levelno

        frame: Optional[FrameType] = logging.currentframe()
        depth = 2
        while frame is not None and frame.f_code.co_filename == logging.__file__:
            frame = frame.f_back
            depth += 1

        logger.opt(depth=depth, exception=record.exc_info).log(level, record.getMessage())


def setup_logging(
    *,
    log_path: Path = Path("logs"),
    level: str = "INFO",
    retention: str = "1 week",
    rotation: str = "500 MB",
    format: str = "<green>{time:YYYY-MM-DD HH:mm:ss.SSS}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>",
) -> None:
    """로깅 설정을 초기화합니다.

    Args:
        log_path: 로그 파일이 저장될 경로
        level: 로그 레벨
        retention: 로그 파일 보관 기간
        rotation: 로그 파일 회전 크기
        format: 로그 포맷
    """
    # 로그 디렉토리 생성
    log_path.mkdir(parents=True, exist_ok=True)

    # 기본 로거 설정
    logging.basicConfig(handlers=[InterceptHandler()], level=0, force=True)

    # uvicorn 로거 설정
    for logger_name in ["uvicorn", "uvicorn.error", "fastapi"]:
        logging_logger = logging.getLogger(logger_name)
        logging_logger.handlers = [InterceptHandler()]

    # loguru 설정
    logger.configure(
        handlers=[
            {
                "sink": sys.stdout,
                "format": format,
                "level": level,
                "serialize": False,
            },
            {
                "sink": log_path / "app.log",
                "format": format,
                "level": level,
                "rotation": rotation,
                "retention": retention,
                "serialize": True,
            },
        ]
    )


def get_logger(name: str) -> Any:
    """로거를 가져옵니다.

    Args:
        name: 로거 이름

    Returns:
        Logger: 로거 인스턴스
    """
    return logger.bind(name=name)
