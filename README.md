# Business Data Research, Management and Maintenance System

A comprehensive web-based system for managing business data, conducting research, and maintaining business information records. Built with Flask, SQLAlchemy, and SQLite.

## Features

### Core Functionality
- **Business Data Management**: Create, Read, Update, and Delete (CRUD) business entities
- **Research Records**: Associate research findings and notes with businesses
- **Search & Filter**: Full-text search across business names, industries, descriptions, and locations
- **Data Validation**: Built-in data integrity checks and validation
- **Status Tracking**: Track business status (active/inactive)

### Research Capabilities
- Link multiple research records to each business
- Categorize research by type
- Track researchers and findings
- Timestamp all research activities

### Maintenance Features
- Data validation API endpoint
- Statistics and analytics
- Database integrity checks
- Clean, intuitive web interface

## Installation

### Prerequisites
- Python 3.8 or higher
- pip (Python package manager)

### Setup

1. Clone the repository:
```bash
git clone https://github.com/mohammadizaker673-boop/datadog.git
cd datadog
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Run the application:
```bash
# For development (with debug mode):
FLASK_DEBUG=true python app.py

# For production (without debug mode):
python app.py
```

4. Open your browser and navigate to:
```
http://localhost:5000
```

The database will be created automatically on first run.

## Usage

### Web Interface

The system provides an intuitive web interface with the following pages:

- **Dashboard** (`/`): View statistics and recent businesses
- **New Business** (`/business/new`): Add a new business entity
- **Business Detail** (`/business/<id>`): View and manage a specific business
- **Research Records** (`/research`): View all research records
- **Search** (`/search`): Search for businesses

### API Endpoints

The system provides a REST API for programmatic access:

#### Business Endpoints

- `GET /api/businesses` - List all businesses
- `POST /api/businesses` - Create a new business
- `GET /api/businesses/<id>` - Get a specific business
- `PUT /api/businesses/<id>` - Update a business
- `DELETE /api/businesses/<id>` - Delete a business

#### Research Endpoints

- `GET /api/research` - List all research records
- `POST /api/research` - Create a new research record
- `GET /api/research/<id>` - Get a specific research record
- `PUT /api/research/<id>` - Update a research record
- `DELETE /api/research/<id>` - Delete a research record

#### Utility Endpoints

- `GET /api/search?q=<query>` - Search businesses
- `GET /api/stats` - Get system statistics
- `GET /api/maintenance/validate` - Validate data integrity

### API Examples

#### Create a Business
```bash
curl -X POST http://localhost:5000/api/businesses \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Example Corp",
    "industry": "Technology",
    "description": "A technology company",
    "location": "New York, NY",
    "contact_email": "info@example.com",
    "website": "https://example.com",
    "status": "active"
  }'
```

#### Search Businesses
```bash
curl "http://localhost:5000/api/search?q=technology"
```

#### Add Research Record
```bash
curl -X POST http://localhost:5000/api/research \
  -H "Content-Type: application/json" \
  -d '{
    "business_id": 1,
    "title": "Market Analysis",
    "category": "Market Research",
    "researcher": "John Doe",
    "content": "Research content here...",
    "findings": "Key findings here..."
  }'
```

#### Get Statistics
```bash
curl http://localhost:5000/api/stats
```

## Data Model

### Business Entity
- `id`: Unique identifier
- `name`: Business name (required)
- `industry`: Industry sector
- `description`: Business description
- `location`: Physical location
- `contact_email`: Contact email address
- `contact_phone`: Contact phone number
- `website`: Business website URL
- `status`: Business status (active/inactive)
- `created_at`: Creation timestamp
- `updated_at`: Last update timestamp

### Research Record
- `id`: Unique identifier
- `business_id`: Associated business (foreign key)
- `title`: Research title (required)
- `content`: Research content
- `category`: Research category
- `researcher`: Name of researcher
- `findings`: Research findings
- `created_at`: Creation timestamp
- `updated_at`: Last update timestamp

## Development

### Project Structure
```
datadog/
├── app.py                  # Main application file
├── requirements.txt        # Python dependencies
├── templates/              # HTML templates
│   ├── base.html          # Base template
│   ├── index.html         # Dashboard
│   ├── business_form.html # Business create/edit form
│   ├── business_detail.html # Business detail page
│   ├── research_list.html # Research list
│   └── search.html        # Search page
├── static/                 # Static assets
│   ├── css/
│   │   └── style.css      # Main stylesheet
│   └── js/
│       └── main.js        # JavaScript utilities
└── business_data.db       # SQLite database (created at runtime)
```

### Database
The system uses SQLite for data storage. The database file `business_data.db` is created automatically in the project root on first run.

## Maintenance

### Data Validation
Run the validation endpoint to check for data integrity issues:
```bash
curl http://localhost:5000/api/maintenance/validate
```

### Backup
To backup your data, simply copy the `business_data.db` file:
```bash
cp business_data.db business_data_backup.db
```

### Reset Database
To reset the database, delete the `business_data.db` file and restart the application:
```bash
rm business_data.db
python app.py
```

## Security Notes

- **Debug Mode**: Debug mode is disabled by default. Only enable it in development by setting `FLASK_DEBUG=true`. Never use debug mode in production as it can allow arbitrary code execution.
- **Secret Key**: Change the `SECRET_KEY` in production by setting the `SECRET_KEY` environment variable
- **Database**: Use a production-grade database (PostgreSQL, MySQL) for production deployments
- **Authentication**: Implement authentication and authorization for production use
- **HTTPS**: Use HTTPS in production
- **Input Validation**: Validate and sanitize all user inputs

## License

This project is open source and available for use and modification.

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.