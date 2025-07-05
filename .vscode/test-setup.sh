#!/bin/bash

echo "🧪 Testing VS Code Setup..."

# Test 1: Check conda environment
echo "1. Testing conda environment..."
if conda env list | grep -q "RepCurveEnv"; then
    echo "   ✅ RepCurveEnv conda environment exists"
else
    echo "   ❌ RepCurveEnv conda environment missing"
    echo "   Run: conda env create -f environment.yml"
fi

# Test 2: Check Flutter installation
echo "2. Testing Flutter installation..."
if command -v flutter &> /dev/null; then
    echo "   ✅ Flutter is installed"
    echo "   Version: $(flutter --version | head -1)"
else
    echo "   ❌ Flutter not found in PATH"
    echo "   Add to PATH: export PATH=\"/Applications/flutter/bin:\$PATH\""
fi

# Test 3: Check Python packages
echo "3. Testing Python packages..."
if conda run -n RepCurveEnv python -c "import django; print('Django:', django.VERSION)" 2>/dev/null; then
    echo "   ✅ Django is installed"
else
    echo "   ❌ Django not found in RepCurveEnv"
fi

# Test 4: Check Flutter dependencies
echo "4. Testing Flutter dependencies..."
cd repcurve_app
if [ -f "pubspec.lock" ]; then
    echo "   ✅ Flutter dependencies installed"
else
    echo "   ❌ Flutter dependencies missing"
    echo "   Run: flutter pub get"
fi
cd ..

# Test 5: Check database
echo "5. Testing database..."
if [ -f "db.sqlite3" ]; then
    echo "   ✅ Database file exists"
else
    echo "   ❌ Database missing"
    echo "   Run: python manage.py migrate"
fi

echo ""
echo "🎯 Setup Status:"
echo "   If all items show ✅, your VS Code tasks should work perfectly!"
echo "   For any ❌ items, follow the suggested commands."
echo ""
echo "🚀 To start development:"
echo "   1. Open VS Code: code ."
echo "   2. Press Cmd+Shift+P"
echo "   3. Type 'Tasks: Run Task'"
echo "   4. Select 'Start Both Services'"