# Backend Setup Guide

Detailed Django API setup for RepCurve.

## Prerequisites

- **macOS** with Homebrew
- **Python 3.11** via Conda
- **Git**

## Step-by-Step Setup

### 1. Clone Repository
```bash
git clone https://github.com/YOUR_USERNAME/RepCurve.git
cd RepCurve
```

### 2. Python Environment
```bash
# Create conda environment from file
conda env create -f environment.yml

# Activate environment
conda activate RepCurveEnv

# Verify installation
python --version  # Should be 3.11.x
pip list | grep django  # Should show Django packages
```

### 3. Database Setup
```bash
# Apply migrations
python manage.py migrate

# Load exercise data
python manage.py populate_exercises

# Create admin user (optional)
python manage.py createsuperuser
```

### 4. Test Installation
```bash
# Start development server
python manage.py runserver

# Test in another terminal
curl http://127.0.0.1:8000/api/health/
# Should return: {"status": "healthy", "message": "RepCurve API is running"}
```

## Development Environment

### Django Admin
- URL: `http://127.0.0.1:8000/admin/`
- Login with superuser credentials
- View/edit all database records

### API Documentation
- **Swagger UI:** `http://127.0.0.1:8000/api/docs/`
- **ReDoc:** `http://127.0.0.1:8000/api/redoc/`
- **OpenAPI Schema:** `http://127.0.0.1:8000/api/schema/`

### Useful Commands
```bash
# Check for issues
python manage.py check

# Create new migrations after model changes
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Django shell for debugging
python manage.py shell

# Run tests
python manage.py test
```

## Project Structure
```
RepCurve/
├── manage.py              # Django management script
├── django_project/        # Django settings
│   ├── settings.py       # Main configuration
│   ├── urls.py          # Root URL routing
│   └── wsgi.py          # WSGI application
├── workouts/             # Main Django app
│   ├── models.py        # Database models
│   ├── views.py         # API endpoints
│   ├── serializers.py   # JSON serialization
│   ├── urls.py          # URL routing
│   └── admin.py         # Admin interface
└── db.sqlite3           # SQLite database
```

## Database Models

### Exercise
- `name`: Exercise name (e.g., "Back Squat")
- `category`: squat, bench, deadlift, accessory
- `description`: Exercise description

### WorkoutTemplate
- User's saved workout templates
- Contains multiple TemplateExercise objects

### ScheduledWorkout
- Links a WorkoutTemplate to a specific date
- What shows up on the calendar

### WorkoutLog
- Completed workout with actual sets/reps/weights
- Links to ScheduledWorkout when user completes it

## Configuration

### Environment Variables
For production, set these environment variables:
```bash
export DJANGO_SECRET_KEY="your-secret-key"
export DJANGO_DEBUG="False"
export DJANGO_ALLOWED_HOSTS="yourdomain.com"
```

### Database
- **Development:** SQLite (included)
- **Production:** PostgreSQL recommended

### CORS Settings
Currently allows all origins for development:
```python
CORS_ALLOW_ALL_ORIGINS = True
```

For production, specify exact origins:
```python
CORS_ALLOWED_ORIGINS = [
    "https://yourdomain.com",
]
```

## Troubleshooting

### Common Issues

**ModuleNotFoundError:**
```bash
conda activate RepCurveEnv
pip install -r requirements.txt  # if available
```

**Database errors:**
```bash
rm db.sqlite3
python manage.py migrate
python manage.py populate_exercises
```

**Permission errors:**
```bash
python manage.py check --deploy
# Fix any security warnings for production
```

### Development Tips

1. **Always activate conda environment** before working
2. **Run migrations** after model changes
3. **Use Django admin** to inspect data
4. **Check API docs** at `/api/docs/` for endpoint details
5. **Test endpoints** with curl or Postman

## Next Steps

- 📖 [Backend Development Guide](../development/backend-guide.md)
- 📱 [Frontend Setup](frontend.md)
- 🤝 [Team Workflow](../development/workflow.md)