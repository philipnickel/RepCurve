#!/bin/bash

echo "🚀 Starting RepCurve development environment..."
echo ""

# Kill any existing processes on these ports
echo "🧹 Cleaning up existing processes..."
lsof -ti:8000 | xargs kill -9 2>/dev/null || true
lsof -ti:3000 | xargs kill -9 2>/dev/null || true

echo "1️⃣ Starting Django server..."
conda run -n RepCurveEnv python manage.py runserver 8000 > /tmp/django.log 2>&1 &
DJANGO_PID=$!
echo "   Django PID: $DJANGO_PID"

echo "2️⃣ Starting Flutter web app..."
cd repcurve_app
flutter run -d chrome --web-port=3000 --web-hostname=127.0.0.1 > /tmp/flutter.log 2>&1 &
FLUTTER_PID=$!
cd ..
echo "   Flutter PID: $FLUTTER_PID"

echo "3️⃣ Waiting for services to start..."
sleep 8

echo "4️⃣ Checking Django health..."
if curl -s http://127.0.0.1:8000/api/health/ > /dev/null 2>&1; then
    echo "✅ Django is ready!"
    
    echo "5️⃣ Opening documentation..."
    open http://127.0.0.1:8000/api/docs/
    sleep 0.5
    open http://127.0.0.1:8000/api/redoc/
    sleep 0.5
    open http://127.0.0.1:8000/admin/
    
    echo "📖 Documentation opened!"
    echo ""
    echo "🎉 RepCurve is ready for development!"
    echo "   📱 Flutter Web: http://localhost:3000"
    echo "   🔧 Django API: http://127.0.0.1:8000"
    echo "   📖 API Docs: http://127.0.0.1:8000/api/docs/"
    echo ""
    echo "💡 To stop services:"
    echo "   kill $DJANGO_PID $FLUTTER_PID"
    echo "   or use Ctrl+C in their terminals"
    
else
    echo "❌ Django failed to start!"
    echo "Django log:"
    tail -10 /tmp/django.log
    echo ""
    echo "Flutter log:"
    tail -10 /tmp/flutter.log
    
    # Clean up failed processes
    kill $DJANGO_PID $FLUTTER_PID 2>/dev/null || true
fi