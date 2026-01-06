"""Tests for API routes."""
import pytest


def test_health_check(client):
    """Test health check endpoint."""
    response = client.get("/health")
    assert response.status_code == 200
    assert response.json()["status"] == "healthy"


def test_list_continents_empty(client):
    """Test listing continents."""
    response = client.get("/continents")
    assert response.status_code == 200
    assert isinstance(response.json(), list)


def test_create_continent(client):
    """Test creating a continent."""
    data = {"name": "Test Continent", "code": "TC"}
    response = client.post("/continents", json=data)
    assert response.status_code == 200
    assert response.json()["name"] == "Test Continent"


def test_get_continent(client):
    """Test getting a specific continent."""
    # First create one
    create_data = {"name": "Africa", "code": "AF"}
    create_response = client.post("/continents", json=create_data)
    continent_id = create_response.json()["id"]

    # Then retrieve it
    response = client.get(f"/continents/{continent_id}")
    assert response.status_code == 200
    assert response.json()["name"] == "Africa"
