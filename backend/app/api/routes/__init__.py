"""API routes initialization."""
from app.api.routes.continents import router as continents_router
from app.api.routes.countries import router as countries_router
from app.api.routes.cities import router as cities_router
from app.api.routes.businesses import router as businesses_router
from app.api.routes.health import router as health_router

__all__ = [
    "continents_router",
    "countries_router",
    "cities_router",
    "businesses_router",
    "health_router",
]
