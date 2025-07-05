# API Endpoints Reference

Complete reference for all RepCurve API endpoints.

## System Endpoints

### Health Check
Check if API is running.

```http
GET /api/health/
```

**Response:**
```json
{
  "status": "healthy",
  "message": "RepCurve API is running"
}
```

### API Information
Get API version and details.

```http
GET /api/info/
```

**Response:**
```json
{
  "name": "RepCurve API",
  "version": "1.0.0",
  "description": "API for tracking powerlifting training"
}
```

## Authentication Endpoints

### Register User
Create new user account.

```http
POST /api/auth/register/
Content-Type: application/json

{
  "username": "john_doe",
  "email": "john@example.com",
  "password": "securepass123",
  "password_confirm": "securepass123",
  "first_name": "John",
  "last_name": "Doe"
}
```

**Response:**
```json
{
  "user": {
    "id": 1,
    "username": "john_doe",
    "email": "john@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "date_joined": "2025-01-15T10:30:00Z"
  },
  "token": "366e01bd9c032be22f2443ce1ac5b468bb44272c"
}
```

### Login User
Authenticate user and get token.

```http
POST /api/auth/login/
Content-Type: application/json

{
  "username": "john_doe",
  "password": "securepass123"
}
```

**Response:**
```json
{
  "user": {...},
  "token": "366e01bd9c032be22f2443ce1ac5b468bb44272c"
}
```

### Logout User
Invalidate user token.

```http
POST /api/auth/logout/
Authorization: Token your-token-here
```

**Response:**
```json
{
  "message": "Successfully logged out"
}
```

### Get User Profile
Get current user information.

```http
GET /api/auth/profile/
Authorization: Token your-token-here
```

**Response:**
```json
{
  "id": 1,
  "username": "john_doe",
  "email": "john@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "date_joined": "2025-01-15T10:30:00Z"
}
```

## Exercise Endpoints

### List Exercises
Get all available exercises.

```http
GET /api/exercises/
Authorization: Token your-token-here
```

**Query Parameters:**
- `category`: Filter by category (squat, bench, deadlift, accessory)
- `search`: Search by name

**Response:**
```json
{
  "count": 22,
  "results": [
    {
      "id": 1,
      "name": "Back Squat",
      "category": "squat",
      "description": "Standard barbell back squat",
      "created_at": "2025-01-15T10:30:00Z"
    }
  ]
}
```

### Get Exercise
Get specific exercise details.

```http
GET /api/exercises/{id}/
Authorization: Token your-token-here
```

## Workout Template Endpoints

### List Workout Templates
Get user's workout templates.

```http
GET /api/workout-templates/
Authorization: Token your-token-here
```

**Response:**
```json
{
  "count": 5,
  "results": [
    {
      "id": 1,
      "name": "Push Day",
      "description": "Chest and shoulders workout",
      "template_exercises": [...],
      "user_name": "john_doe",
      "created_at": "2025-01-15T10:30:00Z",
      "updated_at": "2025-01-15T10:30:00Z"
    }
  ]
}
```

### Create Workout Template
Create new workout template.

```http
POST /api/workout-templates/
Authorization: Token your-token-here
Content-Type: application/json

{
  "name": "Push Day",
  "description": "Chest and shoulders workout"
}
```

**Response:**
```json
{
  "id": 1,
  "name": "Push Day",
  "description": "Chest and shoulders workout",
  "template_exercises": [],
  "user_name": "john_doe",
  "created_at": "2025-01-15T10:30:00Z",
  "updated_at": "2025-01-15T10:30:00Z"
}
```

### Get Workout Template
Get specific workout template.

```http
GET /api/workout-templates/{id}/
Authorization: Token your-token-here
```

### Update Workout Template
Update existing workout template.

```http
PUT /api/workout-templates/{id}/
Authorization: Token your-token-here
Content-Type: application/json

{
  "name": "Updated Push Day",
  "description": "Updated description"
}
```

### Delete Workout Template
Delete workout template.

```http
DELETE /api/workout-templates/{id}/
Authorization: Token your-token-here
```

## Scheduled Workout Endpoints

### List Scheduled Workouts
Get user's scheduled workouts.

```http
GET /api/scheduled-workouts/
Authorization: Token your-token-here
```

**Query Parameters:**
- `start_date`: Filter by start date (YYYY-MM-DD)
- `end_date`: Filter by end date (YYYY-MM-DD)
- `is_completed`: Filter by completion status (true/false)

**Response:**
```json
{
  "count": 10,
  "results": [
    {
      "id": 1,
      "template_name": "Push Day",
      "template_details": {...},
      "scheduled_date": "2025-01-16",
      "notes": "Focus on form",
      "is_completed": false,
      "created_at": "2025-01-15T10:30:00Z"
    }
  ]
}
```

### Create Scheduled Workout
Schedule a workout for specific date.

```http
POST /api/scheduled-workouts/
Authorization: Token your-token-here
Content-Type: application/json

{
  "template": 1,
  "scheduled_date": "2025-01-16",
  "notes": "Focus on form"
}
```

**Response:**
```json
{
  "id": 1,
  "template_name": "Push Day",
  "template_details": {...},
  "scheduled_date": "2025-01-16",
  "notes": "Focus on form",
  "is_completed": false,
  "created_at": "2025-01-15T10:30:00Z"
}
```

### Complete Scheduled Workout
Mark scheduled workout as completed.

```http
POST /api/scheduled-workouts/{id}/complete/
Authorization: Token your-token-here
```

**Response:**
```json
{
  "message": "Workout completed successfully"
}
```

## Calendar Endpoint

### Get Calendar Workouts
Get workouts for calendar view.

```http
GET /api/calendar/
Authorization: Token your-token-here
```

**Query Parameters:**
- `year`: Year (e.g., 2025)
- `month`: Month (1-12)

**Example:**
```http
GET /api/calendar/?year=2025&month=1
Authorization: Token your-token-here
```

**Response:**
```json
[
  {
    "id": 1,
    "template_name": "Push Day",
    "template_details": {...},
    "scheduled_date": "2025-01-16",
    "notes": "Focus on form",
    "is_completed": false,
    "created_at": "2025-01-15T10:30:00Z"
  }
]
```

## Workout Log Endpoints

### List Workout Logs
Get user's completed workout logs.

```http
GET /api/workout-logs/
Authorization: Token your-token-here
```

**Query Parameters:**
- `start_date`: Filter by start date
- `end_date`: Filter by end date
- `exercise`: Filter by exercise name

**Response:**
```json
{
  "count": 15,
  "results": [
    {
      "id": 1,
      "workout_name": "Push Day Session",
      "date": "2025-01-16",
      "duration_minutes": 75,
      "notes": "Great session",
      "exercise_logs": [...],
      "created_at": "2025-01-16T11:30:00Z"
    }
  ]
}
```

### Create Workout Log
Log a completed workout.

```http
POST /api/workout-logs/
Authorization: Token your-token-here
Content-Type: application/json

{
  "scheduled_workout": 1,
  "workout_name": "Push Day Session",
  "date": "2025-01-16",
  "duration_minutes": 75,
  "notes": "Great session"
}
```

## Error Responses

### Validation Error (400)
```json
{
  "name": ["This field is required."],
  "scheduled_date": ["Enter a valid date."]
}
```

### Authentication Error (401)
```json
{
  "detail": "Authentication credentials were not provided."
}
```

### Permission Error (403)
```json
{
  "detail": "You do not have permission to perform this action."
}
```

### Not Found Error (404)
```json
{
  "detail": "Not found."
}
```

## Pagination

All list endpoints support pagination:

**Request:**
```http
GET /api/workout-templates/?page=2&page_size=10
```

**Response:**
```json
{
  "count": 25,
  "next": "http://127.0.0.1:8000/api/workout-templates/?page=3",
  "previous": "http://127.0.0.1:8000/api/workout-templates/?page=1",
  "results": [...]
}
```

## Interactive Testing

Use the interactive API documentation:
- **Swagger UI:** `http://127.0.0.1:8000/api/docs/`
- **ReDoc:** `http://127.0.0.1:8000/api/redoc/`