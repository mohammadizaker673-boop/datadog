"""Business source model - tracks data provenance."""
from sqlalchemy import Column, String, DateTime, ForeignKey, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.database import Base


class BusinessSource(Base):
    """Business source entity - tracks which sources provided which data."""

    __tablename__ = "business_sources"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    business_id = Column(UUID(as_uuid=True), ForeignKey("businesses.id"), nullable=False, index=True)
    source_name = Column(String(255), nullable=False, index=True)
    source_id = Column(String(500), nullable=True)
    last_verified = Column(DateTime, server_default=func.now(), onupdate=func.now())
    created_at = Column(DateTime, server_default=func.now())

    # Relationships
    business = relationship("Business", back_populates="sources")

    def __repr__(self):
        return f"<BusinessSource {self.source_name} ({self.source_id})>"

    def to_dict(self):
        """Convert to dictionary representation."""
        return {
            "id": str(self.id),
            "business_id": str(self.business_id),
            "source_name": self.source_name,
            "source_id": self.source_id,
            "last_verified": self.last_verified.isoformat() if self.last_verified else None,
            "created_at": self.created_at.isoformat() if self.created_at else None,
        }
