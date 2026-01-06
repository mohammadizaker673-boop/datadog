"""Application configuration."""
from pydantic_settings import BaseSettings
from functools import lru_cache


class Settings(BaseSettings):
    """Application settings from environment variables."""

    # Database
    DATABASE_URL: str = "postgresql://datadog_user:datadog_pass@localhost:5432/datadog_db"
    
    # Redis
    REDIS_URL: str = "redis://localhost:6379/0"
    
    # API Keys
    GOOGLE_PLACES_API_KEY: str = ""
    
    # External APIs
    OVERPASS_API_URL: str = "https://overpass-api.de/api/interpreter"
    
    # Application
    SECRET_KEY: str = "change-me-in-production"
    DEBUG: bool = True
    LOG_LEVEL: str = "INFO"
    API_TITLE: str = "Global Business Data Extraction API"
    API_VERSION: str = "0.1.0"
    
    # Celery
    CELERY_BROKER_URL: str = "redis://localhost:6379/0"
    CELERY_RESULT_BACKEND: str = "redis://localhost:6379/0"
    
    # Data Extraction
    DEFAULT_SEARCH_RADIUS_KM: int = 5
    MAX_SEARCH_RADIUS_KM: int = 50
    EXTRACTION_TIMEOUT_SECONDS: int = 30
    MAX_RESULTS_PER_QUERY: int = 1000
    
    # Rate Limiting
    RATE_LIMIT_REQUESTS: int = 100
    RATE_LIMIT_PERIOD: int = 3600
    
    class Config:
        env_file = ".env"
        case_sensitive = True


@lru_cache()
def get_settings() -> Settings:
    """Get cached settings instance."""
    return Settings()
