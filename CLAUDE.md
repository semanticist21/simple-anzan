# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Simple Anzan App - A Flutter-based mental math training application for practicing addition and multiplication calculations (abacus-style). The app supports multiple platforms: Android, iOS, Windows, macOS, Linux, and Web.

Current version: 4.0.7+67

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
- `OptionManager` - Manages global app options (theme, sound, color palette)

**Preference Classes** follow pattern:

```dart
class SpecificPref extends PreferenceInterface<EnumType, ValueType> {
  // Implements setValue(), setIndex(), valueToEnum(), enumToValue()
}
```

### Theme System Architecture

**Color Palette System** (`lib/src/settings/option/`):

The app uses a shadcn-inspired color palette system with 6 themes:
- Blue (default) - Material blue
- Green - shadcn green-600 (darker green for better visibility)
- Sky - shadcn sky-500
- Yellow - shadcn yellow-500
- Violet - shadcn violet-500
- Slate - shadcn slate-500 (grey tone)

**Theme Management**:
- `ThemeSelector` - Manages theme state with reactive stream-based updates
- Supports light/dark mode switching via `isDark` boolean and `isDarkStream`
- Color palette switching via `currentPalette` and `colorPaletteStream`
- `getFlickerTextColor(BuildContext)` utility - Returns black text for default theme in light mode, primary color otherwise (special handling for number display readability)

**Theme Picker** (`lib/src/dialog/theme_color_picker.dart`):
- Uses flutter_colorpicker's BlockPicker for color selection
- Shows "기본" (default) badge on blue theme with check icon overlay
- Immediate color application without confirm dialog
- Supports all 9 languages for theme picker labels

### Flicker Component Architecture

The `Flicker` and `FlickerMultiply` components are the core number display widgets:

**Responsibilities**:
- Display numbers during iteration with timed intervals
- Handle countdown notifications before starting
- Manage burning mode cycles (infinite iteration)
- Apply dynamic font sizing based on digit count (1-5 static, 6-9 scaled)
- Integrate with sound system for audio feedback

**State Integration**:
- Listens to StateProvider for button state changes
- Uses Timer for burning mode scheduling (2s answer display, 3s before next)
- Properly cleans up listeners and timers in dispose()

**Styling**:
- Uses Google Fonts (Gamja Flower) for handwritten feel
- Dynamic font sizing prevents overflow for large numbers
- Theme-aware text color via `ThemeSelector.getFlickerTextColor()`

### Internationalization Architecture

- Uses easy_localization with JSON translation files in `assets/translations/`
- Supports 9 languages: English (en), Korean (ko), Japanese (ja), Uzbek (uz), Burmese (my), French (fr), Arabic (ar), Indonesian (id), Chinese (zh)
- Fallback locale is English
- Translation keys follow hierarchical structure (e.g., `settings.speed`, `buttons.start`, `themePicker.default`)
- Language selector available in settings pages (tabs 1 and 3) with flag icons

**Important**: When adding or modifying UI text, ALL 9 language translations must be updated simultaneously. The Korean note at the end of this file emphasizes this requirement.

### Audio System Architecture

- Uses flutter_soloud for high-performance, low-latency audio playback
- Managed through `SoundOptionHandler` with reactive streams
- Platform-optimized audio formats:
  - Desktop/iOS: `beep_new.wav`
  - Android: `beep_new.ogg`
  - Countdown: `notify_compress.mp3`
- Global sound toggle with persistence via `OptionManager.setSoundBool()`

### Platform-Specific Features

**Windows Platform**:

- Window management via window_manager (minimum 1024x768, default 400x600)
- Custom error logging to `errors.txt` in current directory via FlutterError.onError handler
- ExitWatcher wrapper for proper app lifecycle management
- Windows-specific toolbar options (preset management, fast settings)
- SQLite database initialization required (sqflite_common_ffi)

**Android Platform**:

- Targets Android 15 (API 35, compileSDK 36) with 16KB page size compliance
- Package: com.kobbokkom.abacus_simple_anzan
- Kotlin-based MainActivity integration (Java 11 target)
- ProGuard enabled for release builds with resource shrinking
- MultiDex enabled
- Debug symbols: FULL level for Play Console crash diagnostics
- NDK filters: armeabi-v7a, arm64-v8a, x86_64

**iOS Platform**:

- Bundle ID: com.kobbokkom.abacussimpleanzan (iOS - 새로 출시 예정)

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
  - `option/` - Global app options (theme, sound, color palette)
- `lib/src/components/` - Reusable UI components (flickers, containers, dropdowns)
- `lib/src/dialog/` - Modal dialogs and popups
- `lib/src/model/` - Data models for presets and save data
- `lib/src/functions/` - Utility functions and business logic
- `lib/src/const/` - Constants and styling definitions

## Important Files

### Configuration

- `pubspec.yaml` - Dependencies and app metadata (version 4.0.7+67)
- `analysis_options.yaml` - Flutter linting configuration using flutter_lints
- `android/app/build.gradle` - Android build settings (API 35, 16KB page support)

### Assets & Localization

- `assets/icon.png` - Source icon for multi-platform generation
- `assets/icon_48.png` - Windows-specific icon (48x48)
- `assets/translations/` - JSON translation files (9 languages: en/ko/ja/uz/my/fr/ar/id/zh)
- `assets/beep_new.wav` - Desktop/iOS beep sound
- `assets/beep_new.ogg` - Android beep sound
- `assets/notify_compress.mp3` - Countdown notification sound
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
- `flutter_colorpicker: ^1.1.0` - Color selection widgets (BlockPicker for theme picker)
- `google_fonts: ^6.2.1` - Typography system (uses Gamja Flower for numbers)

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
- Automatic cycling with timers: 2s answer display → 3s delay → next problem
- Visual indicators (fire icon) and different button behaviors when active

### Preset System

- JSON serialization for preset configurations
- Cross-mode preset management with dedicated list dialogs
- Platform-specific fast-setting dialogs for quick configuration
- SQLite storage for Windows platform (preset.db in save/ directory)
- Two separate tables: `add_presets` for addition, `multiply_presets` for multiplication

### Navigation State Management

- Tab switching is blocked during active iterations (iterationStarted state)
- Automatic state reset to iterationNotStarted when switching tabs after completion
- 500ms delay after tab navigation for smooth transitions
- State checking occurs in `_onTap` method to prevent mid-calculation interruptions

### Theme Color Integration

When modifying theme-related features:

1. Color definitions go in `ThemeSelector.getPrimaryColor()` with separate light/dark values
2. Theme picker colors must match exactly in `theme_color_picker.dart` availableColors
3. Color-to-palette mapping in `main.dart` _updateThemeColor() must be synchronized
4. Special text color handling for flicker components uses `ThemeSelector.getFlickerTextColor()`

문구 수정 시 반드시 모든 언어 번역에 대해 진행할 것.
