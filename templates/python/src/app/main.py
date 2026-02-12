# src/app/main.py
"""Fast entrypoint with lazy imports - no import-time side effects"""

import sys
from typing import Any

# PyInstaller/frozen: set package so relative imports work
if getattr(sys, "frozen", False):
    __package__ = "app"  # noqa: A001

VERSION = "1.0.0"


def main() -> dict[str, Any] | None:
    """
    Main entrypoint - uses lazy imports to avoid import-time overhead.
    """
    if len(sys.argv) > 1 and sys.argv[1] in ("--version", "-v"):
        print(f"python-boilerplate {VERSION}")
        return None

    # Lazy imports - load only when needed
    from .models import create_default_user
    from .services import DataService

    # Pure Python - no framework overhead
    service = DataService()
    user = create_default_user()

    result = service.process(user)
    return {"status": "success", "user": user.name, "result": result}


if __name__ == "__main__":
    main()
