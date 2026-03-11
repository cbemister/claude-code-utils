# [Project Name] - Project Documentation

## Overview
[Brief description of what this Django application does and its primary purpose]

## Tech Stack
- **Python** [version, e.g., 3.12+]
- **Django** [version, e.g., 5.0+] with **Django REST Framework**
- **PostgreSQL** for the primary database
- **Celery** with **Redis** for background tasks and queues
- **pytest-django** for testing
- **Ruff** for linting and formatting
- **mypy** (or **pyright**) for type checking
- **django-environ** for environment variable management
- **[Deployment]** - Gunicorn + Nginx / Railway / Render

## Project Structure
```
manage.py
config/
├── __init__.py
├── settings/
│   ├── __init__.py
│   ├── base.py            # Shared settings
│   ├── development.py     # Dev overrides
│   └── production.py      # Production overrides
├── urls.py                # Root URL config
├── wsgi.py
└── celery.py              # Celery app config

apps/
├── accounts/              # User auth and profiles
│   ├── migrations/
│   ├── models.py
│   ├── serializers.py
│   ├── views.py
│   ├── urls.py
│   ├── admin.py
│   └── tests/
│       ├── test_models.py
│       └── test_views.py
└── [feature]/             # Each feature is a Django app
    ├── migrations/
    ├── models.py
    ├── serializers.py
    ├── views.py
    ├── urls.py
    ├── tasks.py           # Celery tasks for this app
    └── tests/

templates/                 # Django HTML templates (if not API-only)
static/                    # Static files (CSS, JS, images)
media/                     # User-uploaded files

requirements/
├── base.txt
├── development.txt
└── production.txt

.env.example
pyproject.toml
```

## Environment Setup

### Initial Setup
```bash
python -m venv venv
source venv/bin/activate        # Linux/Mac
venv\Scripts\activate           # Windows

pip install -r requirements/development.txt

# Copy and fill in environment variables
cp .env.example .env
```

### pyproject.toml
```toml
[tool.ruff]
line-length = 100
select = ["E", "F", "I", "N", "W", "UP"]

[tool.ruff.format]
quote-style = "double"

[tool.mypy]
plugins = ["mypy_django_plugin.main"]
strict = true
ignore_missing_imports = true

[tool.django-stubs]
django_settings_module = "config.settings.development"

[tool.pytest.ini_options]
DJANGO_SETTINGS_MODULE = "config.settings.test"
python_files = ["tests.py", "test_*.py", "*_tests.py"]
addopts = "--reuse-db"
```

## Settings

### Base Settings Pattern
```python
# config/settings/base.py
import environ

env = environ.Env()
environ.Env.read_env()

BASE_DIR = Path(__file__).resolve().parent.parent.parent

SECRET_KEY = env("DJANGO_SECRET_KEY")
DEBUG = env.bool("DJANGO_DEBUG", default=False)
ALLOWED_HOSTS = env.list("DJANGO_ALLOWED_HOSTS", default=["localhost", "127.0.0.1"])

INSTALLED_APPS = [
    "django.contrib.admin",
    "django.contrib.auth",
    "django.contrib.contenttypes",
    "django.contrib.sessions",
    "rest_framework",
    "rest_framework.authtoken",
    "corsheaders",
    # Local apps
    "apps.accounts",
    "apps.[feature]",
]

DATABASES = {
    "default": env.db("DATABASE_URL", default="postgres://localhost/myapp")
}

# Django REST Framework
REST_FRAMEWORK = {
    "DEFAULT_AUTHENTICATION_CLASSES": [
        "rest_framework.authentication.TokenAuthentication",
    ],
    "DEFAULT_PERMISSION_CLASSES": [
        "rest_framework.permissions.IsAuthenticated",
    ],
    "DEFAULT_PAGINATION_CLASS": "rest_framework.pagination.PageNumberPagination",
    "PAGE_SIZE": 20,
}

# Celery
CELERY_BROKER_URL = env("REDIS_URL", default="redis://localhost:6379/0")
CELERY_RESULT_BACKEND = env("REDIS_URL", default="redis://localhost:6379/0")
CELERY_ACCEPT_CONTENT = ["json"]
CELERY_TASK_SERIALIZER = "json"
```

## Models

### Model Pattern
```python
# apps/items/models.py
from django.db import models
from django.conf import settings


class Item(models.Model):
    class Status(models.TextChoices):
        DRAFT = "draft", "Draft"
        PUBLISHED = "published", "Published"
        ARCHIVED = "archived", "Archived"

    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name="items",
    )
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    status = models.CharField(
        max_length=20, choices=Status.choices, default=Status.DRAFT
    )
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        ordering = ["-created_at"]
        indexes = [models.Index(fields=["owner", "status"])]

    def __str__(self) -> str:
        return self.title
```

## DRF Serializers

```python
# apps/items/serializers.py
from rest_framework import serializers
from .models import Item


class ItemSerializer(serializers.ModelSerializer):
    owner_name = serializers.CharField(source="owner.get_full_name", read_only=True)

    class Meta:
        model = Item
        fields = ["id", "title", "description", "status", "owner_name", "created_at"]
        read_only_fields = ["id", "owner_name", "created_at"]


class ItemCreateSerializer(serializers.ModelSerializer):
    class Meta:
        model = Item
        fields = ["title", "description", "status"]

    def create(self, validated_data: dict) -> Item:
        return Item.objects.create(owner=self.context["request"].user, **validated_data)
```

## API Views

### ViewSet Pattern
```python
# apps/items/views.py
from rest_framework import viewsets, permissions, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from .models import Item
from .serializers import ItemSerializer, ItemCreateSerializer


class ItemViewSet(viewsets.ModelViewSet):
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = ["status"]
    search_fields = ["title", "description"]
    ordering_fields = ["created_at", "title"]

    def get_queryset(self):
        return Item.objects.filter(owner=self.request.user).select_related("owner")

    def get_serializer_class(self):
        if self.action in ("create", "update", "partial_update"):
            return ItemCreateSerializer
        return ItemSerializer

    @action(detail=True, methods=["post"])
    def publish(self, request, pk=None):
        item = self.get_object()
        item.status = Item.Status.PUBLISHED
        item.save(update_fields=["status"])
        return Response(ItemSerializer(item).data)
```

### URL Registration
```python
# apps/items/urls.py
from rest_framework.routers import DefaultRouter
from .views import ItemViewSet

router = DefaultRouter()
router.register("items", ItemViewSet, basename="item")

urlpatterns = router.urls
```

```python
# config/urls.py
from django.urls import path, include

urlpatterns = [
    path("admin/", admin.site.urls),
    path("api/v1/", include("apps.accounts.urls")),
    path("api/v1/", include("apps.items.urls")),
]
```

## Celery Tasks

```python
# apps/items/tasks.py
from celery import shared_task
from django.core.mail import send_mail


@shared_task(bind=True, max_retries=3)
def send_item_notification(self, item_id: int, recipient_email: str) -> None:
    try:
        from .models import Item
        item = Item.objects.get(pk=item_id)
        send_mail(
            subject=f"New item: {item.title}",
            message=f"A new item has been published: {item.title}",
            from_email="no-reply@example.com",
            recipient_list=[recipient_email],
        )
    except Exception as exc:
        raise self.retry(exc=exc, countdown=60)
```

```python
# config/celery.py
import os
from celery import Celery

os.environ.setdefault("DJANGO_SETTINGS_MODULE", "config.settings.development")

app = Celery("config")
app.config_from_object("django.conf:settings", namespace="CELERY")
app.autodiscover_tasks()
```

## Testing (pytest-django)

### conftest.py
```python
# conftest.py
import pytest
from rest_framework.test import APIClient
from django.contrib.auth import get_user_model

User = get_user_model()


@pytest.fixture
def api_client() -> APIClient:
    return APIClient()


@pytest.fixture
def user(db) -> User:
    return User.objects.create_user(
        username="testuser",
        email="test@example.com",
        password="testpass123",
    )


@pytest.fixture
def auth_client(api_client: APIClient, user: User) -> APIClient:
    api_client.force_authenticate(user=user)
    return api_client
```

### API Tests
```python
# apps/items/tests/test_views.py
import pytest
from django.urls import reverse
from apps.items.models import Item


@pytest.mark.django_db
class TestItemViewSet:
    def test_list_items(self, auth_client, user):
        Item.objects.create(owner=user, title="My Item")
        url = reverse("item-list")
        response = auth_client.get(url)

        assert response.status_code == 200
        assert response.data["count"] == 1

    def test_create_item(self, auth_client):
        url = reverse("item-list")
        payload = {"title": "New Item", "description": "A test item"}
        response = auth_client.post(url, payload)

        assert response.status_code == 201
        assert response.data["title"] == "New Item"

    def test_unauthenticated_request(self, api_client):
        url = reverse("item-list")
        response = api_client.get(url)

        assert response.status_code == 401
```

## Environment Variables
Create `.env`:
```bash
DJANGO_SECRET_KEY=your-secret-key-at-least-50-characters-long
DJANGO_DEBUG=true
DJANGO_ALLOWED_HOSTS=localhost,127.0.0.1

DATABASE_URL=postgres://user:pass@localhost:5432/myapp

REDIS_URL=redis://localhost:6379/0

# Email
EMAIL_BACKEND=django.core.mail.backends.console.EmailBackend
DEFAULT_FROM_EMAIL=noreply@example.com
```

## Key Files
| Purpose | File |
|---------|------|
| Settings | `config/settings/base.py` |
| Root URLs | `config/urls.py` |
| Celery | `config/celery.py` |
| User model | `apps/accounts/models.py` |
| Test fixtures | `conftest.py` |

## Commands
```bash
# Development
python manage.py runserver           # Start dev server
python manage.py shell_plus          # Interactive shell (django-extensions)

# Database
python manage.py migrate             # Apply migrations
python manage.py makemigrations      # Create new migrations
python manage.py createsuperuser     # Create admin user

# Celery
celery -A config worker -l info      # Start worker
celery -A config beat -l info        # Start scheduler

# Testing
pytest                               # Run all tests
pytest -v                            # Verbose output
pytest apps/items/                   # Test specific app
pytest --cov=apps --cov-report=html  # Coverage report

# Code Quality
ruff check .                         # Lint
ruff format .                        # Format
mypy apps/                           # Type check
```

## Code Style

### Python Conventions
- Type hints on all functions and methods
- Use Django's `from __future__ import annotations` for forward refs
- Prefer class-based views (ViewSets) over function-based views for APIs
- Keep business logic in services or model methods, not views

### Django Conventions
- Use `select_related` / `prefetch_related` to prevent N+1 queries
- Override `get_queryset` to filter by authenticated user
- Use `update_fields` when saving partial model updates
- Add `__str__` to every model

---

## Notes
[Any additional project-specific notes, third-party integrations, or deployment details]

## Resources
- [Django Documentation](https://docs.djangoproject.com/)
- [Django REST Framework](https://www.django-rest-framework.org/)
- [Celery Documentation](https://docs.celeryq.dev/)
- [pytest-django](https://pytest-django.readthedocs.io/)
