"""
Tests for Business Data Management System
"""
import unittest
import json
import os
import sys
from datetime import datetime

# Add parent directory to path
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app import app, db, Business, ResearchRecord

class BusinessDataTestCase(unittest.TestCase):
    """Test case for the Business Data Management System"""
    
    def setUp(self):
        """Set up test client and database"""
        app.config['TESTING'] = True
        app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///test_business_data.db'
        self.app = app.test_client()
        
        with app.app_context():
            db.create_all()
    
    def tearDown(self):
        """Clean up after tests"""
        with app.app_context():
            db.session.remove()
            db.drop_all()
        
        # Remove test database
        if os.path.exists('test_business_data.db'):
            os.remove('test_business_data.db')
    
    def test_index_page(self):
        """Test that the index page loads"""
        response = self.app.get('/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Business Data Management Dashboard', response.data)
    
    def test_create_business_api(self):
        """Test creating a business via API"""
        business_data = {
            'name': 'Test Company',
            'industry': 'Technology',
            'description': 'A test company',
            'location': 'Test City',
            'status': 'active'
        }
        
        response = self.app.post('/api/businesses',
                                data=json.dumps(business_data),
                                content_type='application/json')
        
        self.assertEqual(response.status_code, 201)
        data = json.loads(response.data)
        self.assertEqual(data['name'], 'Test Company')
        self.assertEqual(data['industry'], 'Technology')
        self.assertIn('id', data)
    
    def test_get_businesses_api(self):
        """Test getting all businesses via API"""
        # Create a test business
        with app.app_context():
            business = Business(name='Test Business', industry='Test')
            db.session.add(business)
            db.session.commit()
        
        response = self.app.get('/api/businesses')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertIsInstance(data, list)
        self.assertGreater(len(data), 0)
    
    def test_get_business_by_id(self):
        """Test getting a specific business by ID"""
        # Create a test business
        with app.app_context():
            business = Business(name='Test Business', industry='Test')
            db.session.add(business)
            db.session.commit()
            business_id = business.id
        
        response = self.app.get(f'/api/businesses/{business_id}')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['name'], 'Test Business')
    
    def test_update_business(self):
        """Test updating a business"""
        # Create a test business
        with app.app_context():
            business = Business(name='Old Name', industry='Test')
            db.session.add(business)
            db.session.commit()
            business_id = business.id
        
        # Update the business
        update_data = {'name': 'New Name', 'industry': 'Updated Industry'}
        response = self.app.put(f'/api/businesses/{business_id}',
                               data=json.dumps(update_data),
                               content_type='application/json')
        
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertEqual(data['name'], 'New Name')
        self.assertEqual(data['industry'], 'Updated Industry')
    
    def test_delete_business(self):
        """Test deleting a business"""
        # Create a test business
        with app.app_context():
            business = Business(name='To Delete', industry='Test')
            db.session.add(business)
            db.session.commit()
            business_id = business.id
        
        # Delete the business
        response = self.app.delete(f'/api/businesses/{business_id}')
        self.assertEqual(response.status_code, 200)
        
        # Verify it's deleted
        response = self.app.get(f'/api/businesses/{business_id}')
        self.assertEqual(response.status_code, 404)
    
    def test_create_research_record(self):
        """Test creating a research record"""
        # Create a test business first
        with app.app_context():
            business = Business(name='Test Business', industry='Test')
            db.session.add(business)
            db.session.commit()
            business_id = business.id
        
        # Create research record
        research_data = {
            'business_id': business_id,
            'title': 'Test Research',
            'content': 'Research content',
            'category': 'Market Analysis',
            'researcher': 'Test Researcher'
        }
        
        response = self.app.post('/api/research',
                                data=json.dumps(research_data),
                                content_type='application/json')
        
        self.assertEqual(response.status_code, 201)
        data = json.loads(response.data)
        self.assertEqual(data['title'], 'Test Research')
        self.assertEqual(data['business_id'], business_id)
    
    def test_search_businesses(self):
        """Test searching businesses"""
        # Create test businesses
        with app.app_context():
            business1 = Business(name='Tech Corp', industry='Technology')
            business2 = Business(name='Finance Inc', industry='Finance')
            db.session.add(business1)
            db.session.add(business2)
            db.session.commit()
        
        # Search for tech
        response = self.app.get('/api/search?q=Tech')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertGreater(len(data), 0)
        self.assertEqual(data[0]['name'], 'Tech Corp')
    
    def test_stats_endpoint(self):
        """Test statistics endpoint"""
        # Create test data
        with app.app_context():
            business = Business(name='Test Business', industry='Test', status='active')
            db.session.add(business)
            db.session.commit()
        
        response = self.app.get('/api/stats')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertIn('total_businesses', data)
        self.assertIn('active_businesses', data)
        self.assertGreater(data['total_businesses'], 0)
    
    def test_validate_endpoint(self):
        """Test data validation endpoint"""
        response = self.app.get('/api/maintenance/validate')
        self.assertEqual(response.status_code, 200)
        data = json.loads(response.data)
        self.assertIn('valid', data)
        self.assertIn('issues', data)
    
    def test_business_model(self):
        """Test Business model"""
        with app.app_context():
            business = Business(
                name='Model Test',
                industry='Testing',
                description='Test description',
                location='Test Location'
            )
            db.session.add(business)
            db.session.commit()
            
            # Test to_dict method
            business_dict = business.to_dict()
            self.assertEqual(business_dict['name'], 'Model Test')
            self.assertEqual(business_dict['industry'], 'Testing')
            self.assertIn('id', business_dict)
            self.assertIn('created_at', business_dict)
    
    def test_research_model(self):
        """Test ResearchRecord model"""
        with app.app_context():
            business = Business(name='Test Business')
            db.session.add(business)
            db.session.commit()
            
            research = ResearchRecord(
                business_id=business.id,
                title='Test Research',
                content='Test content'
            )
            db.session.add(research)
            db.session.commit()
            
            # Test to_dict method
            research_dict = research.to_dict()
            self.assertEqual(research_dict['title'], 'Test Research')
            self.assertIn('id', research_dict)

if __name__ == '__main__':
    unittest.main()
