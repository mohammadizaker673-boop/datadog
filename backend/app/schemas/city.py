"""City schemas."""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class CityCreateSchema(BaseModel):
    """Schema for creating a city."""

    name: str
    country_id: str
    state: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    population: Optional[int] = None
    timezone: Optional[str] = None


class CitySchema(CityCreateSchema):
    """Schema for city responses."""

    id: str
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
