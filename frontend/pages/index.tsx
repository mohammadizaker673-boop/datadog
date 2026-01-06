'use client';

import React, { useState, useEffect } from 'react';
import { continentApi, countryApi, cityApi, businessApi } from '../lib/api';

interface Continent {
  id: string;
  name: string;
  code: string;
}

interface Country {
  id: string;
  name: string;
  iso_code: string;
}

interface City {
  id: string;
  name: string;
}

interface Business {
  id: string;
  name: string;
  category: string;
  address: string;
  phone?: string;
  website?: string;
}

export default function Home() {
  const [continents, setContinents] = useState<Continent[]>([]);
  const [countries, setCountries] = useState<Country[]>([]);
  const [cities, setCities] = useState<City[]>([]);
  const [businesses, setBusinesses] = useState<Business[]>([]);

  const [selectedContinent, setSelectedContinent] = useState('');
  const [selectedCountry, setSelectedCountry] = useState('');
  const [selectedCity, setSelectedCity] = useState('');

  const [loading, setLoading] = useState(false);
  const [extracting, setExtracting] = useState(false);
  const [error, setError] = useState('');

  // Load continents on mount
  useEffect(() => {
    fetchContinents();
  }, []);

  // Load countries when continent changes
  useEffect(() => {
    if (selectedContinent) {
      fetchCountries(selectedContinent);
      setSelectedCountry('');
      setSelectedCity('');
      setCities([]);
      setBusinesses([]);
    }
  }, [selectedContinent]);

  // Load cities when country changes
  useEffect(() => {
    if (selectedCountry) {
      fetchCities(selectedCountry);
      setSelectedCity('');
      setBusinesses([]);
    }
  }, [selectedCountry]);

  const fetchContinents = async () => {
    try {
      setLoading(true);
      const response = await continentApi.list();
      setContinents(response.data);
    } catch (err) {
      setError('Failed to load continents');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const fetchCountries = async (continentId: string) => {
    try {
      setLoading(true);
      const response = await countryApi.list(continentId);
      setCountries(response.data);
    } catch (err) {
      setError('Failed to load countries');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const fetchCities = async (countryId: string) => {
    try {
      setLoading(true);
      const response = await cityApi.list(countryId);
      setCities(response.data);
    } catch (err) {
      setError('Failed to load cities');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  const handleExtractBusinesses = async () => {
    if (!selectedCity) {
      setError('Please select a city');
      return;
    }

    try {
      setExtracting(true);
      setError('');
      const response = await businessApi.extract({
        city_id: selectedCity,
      });

      // Fetch businesses after extraction
      const businessResponse = await businessApi.list(selectedCity);
      setBusinesses(businessResponse.data);
    } catch (err) {
      setError('Failed to extract businesses');
      console.error(err);
    } finally {
      setExtracting(false);
    }
  };

  const handleExport = () => {
    if (businesses.length === 0) {
      setError('No businesses to export');
      return;
    }

    const csv = [
      ['Name', 'Category', 'Address', 'Phone', 'Website'],
      ...businesses.map((b) => [
        b.name,
        b.category,
        b.address,
        b.phone || '',
        b.website || '',
      ]),
    ]
      .map((row) => row.map((cell) => `"${cell}"`).join(','))
      .join('\n');

    const blob = new Blob([csv], { type: 'text/csv' });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = `businesses-${selectedCity}-${new Date().toISOString()}.csv`;
    a.click();
  };

  return (
    <div className="min-h-screen bg-gray-50">
      <header className="bg-white shadow">
        <div className="container py-6">
          <h1 className="text-3xl font-bold text-gray-900">
            Global Business Data Extraction
          </h1>
          <p className="text-gray-600 mt-2">
            Discover and extract business data by location
          </p>
        </div>
      </header>

      <main className="container py-8">
        {error && (
          <div className="mb-4 p-4 bg-red-100 border border-red-400 text-red-700 rounded">
            {error}
          </div>
        )}

        {/* Location Selection */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          {/* Continent Selector */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Continent
            </label>
            <select
              className="form-select"
              value={selectedContinent}
              onChange={(e) => setSelectedContinent(e.target.value)}
              disabled={loading}
            >
              <option value="">Select a continent...</option>
              {continents.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </div>

          {/* Country Selector */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              Country
            </label>
            <select
              className="form-select"
              value={selectedCountry}
              onChange={(e) => setSelectedCountry(e.target.value)}
              disabled={!selectedContinent || loading}
            >
              <option value="">Select a country...</option>
              {countries.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </div>

          {/* City Selector */}
          <div>
            <label className="block text-sm font-medium text-gray-700 mb-2">
              City
            </label>
            <select
              className="form-select"
              value={selectedCity}
              onChange={(e) => setSelectedCity(e.target.value)}
              disabled={!selectedCountry || loading}
            >
              <option value="">Select a city...</option>
              {cities.map((c) => (
                <option key={c.id} value={c.id}>
                  {c.name}
                </option>
              ))}
            </select>
          </div>
        </div>

        {/* Action Buttons */}
        <div className="flex gap-4 mb-8">
          <button
            className="btn btn-primary"
            onClick={handleExtractBusinesses}
            disabled={!selectedCity || extracting}
          >
            {extracting ? (
              <>
                <span className="loading mr-2"></span>
                Extracting...
              </>
            ) : (
              'Extract Businesses'
            )}
          </button>
          <button
            className="btn btn-secondary"
            onClick={handleExport}
            disabled={businesses.length === 0}
          >
            Export CSV
          </button>
        </div>

        {/* Results Table */}
        {businesses.length > 0 && (
          <div className="bg-white rounded shadow overflow-x-auto">
            <table className="table">
              <thead>
                <tr>
                  <th>Name</th>
                  <th>Category</th>
                  <th>Address</th>
                  <th>Phone</th>
                  <th>Website</th>
                </tr>
              </thead>
              <tbody>
                {businesses.map((business) => (
                  <tr key={business.id}>
                    <td className="font-medium">{business.name}</td>
                    <td>{business.category}</td>
                    <td>{business.address}</td>
                    <td>{business.phone || '-'}</td>
                    <td>
                      {business.website ? (
                        <a
                          href={business.website}
                          target="_blank"
                          rel="noopener noreferrer"
                          className="text-blue-600 hover:underline"
                        >
                          Visit
                        </a>
                      ) : (
                        '-'
                      )}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}

        {businesses.length === 0 && selectedCity && !loading && !extracting && (
          <div className="text-center py-12 bg-white rounded shadow">
            <p className="text-gray-500">
              No businesses found. Click "Extract Businesses" to start.
            </p>
          </div>
        )}
      </main>
    </div>
  );
}
