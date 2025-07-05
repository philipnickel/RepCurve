# Development Workflow Guide

Guidelines for the two-person RepCurve development team.

## Team Roles

### Backend Developer
- **Focus:** Django REST API, database models, business logic
- **Main directories:** `workouts/`, `django_project/`
- **Responsibilities:**
  - API endpoints and serializers
  - Database schema and migrations
  - Authentication and permissions
  - Data validation and business rules

### Frontend Developer  
- **Focus:** Flutter mobile app, UI/UX, client-side logic
- **Main directories:** `repcurve_app/lib/`
- **Responsibilities:**
  - Screen layouts and navigation
  - API integration and state management
  - User experience and design
  - Cross-platform compatibility

## Daily Workflow

### 1. Environment Setup (Both)
```bash
# Backend developer
conda activate RepCurveEnv
python manage.py runserver

# Frontend developer  
cd repcurve_app
flutter run
```

### 2. Communication Protocol
- **Daily sync:** Quick 5-min check-in about what you're working on
- **API changes:** Backend dev must notify frontend dev immediately
- **Testing:** Both test changes with both systems running
- **Issues:** Create GitHub issues for bugs/features

### 3. Git Workflow

#### Branch Naming
- `backend/feature-name` - Backend features
- `frontend/feature-name` - Frontend features  
- `hotfix/bug-description` - Quick fixes
- `api/endpoint-name` - API-specific changes

#### Commit Messages
```
type(scope): description

Examples:
feat(api): add workout completion endpoint
fix(ui): resolve calendar navigation bug
docs(readme): update setup instructions
refactor(models): simplify workout template structure
```

#### Pull Request Process
1. **Create feature branch** from `main`
2. **Make changes** in your area
3. **Test integration** with other system
4. **Create PR** with clear description
5. **Code review** by other developer
6. **Merge** only after approval and testing

## API Development Protocol

### Backend Dev Creates New Endpoint
1. **Design API** (discuss with frontend dev)
2. **Implement endpoint** in Django
3. **Test with curl/Postman**
4. **Document endpoint** (update README API section)
5. **Notify frontend dev** with example usage

### Frontend Dev Integrates API
1. **Update ApiService** with new method
2. **Add/update models** if needed
3. **Implement UI integration**
4. **Test with real data**
5. **Handle error cases**

## Testing Standards

### Backend Testing
```bash
# Run tests before committing
python manage.py test

# Test API endpoints manually
curl -H "Authorization: Token TOKEN" http://127.0.0.1:8000/api/endpoint/

# Check Django admin interface
python manage.py createsuperuser  # if needed
```

### Frontend Testing
```bash
# Test app functionality
flutter run

# Test on multiple platforms
flutter run -d ios
flutter run -d android

# Test API integration
# Verify all CRUD operations work
```

### Integration Testing (Both)
- **Always test together:** Backend + Frontend running
- **Test user flows:** Registration → Login → Create Workout → Calendar
- **Test error scenarios:** No internet, invalid data, server errors
- **Test on real devices:** Not just simulators

## Common Scenarios

### Adding New Feature (e.g., Workout Notes)

**Backend Developer:**
1. Add `notes` field to `WorkoutLog` model
2. Create and run migration
3. Update serializer to include `notes`
4. Update API endpoints to handle `notes`
5. Test with curl/admin interface

**Frontend Developer:**  
1. Update `WorkoutLog` model in Dart
2. Add notes input field to workout screen
3. Update API service calls
4. Test create/edit/display functionality
5. Handle validation errors

### Debugging API Issues

**Backend Dev:**
- Check Django console for request logs
- Use Django admin to inspect database
- Test endpoints with curl
- Check authentication tokens

**Frontend Dev:**
- Check Flutter console for HTTP errors
- Verify API base URL is correct
- Check request headers and body
- Test on different devices/simulators

### Database Changes

**Backend Dev Process:**
1. Modify model in `models.py`
2. Run `python manage.py makemigrations`
3. Run `python manage.py migrate`
4. Update serializers if needed
5. Notify frontend dev of changes

**Frontend Dev Response:**
1. Update corresponding Dart models
2. Update API service calls if needed
3. Modify UI to handle new fields
4. Test data flow end-to-end

## Code Review Checklist

### Backend PRs
- [ ] Tests pass (`python manage.py test`)
- [ ] API endpoints documented
- [ ] Database migrations included
- [ ] Error handling implemented
- [ ] Authentication/permissions correct

### Frontend PRs  
- [ ] App builds without errors
- [ ] UI follows design guidelines
- [ ] Error states handled gracefully
- [ ] Works on iOS and Android
- [ ] API integration tested

### Both
- [ ] Code is clean and commented
- [ ] No sensitive data committed
- [ ] README updated if needed
- [ ] Feature works end-to-end

## Emergency Procedures

### Server Down
1. Backend dev investigates Django logs
2. Frontend dev implements offline mode/error handling
3. Communicate status to users

### Build Broken
1. Identify which change broke it
2. Revert if necessary for quick fix
3. Fix properly in separate PR

### Database Corruption
1. Restore from backup
2. Re-run migrations if needed
3. Test data integrity

## Tools and Resources

### Backend
- Django Admin: `http://127.0.0.1:8000/admin/`
- API Documentation: See main README
- Django Docs: https://docs.djangoproject.com/

### Frontend
- Flutter Docs: https://docs.flutter.dev/
- Material Design: https://m3.material.io/
- Dart Packages: https://pub.dev/

### Shared
- GitHub Issues: Track bugs and features
- VS Code: Recommended editor
- Postman/curl: API testing