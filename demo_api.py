#!/usr/bin/env python
"""
Demo script for Business Data Management System
Demonstrates API usage with example requests
"""
import requests
import json
from time import sleep

BASE_URL = 'http://localhost:5000/api'

def print_section(title):
    """Print a section header"""
    print('\n' + '='*60)
    print(f'  {title}')
    print('='*60 + '\n')

def demo_api():
    """Demonstrate API functionality"""
    
    print_section('Business Data Management System - API Demo')
    
    # 1. Get Statistics
    print_section('1. System Statistics')
    try:
        response = requests.get(f'{BASE_URL}/stats')
        if response.status_code == 200:
            stats = response.json()
            print(f"Total Businesses: {stats['total_businesses']}")
            print(f"Active Businesses: {stats['active_businesses']}")
            print(f"Total Research Records: {stats['total_research']}")
            print(f"\nIndustries:")
            for industry in stats['industries']:
                if industry['industry']:
                    print(f"  - {industry['industry']}: {industry['count']} businesses")
    except requests.exceptions.ConnectionError:
        print("❌ Could not connect to the server. Make sure the app is running:")
        print("   python app.py")
        return
    
    # 2. List All Businesses
    print_section('2. List All Businesses')
    response = requests.get(f'{BASE_URL}/businesses')
    if response.status_code == 200:
        businesses = response.json()
        print(f"Found {len(businesses)} businesses:\n")
        for business in businesses[:3]:  # Show first 3
            print(f"  • {business['name']}")
            print(f"    Industry: {business['industry']}")
            print(f"    Location: {business['location']}")
            print(f"    Status: {business['status']}")
            print()
    
    # 3. Search Businesses
    print_section('3. Search for Technology Businesses')
    response = requests.get(f'{BASE_URL}/search', params={'q': 'technology'})
    if response.status_code == 200:
        results = response.json()
        print(f"Found {len(results)} result(s):\n")
        for business in results:
            print(f"  • {business['name']} - {business['industry']}")
    
    # 4. Create a New Business
    print_section('4. Create a New Business')
    new_business = {
        'name': 'Demo Tech Company',
        'industry': 'Software',
        'description': 'A demo company created via API',
        'location': 'Virtual Office',
        'contact_email': 'demo@example.com',
        'status': 'active'
    }
    response = requests.post(f'{BASE_URL}/businesses', 
                            json=new_business,
                            headers={'Content-Type': 'application/json'})
    if response.status_code == 201:
        created = response.json()
        business_id = created['id']
        print(f"✓ Created business with ID: {business_id}")
        print(f"  Name: {created['name']}")
        print(f"  Industry: {created['industry']}")
        
        # 5. Add Research Record
        print_section('5. Add Research Record for New Business')
        new_research = {
            'business_id': business_id,
            'title': 'Initial Market Assessment',
            'category': 'Market Research',
            'researcher': 'Demo User',
            'content': 'Initial research conducted for the new business.',
            'findings': 'Promising market opportunity identified.'
        }
        response = requests.post(f'{BASE_URL}/research',
                                json=new_research,
                                headers={'Content-Type': 'application/json'})
        if response.status_code == 201:
            research = response.json()
            print(f"✓ Created research record with ID: {research['id']}")
            print(f"  Title: {research['title']}")
            print(f"  Category: {research['category']}")
        
        # 6. Update the Business
        print_section('6. Update Business Status')
        update_data = {'status': 'inactive', 'description': 'Demo completed - marked inactive'}
        response = requests.put(f'{BASE_URL}/businesses/{business_id}',
                               json=update_data,
                               headers={'Content-Type': 'application/json'})
        if response.status_code == 200:
            updated = response.json()
            print(f"✓ Updated business status to: {updated['status']}")
        
        # 7. Get Updated Statistics
        print_section('7. Updated Statistics')
        response = requests.get(f'{BASE_URL}/stats')
        if response.status_code == 200:
            stats = response.json()
            print(f"Total Businesses: {stats['total_businesses']}")
            print(f"Active Businesses: {stats['active_businesses']}")
            print(f"Inactive Businesses: {stats['inactive_businesses']}")
            print(f"Total Research Records: {stats['total_research']}")
        
        # 8. Clean up - Delete the demo business
        print_section('8. Clean Up - Delete Demo Business')
        response = requests.delete(f'{BASE_URL}/businesses/{business_id}')
        if response.status_code == 200:
            print(f"✓ Deleted demo business (ID: {business_id})")
    
    # 9. Data Validation
    print_section('9. Data Validation Check')
    response = requests.get(f'{BASE_URL}/maintenance/validate')
    if response.status_code == 200:
        validation = response.json()
        if validation['valid']:
            print("✓ Data validation passed - no issues found")
        else:
            print("⚠ Data validation found issues:")
            for issue in validation['issues']:
                print(f"  - {issue}")
    
    print_section('Demo Complete!')
    print('For more information, see:')
    print('  - README.md for setup instructions')
    print('  - API_DOCUMENTATION.md for full API reference')
    print('  - Visit http://localhost:5000 for the web interface')
    print()

if __name__ == '__main__':
    demo_api()
