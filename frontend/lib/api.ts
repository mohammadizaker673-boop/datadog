import axios from 'axios';

const API_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:8000';

const apiClient = axios.create({
  baseURL: API_URL,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Request interceptor
apiClient.interceptors.request.use(
  (config) => {
    // Add auth token if needed
    return config;
  },
  (error) => Promise.reject(error)
);

// Response interceptor
apiClient.interceptors.response.use(
  (response) => response,
  (error) => {
    console.error('API Error:', error);
    return Promise.reject(error);
  }
);

export const continentApi = {
  list: () => apiClient.get('/continents'),
  get: (id: string) => apiClient.get(`/continents/${id}`),
};

export const countryApi = {
  list: (continentId?: string) =>
    apiClient.get('/countries', { params: { continent_id: continentId } }),
  get: (id: string) => apiClient.get(`/countries/${id}`),
};

export const cityApi = {
  list: (countryId?: string) =>
    apiClient.get('/cities', { params: { country_id: countryId } }),
  get: (id: string) => apiClient.get(`/cities/${id}`),
};

export const businessApi = {
  list: (cityId?: string, category?: string, skip = 0, limit = 100) =>
    apiClient.get('/businesses', {
      params: { city_id: cityId, category, skip, limit },
    }),
  get: (id: string) => apiClient.get(`/businesses/${id}`),
  extract: (request: any) => apiClient.post('/businesses/extract', request),
};

export default apiClient;
