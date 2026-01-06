"""Country schemas."""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional, List


class CountryCreateSchema(BaseModel):
    """Schema for creating a country."""

    name: str
    iso_code: str
    iso3_code: str
    continent_id: str
    currency: Optional[str] = None
    language: Optional[List[str]] = None


class CountrySchema(CountryCreateSchema):
    """Schema for country responses."""

    id: str
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
