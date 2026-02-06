# [Python Application Name] - Project Documentation

## Overview
[Brief description of what this Python application does and its primary purpose]

## Tech Stack
- **Python** [version, e.g., 3.11+]
- **[Framework]** - FastAPI / Flask / Django / None
- **[Database]** - PostgreSQL / MongoDB / SQLite (if used)
- **[ORM]** - SQLAlchemy / Tortoise ORM / Django ORM (if used)
- **[Validation]** - Pydantic / Marshmallow (if used)
- **[Testing]** - pytest / unittest
- **[Linting]** - ruff / flake8 / pylint
- **[Formatting]** - black / ruff format
- **[Type Checking]** - mypy / pyright

## Project Structure
```
project/
├── src/
│   ├── __init__.py
│   ├── main.py             # Application entry point
│   ├── config.py           # Configuration management
│   ├── models/             # Data models
│   │   ├── __init__.py
│   │   └── user.py
│   ├── routes/             # API routes (FastAPI/Flask)
│   │   ├── __init__.py
│   │   ├── auth.py
│   │   └── users.py
│   ├── services/           # Business logic
│   │   ├── __init__.py
│   │   └── user_service.py
│   ├── schemas/            # Pydantic schemas/validation
│   │   ├── __init__.py
│   │   └── user.py
│   ├── middleware/         # Custom middleware
│   │   └── auth.py
│   └── utils/              # Utility functions
│       ├── __init__.py
│       ├── database.py
│       └── helpers.py
├── tests/
│   ├── __init__.py
│   ├── conftest.py         # pytest fixtures
│   ├── test_auth.py
│   └── test_users.py
├── alembic/                # Database migrations (if SQLAlchemy)
│   └── versions/
├── .env.example            # Example environment variables
├── pyproject.toml          # Project metadata and dependencies
├── requirements.txt        # Or use pyproject.toml
└── README.md
```

## Environment Setup

### Virtual Environment
```bash
# Create virtual environment
python -m venv venv

# Activate
source venv/bin/activate  # Linux/Mac
venv\Scripts\activate     # Windows

# Install dependencies
pip install -r requirements.txt
# or
pip install -e .
```

### pyproject.toml Configuration
```toml
[project]
name = "project-name"
version = "0.1.0"
requires-python = ">=3.11"
dependencies = [
    "fastapi>=0.109.0",
    "uvicorn[standard]>=0.27.0",
    "pydantic>=2.5.0",
    "sqlalchemy>=2.0.0",
    "pydantic-settings>=2.1.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-asyncio>=0.21.0",
    "black>=23.12.0",
    "mypy>=1.8.0",
    "ruff>=0.1.9",
]

[tool.ruff]
line-length = 100
select = ["E", "F", "I"]

[tool.black]
line-length = 100

[tool.mypy]
strict = true
python_version = "3.11"
```

## Application Entry Point

### FastAPI Application
```python
# src/main.py
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from src.routes import auth, users
from src.config import settings
from src.utils.database import init_db

app = FastAPI(
    title=settings.APP_NAME,
    version=settings.VERSION,
    docs_url="/docs" if settings.DEBUG else None,
)

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(auth.router, prefix="/api/auth", tags=["auth"])
app.include_router(users.router, prefix="/api/users", tags=["users"])

@app.on_event("startup")
async def startup():
    await init_db()

@app.get("/health")
async def health_check():
    return {"status": "healthy"}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(
        "src.main:app",
        host="0.0.0.0",
        port=8000,
        reload=settings.DEBUG,
    )
```

## Configuration Management

### Settings with Pydantic
```python
# src/config.py
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    model_config = SettingsConfigDict(
        env_file=".env",
        env_file_encoding="utf-8",
        case_sensitive=False,
    )

    # App
    APP_NAME: str = "My Application"
    VERSION: str = "1.0.0"
    DEBUG: bool = False

    # Database
    DATABASE_URL: str

    # Security
    SECRET_KEY: str
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 30

    # CORS
    CORS_ORIGINS: list[str] = ["http://localhost:3000"]

settings = Settings()
```

## API Routes (FastAPI)

### Route Definition
```python
# src/routes/users.py
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from src.schemas.user import UserCreate, UserResponse, UserUpdate
from src.services import user_service
from src.middleware.auth import get_current_user
from src.utils.database import get_db

router = APIRouter()

@router.get("/", response_model=list[UserResponse])
async def list_users(
    skip: int = 0,
    limit: int = 100,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    """List all users (admin only)"""
    if current_user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized",
        )
    return user_service.get_users(db, skip=skip, limit=limit)

@router.get("/{user_id}", response_model=UserResponse)
async def get_user(
    user_id: int,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    """Get user by ID"""
    user = user_service.get_user(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
    return user

@router.post("/", response_model=UserResponse, status_code=status.HTTP_201_CREATED)
async def create_user(
    user: UserCreate,
    db: Session = Depends(get_db),
):
    """Create new user"""
    return user_service.create_user(db, user)

@router.put("/{user_id}", response_model=UserResponse)
async def update_user(
    user_id: int,
    user: UserUpdate,
    db: Session = Depends(get_db),
    current_user = Depends(get_current_user),
):
    """Update user"""
    if current_user.id != user_id and current_user.role != "admin":
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail="Not authorized",
        )
    updated_user = user_service.update_user(db, user_id, user)
    if not updated_user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail="User not found",
        )
    return updated_user
```

## Pydantic Schemas

### Request/Response Models
```python
# src/schemas/user.py
from pydantic import BaseModel, EmailStr, Field
from datetime import datetime

class UserBase(BaseModel):
    email: EmailStr
    username: str = Field(min_length=3, max_length=50)
    full_name: str | None = None

class UserCreate(UserBase):
    password: str = Field(min_length=8, max_length=100)

class UserUpdate(BaseModel):
    email: EmailStr | None = None
    username: str | None = Field(None, min_length=3, max_length=50)
    full_name: str | None = None

class UserResponse(UserBase):
    id: int
    is_active: bool
    created_at: datetime

    model_config = {
        "from_attributes": True,  # Allows SQLAlchemy models
    }

class UserInDB(UserResponse):
    hashed_password: str
```

## Database Models (SQLAlchemy)

### Model Definition
```python
# src/models/user.py
from sqlalchemy import Boolean, Column, Integer, String, DateTime
from sqlalchemy.sql import func
from src.utils.database import Base

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    username = Column(String, unique=True, index=True, nullable=False)
    full_name = Column(String, nullable=True)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)
    role = Column(String, default="user")
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    updated_at = Column(DateTime(timezone=True), onupdate=func.now())
```

### Database Connection
```python
# src/utils/database.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from src.config import settings

engine = create_engine(
    settings.DATABASE_URL,
    pool_pre_ping=True,
    echo=settings.DEBUG,
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    """Dependency for getting database session"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

async def init_db():
    """Initialize database (create tables)"""
    Base.metadata.create_all(bind=engine)
```

## Service Layer

### Business Logic
```python
# src/services/user_service.py
from sqlalchemy.orm import Session
from src.models.user import User
from src.schemas.user import UserCreate, UserUpdate
from src.utils.security import get_password_hash

def get_users(db: Session, skip: int = 0, limit: int = 100) -> list[User]:
    return db.query(User).offset(skip).limit(limit).all()

def get_user(db: Session, user_id: int) -> User | None:
    return db.query(User).filter(User.id == user_id).first()

def get_user_by_email(db: Session, email: str) -> User | None:
    return db.query(User).filter(User.email == email).first()

def create_user(db: Session, user: UserCreate) -> User:
    hashed_password = get_password_hash(user.password)
    db_user = User(
        email=user.email,
        username=user.username,
        full_name=user.full_name,
        hashed_password=hashed_password,
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def update_user(db: Session, user_id: int, user: UserUpdate) -> User | None:
    db_user = get_user(db, user_id)
    if not db_user:
        return None

    update_data = user.model_dump(exclude_unset=True)
    for field, value in update_data.items():
        setattr(db_user, field, value)

    db.commit()
    db.refresh(db_user)
    return db_user

def delete_user(db: Session, user_id: int) -> bool:
    db_user = get_user(db, user_id)
    if not db_user:
        return False

    db.delete(db_user)
    db.commit()
    return True
```

## Authentication & Authorization

### JWT Token Authentication
```python
# src/middleware/auth.py
from datetime import datetime, timedelta
from jose import JWTError, jwt
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from sqlalchemy.orm import Session

from src.config import settings
from src.utils.database import get_db
from src.services import user_service

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="/api/auth/login")

def create_access_token(data: dict) -> str:
    to_encode = data.copy()
    expire = datetime.utcnow() + timedelta(
        minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
    )
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)

async def get_current_user(
    token: str = Depends(oauth2_scheme),
    db: Session = Depends(get_db),
):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )

    try:
        payload = jwt.decode(
            token,
            settings.SECRET_KEY,
            algorithms=[settings.ALGORITHM]
        )
        user_id: int = payload.get("sub")
        if user_id is None:
            raise credentials_exception
    except JWTError:
        raise credentials_exception

    user = user_service.get_user(db, user_id)
    if user is None:
        raise credentials_exception

    return user
```

### Password Hashing
```python
# src/utils/security.py
from passlib.context import CryptContext

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)

def get_password_hash(password: str) -> str:
    return pwd_context.hash(password)
```

## Testing with pytest

### Test Configuration
```python
# tests/conftest.py
import pytest
from fastapi.testclient import TestClient
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from src.main import app
from src.utils.database import Base, get_db

SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"

engine = create_engine(
    SQLALCHEMY_DATABASE_URL,
    connect_args={"check_same_thread": False}
)
TestingSessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

@pytest.fixture
def db():
    Base.metadata.create_all(bind=engine)
    db = TestingSessionLocal()
    try:
        yield db
    finally:
        db.close()
        Base.metadata.drop_all(bind=engine)

@pytest.fixture
def client(db):
    def override_get_db():
        try:
            yield db
        finally:
            pass

    app.dependency_overrides[get_db] = override_get_db
    yield TestClient(app)
    app.dependency_overrides.clear()
```

### Unit Tests
```python
# tests/test_users.py
import pytest
from src.schemas.user import UserCreate
from src.services import user_service

def test_create_user(db):
    user_data = UserCreate(
        email="test@example.com",
        username="testuser",
        password="testpass123",
    )
    user = user_service.create_user(db, user_data)

    assert user.email == "test@example.com"
    assert user.username == "testuser"
    assert user.id is not None

def test_get_user_by_email(db):
    user_data = UserCreate(
        email="test@example.com",
        username="testuser",
        password="testpass123",
    )
    created_user = user_service.create_user(db, user_data)

    found_user = user_service.get_user_by_email(db, "test@example.com")

    assert found_user is not None
    assert found_user.id == created_user.id
```

### Integration Tests
```python
# tests/test_auth.py
def test_register_user(client):
    response = client.post(
        "/api/auth/register",
        json={
            "email": "test@example.com",
            "username": "testuser",
            "password": "testpass123",
        },
    )
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "test@example.com"
    assert "password" not in data

def test_login_success(client, db):
    # Create user first
    user_data = UserCreate(
        email="test@example.com",
        username="testuser",
        password="testpass123",
    )
    user_service.create_user(db, user_data)

    # Login
    response = client.post(
        "/api/auth/login",
        data={
            "username": "test@example.com",
            "password": "testpass123",
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"
```

## Type Hints

### Function Type Hints
```python
from typing import Optional, List

def get_users(
    db: Session,
    skip: int = 0,
    limit: int = 100
) -> list[User]:
    return db.query(User).offset(skip).limit(limit).all()

def process_data(
    items: list[str],
    config: dict[str, any],
) -> tuple[list[str], int]:
    processed = [item.upper() for item in items]
    return processed, len(processed)

async def fetch_data(url: str) -> dict[str, any] | None:
    # Implementation
    return None
```

## Environment Variables

Create `.env` file:
```bash
# Application
APP_NAME="My Application"
DEBUG=true

# Database
DATABASE_URL=postgresql://user:pass@localhost/dbname

# Security
SECRET_KEY=your-secret-key-here-min-32-characters
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=30

# CORS
CORS_ORIGINS=["http://localhost:3000","http://localhost:8000"]
```

## Commands
```bash
# Development
uvicorn src.main:app --reload     # Run dev server
python -m src.main                # Alternative way

# Testing
pytest                            # Run all tests
pytest -v                         # Verbose output
pytest tests/test_users.py        # Specific file
pytest -k test_create             # Tests matching pattern
pytest --cov=src                  # With coverage

# Code Quality
black .                           # Format code
ruff check .                      # Lint code
mypy src                          # Type checking

# Database
alembic revision --autogenerate -m "message"  # Create migration
alembic upgrade head              # Apply migrations
alembic downgrade -1              # Rollback one migration
```

## Code Style

### Python Conventions
- Use type hints for all function signatures
- Follow PEP 8 (enforced by black/ruff)
- Use descriptive variable names
- Keep functions small and focused

### Imports
```python
# Standard library
import os
from datetime import datetime

# Third-party
from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session

# Local
from src.models import User
from src.schemas import UserCreate
```

### Error Handling
```python
from fastapi import HTTPException, status

def get_user_or_404(db: Session, user_id: int) -> User:
    user = user_service.get_user(db, user_id)
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User {user_id} not found",
        )
    return user
```

---

## Notes
[Any additional Python/framework-specific conventions, third-party integrations, or important information]

## Resources
- [FastAPI Documentation](https://fastapi.tiangolo.com/)
- [SQLAlchemy Documentation](https://docs.sqlalchemy.org/)
- [Pydantic Documentation](https://docs.pydantic.dev/)
- [pytest Documentation](https://docs.pytest.org/)
