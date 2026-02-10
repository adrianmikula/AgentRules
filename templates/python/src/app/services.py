# src/app/services.py
"""Business logic services - pure Python, no framework"""

from datetime import datetime
from typing import Any

from .models import User, UserResult, user_to_dict


class DataService:
    """Simple data service - no Spring/Flask/Django"""

    def __init__(self) -> None:
        self._processed: list[str] = []

    def process(self, user: User) -> UserResult:
        """Process a user - pure business logic"""
        timestamp = datetime.utcnow().isoformat()
        self._processed.append(user.name)

        return UserResult(
            user=user,
            processed=True,
            timestamp=timestamp,
        )

    def get_processed_count(self) -> int:
        """Get count of processed users"""
        return len(self._processed)


def create_service() -> DataService:
    """Factory function - no DI container"""
    return DataService()


def process_data(user: User) -> dict[str, Any]:
    """Standalone function - easy to test"""
    service = DataService()
    result = service.process(user)
    return {
        "user": user_to_dict(result.user),
        "processed": result.processed,
        "timestamp": result.timestamp,
    }
