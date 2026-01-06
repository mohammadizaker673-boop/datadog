"""Test configuration."""
import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

from app.database import Base, get_db
from app.main import app


@pytest.fixture(scope="session")
def test_db():
    """Create test database."""
    SQLALCHEMY_DATABASE_URL = "sqlite:///./test.db"
    engine = create_engine(
        SQLALCHEMY_DATABASE_URL, connect_args={"check_same_thread": False}
    )
    Base.metadata.create_all(bind=engine)
    yield engine


@pytest.fixture(scope="function")
def db_session(test_db):
    """Create database session for tests."""
    connection = test_db.connect()
    transaction = connection.begin()
    session = sessionmaker(autocommit=False, autoflush=False, bind=connection)()

    def override_get_db():
        try:
            yield session
        finally:
            session.close()

    app.dependency_overrides[get_db] = override_get_db
    yield session
    transaction.rollback()
    connection.close()


@pytest.fixture
def client(db_session):
    """Create test client."""
    from fastapi.testclient import TestClient
    return TestClient(app)
