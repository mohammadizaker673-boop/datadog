"""Country model for geographic hierarchy."""
from sqlalchemy import Column, String, DateTime, ForeignKey, func
from sqlalchemy.dialects.postgresql import UUID, ARRAY
from sqlalchemy.orm import relationship
import uuid

from app.database import Base


class Country(Base):
    """Country entity - mapped to continents using ISO standards."""

    __tablename__ = "countries"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False, index=True)
    iso_code = Column(String(2), nullable=False, unique=True, index=True)
    iso3_code = Column(String(3), nullable=False, unique=True, index=True)
    continent_id = Column(UUID(as_uuid=True), ForeignKey("continents.id"), nullable=False, index=True)
    currency = Column(String(3), nullable=True)
    language = Column(ARRAY(String), nullable=True)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    # Relationships
    continent = relationship("Continent", back_populates="countries")
    cities = relationship("City", back_populates="country", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<Country {self.name} ({self.iso_code})>"

    def to_dict(self):
        """Convert to dictionary representation."""
        return {
            "id": str(self.id),
            "name": self.name,
            "iso_code": self.iso_code,
            "iso3_code": self.iso3_code,
            "continent_id": str(self.continent_id),
            "currency": self.currency,
            "language": self.language,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
