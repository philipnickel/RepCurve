# API Overview

RepCurve REST API documentation for powerlifting training data.

## Base Information

- **Base URL:** `http://127.0.0.1:8000/api/`
- **Authentication:** Token-based
- **Format:** JSON
- **HTTP Methods:** GET, POST, PUT, PATCH, DELETE

## Authentication

### Token Authentication
All authenticated endpoints require a token in the Authorization header:

```http
Authorization: Token your-token-here
```

### Getting a Token
```bash
# Register new user
curl -X POST http://127.0.0.1:8000/api/auth/register/ \
  -H "Content-Type: application/json" \
  -d '{
    "username": "testuser",
    "email": "test@example.com", 
    "password": "securepass123",
    "password_confirm": "securepass123"
  }'

# Response includes token
{
  "user": {...},
  "token": "366e01bd9c032be22f2443ce1ac5b468bb44272c"
}
```

### Using Token
```bash
curl -H "Authorization: Token 366e01bd9c032be22f2443ce1ac5b468bb44272c" \
  http://127.0.0.1:8000/api/workout-templates/
```

## Response Format

### Success Response
```json
{
  "success": true,
  "data": {
    "id": 1,
    "name": "Push Day",
    "description": "Chest and shoulders workout"
  },
  "error": null
}
```

### Error Response
```json
{
  "success": false,
  "data": null,
  "error": "Invalid credentials"
}
```

### List Response
```json
{
  "count": 25,
  "next": "http://127.0.0.1:8000/api/workouts/?page=2",
  "previous": null,
  "results": [
    {...},
    {...}
  ]
}
```

## HTTP Status Codes

| Code | Meaning |
|------|---------|
| 200 | OK - Success |
| 201 | Created - Resource created |
| 204 | No Content - Success, no response body |
| 400 | Bad Request - Invalid data |
| 401 | Unauthorized - Authentication required |
| 403 | Forbidden - Permission denied |
| 404 | Not Found - Resource doesn't exist |
| 500 | Internal Server Error |

## Data Models

### User
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

### Exercise
```json
{
  "id": 1,
  "name": "Back Squat",
  "category": "squat",
  "description": "Standard barbell back squat",
  "created_at": "2025-01-15T10:30:00Z"
}
```

### WorkoutTemplate
```json
{
  "id": 1,
  "name": "Push Day",
  "description": "Chest and shoulders",
  "template_exercises": [...],
  "user_name": "john_doe",
  "created_at": "2025-01-15T10:30:00Z",
  "updated_at": "2025-01-15T10:30:00Z"
}
```

### ScheduledWorkout
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

### WorkoutLog
```json
{
  "id": 1,
  "workout_name": "Push Day Session",
  "date": "2025-01-16",
  "duration_minutes": 75,
  "notes": "Great session",
  "exercise_logs": [...],
  "created_at": "2025-01-16T11:30:00Z"
}
```

## Pagination

List endpoints use cursor pagination:
```json
{
  "count": 25,
  "next": "http://127.0.0.1:8000/api/workouts/?page=2",
  "previous": null,
  "results": [...]
}
```

Query parameters:
- `page`: Page number (default: 1)
- `page_size`: Items per page (default: 20, max: 100)

## Filtering and Search

### Date Filtering
```bash
# Get workouts for specific date range
curl "http://127.0.0.1:8000/api/scheduled-workouts/?start_date=2025-01-01&end_date=2025-01-31"

# Calendar view for month
curl "http://127.0.0.1:8000/api/calendar/?year=2025&month=1"
```

### Category Filtering
```bash
# Get exercises by category
curl "http://127.0.0.1:8000/api/exercises/?category=squat"
```

## Rate Limiting

- **Development:** No rate limits
- **Production:** 1000 requests/hour per user

## CORS Policy

- **Development:** All origins allowed
- **Production:** Specific origins only

## Interactive Documentation

- **Swagger UI:** `http://127.0.0.1:8000/api/docs/`
- **ReDoc:** `http://127.0.0.1:8000/api/redoc/`
- **OpenAPI Schema:** `http://127.0.0.1:8000/api/schema/`

## Error Handling

### Common Errors

**Authentication Required (401):**
```json
{
  "detail": "Authentication credentials were not provided."
}
```

**Permission Denied (403):**
```json
{
  "detail": "You do not have permission to perform this action."
}
```

**Validation Error (400):**
```json
{
  "name": ["This field is required."],
  "email": ["Enter a valid email address."]
}
```

**Not Found (404):**
```json
{
  "detail": "Not found."
}
```

## Best Practices

### API Calls
1. **Always include Content-Type:** `application/json`
2. **Include Authorization header** for protected endpoints
3. **Handle error responses** gracefully
4. **Use appropriate HTTP methods** (GET, POST, PUT, DELETE)
5. **Validate data** before sending

### Performance
1. **Use pagination** for large datasets
2. **Cache responses** when appropriate
3. **Batch requests** when possible
4. **Include only needed fields** in responses

## Support

- **Issues:** Create GitHub issue
- **Questions:** Check API documentation first
- **Changes:** Review changelog for updates