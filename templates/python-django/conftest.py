"""conftest.py - pytest configuration"""

import os
import django
from pathlib import Path

# Set Django settings module
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings")

# Setup Django before tests
django.setup()


def pytest_configure(config):
    """Configure pytest with Django."""
    from django.conf import settings
    
    # Use in-memory SQLite for tests
    settings.DATABASES["default"] = {
        "ENGINE": "django.db.backends.sqlite3",
        "NAME": ":memory:",
    }


def pytest_collection_modifyitems(config, items):
    """Modify test collection for faster runs."""
    # Run unit tests first (no DB)
    unit_tests = []
    integration_tests = []
    
    for item in items:
        if "integration" in str(item.fspath):
            integration_tests.append(item)
        else:
            unit_tests.append(item)
    
    # Reorder: unit tests first
    items[:] = unit_tests + integration_tests
