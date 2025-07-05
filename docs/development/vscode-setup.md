# VS Code Setup Guide

Complete VS Code configuration for RepCurve development.

## Quick Setup

1. **Open project in VS Code:**
   ```bash
   cd RepCurve
   code .
   ```

2. **Install recommended extensions** (VS Code will prompt you)

3. **Run setup task:**
   - `Cmd+Shift+P` → "Tasks: Run Task" → "Full Setup"

4. **Start development servers:**
   - `Cmd+Shift+P` → "Tasks: Run Task" → "Start Both Services"

## Available Tasks

Access via `Cmd+Shift+P` → "Tasks: Run Task":

### 🚀 Main Tasks
- **🚀 Start Everything** - Ultimate task: Django + Flutter + Documentation (DEFAULT)
- **Start Both Services** - Django + Flutter in separate terminals
- **Start Django Server** - Django development server only
- **Start Flutter Web** - Flutter web app only

### 🛠️ Setup Tasks
- **Full Setup** - Complete project setup (database + dependencies)
- **Create Conda Environment** - Create RepCurveEnv from environment.yml
- **Setup Database** - Run Django migrations
- **Populate Exercises** - Load exercise database
- **Flutter Clean & Get** - Clean Flutter cache and get dependencies

### 🔍 Troubleshooting Tasks
- **🔍 Troubleshoot Setup** - Check conda, Flutter, database, and dependencies
- **Test API Health** - Test API connection and show response

### 📖 Documentation Tasks
- **📖 Open Docs Now** - Manually open all documentation (backup if auto-open fails)
- **Open API Documentation** - Open Swagger UI (checks if Django is running)
- **Open ReDoc Documentation** - Open ReDoc (checks if Django is running)
- **Open Django Admin** - Open admin interface (checks if Django is running)
- **Open All Documentation** - Smart task that checks Django status first

## Keyboard Shortcuts

| Shortcut | Action |
|----------|--------|
| `Cmd+Shift+P` | Command palette |
| `Ctrl+Shift+` ` | Open terminal |
| `Cmd+Shift+B` | Run default build task (Start Both Services) |
| `F5` | Start debugging (Flutter) |
| `Cmd+F5` | Run without debugging |

## Debug Configurations

Available in Run & Debug panel (`Cmd+Shift+D`):

### Flutter Debugging
- **Flutter Web** - Debug on Chrome with port 3000
- **Flutter iOS Simulator** - Debug on iOS simulator
- **Flutter Android Emulator** - Debug on Android emulator

### Compound Configuration
- **Django + Flutter Web** - Starts both services and attaches debugger

## Workspace Settings

The `.vscode/settings.json` file configures:

### Python Settings
- **Interpreter:** Uses RepCurveEnv conda environment
- **Linting:** Pylint enabled
- **Formatting:** Black formatter
- **Auto-format:** On save

### Dart/Flutter Settings
- **SDK Path:** `/Applications/flutter`
- **UI Guides:** Preview enabled
- **Auto-format:** On save and type
- **Line length:** 80 characters

### File Exclusions
Hides common build/cache directories:
- `__pycache__/`, `*.pyc`
- `build/`, `.dart_tool/`
- `RepCurveEnv/`

## Terminal Integration

### Conda Environment
- Automatically activates RepCurveEnv for Python tasks
- Flutter path added to terminal environment

### Multiple Terminals
Tasks automatically open in separate terminal panels:
- Django server in one terminal
- Flutter web in another terminal
- Separate terminals for setup tasks

## Development Workflow

### 1. Daily Startup
```bash
# 🚀 ONE COMMAND TO RULE THEM ALL:
Cmd+Shift+B

# This automatically:
# ✅ Starts Django server in separate terminal
# ✅ Starts Flutter web app in separate terminal
# ✅ Waits 8 seconds, then opens all documentation
# ✅ Shows status and URLs

# If documentation doesn't open automatically:
Cmd+Shift+P → "Tasks: Run Task" → "📖 Open Docs Now"
```

### 2. Making Changes

**Backend Changes:**
- Edit files in `workouts/`
- Django auto-reloads
- Check terminal for any errors

**Frontend Changes:**
- Edit files in `repcurve_app/lib/`
- Flutter hot-reloads automatically
- Use `r` in terminal for manual hot reload

### 3. Debugging

**Flutter Debugging:**
1. Set breakpoints in Dart code
2. Press `F5` or use Run & Debug panel
3. Select "Flutter Web" configuration

**Django Debugging:**
- Use `print()` statements
- Check Django terminal output
- Use Django admin at `http://127.0.0.1:8000/admin/`

## Extensions Setup

### Recommended Extensions
The `.vscode/extensions.json` suggests:

**Python Development:**
- Python (Microsoft)
- Pylint
- Black Formatter

**Flutter Development:**
- Dart (Dart Code)
- Flutter (Dart Code)

**General:**
- JSON support
- YAML support
- Prettier (for JSON/YAML formatting)

### Installing Extensions
VS Code will prompt to install recommended extensions when you open the project.

## Troubleshooting

### Tasks Not Working

**Conda environment not found:**
```bash
# Create environment first
conda env create -f environment.yml
```

**Flutter command not found:**
```bash
# Add Flutter to PATH
echo 'export PATH="/Applications/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

### Debug Issues

**Flutter debugger not connecting:**
1. Ensure Flutter web is running
2. Check Chrome is installed
3. Try restarting VS Code

**Python debugger issues:**
1. Ensure RepCurveEnv is activated
2. Check Python interpreter setting in VS Code
3. Try `Cmd+Shift+P` → "Python: Select Interpreter"

### Performance Issues

**Slow startup:**
- Exclude build directories in settings
- Close unused terminals
- Restart VS Code if needed

**High CPU usage:**
- Check for infinite loops in code
- Ensure only one instance of each server
- Kill old processes if needed

## File Organization

### Workspace Layout
```
RepCurve/
├── .vscode/              # VS Code configuration
│   ├── tasks.json       # Build tasks
│   ├── launch.json      # Debug configurations
│   ├── settings.json    # Workspace settings
│   └── extensions.json  # Recommended extensions
├── workouts/            # Django backend
├── repcurve_app/        # Flutter frontend
└── docs/               # Documentation
```

### Recommended VS Code Layout
- **Explorer** - Left sidebar for file navigation
- **Terminal** - Bottom panel with multiple terminals
- **Editor** - Main area split for backend/frontend files
- **Debug Console** - For Flutter debugging output

## Productivity Tips

### Multi-file Editing
- Split editor: `Cmd+\`
- Open files side by side for backend/frontend work
- Use `Cmd+P` for quick file navigation

### Search and Replace
- `Cmd+F` - Search in current file
- `Cmd+Shift+F` - Search across all files
- `Cmd+Shift+H` - Replace across all files

### Git Integration
- Built-in Git support in Source Control panel
- See changes, stage files, commit directly in VS Code
- View diffs inline

### Terminal Management
- `Ctrl+Shift+` ` - Open new terminal
- `Cmd+1`, `Cmd+2` - Switch between terminal tabs
- Split terminals for different tasks

This VS Code setup provides a complete development environment for the RepCurve project with automatic server startup, debugging support, and optimized settings for both Django and Flutter development.