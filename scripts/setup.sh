#!/usr/bin/env bash
# Development startup script

set -e

echo "Starting Global Business Data Extraction App..."

# Check if .env exists
if [ ! -f backend/.env ]; then
    echo "Creating .env from .env.example..."
    cp backend/.env.example backend/.env
fi

echo "Installing backend dependencies..."
cd backend
pip install -q -r requirements.txt
cd ..

echo "Initializing database..."
cd backend
python scripts/seed_data.py
cd ..

echo "Installing frontend dependencies..."
cd frontend
npm install --quiet
cd ..

echo ""
echo "✅ Setup complete!"
echo ""
echo "Start services with:"
echo "  docker-compose up"
echo ""
echo "Or run locally:"
echo "  # Terminal 1 - Backend"
echo "  cd backend && uvicorn app.main:app --reload"
echo ""
echo "  # Terminal 2 - Frontend"
echo "  cd frontend && npm run dev"
echo ""
echo "Access:"
echo "  Frontend: http://localhost:3000"
echo "  Backend API: http://localhost:8000"
echo "  API Docs: http://localhost:8000/docs"
