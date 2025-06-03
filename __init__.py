"""
Core package for application configuration and settings.

FastAPI Base Project
"""

import sys
from pathlib import Path

# fastapi_base 패키지의 루트 디렉토리를 Python 경로에 추가
package_root = Path(__file__).parent
sys.path.append(str(package_root))
