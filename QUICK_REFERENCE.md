# Quick Reference Guide

## Project Overview

Global Business Data Extraction App - A comprehensive platform for discovering and managing business data globally.

**Status**: MVP Complete and Ready for Development
**Tech Stack**: Next.js + FastAPI + PostgreSQL + Redis + Celery

## Quick Commands

### Start Everything (Docker)
```bash
cd /workspaces/datadog
docker-compose up
```

### Access Points
| Service | URL |
|---------|-----|
| Frontend | http://localhost:3000 |
| Backend API | http://localhost:8000 |
| API Docs | http://localhost:8000/docs |
| Health Check | http://localhost:8000/health |

### Backend Development
```bash
cd backend
source venv/bin/activate
pip install -r requirements.txt
uvicorn app.main:app --reload
```

### Frontend Development
```bash
cd frontend
npm install
npm run dev
```

### Database Seeding
```bash
cd backend
python scripts/seed_data.py
```

### Run Tests
```bash
# Backend
cd backend && pytest tests/

# Frontend
cd frontend && npm test
```

## Key Endpoints

### Continents
- `GET /continents` - List all
- `GET /continents/{id}` - Get one
- `POST /continents` - Create

### Countries
- `GET /countries` - List all
- `GET /countries?continent_id={id}` - Filter by continent
- `POST /countries` - Create

### Cities
- `GET /cities` - List all
- `GET /cities?country_id={id}` - Filter by country
- `POST /cities` - Create

### Businesses
- `GET /businesses?city_id={id}` - List by city
- `POST /businesses` - Create
- `POST /businesses/extract` - Extract from city

## Database

### Connection
```
Host: localhost
Port: 5432
User: datadog_user
Password: datadog_pass
Database: datadog_db
```

### Main Tables
- `continents` - 7 static records
- `countries` - ISO-mapped countries
- `cities` - Cities with coordinates
- `businesses` - Business data
- `business_sources` - Data provenance
- `business_categories` - Category taxonomy

### Sample Data
Pre-seeded with:
- 7 continents
- 6 countries (Germany, US, UK, France, Japan, Australia)
- 6 cities (Berlin, New York, London, Paris, Tokyo, Sydney)

## File Structure Map

```
backend/
  ├── app/
  │   ├── models/        → Database models (ORM)
  │   ├── schemas/       → API request/response (Pydantic)
  │   ├── api/routes/    → API endpoints
  │   ├── services/      → Business logic
  │   ├── main.py        → FastAPI app
  │   └── config.py      → Settings
  ├── scripts/seed_data.py → DB initialization
  └── requirements.txt

frontend/
  ├── pages/index.tsx    → Main page
  ├── lib/api.ts         → API client
  ├── styles/            → CSS & Tailwind
  └── package.json
```

## Environment Setup

### Backend (.env)
```bash
DATABASE_URL=postgresql://datadog_user:datadog_pass@localhost:5432/datadog_db
REDIS_URL=redis://localhost:6379/0
GOOGLE_PLACES_API_KEY=your_api_key
SECRET_KEY=your_secret_key
DEBUG=True
```

### Frontend (.env.local - if needed)
```bash
NEXT_PUBLIC_API_URL=http://localhost:8000
```

## Common Tasks

### Add a Model
1. Create in `backend/app/models/your_model.py`
2. Create schema in `backend/app/schemas/your_schema.py`
3. Create routes in `backend/app/api/routes/your_route.py`
4. Add to `app/models/__init__.py` and `app/schemas/__init__.py`

### Seed New Data
```bash
# Edit backend/scripts/seed_data.py
# Then run:
python backend/scripts/seed_data.py
```

### Deploy Docker
```bash
docker build -t datadog-backend ./backend
docker build -t datadog-frontend ./frontend
docker-compose -f docker-compose.yml up -d
```

## Architecture

```
User → Frontend (Next.js)
       ↓
       API (FastAPI)
       ↓
       Services (Business Logic)
       ↓
       Database (PostgreSQL)
       Cache (Redis)
       Jobs (Celery)
```

## Performance Targets

| Target | Expectation |
|--------|------------|
| Page Load | < 1 second |
| Location Selection | < 300ms |
| API Response | < 500ms |
| Database Query | < 100ms |
| Extraction Start | < 2 seconds |

## Key Features (MVP)

✅ Location hierarchy (Continent → Country → City)
✅ Business data extraction
✅ Multi-provider support (architecture ready)
✅ CSV export
✅ Responsive UI
✅ Full REST API
✅ Database persistence
✅ Docker deployment
✅ Async task support
✅ Error handling

## Future Enhancements

**Phase 2** (Parts 8-10):
- User authentication
- Scheduled rescans
- Business lifecycle tracking
- Change detection
- Advanced analytics

**Phase 3** (Parts 11+):
- AI enrichment
- Market intelligence
- Lead generation
- API tiers
- Monetization

## Troubleshooting

### Port already in use
```bash
# Find process on port
lsof -i :8000  # Backend
lsof -i :3000  # Frontend
lsof -i :5432  # Postgres
# Kill: kill -9 <PID>
```

### Database connection error
```bash
# Check PostgreSQL
docker-compose logs postgres
# Rebuild
docker-compose down -v && docker-compose up
```

### API not responding
```bash
# Check backend
curl http://localhost:8000/health
# Check logs
docker-compose logs backend
```

### Frontend won't load
```bash
# Check npm
cd frontend && npm install
npm run dev
```

## Resources

- **Backend README**: `backend/README.md`
- **Frontend README**: `frontend/README.md`
- **Full Summary**: `IMPLEMENTATION_SUMMARY.md`
- **API Docs**: http://localhost:8000/docs
- **Specification**: Check the 11-part spec documents

## Key Concepts

### Fingerprint Hash
Unique identifier for each business: `hash(name + address + coordinates)`

### Data Provenance
Every business record tracks its source(s) via `business_sources` table

### Deduplication
Prevents duplicate businesses across multiple data sources

### Geo-awareness
PostGIS integration enables:
- Radius searches
- Bounding box queries
- Distance calculations

## Team Collaboration

### Git Workflow
```bash
git checkout -b feature/your-feature
git commit -m "Add feature"
git push origin feature/your-feature
# Create PR
```

### Code Standards
- Backend: PEP 8, type hints, docstrings
- Frontend: ESLint, Prettier, TypeScript strict

## Monitoring & Logging

### Backend Logs
```bash
docker-compose logs backend -f
```

### Database Logs
```bash
docker-compose logs postgres -f
```

### All Services
```bash
docker-compose logs -f
```

## Additional Help

For detailed information, see:
- Backend development: `backend/README.md`
- Frontend development: `frontend/README.md`
- Full implementation details: `IMPLEMENTATION_SUMMARY.md`
- API specification: Interactive docs at http://localhost:8000/docs

---

**Remember**: Start with `docker-compose up` for the fastest setup!
