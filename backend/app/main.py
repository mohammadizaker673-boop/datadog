"""Main FastAPI application."""
import logging
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.config import get_settings
from app.database import init_db
from app.api.routes import (
    continents_router,
    countries_router,
    cities_router,
    businesses_router,
    health_router,
)

# Setup logging
logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
)

settings = get_settings()

# Create FastAPI app
app = FastAPI(
    title=settings.API_TITLE,
    version=settings.API_VERSION,
    description="Global Business Data Extraction API - A system for discovering and managing business data across the world",
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # TODO: Configure properly for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include routers
app.include_router(health_router)
app.include_router(continents_router)
app.include_router(countries_router)
app.include_router(cities_router)
app.include_router(businesses_router)


@app.on_event("startup")
async def startup_event():
    """Initialize database on startup."""
    init_db()
    logging.info("Application startup completed")


@app.on_event("shutdown")
async def shutdown_event():
    """Cleanup on shutdown."""
    logging.info("Application shutdown")


@app.get("/")
async def root():
    """Root endpoint."""
    return {
        "message": "Global Business Data Extraction API",
        "version": settings.API_VERSION,
        "docs": "/docs",
    }
