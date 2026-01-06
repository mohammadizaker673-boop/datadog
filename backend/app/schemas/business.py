"""Business schemas."""
from pydantic import BaseModel, HttpUrl
from datetime import datetime
from typing import Optional, List


class BusinessSourceSchema(BaseModel):
    """Schema for business source."""

    id: str
    source_name: str
    source_id: Optional[str] = None
    last_verified: Optional[datetime] = None


class BusinessCreateSchema(BaseModel):
    """Schema for creating a business."""

    name: str
    category: str
    address: str
    city_id: str
    description: Optional[str] = None
    phone: Optional[str] = None
    website: Optional[str] = None
    email: Optional[str] = None
    status: Optional[str] = "active"
    confidence_score: Optional[float] = 1.0


class BusinessSchema(BusinessCreateSchema):
    """Schema for business responses."""

    id: str
    fingerprint_hash: Optional[str] = None
    first_seen_date: Optional[datetime] = None
    last_verified_date: Optional[datetime] = None
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None
    sources: Optional[List[BusinessSourceSchema]] = []

    class Config:
        from_attributes = True


class BusinessExtractionRequest(BaseModel):
    """Schema for business extraction request."""

    continent_id: Optional[str] = None
    country_id: Optional[str] = None
    city_id: str
    category: Optional[str] = None
    company_size: Optional[str] = None
    status: Optional[str] = "active"
