"""City API routes."""
from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.schemas import CitySchema, CityCreateSchema
from app.models import City

router = APIRouter(prefix="/cities", tags=["cities"])


@router.get("", response_model=List[CitySchema])
async def list_cities(
    country_id: str = Query(None),
    db: Session = Depends(get_db),
):
    """List cities, optionally filtered by country."""
    query = db.query(City)
    if country_id:
        query = query.filter(City.country_id == country_id)
    return query.all()


@router.get("/{city_id}", response_model=CitySchema)
async def get_city(city_id: str, db: Session = Depends(get_db)):
    """Get a specific city by ID."""
    city = db.query(City).filter(City.id == city_id).first()
    if not city:
        raise HTTPException(status_code=404, detail="City not found")
    return city


@router.post("", response_model=CitySchema)
async def create_city(data: CityCreateSchema, db: Session = Depends(get_db)):
    """Create a new city."""
    city = City(
        name=data.name,
        country_id=data.country_id,
        state=data.state,
        latitude=data.latitude,
        longitude=data.longitude,
        population=data.population,
        timezone=data.timezone,
    )
    db.add(city)
    db.commit()
    db.refresh(city)
    return city
