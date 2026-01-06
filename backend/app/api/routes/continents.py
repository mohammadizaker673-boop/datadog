"""Continent API routes."""
from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List

from app.database import get_db
from app.schemas import ContinentSchema, ContinentCreateSchema
from app.models import Continent

router = APIRouter(prefix="/continents", tags=["continents"])


@router.get("", response_model=List[ContinentSchema])
async def list_continents(db: Session = Depends(get_db)):
    """List all continents."""
    continents = db.query(Continent).all()
    return continents


@router.get("/{continent_id}", response_model=ContinentSchema)
async def get_continent(continent_id: str, db: Session = Depends(get_db)):
    """Get a specific continent by ID."""
    continent = db.query(Continent).filter(Continent.id == continent_id).first()
    if not continent:
        raise HTTPException(status_code=404, detail="Continent not found")
    return continent


@router.post("", response_model=ContinentSchema)
async def create_continent(data: ContinentCreateSchema, db: Session = Depends(get_db)):
    """Create a new continent."""
    continent = Continent(name=data.name, code=data.code)
    db.add(continent)
    db.commit()
    db.refresh(continent)
    return continent
