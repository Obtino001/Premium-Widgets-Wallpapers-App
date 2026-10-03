# FORM — Phase 1

An Android-first Flutter preview app for matching widgets, wallpapers, and complete home-screen themes. All content is local mock data. The working product name is centralized in `lib/core/design.dart`.

## Run

Install Flutter 3.47 or a compatible recent stable version and the Android SDK, then run:

```sh
flutter pub get
flutter run -d <android-device-id>
```

For an installable debug APK:

```sh
flutter build apk --debug
```

The APK is written to `build/app/outputs/flutter-apk/app-debug.apk`.

## Project structure

```text
lib/
  core/       Brand, design tokens, theme, persisted favorites
  data/       Local mock catalog
  models/     Theme, widget, wallpaper, category models
  screens/    Splash, onboarding, discovery, browse, saved, details
  widgets/    Phone preview, wallpaper art, item cards, shared controls
test/         Navigation and favorites flow tests
android/      Android host project and ivory launch background
```

## Phase 1 delivered

- Splash and three product-preview onboarding pages, shown once per install.
- Home discovery with a featured theme, category chips, widget previews, theme cards, and wallpaper discovery.
- Widgets and Wallpapers browse pages with category filtering.
- Theme, widget, and wallpaper detail pages with realistic local previews.
- Saved page with an empty state, filtering, and favorites persisted through SharedPreferences.
- Reusable phone preview, widget previews, generated wallpaper art, cards, chips, controls, and design tokens.
- Six themes, eight widgets, and nine generated wallpapers in the local catalog.

## Current limits

Apply Theme, Add Widget, and Set Wallpaper show informational sheets. They do not change the Android home screen or wallpaper in Phase 1. The wallpapers are generated shapes and gradients, and theme data is local. No backend, billing, ads, account system, analytics, or native home-screen widget service is included.

## Verify

```sh
flutter analyze
flutter test
flutter build apk --debug
```

On Windows, `android/gradle.properties` disables Kotlin incremental compilation because the project and Pub cache can be on separate drives; this prevents a Kotlin cache path error during Android builds.
