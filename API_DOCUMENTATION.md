# API Documentation

## Business Data Research, Management and Maintenance System API

### Base URL
```
http://localhost:5000/api
```

### Authentication
Currently, the API does not require authentication. In production, implement appropriate authentication mechanisms.

## Endpoints

### Business Endpoints

#### List All Businesses
```http
GET /api/businesses
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "TechStart Inc.",
    "industry": "Technology",
    "description": "A fast-growing startup...",
    "location": "San Francisco, CA",
    "contact_email": "info@techstart.com",
    "contact_phone": "(415) 555-0100",
    "website": "https://techstart.example.com",
    "status": "active",
    "created_at": "2026-01-04T23:00:00",
    "updated_at": "2026-01-04T23:00:00"
  }
]
```

#### Create Business
```http
POST /api/businesses
Content-Type: application/json
```

**Request Body:**
```json
{
  "name": "Example Corp",
  "industry": "Technology",
  "description": "A technology company",
  "location": "New York, NY",
  "contact_email": "info@example.com",
  "contact_phone": "(555) 123-4567",
  "website": "https://example.com",
  "status": "active"
}
```

**Response:** `201 Created`
```json
{
  "id": 2,
  "name": "Example Corp",
  ...
}
```

#### Get Business by ID
```http
GET /api/businesses/{id}
```

**Response:** `200 OK`
```json
{
  "id": 1,
  "name": "TechStart Inc.",
  ...
}
```

#### Update Business
```http
PUT /api/businesses/{id}
Content-Type: application/json
```

**Request Body:** (all fields optional)
```json
{
  "name": "Updated Name",
  "status": "inactive"
}
```

**Response:** `200 OK`

#### Delete Business
```http
DELETE /api/businesses/{id}
```

**Response:** `200 OK`
```json
{
  "message": "Business deleted successfully"
}
```

### Research Endpoints

#### List All Research Records
```http
GET /api/research
```

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "business_id": 1,
    "title": "Market Analysis Q1 2026",
    "content": "Conducted comprehensive market analysis...",
    "category": "Market Research",
    "researcher": "Jane Smith",
    "findings": "The AI market is growing at 45% YoY...",
    "created_at": "2026-01-04T23:00:00",
    "updated_at": "2026-01-04T23:00:00"
  }
]
```

#### Create Research Record
```http
POST /api/research
Content-Type: application/json
```

**Request Body:**
```json
{
  "business_id": 1,
  "title": "New Research",
  "content": "Research content...",
  "category": "Market Research",
  "researcher": "John Doe",
  "findings": "Key findings..."
}
```

**Response:** `201 Created`

#### Get Research Record by ID
```http
GET /api/research/{id}
```

**Response:** `200 OK`

#### Update Research Record
```http
PUT /api/research/{id}
Content-Type: application/json
```

**Request Body:** (all fields optional)
```json
{
  "title": "Updated Title",
  "findings": "Updated findings"
}
```

**Response:** `200 OK`

#### Delete Research Record
```http
DELETE /api/research/{id}
```

**Response:** `200 OK`

### Search & Analytics Endpoints

#### Search Businesses
```http
GET /api/search?q={query}
```

**Parameters:**
- `q`: Search query (searches name, industry, description, location)

**Response:** `200 OK`
```json
[
  {
    "id": 1,
    "name": "TechStart Inc.",
    ...
  }
]
```

#### Get Statistics
```http
GET /api/stats
```

**Response:** `200 OK`
```json
{
  "total_businesses": 5,
  "active_businesses": 4,
  "inactive_businesses": 1,
  "total_research": 10,
  "industries": [
    {
      "industry": "Technology",
      "count": 2
    }
  ]
}
```

### Maintenance Endpoints

#### Validate Data
```http
GET /api/maintenance/validate
```

**Response:** `200 OK`
```json
{
  "valid": true,
  "issues": []
}
```

## Error Responses

### 400 Bad Request
```json
{
  "error": "Business name is required"
}
```

### 404 Not Found
```json
{
  "error": "Not found"
}
```

## Examples Using curl

### Create a business
```bash
curl -X POST http://localhost:5000/api/businesses \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Company",
    "industry": "Technology",
    "status": "active"
  }'
```

### Search for businesses
```bash
curl "http://localhost:5000/api/search?q=technology"
```

### Add research record
```bash
curl -X POST http://localhost:5000/api/research \
  -H "Content-Type: application/json" \
  -d '{
    "business_id": 1,
    "title": "Market Research",
    "category": "Analysis",
    "researcher": "John Smith",
    "findings": "Key market insights..."
  }'
```

### Get statistics
```bash
curl http://localhost:5000/api/stats
```

## Notes

- All datetime fields are in ISO 8601 format
- The `business_id` field in research records must reference an existing business
- Deleting a business will cascade delete all associated research records
- Search is case-insensitive and uses partial matching
