# src/app/models.py
"""Pure Python models - no database or ORM dependencies"""

from dataclasses import dataclass
from typing import NotRequired, TypedDict


@dataclass
class User:
    """Simple user model - pure Python, no ORM"""
    name: str
    email: str | None = None
    active: bool = True


@dataclass
class UserResult:
    """Result of user processing"""
    user: User
    processed: bool
    timestamp: str


class UserDict(TypedDict):
    """Type for user data serialization"""
    name: str
    email: NotRequired[str | None]
    active: bool


def create_default_user() -> User:
    """Factory function for default user"""
    return User(name="default", email=None, active=True)


def user_to_dict(user: User) -> UserDict:
    """Convert User to dictionary - no ORM magic"""
    return {
        "name": user.name,
        "email": user.email,
        "active": user.active,
    }
