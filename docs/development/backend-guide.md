# Backend Development Guide

This directory contains the main Django app for RepCurve's API backend.

## File Structure

```
workouts/
├── models.py           # Database models (Exercise, WorkoutTemplate, etc.)
├── serializers.py      # API serializers for JSON conversion  
├── views.py           # API endpoints and business logic
├── urls.py            # URL routing
├── admin.py           # Django admin interface
└── management/
    └── commands/
        └── populate_exercises.py  # Command to load exercises
```

## Key Models

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

## API Development

### Adding New Endpoints

1. **Add view in `views.py`:**
   ```python
   @api_view(['GET'])
   @permission_classes([IsAuthenticated])
   def my_new_endpoint(request):
       return Response({'data': 'example'})
   ```

2. **Add URL in `urls.py`:**
   ```python
   path('my-endpoint/', views.my_new_endpoint, name='my-endpoint'),
   ```

3. **Test with curl:**
   ```bash
   curl -H "Authorization: Token YOUR_TOKEN" http://127.0.0.1:8000/api/my-endpoint/
   ```

### Testing

```bash
# Run all tests
python manage.py test

# Test specific app
python manage.py test workouts

# Run Django shell for debugging
python manage.py shell
```

### Database

```bash
# Create migrations after model changes
python manage.py makemigrations

# Apply migrations
python manage.py migrate

# Create superuser for admin
python manage.py createsuperuser

# Load exercises database
python manage.py populate_exercises
```

## Common Tasks

### Adding a New Exercise Category
1. Update `CATEGORY_CHOICES` in `models.py`
2. Add exercises to `populate_exercises.py`
3. Update Flutter app's exercise filtering

### Adding New Workout Fields
1. Add field to model in `models.py`
2. Update serializer in `serializers.py`
3. Create and run migration
4. Update Flutter models

### API Response Format
All endpoints return JSON in this format:
```json
{
  "success": true,
  "data": {...},
  "error": null
}
```

Or for errors:
```json
{
  "success": false,
  "data": null, 
  "error": "Error message"
}
```

## Debugging

### Check API logs
Django prints all requests to console when running `python manage.py runserver`

### Inspect database
```bash
python manage.py shell
>>> from workouts.models import *
>>> WorkoutTemplate.objects.all()
>>> User.objects.filter(username='testuser')
```

### Admin interface
Visit `http://127.0.0.1:8000/admin/` to view/edit data through web interface.