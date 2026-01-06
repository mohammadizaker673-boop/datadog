"""Continent schemas."""
from pydantic import BaseModel
from datetime import datetime
from typing import Optional


class ContinentCreateSchema(BaseModel):
    """Schema for creating a continent."""

    name: str
    code: str


class ContinentSchema(ContinentCreateSchema):
    """Schema for continent responses."""

    id: str
    created_at: Optional[datetime] = None
    updated_at: Optional[datetime] = None

    class Config:
        from_attributes = True
