"""Business API routes."""
from fastapi import APIRouter, Depends, HTTPException, Query, BackgroundTasks
from sqlalchemy.orm import Session
from typing import List
import hashlib

from app.database import get_db
from app.schemas import BusinessSchema, BusinessCreateSchema, BusinessExtractionRequest
from app.models import Business, City
from app.services.extraction_service import ExtractionService

router = APIRouter(prefix="/businesses", tags=["businesses"])
extraction_service = ExtractionService()


def _generate_fingerprint(name: str, address: str, latitude: float = None, longitude: float = None) -> str:
    """Generate fingerprint hash for a business."""
    fingerprint_input = f"{name.lower().strip()}|{address.lower().strip()}|{latitude}|{longitude}"
    return hashlib.sha256(fingerprint_input.encode()).hexdigest()


@router.get("", response_model=List[BusinessSchema])
async def list_businesses(
    city_id: str = Query(None),
    category: str = Query(None),
    status: str = Query("active"),
    skip: int = Query(0, ge=0),
    limit: int = Query(100, ge=1, le=1000),
    db: Session = Depends(get_db),
):
    """List businesses, optionally filtered by city, category, or status."""
    query = db.query(Business)
    if city_id:
        query = query.filter(Business.city_id == city_id)
    if category:
        query = query.filter(Business.category == category)
    query = query.filter(Business.status == status)
    return query.offset(skip).limit(limit).all()


@router.get("/{business_id}", response_model=BusinessSchema)
async def get_business(business_id: str, db: Session = Depends(get_db)):
    """Get a specific business by ID."""
    business = db.query(Business).filter(Business.id == business_id).first()
    if not business:
        raise HTTPException(status_code=404, detail="Business not found")
    return business


@router.post("", response_model=BusinessSchema)
async def create_business(data: BusinessCreateSchema, db: Session = Depends(get_db)):
    """Create a new business."""
    # Verify city exists
    city = db.query(City).filter(City.id == data.city_id).first()
    if not city:
        raise HTTPException(status_code=400, detail="City not found")

    # Generate fingerprint
    fingerprint = _generate_fingerprint(data.name, data.address, None, None)

    business = Business(
        name=data.name,
        category=data.category,
        description=data.description,
        address=data.address,
        phone=data.phone,
        website=data.website,
        email=data.email,
        city_id=data.city_id,
        status=data.status,
        confidence_score=data.confidence_score,
        fingerprint_hash=fingerprint,
    )
    db.add(business)
    db.commit()
    db.refresh(business)
    return business


@router.post("/extract", response_model=dict)
async def extract_businesses(
    request: BusinessExtractionRequest,
    background_tasks: BackgroundTasks,
    db: Session = Depends(get_db),
):
    """
    Extract businesses for a selected city.
    
    This endpoint initiates the data extraction process.
    For large cities, extraction happens asynchronously.
    """
    # Verify city exists
    city = db.query(City).filter(City.id == request.city_id).first()
    if not city:
        raise HTTPException(status_code=400, detail="City not found")

    # Start background extraction task
    background_tasks.add_task(
        extraction_service.extract_city_businesses,
        city_id=request.city_id,
        category=request.category,
        company_size=request.company_size,
    )

    return {
        "status": "extraction_started",
        "city_id": request.city_id,
        "message": "Business data extraction has been initiated. Results will be available shortly.",
    }
