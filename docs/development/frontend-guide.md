# Frontend Development Guide

Flutter mobile app for RepCurve powerlifting tracker.

## File Structure

```
lib/
├── main.dart               # App entry point
├── models/                 # Data models
│   ├── workout_models.dart # Workout, Exercise, Set models
│   ├── user.dart          # User model
│   └── api_response.dart  # API response wrapper
├── services/              # API and business logic
│   ├── api_service.dart   # HTTP requests to Django API
│   └── auth_service.dart  # Authentication logic
├── providers/             # State management
│   └── auth_provider.dart # User authentication state
└── screens/               # UI screens
    ├── auth/             # Login/register screens
    ├── workouts/         # Workout creation/editing
    ├── calendar_screen.dart  # Weekly calendar view
    ├── analysis_screen.dart  # Progress charts
    └── main_navigation.dart  # Bottom navigation
```

## Development Setup

### Prerequisites
- Flutter SDK installed and in PATH
- iOS Simulator or Android Emulator running
- Django API server running on `http://127.0.0.1:8000`

### Commands
```bash
# Install dependencies
flutter pub get

# Run on connected device/simulator
flutter run

# Run on specific platform
flutter run -d ios
flutter run -d android
flutter run -d chrome

# Build for release
flutter build ios
flutter build android
```

## Key Concepts

### API Integration
All API calls go through `ApiService` class:
```dart
// Example API call
final response = await ApiService.createWorkoutTemplate(template);
if (response.success) {
  // Handle success
  final template = response.data;
} else {
  // Handle error
  print(response.error);
}
```

### Authentication Flow
1. User logs in → `AuthService.login()` → Store token
2. All API calls include token in headers
3. Token stored securely using `flutter_secure_storage`

### State Management
Using Provider pattern:
```dart
// Access auth state
final authProvider = Provider.of<AuthProvider>(context);
final user = authProvider.user;

// Update state
authProvider.login(userData);
authProvider.logout();
```

## Screen Development

### Adding New Screen
1. **Create screen file:**
   ```dart
   // lib/screens/my_screen.dart
   class MyScreen extends StatefulWidget {
     @override
     State<MyScreen> createState() => _MyScreenState();
   }
   ```

2. **Add navigation:**
   ```dart
   Navigator.push(context, 
     MaterialPageRoute(builder: (context) => MyScreen())
   );
   ```

3. **Add to bottom navigation** (if needed):
   Update `main_navigation.dart`

### API Data Flow
1. Screen calls `ApiService` method
2. `ApiService` makes HTTP request to Django
3. Response converted to Dart model objects
4. UI updated with data

### Common Patterns

**Loading States:**
```dart
bool _isLoading = false;

// In API call
setState(() { _isLoading = true; });
try {
  final result = await ApiService.getData();
  // Handle result
} finally {
  setState(() { _isLoading = false; });
}
```

**Error Handling:**
```dart
if (!response.success) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Error: ${response.error}')),
  );
}
```

## Testing

### Unit Tests
```bash
flutter test
```

### Widget Tests  
```bash
flutter test test/widget_test.dart
```

### Integration Tests
```bash
flutter drive --target=test_driver/app.dart
```

## Common Issues

### API Connection Problems
- Ensure Django server is running on port 8000
- Check `baseUrl` in `api_service.dart`
- For physical device testing, use computer's IP address

### Build Issues
```bash
# Clean build cache
flutter clean
flutter pub get

# Reset iOS build
cd ios && rm -rf Pods Podfile.lock && pod install
```

### Hot Reload Not Working
- Save files to trigger hot reload
- Use `r` in terminal for manual hot reload
- Use `R` for hot restart (full restart)

## UI Guidelines

- Follow Material Design 3 principles
- Use `Theme.of(context)` for colors/typography
- Implement both light and dark themes
- Ensure accessibility (screen readers, contrast)
- Test on multiple screen sizes

## Performance Tips

- Use `const` constructors for static widgets
- Implement `ListView.builder` for long lists
- Cache API responses when appropriate
- Use `FutureBuilder` for async data loading