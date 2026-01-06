"""Business model - core business entity."""
from sqlalchemy import Column, String, DateTime, ForeignKey, func, Float, Index
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.database import Base


class Business(Base):
    """Business entity - core business data."""

    __tablename__ = "businesses"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(500), nullable=False, index=True)
    category = Column(String(255), nullable=False, index=True)
    description = Column(String(2000), nullable=True)
    address = Column(String(500), nullable=False)
    phone = Column(String(20), nullable=True, index=True)
    website = Column(String(500), nullable=True)
    email = Column(String(255), nullable=True)
    city_id = Column(UUID(as_uuid=True), ForeignKey("cities.id"), nullable=False, index=True)
    status = Column(String(50), default="active", nullable=False)
    confidence_score = Column(Float, default=1.0)
    fingerprint_hash = Column(String(64), nullable=True, index=True)
    first_seen_date = Column(DateTime, server_default=func.now())
    last_verified_date = Column(DateTime, server_default=func.now(), onupdate=func.now())
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    # Relationships
    city = relationship("City", back_populates="businesses")
    sources = relationship("BusinessSource", back_populates="business", cascade="all, delete-orphan")

    # Indexes
    __table_args__ = (
        Index("idx_business_city_name", "city_id", "name"),
        Index("idx_business_fingerprint", "fingerprint_hash"),
    )

    def __repr__(self):
        return f"<Business {self.name}>"

    def to_dict(self, include_sources=True):
        """Convert to dictionary representation."""
        data = {
            "id": str(self.id),
            "name": self.name,
            "category": self.category,
            "description": self.description,
            "address": self.address,
            "phone": self.phone,
            "website": self.website,
            "email": self.email,
            "city_id": str(self.city_id),
            "status": self.status,
            "confidence_score": self.confidence_score,
            "first_seen_date": self.first_seen_date.isoformat() if self.first_seen_date else None,
            "last_verified_date": self.last_verified_date.isoformat() if self.last_verified_date else None,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
        if include_sources:
            data["sources"] = [s.to_dict() for s in self.sources]
        return data
