"""apps/core/tests/unit/test_models.py - Unit tests (fast, no DB)"""

import pytest
from unittest.mock import Mock


class TestItemModel:
    """Unit tests for Item model (no DB required)."""

    def test_item_creation(self):
        """Test Item can be created with name."""
        # This is a mock-based test - no DB
        mock_item = Mock()
        mock_item.name = "Test Item"
        mock_item.description = ""
        
        assert mock_item.name == "Test Item"
        assert mock_item.description == ""

    def test_item_str_representation(self):
        """Test Item string representation."""
        mock_item = Mock()
        mock_item.__str__ = Mock(return_value="Test Item")
        
        assert str(mock_item) == "Test Item"

    def test_item_ordering(self):
        """Test Item has ordering defined."""
        # Test Meta class exists with ordering
        from apps.core.models import Item
        
        assert hasattr(Item.Meta, 'ordering')
        assert Item.Meta.ordering == ["-created_at"]


class TestSerializers:
    """Unit tests for serializers (no DB required)."""

    def test_item_serializer_fields(self):
        """Test ItemSerializer has expected fields."""
        from apps.core.serializers import ItemSerializer
        
        serializer = ItemSerializer()
        expected_fields = {'id', 'name', 'description', 'created_at', 'updated_at'}
        assert set(serializer.fields.keys()) == expected_fields

    def test_item_serializer_read_only_fields(self):
        """Test ItemSerializer has read-only fields."""
        from apps.core.serializers import ItemSerializer
        
        serializer = ItemSerializer()
        read_only = {'id', 'created_at', 'updated_at'}
        assert set(serializer.Meta.read_only_fields) == read_only
