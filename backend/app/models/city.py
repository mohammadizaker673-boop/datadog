"""City model for geographic hierarchy."""
from sqlalchemy import Column, String, DateTime, ForeignKey, func, Float, Integer
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from geoalchemy2 import Geometry
import uuid

from app.database import Base


class City(Base):
    """City entity - stores city-level geographic data."""

    __tablename__ = "cities"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False, index=True)
    country_id = Column(UUID(as_uuid=True), ForeignKey("countries.id"), nullable=False, index=True)
    state = Column(String(255), nullable=True)
    latitude = Column(Float, nullable=True)
    longitude = Column(Float, nullable=True)
    geom = Column(Geometry("POINT", srid=4326), nullable=True)
    population = Column(Integer, nullable=True)
    timezone = Column(String(100), nullable=True)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    # Relationships
    country = relationship("Country", back_populates="cities")
    businesses = relationship("Business", back_populates="city", cascade="all, delete-orphan")

    def __repr__(self):
        return f"<City {self.name}>"

    def to_dict(self):
        """Convert to dictionary representation."""
        return {
            "id": str(self.id),
            "name": self.name,
            "country_id": str(self.country_id),
            "state": self.state,
            "latitude": self.latitude,
            "longitude": self.longitude,
            "population": self.population,
            "timezone": self.timezone,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
