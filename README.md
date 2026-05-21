# Medical App - Advanced Wellness Monitoring Platform

A professional Flutter application for medical assessment and patient wellness monitoring with multi-language support and secure authentication.

## 🏥 Features

- **User Authentication**: Secure login/registration for patients and administrators
- **Multi-Language Support**: English, French, and Arabic
- **Assessment Management**: Comprehensive medical assessments with structured data
- **Patient Tracking**: Real-time wellness monitoring and health metrics
- **Secure Storage**: SQLite database with encrypted local storage
- **Admin Dashboard**: Professional admin interface for data management
- **Video Integration**: YouTube video player and video_player support
- **PDF Export**: Generate and print medical reports

## 📋 Project Structure

```
lib/
├── app/                        # App configuration & routing
├── core/
│   ├── constants/             # App colors, translations, config
│   ├── providers/             # State management (Provider)
│   └── widgets/               # Reusable UI components
├── features/
│   ├── auth/                  # Authentication feature
│   │   ├── presentation/      # Screens & widgets
│   │   ├── domain/            # Business logic
│   │   └── data/              # Data models & repositories
│   ├── assessment/            # Assessment feature
│   ├── patient/               # Patient management
│   └── admin/                 # Admin features
└── main.dart                  # App entry point
```

## 🛠 Tech Stack

- **Framework**: Flutter 3.11.0+
- **State Management**: Provider 6.0.0
- **Database**: SQLite with sqflite
- **Authentication**: Secure credential management
- **Localization**: intl 0.20.0
- **Video**: YouTube Player & Video Player

## 📦 Dependencies

```yaml
flutter:
  cupertino_icons: ^1.0.8
  provider: ^6.0.0
  video_player: ^2.8.0
  youtube_player_flutter: ^9.1.1
  intl: ^0.20.0
  shared_preferences: ^2.2.2
  pdf: ^3.10.0
  printing: ^5.11.0
  sqflite: ^2.3.0
  sqflite_common_ffi: ^2.3.4
  path: ^1.8.3
  crypto: ^3.0.3
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.11.0 or higher
- Dart 3.1.0 or higher
- Android SDK (for Android development)
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/medical_app.git
cd medical_app
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Generate localization files**
```bash
flutter gen-l10n
```

4. **Run the application**
```bash
flutter run
```

## 🔐 Authentication

### Test Credentials
- **Admin Email**: admin@medilevel.com
- **Admin Password**: admin_password
- **Patient Email**: test@medilevel.com
- **Patient Password**: password123

## 📱 Supported Platforms

- ✅ Android (API 21+)
- ✅ iOS (12.0+)
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🌍 Internationalization

The app supports three languages:
- **English** (en)
- **French** (fr)
- **Arabic** (ar)

Language selection is available on the login screen.

## 📊 Database Schema

The app uses SQLite for local storage with the following main tables:
- **Users**: Patient and admin credentials
- **Assessments**: Medical assessment data
- **Responses**: Assessment response data
- **Settings**: User preferences and configuration

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/path/to/test.dart
```

## 🔨 Build

### Android
```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 📝 Code Style & Conventions

- Follow [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines
- Use meaningful variable and function names
- Maintain consistent indentation (2 spaces)
- Document complex functions with comments
- Keep methods focused and small

## 🔒 Security Considerations

- Sensitive data is encrypted using crypto package
- Credentials stored securely in SharedPreferences
- HTTPS enforced for API communications
- Input validation on all user inputs
- SQL injection prevention through parameterized queries

## 📄 License

This project is proprietary and confidential. Unauthorized copying or distribution is prohibited.

## 👥 Contributors

- Development Team
- Quality Assurance Team

## 📞 Support

For issues and questions:
1. Check existing GitHub issues
2. Create a new issue with detailed description
3. Contact: support@medilevel.com

## 🔄 Version History

### v1.0.0 (Current)
- Initial release
- Core authentication system
- Assessment module
- Multi-language support
- Admin dashboard

---

**Last Updated**: May 2026

