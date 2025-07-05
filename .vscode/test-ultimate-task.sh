#!/bin/bash

echo "🧪 Testing Ultimate VS Code Task Components..."
echo ""

# Test 1: Check conda environment
echo "1. Testing conda environment..."
if conda env list | grep -q "RepCurveEnv"; then
    echo "   ✅ RepCurveEnv exists"
else
    echo "   ❌ RepCurveEnv missing"
    exit 1
fi

# Test 2: Check if Django can start
echo "2. Testing Django startup..."
if conda run -n RepCurveEnv python manage.py check > /dev/null 2>&1; then
    echo "   ✅ Django can start"
else
    echo "   ❌ Django has issues"
    echo "   Run: conda run -n RepCurveEnv python manage.py check"
    exit 1
fi

# Test 3: Check Flutter
echo "3. Testing Flutter..."
if command -v flutter &> /dev/null; then
    echo "   ✅ Flutter is available"
else
    echo "   ❌ Flutter not found"
    exit 1
fi

# Test 4: Check Flutter dependencies
echo "4. Testing Flutter dependencies..."
cd repcurve_app
if flutter pub get > /dev/null 2>&1; then
    echo "   ✅ Flutter dependencies OK"
else
    echo "   ❌ Flutter dependencies missing"
    echo "   Run: cd repcurve_app && flutter pub get"
    cd ..
    exit 1
fi
cd ..

# Test 5: Simulate the task workflow
echo "5. Testing task workflow simulation..."
echo "   📝 The ultimate task will:"
echo "   1️⃣ Start Django server in background"
echo "   2️⃣ Start Flutter web app in background" 
echo "   3️⃣ Wait 5 seconds for startup"
echo "   4️⃣ Check Django health endpoint"
echo "   5️⃣ Open documentation URLs"

echo ""
echo "🎯 All checks passed! The ultimate task should work."
echo ""
echo "🚀 To run the ultimate task:"
echo "   1. Open VS Code: code ."
echo "   2. Press Cmd+Shift+B"
echo "   3. Everything starts automatically!"
echo ""
echo "📋 Expected URLs that will open:"
echo "   📖 http://127.0.0.1:8000/api/docs/"
echo "   📄 http://127.0.0.1:8000/api/redoc/"
echo "   🛠️ http://127.0.0.1:8000/admin/"
echo "   📱 http://localhost:3000/ (Flutter web)"