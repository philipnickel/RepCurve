#!/bin/bash

echo "🚀 Starting RepCurve development environment..."
echo ""

# Check if conda environment exists
if ! conda env list | grep -q "RepCurveEnv"; then
    echo "❌ RepCurveEnv conda environment not found!"
    echo "Please run: conda env create -f environment.yml"
    exit 1
fi

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found in PATH!"
    echo "Please install Flutter and add to PATH"
    exit 1
fi

echo "✅ Environment checks passed"
echo ""

echo "Starting services in background..."
echo "1️⃣ Django server..."
echo "2️⃣ Flutter web app..."
echo "3️⃣ Opening documentation..."
echo ""

# Start Django in background
conda run -n RepCurveEnv python manage.py runserver &
DJANGO_PID=$!

# Start Flutter in background  
cd repcurve_app
flutter run -d chrome --web-port=3000 &
FLUTTER_PID=$!
cd ..

# Wait a bit for services to start
sleep 3

# Open documentation
echo "📖 Opening documentation in browser..."
open http://127.0.0.1:8000/api/docs/ 2>/dev/null || echo "Will open when Django starts"
open http://127.0.0.1:8000/api/redoc/ 2>/dev/null || true
open http://127.0.0.1:8000/admin/ 2>/dev/null || true

echo ""
echo "🎉 RepCurve development environment starting!"
echo ""
echo "📱 Flutter Web: http://localhost:3000"
echo "🔧 Django API: http://127.0.0.1:8000"
echo "📖 API Docs: http://127.0.0.1:8000/api/docs/"
echo "🛠️ Admin: http://127.0.0.1:8000/admin/"
echo ""
echo "💡 Both services are starting in background."
echo "   Check terminal output for any errors."
echo "   Use 'ps aux | grep python' to see Django process"
echo "   Use 'ps aux | grep flutter' to see Flutter process"