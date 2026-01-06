"""Database configuration and session management."""
from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session
from sqlalchemy.pool import NullPool
from geoalchemy2 import Geometry
import logging

from app.config import get_settings

logger = logging.getLogger(__name__)

settings = get_settings()

# Create engine
engine = create_engine(
    settings.DATABASE_URL,
    echo=settings.DEBUG,
    poolclass=NullPool if settings.DEBUG else None,
)

# Session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)


def get_db() -> Session:
    """Get database session."""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


# Base class for models
from sqlalchemy.orm import declarative_base

Base = declarative_base()


def init_db():
    """Initialize database tables."""
    Base.metadata.create_all(bind=engine)
    logger.info("Database tables created/verified")
