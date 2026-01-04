"""
Business Data Research, Management and Maintenance System
Main application module
"""
from flask import Flask, render_template, request, jsonify, redirect, url_for
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime
import os

app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///business_data.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['SECRET_KEY'] = os.environ.get('SECRET_KEY', 'dev-secret-key-change-in-production')

db = SQLAlchemy(app)

# Models
class Business(db.Model):
    """Business entity model for storing business information"""
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(200), nullable=False)
    industry = db.Column(db.String(100))
    description = db.Column(db.Text)
    location = db.Column(db.String(200))
    contact_email = db.Column(db.String(120))
    contact_phone = db.Column(db.String(20))
    website = db.Column(db.String(200))
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    status = db.Column(db.String(20), default='active')
    
    research_records = db.relationship('ResearchRecord', backref='business', lazy=True, cascade='all, delete-orphan')
    
    def to_dict(self):
        """Convert model to dictionary"""
        return {
            'id': self.id,
            'name': self.name,
            'industry': self.industry,
            'description': self.description,
            'location': self.location,
            'contact_email': self.contact_email,
            'contact_phone': self.contact_phone,
            'website': self.website,
            'status': self.status,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }

class ResearchRecord(db.Model):
    """Research record model for storing research data about businesses"""
    id = db.Column(db.Integer, primary_key=True)
    business_id = db.Column(db.Integer, db.ForeignKey('business.id'), nullable=False)
    title = db.Column(db.String(200), nullable=False)
    content = db.Column(db.Text)
    category = db.Column(db.String(100))
    researcher = db.Column(db.String(100))
    findings = db.Column(db.Text)
    created_at = db.Column(db.DateTime, default=datetime.utcnow)
    updated_at = db.Column(db.DateTime, default=datetime.utcnow, onupdate=datetime.utcnow)
    
    def to_dict(self):
        """Convert model to dictionary"""
        return {
            'id': self.id,
            'business_id': self.business_id,
            'title': self.title,
            'content': self.content,
            'category': self.category,
            'researcher': self.researcher,
            'findings': self.findings,
            'created_at': self.created_at.isoformat() if self.created_at else None,
            'updated_at': self.updated_at.isoformat() if self.updated_at else None,
        }

# Initialize database
with app.app_context():
    db.create_all()

# Routes - Web Interface
@app.route('/')
def index():
    """Main dashboard page"""
    businesses = Business.query.order_by(Business.created_at.desc()).all()
    stats = {
        'total_businesses': Business.query.count(),
        'active_businesses': Business.query.filter_by(status='active').count(),
        'total_research': ResearchRecord.query.count()
    }
    return render_template('index.html', businesses=businesses, stats=stats)

@app.route('/business/<int:id>')
def business_detail(id):
    """Business detail page"""
    business = Business.query.get_or_404(id)
    research_records = ResearchRecord.query.filter_by(business_id=id).order_by(ResearchRecord.created_at.desc()).all()
    return render_template('business_detail.html', business=business, research_records=research_records)

@app.route('/business/new')
def new_business():
    """New business form page"""
    return render_template('business_form.html', business=None)

@app.route('/business/<int:id>/edit')
def edit_business(id):
    """Edit business form page"""
    business = Business.query.get_or_404(id)
    return render_template('business_form.html', business=business)

@app.route('/research')
def research_list():
    """Research records list page"""
    records = ResearchRecord.query.order_by(ResearchRecord.created_at.desc()).all()
    return render_template('research_list.html', records=records)

@app.route('/search')
def search():
    """Search page"""
    query = request.args.get('q', '')
    results = []
    if query:
        results = Business.query.filter(
            (Business.name.contains(query)) |
            (Business.industry.contains(query)) |
            (Business.description.contains(query)) |
            (Business.location.contains(query))
        ).all()
    return render_template('search.html', query=query, results=results)

# API Routes
@app.route('/api/businesses', methods=['GET'])
def api_get_businesses():
    """Get all businesses"""
    businesses = Business.query.all()
    return jsonify([b.to_dict() for b in businesses])

@app.route('/api/businesses', methods=['POST'])
def api_create_business():
    """Create a new business"""
    data = request.get_json()
    
    if not data or 'name' not in data:
        return jsonify({'error': 'Business name is required'}), 400
    
    business = Business(
        name=data['name'],
        industry=data.get('industry'),
        description=data.get('description'),
        location=data.get('location'),
        contact_email=data.get('contact_email'),
        contact_phone=data.get('contact_phone'),
        website=data.get('website'),
        status=data.get('status', 'active')
    )
    
    db.session.add(business)
    db.session.commit()
    
    return jsonify(business.to_dict()), 201

@app.route('/api/businesses/<int:id>', methods=['GET'])
def api_get_business(id):
    """Get a specific business"""
    business = Business.query.get_or_404(id)
    return jsonify(business.to_dict())

@app.route('/api/businesses/<int:id>', methods=['PUT'])
def api_update_business(id):
    """Update a business"""
    business = Business.query.get_or_404(id)
    data = request.get_json()
    
    if 'name' in data:
        business.name = data['name']
    if 'industry' in data:
        business.industry = data['industry']
    if 'description' in data:
        business.description = data['description']
    if 'location' in data:
        business.location = data['location']
    if 'contact_email' in data:
        business.contact_email = data['contact_email']
    if 'contact_phone' in data:
        business.contact_phone = data['contact_phone']
    if 'website' in data:
        business.website = data['website']
    if 'status' in data:
        business.status = data['status']
    
    business.updated_at = datetime.utcnow()
    db.session.commit()
    
    return jsonify(business.to_dict())

@app.route('/api/businesses/<int:id>', methods=['DELETE'])
def api_delete_business(id):
    """Delete a business"""
    business = Business.query.get_or_404(id)
    db.session.delete(business)
    db.session.commit()
    
    return jsonify({'message': 'Business deleted successfully'}), 200

@app.route('/api/research', methods=['GET'])
def api_get_research():
    """Get all research records"""
    records = ResearchRecord.query.all()
    return jsonify([r.to_dict() for r in records])

@app.route('/api/research', methods=['POST'])
def api_create_research():
    """Create a new research record"""
    data = request.get_json()
    
    if not data or 'title' not in data or 'business_id' not in data:
        return jsonify({'error': 'Title and business_id are required'}), 400
    
    # Validate business exists
    business = Business.query.get(data['business_id'])
    if not business:
        return jsonify({'error': 'Business not found'}), 404
    
    record = ResearchRecord(
        business_id=data['business_id'],
        title=data['title'],
        content=data.get('content'),
        category=data.get('category'),
        researcher=data.get('researcher'),
        findings=data.get('findings')
    )
    
    db.session.add(record)
    db.session.commit()
    
    return jsonify(record.to_dict()), 201

@app.route('/api/research/<int:id>', methods=['GET'])
def api_get_research_record(id):
    """Get a specific research record"""
    record = ResearchRecord.query.get_or_404(id)
    return jsonify(record.to_dict())

@app.route('/api/research/<int:id>', methods=['PUT'])
def api_update_research(id):
    """Update a research record"""
    record = ResearchRecord.query.get_or_404(id)
    data = request.get_json()
    
    if 'title' in data:
        record.title = data['title']
    if 'content' in data:
        record.content = data['content']
    if 'category' in data:
        record.category = data['category']
    if 'researcher' in data:
        record.researcher = data['researcher']
    if 'findings' in data:
        record.findings = data['findings']
    
    record.updated_at = datetime.utcnow()
    db.session.commit()
    
    return jsonify(record.to_dict())

@app.route('/api/research/<int:id>', methods=['DELETE'])
def api_delete_research(id):
    """Delete a research record"""
    record = ResearchRecord.query.get_or_404(id)
    db.session.delete(record)
    db.session.commit()
    
    return jsonify({'message': 'Research record deleted successfully'}), 200

@app.route('/api/search', methods=['GET'])
def api_search():
    """Search businesses"""
    query = request.args.get('q', '')
    if not query:
        return jsonify([])
    
    results = Business.query.filter(
        (Business.name.contains(query)) |
        (Business.industry.contains(query)) |
        (Business.description.contains(query)) |
        (Business.location.contains(query))
    ).all()
    
    return jsonify([b.to_dict() for b in results])

@app.route('/api/maintenance/validate', methods=['GET'])
def api_validate_data():
    """Validate data integrity"""
    issues = []
    
    # Check for businesses without names
    unnamed = Business.query.filter(
        (Business.name == None) | (Business.name == '')
    ).count()
    if unnamed > 0:
        issues.append(f'{unnamed} businesses without names')
    
    # Check for orphaned research records
    orphaned = db.session.query(ResearchRecord).filter(
        ~db.session.query(Business.id).filter(Business.id == ResearchRecord.business_id).exists()
    ).count()
    if orphaned > 0:
        issues.append(f'{orphaned} orphaned research records')
    
    return jsonify({
        'valid': len(issues) == 0,
        'issues': issues
    })

@app.route('/api/stats', methods=['GET'])
def api_stats():
    """Get system statistics"""
    industry_counts = db.session.query(Business.industry, db.func.count(Business.id)).group_by(Business.industry).all()
    industries = [{'industry': industry, 'count': count} for industry, count in industry_counts]
    
    return jsonify({
        'total_businesses': Business.query.count(),
        'active_businesses': Business.query.filter_by(status='active').count(),
        'inactive_businesses': Business.query.filter_by(status='inactive').count(),
        'total_research': ResearchRecord.query.count(),
        'industries': industries
    })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
