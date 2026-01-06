"""Backend project README."""

# Global Business Data Extraction App - Backend

A FastAPI-based backend for the Global Business Data Extraction platform.

## Architecture

- **Framework**: FastAPI (async Python web framework)
- **Database**: PostgreSQL with PostGIS for geographic queries
- **Cache/Queue**: Redis for caching and Celery message broker
- **ORM**: SQLAlchemy for database operations
- **Task Queue**: Celery for async data extraction

## Project Structure

```
backend/
├── app/
│   ├── models/          # SQLAlchemy database models
│   ├── schemas/         # Pydantic request/response schemas
│   ├── api/
│   │   └── routes/      # API endpoint handlers
│   ├── services/        # Business logic services
│   ├── providers/       # External data provider integrations
│   ├── utils/           # Utility functions
│   ├── config.py        # Application configuration
│   ├── database.py      # Database connection & initialization
│   ├── celery_tasks.py  # Async task definitions
│   └── main.py          # FastAPI application entry point
├── migrations/          # Database migrations (Alembic)
├── tests/               # Test suite
├── requirements.txt     # Python dependencies
├── Dockerfile           # Container image definition
└── README.md            # This file
```

## Setup

### Prerequisites
- Python 3.11+
- PostgreSQL 15+ with PostGIS
- Redis 7+

### Local Installation

1. **Create virtual environment**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your settings
   ```

4. **Initialize database**
   ```bash
   python -c "from app.database import init_db; init_db()"
   ```

5. **Seed initial data (continents, countries, cities)**
   ```bash
   python scripts/seed_data.py
   ```

## Running

### Development

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

API documentation available at: http://localhost:8000/docs

### With Docker Compose

```bash
docker-compose up
```

### Celery Worker (for async tasks)

```bash
celery -A app.celery_tasks worker --loglevel=info
```

## API Endpoints

### Location Management
- `GET /continents` - List all continents
- `GET /continents/{id}` - Get continent details
- `POST /continents` - Create continent
- `GET /countries?continent_id=` - List countries
- `GET /cities?country_id=` - List cities

### Business Data
- `GET /businesses?city_id=` - List businesses
- `POST /businesses` - Create business manually
- `POST /businesses/extract` - Extract businesses for a city

### Health
- `GET /health` - Health check

## Data Models

### Geographic Hierarchy
```
Continent
  └── Country
      └── City
          └── Business
```

### Key Models
- **Continent**: Top-level geographic grouping
- **Country**: ISO-mapped countries
- **City**: City-level data with coordinates
- **Business**: Core business entity
- **BusinessSource**: Data provenance tracking
- **BusinessCategory**: Standardized categories

## External APIs

### Supported Providers
1. **Google Places API**
   - Primary global business discovery
   - Set `GOOGLE_PLACES_API_KEY` in `.env`

2. **OpenStreetMap Overpass API**
   - Free, open data source
   - No API key required

## Database Schema

See [Part 3 - Data Hierarchy Model](../../docs/Part3-DataHierarchyModel.md) for detailed schema specification.

## Development

### Running Tests
```bash
pytest tests/
pytest --cov=app tests/  # With coverage
```

### Database Migrations
```bash
# Create migration
alembic revision --autogenerate -m "Description"

# Apply migration
alembic upgrade head

# Rollback
alembic downgrade -1
```

### Code Quality
```bash
# Format code
black app/

# Lint
flake8 app/

# Type checking
mypy app/
```

## Performance Optimization

- Database indexes on frequently queried fields
- Redis caching for continents, countries, and cities
- Async/await throughout for high concurrency
- Connection pooling with SQLAlchemy
- Pagination for large result sets (1000 max)

## Future Enhancements

- AI-powered deduplication
- Scheduled city rescans
- Business lifecycle tracking
- Advanced analytics and insights
- API authentication & rate limiting
- Multi-tenant support

## Deployment

See [docker-compose.yml](../docker-compose.yml) for containerized deployment.

For production:
- Use environment-specific `.env` files
- Enable HTTPS
- Configure CORS properly
- Set up monitoring & logging
- Use managed PostgreSQL & Redis services
- Implement proper secrets management

## Contributing

1. Follow PEP 8 style guide
2. Write tests for new features
3. Update documentation
4. Make focused commits

## License

Proprietary - Global Business Data Extraction App
