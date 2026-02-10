# src/app/main.py
"""Fast entrypoint with lazy imports - no import-time side effects"""

from typing import Any


def main() -> dict[str, Any]:
    """
    Main entrypoint - uses lazy imports to avoid import-time overhead.
    """
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
