# Frontend Setup Guide

Detailed Flutter app setup for RepCurve.

## Prerequisites

- **macOS** with Xcode (for iOS development)
- **Android Studio** (for Android development)
- **Flutter SDK**
- **Git**

## Step-by-Step Setup

### 1. Install Flutter

```bash
# Download Flutter SDK
cd ~/Development
git clone https://github.com/flutter/flutter.git

# Add to PATH permanently
echo 'export PATH="$HOME/Development/flutter/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify installation
flutter --version
flutter doctor
```

### 2. Platform Setup

**For iOS Development:**
```bash
# Install Xcode from App Store
# Accept Xcode license
sudo xcodebuild -license accept

# Install iOS Simulator
open -a Simulator
```

**For Android Development:**
```bash
# Install Android Studio
# Install Android SDK through Android Studio
# Create Android Virtual Device (AVD)
```

### 3. Clone and Setup Project

```bash
# Clone repository (if not already done)
git clone https://github.com/YOUR_USERNAME/RepCurve.git
cd RepCurve/repcurve_app

# Install Flutter dependencies
flutter pub get

# Verify setup
flutter doctor
flutter devices  # Should show available simulators/devices
```

### 4. Run Application

```bash
# Start iOS Simulator
open -a Simulator

# Run on iOS
flutter run

# Or specify platform
flutter run -d ios
flutter run -d android
flutter run -d chrome  # Web
```

## Development Environment

### VS Code Setup (Recommended)

Install extensions:
- **Flutter** (by Dart Code)
- **Dart** (by Dart Code)

VS Code settings for Flutter:
```json
{
  "dart.flutterSdkPath": "/path/to/flutter",
  "dart.previewFlutterUiGuides": true,
  "dart.debugExternalLibraries": false
}
```

### Project Structure
```
repcurve_app/
├── lib/                    # Main source code
│   ├── main.dart          # App entry point
│   ├── models/            # Data models
│   ├── services/          # API and business logic
│   ├── providers/         # State management
│   └── screens/           # UI screens
├── android/               # Android-specific code
├── ios/                   # iOS-specific code
├── web/                   # Web-specific code
├── test/                  # Unit tests
└── pubspec.yaml          # Dependencies
```

### Key Files

**pubspec.yaml** - Dependencies and configuration:
```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  provider: ^6.0.5
  flutter_secure_storage: ^9.0.0
  table_calendar: ^3.0.9
  fl_chart: ^0.68.0
```

**lib/main.dart** - App entry point
**lib/services/api_service.dart** - API communication
**lib/models/workout_models.dart** - Data models

## Development Workflow

### Hot Reload
```bash
# In running app terminal
r      # Hot reload
R      # Hot restart
q      # Quit
```

### Debugging
```bash
# Run with debugging
flutter run --debug

# Run in profile mode
flutter run --profile

# Run in release mode
flutter run --release
```

### Testing
```bash
# Run unit tests
flutter test

# Run widget tests
flutter test test/widget_test.dart

# Run integration tests
flutter drive --target=test_driver/app.dart
```

### Building
```bash
# Build iOS app
flutter build ios

# Build Android APK
flutter build apk

# Build Android App Bundle
flutter build appbundle

# Build for web
flutter build web
```

## API Integration

### Base URL Configuration
Edit `lib/services/api_service.dart`:
```dart
class ApiService {
  // Development
  static const String baseUrl = 'http://127.0.0.1:8000/api';
  
  // For physical device testing, use computer's IP
  // static const String baseUrl = 'http://192.168.1.XXX:8000/api';
}
```

### Testing API Connection
1. Ensure Django server is running on `http://127.0.0.1:8000`
2. Launch Flutter app
3. Check for green API connection indicator on home screen
4. If red, check console for network errors

## Platform-Specific Notes

### iOS
- **Simulator:** Included with Xcode
- **Physical Device:** Requires Apple Developer account for deployment
- **Permissions:** Camera, storage automatically handled

### Android
- **Emulator:** Create AVD in Android Studio
- **Physical Device:** Enable USB debugging
- **Permissions:** Handled in AndroidManifest.xml

### Web
- **Local Testing:** `flutter run -d chrome`
- **CORS:** Ensure Django CORS settings allow web requests
- **Deployment:** `flutter build web` creates web/ directory

## Common Issues

### Flutter Doctor Issues
```bash
# Xcode license not accepted
sudo xcodebuild -license accept

# Android license not accepted
flutter doctor --android-licenses

# iOS tools missing
brew install --cask cocoapods
```

### Build Issues
```bash
# Clean build cache
flutter clean
flutter pub get

# iOS build issues
cd ios
rm -rf Pods Podfile.lock
pod install
cd ..

# Android build issues
cd android
./gradlew clean
cd ..
```

### API Connection Issues
- **Ensure Django server running:** `python manage.py runserver`
- **Check API URL in code:** Should match Django server address
- **Physical device:** Use computer's IP address, not localhost
- **Firewall:** Ensure port 8000 is accessible

### Simulator Issues
```bash
# Reset iOS Simulator
xcrun simctl erase all

# List Android AVDs
emulator -list-avds

# Start specific Android emulator
emulator @avd_name
```

## Performance Tips

### Development
- Use **hot reload** for quick UI changes
- Use **hot restart** for logic changes
- Use **profile mode** for performance testing
- Keep **dev tools open** for debugging

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
flutter format .

# Check for unused dependencies
flutter pub deps
```

## Next Steps

- 📖 [Frontend Development Guide](../development/frontend-guide.md)
- 🔧 [Backend Setup](backend.md)
- 🤝 [Team Workflow](../development/workflow.md)