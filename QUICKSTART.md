# Quick Start Guide

Get up and running with the Business Data Management System in 5 minutes!

## Prerequisites

- Python 3.8 or higher
- pip (Python package manager)

## Installation & Setup

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

This will install:
- Flask (web framework)
- Flask-SQLAlchemy (database ORM)
- Flask-CORS (cross-origin support)
- python-dotenv (environment configuration)

### 2. Load Sample Data (Optional)

```bash
python load_sample_data.py
```

This creates 5 sample businesses and 5 research records to help you explore the system.

### 3. Start the Application

```bash
# For development with debug mode (helpful error messages):
FLASK_DEBUG=true python app.py

# Or for production mode (more secure):
python app.py
```

You should see:
```
 * Running on http://127.0.0.1:5000
```

### 4. Access the Web Interface

Open your browser and go to:
```
http://localhost:5000
```

You'll see the dashboard with statistics and business listings.

## Basic Usage

### Using the Web Interface

1. **View Dashboard**: See statistics and recent businesses
2. **Add Business**: Click "New Business" to create a business entry
3. **View Details**: Click on any business name to see full details
4. **Add Research**: From a business detail page, click "Add Research"
5. **Search**: Use the search page to find businesses by keywords

### Using the API

#### Get all businesses
```bash
curl http://localhost:5000/api/businesses
```

#### Create a new business
```bash
curl -X POST http://localhost:5000/api/businesses \
  -H "Content-Type: application/json" \
  -d '{
    "name": "My Company",
    "industry": "Technology",
    "description": "An innovative tech company",
    "location": "San Francisco, CA",
    "status": "active"
  }'
```

#### Search for businesses
```bash
curl "http://localhost:5000/api/search?q=technology"
```

#### Get statistics
```bash
curl http://localhost:5000/api/stats
```

## Run the Demo

To see a complete API demonstration:

```bash
# Make sure the app is running first
python app.py &

# In another terminal, run the demo
python demo_api.py
```

## Running Tests

```bash
python test_app.py
```

All 12 tests should pass, covering:
- Business CRUD operations
- Research record management
- Search functionality
- Data validation
- Statistics API

## File Structure

```
datadog/
├── app.py                    # Main application
├── requirements.txt          # Dependencies
├── load_sample_data.py       # Sample data loader
├── demo_api.py              # API demonstration
├── test_app.py              # Test suite
├── templates/               # HTML templates
│   ├── base.html
│   ├── index.html
│   ├── business_form.html
│   ├── business_detail.html
│   ├── research_list.html
│   └── search.html
├── static/                  # CSS and JavaScript
│   ├── css/style.css
│   └── js/main.js
└── instance/               # Database (auto-created)
    └── business_data.db
```

## Next Steps

1. **Explore the API**: Check `API_DOCUMENTATION.md` for complete API reference
2. **Read the README**: See `README.md` for detailed documentation
3. **Customize**: Modify the code to fit your specific needs
4. **Deploy**: Set up a production server with proper authentication

## Common Tasks

### Reset the Database
```bash
rm -rf instance/
python app.py  # Database will be recreated
```

### Backup the Database
```bash
cp instance/business_data.db backup.db
```

### Change the Port
```bash
# Edit app.py, change the last line to:
app.run(debug=True, host='0.0.0.0', port=8080)
```

## Troubleshooting

### Port 5000 Already in Use
```bash
# Kill the process using port 5000
lsof -ti:5000 | xargs kill -9

# Or use a different port (edit app.py)
```

### Database Locked Error
```bash
# Make sure only one instance of the app is running
pkill -f "python app.py"
python app.py
```

### Missing Dependencies
```bash
pip install -r requirements.txt --upgrade
```

## Support

For issues or questions:
- Check `README.md` for detailed documentation
- Review `API_DOCUMENTATION.md` for API specifics
- Examine the test file `test_app.py` for usage examples

## Security Note

This is a development setup. For production:
- Set a strong SECRET_KEY environment variable
- Use a production database (PostgreSQL, MySQL)
- Implement authentication and authorization
- Use HTTPS
- Add input validation and sanitization
- Set up proper logging and monitoring
