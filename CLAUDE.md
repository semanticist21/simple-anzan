# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Simple Anzan App - A Flutter-based mental math training application for practicing addition and multiplication calculations (abacus-style). The app supports multiple platforms: Android, iOS, Windows, macOS, Linux, and Web.

Current version: 4.0.0+61

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

### Code Quality

- `flutter analyze` - Run static analysis (uses analysis_options.yaml with flutter_lints)
- `flutter test` - Run unit tests
- `flutter test test/` - Run tests in test directory

### Asset Management

- `flutter pub run flutter_launcher_icons:main` - Generate app icons from assets/icon.png

## Architecture

### Core Application Structure

The app follows a four-tab navigation structure managed through a bottom navigation bar:

1. Addition mode (`/` - HomePage)
2. Addition settings (`/settings` - SettingsPage)
3. Multiplication mode (`/multiply` - HomeMultiplyPage)
4. Multiplication settings (`/settings/multiply` - SettingsMultiplyPage)

Navigation is handled by `router.dart` using custom routes, with state-aware navigation that prevents tab switching during active iterations.

### State Management Architecture

Uses Provider pattern with two main providers:

- `StateProvider` - Manages addition mode state with `ButtonState` enum (iterationNotStarted, iterationStarted, iterationCompleted)
- `StateProviderMultiply` - Manages multiplication mode state with `ButtonMultiplyState` enum

Both providers control:

- Button visibility and text based on current state
- Problem list generation and storage
- Integration with "burning mode" for infinite iterations

### Settings Architecture Pattern

Implements a sophisticated preference interface system:

**Interface Layer** (`lib/src/settings/Interface/`):

- `PreferenceInterface<T, V>` - Abstract base class for type-safe preference management
- Generic design allows enum-based preferences with automatic SharedPreferences persistence
- Automatic index/value synchronization and validation

**Implementation Layer**:

- `SettingsManager` - Manages addition mode preferences (digit, speed, questions, etc.)
- `SettingsMultiplyManager` - Manages multiplication mode preferences
- `OptionManager` - Manages global app options (theme, sound)

**Preference Classes** follow pattern:

```dart
class SpecificPref extends PreferenceInterface<EnumType, ValueType> {
  // Implements setValue(), setIndex(), valueToEnum(), enumToValue()
}
```

### Internationalization Architecture

- Uses easy_localization with JSON translation files in `assets/translations/`
- Supports English, Korean, and Japanese (`en.json`, `ko.json`, `ja.json`)
- Fallback locale is English
- Translation keys follow hierarchical structure (e.g., `settings.speed`, `buttons.start`)

### Audio System Architecture

- Uses flutter_soloud for high-performance, low-latency audio playback
- Managed through `SoundOptionHandler` with reactive streams
- Platform-optimized audio formats (OGG/M4A/WAV)
- Global sound toggle with persistence

### Platform-Specific Features

**Windows Platform**:

- Window management via window_manager (minimum 1024x768, default 400x600)
- Custom error logging to `errors.txt` file
- ExitWatcher wrapper for proper app lifecycle management
- Windows-specific toolbar options (preset management, fast settings)

**Android Platform**:

- Targets Android 15 (API 35) with 16KB page size compliance
- Package: com.kobbokkom.abacus_simple_anzan
- Kotlin-based MainActivity integration
- ProGuard enabled for release builds

### Theme System

- Dual theme support (light/dark) via `ThemeSelector`
- Reactive theme switching with stream-based updates
- Platform-appropriate styling with Material Design 3
- Custom toggle switches with gradient animations

## Key Directories

### Core Structure

- `lib/main.dart` - App entry point with platform-specific initialization
- `lib/router.dart` - Centralized routing configuration
- `lib/client.dart` - Database client and data management
- `lib/custom_route.dart` - Custom route animations

### Source Organization

- `lib/src/pages/` - Main UI pages (4 primary screens)
- `lib/src/provider/` - State management providers
- `lib/src/settings/` - Settings management system
  - `Interface/` - Generic preference interfaces
  - `plus_pref/` - Addition mode preferences
  - `multiply_prefs/` - Multiplication mode preferences
  - `option/` - Global app options
- `lib/src/components/` - Reusable UI components (flickers, containers, dropdowns)
- `lib/src/dialog/` - Modal dialogs and popups
- `lib/src/model/` - Data models for presets and save data
- `lib/src/functions/` - Utility functions and business logic
- `lib/src/const/` - Constants and styling definitions

## Important Files

### Configuration

- `pubspec.yaml` - Dependencies and app metadata (version 4.0.0+61)
- `analysis_options.yaml` - Flutter linting configuration using flutter_lints
- `android/app/build.gradle` - Android build settings (API 35, 16KB page support)

### Assets & Localization

- `assets/icon.png` - Source icon for multi-platform generation
- `assets/translations/` - JSON translation files (en/ko/ja)
- Flutter app icons configured for all platforms via flutter_launcher_icons

### Database

- SQLite database via sqflite_common_ffi for cross-platform preset storage
- Preset models for both addition and multiplication modes

## Key Dependencies

### Core Framework

- `provider: ^6.1.5` - State management
- `shared_preferences: ^2.5.3` - Local storage with caching
- `easy_localization: ^3.0.8` - Internationalization framework

### Audio & UI

- `flutter_soloud: ^3.3.6` - High-performance audio system
- `animated_toggle_switch: ^0.8.3` - Custom toggle controls
- `flutter_colorpicker: ^1.1.0` - Color selection widgets
- `google_fonts: ^6.2.1` - Typography system

### Platform Support

- `window_manager: ^0.5.1` - Desktop window management
- `universal_io: ^2.2.2` - Cross-platform IO operations
- `sqflite_common_ffi: ^2.3.6` - Cross-platform SQLite

## Development Patterns

### State Transitions

Both calculation modes use finite state machines:

```
iterationNotStarted → iterationStarted → iterationCompleted → iterationNotStarted
```

State changes trigger UI updates for button visibility, text, and available actions.

### Burning Mode Integration

- Special infinite iteration mode that bypasses normal completion
- Mode-specific implementation in both addition and multiplication providers
- Visual indicators and different button behaviors when active

### Preset System

- JSON serialization for preset configurations
- Cross-mode preset management with dedicated list dialogs
- Platform-specific fast-setting dialogs for quick configuration
