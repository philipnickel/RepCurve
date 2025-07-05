# RepCurve
Tool for tracking, programming and analyzing powerlifting training

## Setup and Installation

1. **Create and activate conda environment from file:**
   ```bash
   conda env create -f environment.yml
   conda activate RepCurveEnv
   ```

2. **Run the development server:**
   ```bash
   python manage.py runserver
   ```

3. **Access the application:**
   Open your browser and go to `http://127.0.0.1:8000/`

## Project Structure

- `django_project/` - Main Django project configuration
- `hello/` - Simple hello world app
- `api/` - REST API endpoints for Flutter app
- `repcurve_app/` - Flutter mobile application
- `environment.yml` - Conda environment configuration

## Flutter App Setup

### Prerequisites
Add Flutter to your PATH (one-time setup):
```bash
echo 'export PATH="/Applications/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

1. **Run the Django API server:**
   ```bash
   conda activate RepCurveEnv
   python manage.py runserver
   ```

2. **Run the Flutter app:**
   ```bash
   cd repcurve_app
   flutter run
   ```

   For web testing:
   ```bash
   flutter run -d chrome
   ```

3. **Test API connectivity:**
   - The Flutter app will automatically test the connection to `http://127.0.0.1:8000/api/`
   - Green checkmark = API connected successfully
   - Red error = Check that Django server is running

## Features

### 🔐 **Authentication System**
- User registration and login
- Secure token-based authentication
- Profile management

### 📱 **Flutter Mobile App**
- Material Design 3 UI with light/dark theme
- Cross-platform (iOS, Android, Web)
- Secure token storage
- Real-time API connectivity

### 📊 **Workout Management**
- Create custom workout templates
- Schedule workouts on specific dates
- Calendar view for workout planning
- Log completed workouts with sets, reps, weight, and RPE
- Automatic 1RM calculations

### 🏋️ **Exercise Tracking**
- Comprehensive exercise database
- Categories: Squat, Bench Press, Deadlift, Accessories
- Detailed workout logging
- Set-by-set tracking with RPE

### 🗄️ **Django REST API**
- Complete CRUD operations for all workout data
- User-specific data filtering
- Calendar endpoint for month-view data
- Pagination and filtering support

## API Endpoints

### Authentication
- `POST /api/auth/register/` - User registration
- `POST /api/auth/login/` - User login
- `POST /api/auth/logout/` - User logout
- `GET /api/auth/profile/` - Get user profile

### Workouts
- `GET /api/exercises/` - List all exercises
- `GET /api/workout-templates/` - List user's workout templates
- `GET /api/scheduled-workouts/` - List scheduled workouts
- `GET /api/calendar/` - Get workouts for calendar view
- `GET /api/workout-logs/` - List workout logs
- `POST /api/scheduled-workouts/{id}/complete/` - Complete a workout

## User Flow

1. **Registration/Login** - User creates account or logs in
2. **Home Dashboard** - Overview of API status and quick actions
3. **Calendar View** - See scheduled workouts by date
4. **Workout Planning** - Create templates and schedule workouts
5. **Workout Logging** - Record completed workouts with detailed sets
6. **Progress Tracking** - View workout history and stats
