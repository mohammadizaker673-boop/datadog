"""Business source schemas."""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class BusinessSourceSchema(BaseModel):
    """Schema for business source."""

    id: str
    business_id: str
    source_name: str
    source_id: Optional[str] = None
    last_verified: Optional[datetime] = None
    created_at: Optional[datetime] = None

    class Config:
        from_attributes = True
