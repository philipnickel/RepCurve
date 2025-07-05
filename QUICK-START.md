# RepCurve Quick Start Card 🚀

## One-Command Development ⚡

```bash
# 1. Open in VS Code
code .

# 2. Start everything (Django + Flutter + Docs)
Cmd+Shift+B
```

### What Happens Automatically:
- 🚀 Django server starts in separate terminal
- 📱 Flutter web app starts in separate terminal  
- ⏱️ Waits 8 seconds for servers to initialize
- 📖 API documentation opens in browser (if Django is ready)
- 🛠️ Django admin opens in browser

### Backup Plan:
If documentation doesn't auto-open:
`Cmd+Shift+P → "Tasks: Run Task" → "📖 Open Docs Now"`

## VS Code Tasks (Cmd+Shift+P → "Tasks: Run Task")

### 🚀 **Main Tasks**
- **🚀 Start Everything** - Django + Flutter + Documentation (DEFAULT)
- **Start Both Services** - Django + Flutter in separate terminals
- **Start Django Server** - Backend only  
- **Start Flutter Web** - Frontend only

### 📖 **Documentation**
- **📖 Open Docs Now** - Manual backup if auto-open fails
- **Open All Documentation** - Smart check + open all docs
- **Open API Documentation** - Interactive Swagger UI
- **Open ReDoc Documentation** - Clean API docs
- **Open Django Admin** - Data management

### 🛠️ **Setup** 
- **Full Setup** - Database + exercises + dependencies
- **Setup Database** - Run migrations
- **Populate Exercises** - Load exercise data

### 🧪 **Testing**
- **Test API Health** - Check API connection

## Quick URLs

```bash
# After starting Django server:
open http://127.0.0.1:8000/api/docs/     # 📖 Swagger UI
open http://127.0.0.1:8000/api/redoc/    # 📄 ReDoc  
open http://127.0.0.1:8000/admin/        # 🛠️ Admin
open http://127.0.0.1:8000/api/health/   # ✅ Health
```

## Flutter Commands

```bash
cd repcurve_app

# Development
flutter run -d chrome --web-port=3000    # Web
flutter run -d ios                       # iOS Simulator  
flutter run -d android                   # Android Emulator

# In running app terminal:
r      # Hot reload
R      # Hot restart  
q      # Quit
```

## Debugging

- **Flutter:** `F5` in VS Code
- **Django:** Check terminal output + admin interface
- **API:** Use Swagger UI for testing endpoints

## Folder Structure

```
RepCurve/
├── workouts/              # 🐍 Django backend
├── repcurve_app/          # 📱 Flutter frontend  
├── docs/                  # 📚 Documentation
└── .vscode/              # 💻 VS Code config
```

---

💡 **Pro Tip:** Keep both Django and Flutter running simultaneously for the best development experience!