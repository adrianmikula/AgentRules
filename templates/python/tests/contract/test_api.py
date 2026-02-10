# tests/contract/test_api.py
"""Contract tests - API schema validation (no real API calls)"""

from app.models import User, user_to_dict


class TestAPIContract:
    """Contract tests - validate API schema without hitting real services"""

    def test_user_schema_matches_api_contract(self) -> None:
        """Verify user model matches expected API contract"""
        user = User(name="test", email="test@example.com")
        data = user_to_dict(user)

        # Contract assertions - no real API needed
        assert "name" in data
        assert "email" in data or data.get("email") is None
        assert "active" in data
        assert isinstance(data["name"], str)
        assert isinstance(data["active"], bool)

    def test_user_required_fields(self) -> None:
        """Verify required fields are present"""
        user = User(name="required")
        data = user_to_dict(user)

        assert "name" in data
        assert data["name"] == "required"

    def test_user_optional_fields(self) -> None:
        """Verify optional fields work correctly"""
        user = User(name="optional", email="opt@example.com", active=False)
        data = user_to_dict(user)

        assert data["email"] == "opt@example.com"
        assert data["active"] is False

    def test_user_email_nullable(self) -> None:
        """Verify email can be None"""
        user = User(name="no-email")
        data = user_to_dict(user)

        assert data["email"] is None
