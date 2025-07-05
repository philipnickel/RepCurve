# RepCurve

A powerlifting training tracker with Django REST API backend and Flutter mobile frontend.

## 🚀 Quick Start

### Option 1: VS Code (Recommended) ⚡
```bash
# Open in VS Code and start everything with one command
code .
# Then: Cmd+Shift+B 
# 🚀 Starts Django + Flutter + Opens documentation after 8 seconds

# If docs don't auto-open: Cmd+Shift+P → "📖 Open Docs Now"
```

### Option 2: Manual Setup
```bash
# 1. Backend (Django API)
conda env create -f environment.yml
conda activate RepCurveEnv
python manage.py migrate
python manage.py populate_exercises
python manage.py runserver

# 2. Frontend (Flutter App) - in new terminal
cd repcurve_app
flutter pub get
flutter run
```

✅ **Success:** Django on port 8000 + Flutter app + Documentation opens automatically

### 🌐 Access Points (Auto-opened with VS Code)
- 📱 **Flutter Web:** `http://localhost:3000`
- 🔧 **Django API:** `http://127.0.0.1:8000` 
- 📖 **API Docs (Swagger):** `http://127.0.0.1:8000/api/docs/`
- 📄 **API Docs (ReDoc):** `http://127.0.0.1:8000/api/redoc/`
- 🛠️ **Django Admin:** `http://127.0.0.1:8000/admin/`

## 📚 Documentation

Comprehensive documentation is in the [`docs/`](docs/) directory:

### Getting Started
- 📖 **[Quick Start Guide](docs/setup/quickstart.md)** - 5-minute setup
- 🔧 [Backend Setup](docs/setup/backend.md) - Detailed Django setup
- 📱 [Frontend Setup](docs/setup/frontend.md) - Detailed Flutter setup

### Development
- 🤝 **[Team Workflow](docs/development/workflow.md)** - Git, code review, communication
- 💻 **[VS Code Setup](docs/development/vscode-setup.md)** - Automated tasks and debugging
- ⚙️ [Backend Development](docs/development/backend-guide.md) - Django API development
- 📱 [Frontend Development](docs/development/frontend-guide.md) - Flutter app development

### API Reference
- 📡 **[API Overview](docs/api/overview.md)** - Authentication, formats, models
- 📋 [API Endpoints](docs/api/endpoints.md) - Complete endpoint reference
- 🌐 [Interactive API Docs](http://127.0.0.1:8000/api/docs/) - Swagger UI (when running)

## 🏗️ Project Structure

```
RepCurve/
├── docs/                   # 📚 All documentation
├── django_project/         # ⚙️ Django settings
├── workouts/              # 🏋️ Main Django app (API + models)
├── repcurve_app/          # 📱 Flutter mobile app
├── environment.yml        # 🐍 Python dependencies
└── db.sqlite3            # 🗄️ SQLite database
```

## ✨ Features

- 🔐 **User Authentication** - Secure token-based auth
- 🏋️ **Workout Management** - Templates, scheduling, logging
- 📅 **Calendar View** - Week-based workout planning
- 📊 **Progress Tracking** - Sets, reps, weights, RPE, 1RM calculations
- 📱 **Cross-Platform** - iOS, Android, Web support
- 🎯 **Exercise Database** - 22+ powerlifting exercises

## 👥 For Developers

### Backend Developer
- **Work in:** `workouts/` directory
- **Tools:** Django admin at `http://127.0.0.1:8000/admin/`
- **Docs:** [Backend Development Guide](docs/development/backend-guide.md)

### Frontend Developer  
- **Work in:** `repcurve_app/lib/` directory
- **Tools:** Flutter dev tools, hot reload
- **Docs:** [Frontend Development Guide](docs/development/frontend-guide.md)

### Team Workflow
- **Git workflow:** Feature branches with code review
- **Communication:** Daily sync, API change notifications
- **Testing:** Both systems must be tested together
- **Full Guide:** [Team Workflow](docs/development/workflow.md)

## 🛠️ Development Notes

- **Django:** Runs on port 8000 with SQLite
- **Flutter:** Connects to `127.0.0.1:8000/api/`
- **Authentication:** All endpoints require tokens except health/auth
- **Documentation:** Auto-generated at `/api/docs/` and `/api/redoc/`

## 🆘 Need Help?

1. **Setup Issues:** [Quick Start Guide](docs/setup/quickstart.md)
2. **API Questions:** [API Documentation](docs/api/overview.md)
3. **Development:** [Team Workflow](docs/development/workflow.md)
4. **Bugs:** Create GitHub issue

## 🚀 Next Steps

New to the project? Start here:
1. 📖 [Quick Start Guide](docs/setup/quickstart.md) - Get running in 1-5 minutes
2. 💻 [VS Code Setup](docs/development/vscode-setup.md) - Automated development
3. 🤝 [Team Workflow](docs/development/workflow.md) - Learn our process
4. 🏗️ Pick your path: [Backend](docs/development/backend-guide.md) or [Frontend](docs/development/frontend-guide.md)
5. 📡 [API Reference](docs/api/overview.md) - Understand the data flow

### 📋 Quick Reference
- 🃏 **[Quick Start Card](QUICK-START.md)** - Essential commands and URLs

---

**RepCurve** - Track. Progress. Lift. 🏋️‍♂️