"""Country API routes."""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.schemas import CountrySchema, CountryCreateSchema
from app.models import Country

router = APIRouter(prefix="/countries", tags=["countries"])


@router.get("", response_model=List[CountrySchema])
async def list_countries(
    continent_id: str = Query(None),
    db: Session = Depends(get_db),
):
    """List countries, optionally filtered by continent."""
    query = db.query(Country)
    if continent_id:
        query = query.filter(Country.continent_id == continent_id)
    return query.all()


@router.get("/{country_id}", response_model=CountrySchema)
async def get_country(country_id: str, db: Session = Depends(get_db)):
    """Get a specific country by ID."""
    country = db.query(Country).filter(Country.id == country_id).first()
    if not country:
        raise HTTPException(status_code=404, detail="Country not found")
    return country


@router.post("", response_model=CountrySchema)
async def create_country(data: CountryCreateSchema, db: Session = Depends(get_db)):
    """Create a new country."""
    country = Country(
        name=data.name,
        iso_code=data.iso_code,
        iso3_code=data.iso3_code,
        continent_id=data.continent_id,
        currency=data.currency,
        language=data.language,
    )
    db.add(country)
    db.commit()
    db.refresh(country)
    return country
