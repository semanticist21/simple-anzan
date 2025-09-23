# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Simple Anzan App - A Flutter-based mental math training application for practicing addition and multiplication calculations (abacus-style). The app supports multiple platforms: Android, iOS, Windows, macOS, Linux, and Web.

Current version: 3.7.20+60

## Development Commands

### Flutter Development
- `flutter pub get` - Install dependencies
- `flutter run` - Run the app in development mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS app (requires macOS and Xcode)
- `flutter build web` - Build web version
- `flutter build windows` - Build Windows executable
- `flutter build macos` - Build macOS app
- `flutter build linux` - Build Linux executable

### Android 16KB Page Size Compliance
- App targets Android 15 (API 35) for Google Play compliance
- Updated dependencies to support 16KB memory page sizes
- Key updated libraries: flutter_soloud ^2.1.0, shared_preferences ^2.2.3

### Code Quality
- `flutter analyze` - Run static analysis (uses analysis_options.yaml)
- `flutter test` - Run unit tests
- `flutter test test/` - Run tests in test directory

### Asset Management
- `flutter pub run flutter_launcher_icons:main` - Generate app icons
- `flutter pub run flutter_native_splash:create` - Generate splash screens

## Architecture

### Core Structure
- `lib/main.dart` - App entry point with platform-specific window management
- `lib/router.dart` - App routing configuration
- `lib/client.dart` - Client-side logic and state management
- `lib/src/` - Main source code directory

### Key Directories
- `lib/src/pages/` - UI pages (home_page.dart, home_page_multiply.dart, etc.)
- `lib/src/components/` - Reusable UI components (flicker widgets, containers)
- `lib/src/provider/` - State management using Provider pattern
- `lib/src/settings/` - Settings management with preference interfaces
- `lib/src/dialog/` - Modal dialogs and popups
- `lib/src/model/` - Data models (preset_add_model.dart, preset_multiply_model.dart)
- `lib/src/functions/` - Utility functions and business logic
- `lib/src/const/` - Constants (colors, localization, app constants)

### State Management
Uses Provider pattern for state management:
- `StateProvider` - Main state provider for addition mode
- `StateProviderMultiply` - State provider for multiplication mode

### Settings Architecture
- Preference interface pattern in `lib/src/settings/Interface/`
- Separate preference managers for addition (`plus_pref/`) and multiplication (`multiply_prefs/`)
- Theme and sound options in `lib/src/settings/option/`

### Platform Support
- Multi-platform targeting with platform-specific configurations
- Windows: Window management with custom sizing and error logging
- Android: Custom MainActivity in Kotlin with native sound player
- Native sound integration via platform channels

### Key Features
- Two calculation modes: Addition and Multiplication
- Preset management for different difficulty levels
- Customizable themes and sound options
- Speed settings and countdown modes
- Problem generation and iteration control

## Important Files

### Configuration
- `pubspec.yaml` - Dependencies and app configuration
- `analysis_options.yaml` - Flutter linting rules
- `android/app/build.gradle` - Android build configuration

### Assets
- `assets/` - Contains app icons and audio files
- Icons managed via flutter_launcher_icons configuration
- Splash screen managed via flutter_native_splash

### Database
- `preset.db` - SQLite database for storing presets and user data
- Uses sqflite_common_ffi for cross-platform database support

## Dependencies

### Core Dependencies
- provider: State management
- shared_preferences: Local storage
- sqflite_common_ffi: Database
- flutter_soloud: High-performance, low-latency audio playback
- intl: Internationalization
- crypto: Hashing utilities

### Platform-Specific
- window_manager: Windows window management
- just_audio_windows: Windows audio support
- universal_io: Cross-platform IO operations

### UI
- flutter_colorpicker: Color selection
- cupertino_icons: iOS-style icons

## Native Integration

### Android
- Kotlin-based MainActivity
- Package name: com.kobbokkom.abacus_simple_anzan

### Sound System
- High-performance audio handling using flutter_soloud package
- Conditional audio format selection: OGG for Android, M4A for iOS, WAV for desktop
- Low-latency audio playback optimized for games and interactive applications
- Audio assets managed in the assets directory