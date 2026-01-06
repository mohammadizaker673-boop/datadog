"""WSGI entry point for production deployment."""
from app.main import app

# For deployment with gunicorn or similar
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
