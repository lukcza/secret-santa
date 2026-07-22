# 🎅 Secret Santa

A modern, feature-rich mobile application for organizing Secret Santa gift exchanges. Built with Flutter and Firebase, this app makes coordinating gift exchanges easy and fun!

<div align="center">

[![Flutter](https://img.shields.io/badge/Flutter-3.7+-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.7+-0175C2?style=for-the-badge&logo=dart)](https://dart.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Firestore-FFCA28?style=for-the-badge&logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](#license)

</div>

---

## ✨ Features

- 🔐 **Secure Authentication** - Email and Password login powered by Firebase Authentication
- 👥 **Create & Manage Groups** - Organize Secret Santa groups with friends and family
- 🎁 **Smart Matching** - (Upcoming) Automatic Secret Santa pair matching algorithm
- 💬 **Real-time Updates** - Instant synchronization across devices using Firestore
- 🌍 **Multi-language Support** - Support for multiple languages (i18n)
- 🎨 **Dark & Light Themes** - Adaptive UI with system theme support
- 📱 **Cross-platform** - Available on iOS, Android, Web, Windows, macOS, and Linux
- 🚀 **State Management** - Clean architecture with BLoC pattern
- 📦 **Component Library** - Pre-built UI components with Widgetbook documentation

---

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.7+
- **Language**: Dart 3.7+
- **State Management**: BLoC Pattern with flutter_bloc
- **Routing**: GoRouter for navigation
- **UI Components**: Widgetbook for component documentation

### Backend & Services
- **Backend**: Firebase
  - **Authentication**: Firebase Auth (Email/Password)
  - **Database**: Cloud Firestore
  - **Realtime**: Real-time synchronization

### Development Tools
- **Localization**: intl & flutter_localizations
- **Dependency Injection**: GetIt
- **Functional Programming**: fpdart (Functional Programming Dart)
- **Code Generation**: build_runner

---

## 📋 Project Structure

```
lib/
├── main.dart                 # Application entry point
├── firebase_options.dart     # Firebase configuration
├── injection_container.dart  # Dependency injection setup
├── core/                     # Core functionality
│   ├── enums/               # Enums used across app
│   ├── errors/              # Error handling
│   ├── extensions/          # Dart extensions
│   ├── l10n/                # Localization
│   ├── router/              # Navigation routes
│   ├── theme/               # App theming
│   └── utils/               # Utility functions
├── features/                # Feature modules
│   ├── auth/               # Authentication feature
│   ├── groups/             # Groups management
│   └── home/               # Home screen
└── assets/                 # Images, fonts, etc.
```

---

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.7+ ([Install Flutter](https://flutter.dev/docs/get-started/install))
- Dart 3.7+
- Firebase project setup

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/secret-santa.git
   cd secret-santa
   ```

2. **Get Flutter dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Firebase**
   - Create a Firebase project on [Firebase Console](https://console.firebase.google.com)
   - Download your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS)
   - Place them in the appropriate directories:
     - Android: `android/app/`
     - iOS: `ios/Runner/`

4. **Run code generation**
   ```bash
   flutter pub run build_runner build
   ```

5. **Run the app**
   ```bash
   flutter run
   ```

---

## 🎯 Usage

### Running on Different Platforms

**iOS**
```bash
flutter run -d iphone
```

**Android**
```bash
flutter run -d android
```

**Web**
```bash
flutter run -d chrome
```

**Windows/macOS/Linux**
```bash
flutter run -d windows   # or macos, linux
```

### Development Commands

**Watch for changes and rebuild**
```bash
flutter run
```

**Build APK (Android)**
```bash
flutter build apk
```

**Build IPA (iOS)**
```bash
flutter build ios
```

**Build release**
```bash
flutter build web
```

**Widgetbook - Component Library**
```bash
cd widgetbook
flutter run -d chrome
```

---

## 📐 Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
Feature Module
├── Data Layer
│   ├── datasources (local, remote)
│   ├── models
│   └── repositories
├── Domain Layer
│   ├── entities
│   ├── repositories (interfaces)
│   └── usecases
└── Presentation Layer
    ├── bloc
    ├── pages
    └── widgets
```

**Key Patterns:**
- **BLoC Pattern** for state management
- **Dependency Injection** with GetIt
- **Functional Programming** with fpdart for error handling
- **Repository Pattern** for data access
- **Equatable** for value equality

---

## 📱 Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Create a new project or use existing one
3. Enable Authentication methods:
   - Email/Password
4. Create Firestore Database:
   - Collections: `groups`, `users`, `pairings`
   - Set appropriate security rules
5. Download config files and add to project

---

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Run `flutter analyze` to check code quality
- Use `dart format` to format code

---


## 🔗 Links

- [Flutter Documentation](https://flutter.dev)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [BLoC Library](https://bloclibrary.dev)
