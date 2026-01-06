"""Celery configuration and tasks."""
from celery import Celery
from app.config import get_settings

settings = get_settings()

celery_app = Celery(
    "datadog",
    broker=settings.CELERY_BROKER_URL,
    backend=settings.CELERY_RESULT_BACKEND,
)

celery_app.conf.update(
    task_serializer="json",
    accept_content=["json"],
    result_serializer="json",
    timezone="UTC",
    enable_utc=True,
)


@celery_app.task
def extract_city_businesses_task(city_id: str, category: str = None):
    """Async task for extracting businesses."""
    from app.services.extraction_service import ExtractionService
    
    service = ExtractionService()
    # TODO: Implement async extraction logic
    return {"status": "completed", "city_id": city_id}
