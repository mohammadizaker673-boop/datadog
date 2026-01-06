"""Initial data seeding script."""
import sys
from sqlalchemy.orm import Session

from app.database import SessionLocal, engine, Base
from app.models import Continent, Country, City

# Continent data
CONTINENTS_DATA = [
    {"name": "Africa", "code": "AF"},
    {"name": "Asia", "code": "AS"},
    {"name": "Europe", "code": "EU"},
    {"name": "North America", "code": "NA"},
    {"name": "South America", "code": "SA"},
    {"name": "Oceania", "code": "OC"},
]

# Sample country data
COUNTRIES_DATA = [
    {"name": "Germany", "iso_code": "DE", "iso3_code": "DEU", "continent": "EU", "currency": "EUR"},
    {"name": "United States", "iso_code": "US", "iso3_code": "USA", "continent": "NA", "currency": "USD"},
    {"name": "United Kingdom", "iso_code": "GB", "iso3_code": "GBR", "continent": "EU", "currency": "GBP"},
    {"name": "France", "iso_code": "FR", "iso3_code": "FRA", "continent": "EU", "currency": "EUR"},
    {"name": "Japan", "iso_code": "JP", "iso3_code": "JPN", "continent": "AS", "currency": "JPY"},
    {"name": "Australia", "iso_code": "AU", "iso3_code": "AUS", "continent": "OC", "currency": "AUD"},
]

# Sample city data
CITIES_DATA = [
    {"name": "Berlin", "country": "DE", "latitude": 52.5200, "longitude": 13.4050, "timezone": "Europe/Berlin"},
    {"name": "New York", "country": "US", "latitude": 40.7128, "longitude": -74.0060, "timezone": "America/New_York"},
    {"name": "London", "country": "GB", "latitude": 51.5074, "longitude": -0.1278, "timezone": "Europe/London"},
    {"name": "Paris", "country": "FR", "latitude": 48.8566, "longitude": 2.3522, "timezone": "Europe/Paris"},
    {"name": "Tokyo", "country": "JP", "latitude": 35.6762, "longitude": 139.6503, "timezone": "Asia/Tokyo"},
    {"name": "Sydney", "country": "AU", "latitude": -33.8688, "longitude": 151.2093, "timezone": "Australia/Sydney"},
]


def seed_database():
    """Seed initial data into database."""
    db = SessionLocal()
    try:
        # Create tables
        Base.metadata.create_all(bind=engine)
        
        # Check if continents already exist
        existing_continents = db.query(Continent).count()
        if existing_continents > 0:
            print("Database already seeded. Skipping...")
            return

        # Seed continents
        print("Seeding continents...")
        continents_map = {}
        for cont_data in CONTINENTS_DATA:
            continent = Continent(name=cont_data["name"], code=cont_data["code"])
            db.add(continent)
            db.flush()
            continents_map[cont_data["code"]] = continent.id
        db.commit()
        print(f"✓ Seeded {len(CONTINENTS_DATA)} continents")

        # Seed countries
        print("Seeding countries...")
        countries_map = {}
        for country_data in COUNTRIES_DATA:
            country = Country(
                name=country_data["name"],
                iso_code=country_data["iso_code"],
                iso3_code=country_data["iso3_code"],
                continent_id=continents_map[country_data["continent"]],
                currency=country_data["currency"],
            )
            db.add(country)
            db.flush()
            countries_map[country_data["iso_code"]] = country.id
        db.commit()
        print(f"✓ Seeded {len(COUNTRIES_DATA)} countries")

        # Seed cities
        print("Seeding cities...")
        for city_data in CITIES_DATA:
            city = City(
                name=city_data["name"],
                country_id=countries_map[city_data["country"]],
                latitude=city_data["latitude"],
                longitude=city_data["longitude"],
                timezone=city_data["timezone"],
            )
            db.add(city)
        db.commit()
        print(f"✓ Seeded {len(CITIES_DATA)} cities")

        print("\n✓ Database seeding completed successfully!")

    except Exception as e:
        db.rollback()
        print(f"✗ Error seeding database: {e}")
        sys.exit(1)
    finally:
        db.close()


if __name__ == "__main__":
    seed_database()
