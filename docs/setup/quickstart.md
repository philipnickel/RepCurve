# Quick Start Guide

Get RepCurve running in 5 minutes.

## Prerequisites

- **macOS** with Homebrew
- **Python** via Conda
- **Flutter** SDK

## Option A: VS Code Quick Start (1 minute) ⚡

```bash
# Clone and open in VS Code
git clone https://github.com/YOUR_USERNAME/RepCurve.git
cd RepCurve
code .

# In VS Code: Press Cmd+Shift+B to start both servers
# OR: Cmd+Shift+P → "Tasks: Run Task" → "Start Both Services"
```

✅ **Test:** Both Django server and Flutter web app start automatically

## Option B: Manual Setup (5 minutes)

### Step 1: Backend Setup (2 minutes)

```bash
# Clone and enter project
git clone https://github.com/YOUR_USERNAME/RepCurve.git
cd RepCurve

# Create Python environment
conda env create -f environment.yml
conda activate RepCurveEnv

# Setup database
python manage.py migrate
python manage.py populate_exercises

# Start Django server
python manage.py runserver
```

✅ **Test:** Visit `http://127.0.0.1:8000/api/health/` - should see `{"status": "healthy"}`

### Step 2: Frontend Setup (2 minutes)

```bash
# In a new terminal window
cd RepCurve/repcurve_app

# Install Flutter dependencies
flutter pub get

# Start Flutter app
flutter run
```

✅ **Test:** App should launch with login screen and green API connection indicator

## 🌐 Open Interactive Documentation

After starting Django server:
```bash
# API Documentation
open http://127.0.0.1:8000/api/docs/     # 📖 Swagger UI (interactive API)
open http://127.0.0.1:8000/api/redoc/    # 📄 ReDoc (clean docs)

# Development Tools  
open http://127.0.0.1:8000/admin/        # 🛠️ Django Admin (data management)
open http://127.0.0.1:8000/api/health/   # ✅ Health check
```

## Step 3: Test Integration (1 minute)

1. **Create account** in Flutter app
2. **Login** with your credentials  
3. **Add a workout** using the + button
4. **Check calendar** - workout should appear

## Success Indicators

- ✅ Django server running on port 8000
- ✅ Flutter app running on simulator/device/web
- ✅ Green API connection in Flutter app
- ✅ Can create account and login
- ✅ Can create and view workouts
- ✅ Interactive API docs accessible

## Troubleshooting

**Django won't start:**
```bash
conda activate RepCurveEnv
pip install djangorestframework django-cors-headers
```

**Flutter won't start:**
```bash
echo 'export PATH="/Applications/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

**API connection failed:**
- Ensure Django is running on port 8000
- Check that both systems are on same network

## Next Steps

- 📖 [Backend Development Guide](../development/backend-guide.md)
- 📱 [Frontend Development Guide](../development/frontend-guide.md)
- 🤝 [Team Workflow](../development/workflow.md)