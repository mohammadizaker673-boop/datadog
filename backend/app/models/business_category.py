"""Business category model - standardized categories."""
from sqlalchemy import Column, String, DateTime, ForeignKey, func
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
import uuid

from app.database import Base


class BusinessCategory(Base):
    """Business category entity - standardized categories across providers."""

    __tablename__ = "business_categories"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    name = Column(String(255), nullable=False, unique=True, index=True)
    parent_category_id = Column(UUID(as_uuid=True), ForeignKey("business_categories.id"), nullable=True)
    created_at = Column(DateTime, server_default=func.now())
    updated_at = Column(DateTime, server_default=func.now(), onupdate=func.now())

    # Self-referencing relationship for hierarchy
    parent = relationship("BusinessCategory", remote_side=[id], backref="children")

    def __repr__(self):
        return f"<BusinessCategory {self.name}>"

    def to_dict(self):
        """Convert to dictionary representation."""
        return {
            "id": str(self.id),
            "name": self.name,
            "parent_category_id": str(self.parent_category_id) if self.parent_category_id else None,
            "created_at": self.created_at.isoformat() if self.created_at else None,
            "updated_at": self.updated_at.isoformat() if self.updated_at else None,
        }
