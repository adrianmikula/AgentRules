# tests/unit/test_models.py
"""Fast unit tests - pure functions, no fixtures"""

from app.models import User, create_default_user, user_to_dict


class TestUserModel:
    """Test User model - no external dependencies"""

    def test_user_creation(self) -> None:
        """Test basic user creation"""
        user = User(name="test", email="test@example.com")
        assert user.name == "test"
        assert user.email == "test@example.com"
        assert user.active is True

    def test_user_defaults(self) -> None:
        """Test user default values"""
        user = User(name="default")
        assert user.email is None
        assert user.active is True

    def test_create_default_user(self) -> None:
        """Test factory function"""
        user = create_default_user()
        assert user.name == "default"
        assert user.active is True

    def test_user_to_dict(self) -> None:
        """Test serialization"""
        user = User(name="test", email="test@example.com", active=True)
        result = user_to_dict(user)
        assert result["name"] == "test"
        assert result["email"] == "test@example.com"
        assert result["active"] is True
