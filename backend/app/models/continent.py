"""Continent model for geographic hierarchy."""
from sqlalchemy import Column, String, DateTime, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.database import Base


class Continent(Base):
    """Continent entity - top-level geographic grouping."""

    __tablename__ = "continents"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False, unique=True, index=True)
    code = Column(String(10), nullable=False, unique=True, index=True)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    # Relationships
    countries = relationship("Country", back_populates="continent", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Continent {self.name} ({self.code})>"

    def to_dict(self):
        """Convert to dictionary representation."""
        return {
            "id": str(self.id),
            "name": self.name,
            "code": self.code,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
