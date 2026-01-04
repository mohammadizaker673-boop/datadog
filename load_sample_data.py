"""
Sample data loader for Business Data Management System
Run this script to populate the database with sample data
"""
import sys
import os
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from app import app, db, Business, ResearchRecord
from datetime import datetime

def load_sample_data():
    """Load sample businesses and research data"""
    with app.app_context():
        # Clear existing data
        db.drop_all()
        db.create_all()
        
        # Sample businesses
        businesses = [
            Business(
                name='TechStart Inc.',
                industry='Technology',
                description='A fast-growing startup focused on AI and machine learning solutions for businesses.',
                location='San Francisco, CA',
                contact_email='info@techstart.com',
                contact_phone='(415) 555-0100',
                website='https://techstart.example.com',
                status='active'
            ),
            Business(
                name='Global Finance Corp',
                industry='Finance',
                description='International financial services provider with expertise in investment banking and wealth management.',
                location='New York, NY',
                contact_email='contact@globalfinance.com',
                contact_phone='(212) 555-0200',
                website='https://globalfinance.example.com',
                status='active'
            ),
            Business(
                name='Green Energy Solutions',
                industry='Energy',
                description='Renewable energy company specializing in solar and wind power installations.',
                location='Austin, TX',
                contact_email='hello@greenenergy.com',
                contact_phone='(512) 555-0300',
                website='https://greenenergy.example.com',
                status='active'
            ),
            Business(
                name='HealthTech Innovations',
                industry='Healthcare',
                description='Healthcare technology company developing telemedicine and patient management systems.',
                location='Boston, MA',
                contact_email='info@healthtech.com',
                contact_phone='(617) 555-0400',
                website='https://healthtech.example.com',
                status='active'
            ),
            Business(
                name='RetailMax',
                industry='Retail',
                description='E-commerce platform for retail businesses with integrated inventory management.',
                location='Seattle, WA',
                contact_email='support@retailmax.com',
                contact_phone='(206) 555-0500',
                website='https://retailmax.example.com',
                status='inactive'
            ),
        ]
        
        for business in businesses:
            db.session.add(business)
        
        db.session.commit()
        
        # Sample research records
        research_records = [
            ResearchRecord(
                business_id=1,
                title='Market Analysis Q1 2026',
                category='Market Research',
                researcher='Jane Smith',
                content='Conducted comprehensive market analysis for the AI/ML sector in Q1 2026.',
                findings='The AI market is growing at 45% YoY. TechStart is well-positioned with strong competitive advantages in natural language processing.'
            ),
            ResearchRecord(
                business_id=1,
                title='Competitive Landscape Review',
                category='Competitive Analysis',
                researcher='John Doe',
                content='Analyzed main competitors and their product offerings.',
                findings='Three main competitors identified. TechStart has superior technology but smaller market presence.'
            ),
            ResearchRecord(
                business_id=2,
                title='Regulatory Compliance Assessment',
                category='Compliance',
                researcher='Sarah Johnson',
                content='Review of regulatory requirements for international financial services.',
                findings='Company is fully compliant with all major regulatory frameworks including Basel III and Dodd-Frank.'
            ),
            ResearchRecord(
                business_id=3,
                title='Sustainability Impact Study',
                category='Environmental',
                researcher='Michael Green',
                content='Evaluation of environmental impact and carbon footprint reduction.',
                findings='Company has reduced carbon emissions by 75% compared to traditional energy sources. Strong positive environmental impact.'
            ),
            ResearchRecord(
                business_id=4,
                title='Patient Satisfaction Survey',
                category='Customer Research',
                researcher='Emily Brown',
                content='Survey of 5000 patients using the telemedicine platform.',
                findings='92% satisfaction rate. Patients appreciate convenience and reduced wait times. Some concerns about privacy need to be addressed.'
            ),
        ]
        
        for record in research_records:
            db.session.add(record)
        
        db.session.commit()
        
        print('Sample data loaded successfully!')
        print(f'Created {len(businesses)} businesses')
        print(f'Created {len(research_records)} research records')

if __name__ == '__main__':
    load_sample_data()
