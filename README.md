# Hitachi Mobile Exam — Flutter App

A Flutter application built for the front-end mobile assessment. It implements a
three-screen authentication and content flow against the provided REST API.

## Summary

The app walks the user through a complete login-to-content journey:

- **Splash** — an animated launch screen where three brand icons (YouTube,
  Spotify, Facebook) bob in a staggered wave, then transitions into login.
- **Screen 1 — Login** — a logo built from three separate icons, a username
  field with live validation (required, max 24 characters, alphanumeric, with
  center-aligned error prompts), and an "Enter" button that enables only when
  the input is valid. A valid username opens a "Verify It's You" modal for the
  6-digit PIN, with a numbers-only keypad, an Enter button that activates only
  when all six digits are entered, and a Close button that clears the PIN.
- **Screen 2 — Loading** — shows the login status ("Logging In"), calls the
  login endpoint, returns to Screen 1 with an error on rejection, or proceeds to
  Screen 3 on success.
- **Screen 3 — Home** — built entirely from API data: the user avatar, name, and
  id, plus a 2×2 grid of social icons. Tapping YouTube/Spotify/Facebook opens a
  detail page with the brand banner, description, and a "Visit" button that opens
  the site in an in-app browser. The fourth tile opens an auto-playing carousel
  of additional brands (Samsung, Apple, Windows) whose name and "Visit" button
  update per slide and open the brand site in an external browser. Tapping the
  avatar opens a logout action sheet which shows a "Logging Out" screen for three
  seconds before returning to the login screen.

**Tech:** Flutter (Material 3), `http`, `carousel_slider`, `url_launcher`,
`webview_flutter`, `cached_network_image`, `google_fonts`.

### Test accounts

- **Username:** any value (letters/numbers, up to 24 characters)
- **PIN / OTP:** `123456` or `123123`

## Security

This app handles authentication for a fintech context, so the following
controls are in place (see [`SECURITY.md`](SECURITY.md) for full detail):

- **Screenshot / screen-record protection** — `FLAG_SECURE` on release builds
  blocks screenshots, screen recording, and app-switcher previews of the PIN and
  account data.
- **Transport security** — HTTPS is enforced in code and at the platform level;
  cleartext (plain HTTP) traffic is disabled via a network security config.
- **No data at rest** — Android backups are disabled, and the PIN/OTP are held
  only transiently in memory — never persisted or logged.
- **Safe error handling** — network/parse errors are wrapped in user-safe
  messages so raw server responses are never exposed.
- **Hardened in-app browser** — WebView navigation is restricted to HTTPS only.
- **Externalised configuration** — the API client id and base URL are injected
  at build time with `--dart-define` rather than hardcoded in source.

## Performance

The app is built for fast startup and smooth navigation:

- **Ahead-of-time (release) builds** — release APKs are AOT-compiled with debug
  asserts stripped, the largest factor in real-device performance.
- **Cached network images** — the user avatar and brand banners use
  `cached_network_image`, so they load from disk on repeat views instead of
  re-downloading.
- **Isolated animations** — the splash wave is wrapped in a `RepaintBoundary`
  so its per-frame repaints don't dirty the rest of the screen.
- **Icon tree-shaking** — unused Material icon glyphs are stripped at build time
  (~99% font-asset reduction).
- **Const-heavy widget tree** — widgets are `const` wherever possible to
  minimize rebuilds, and pure logic (validation, parsing) is kept out of the
  build path.

## Getting started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) (3.x or newer)
- Android Studio / Android SDK (for Android builds), or Xcode (for iOS)
- A connected device or running emulator

Verify your setup:

```bash
flutter doctor
```

### Clone the repository

```bash
git clone https://github.com/kingbautista11/hitachi-exam-flutter.git
cd hitachi-exam-flutter
```

### Install dependencies

```bash
flutter pub get
```

### Run the app

With an emulator running or a device connected:

```bash
flutter run
```

To choose a specific device:

```bash
flutter devices            # list available devices
flutter run -d <device-id> # e.g. flutter run -d emulator-5554
```

To pass configuration explicitly (optional — sensible defaults are built in):

```bash
flutter run \
  --dart-define=CLIENT_ID=<client_id> \
  --dart-define=API_BASE_URL=https://indexcodex.com/api/v1
```

## Build an APK for a mobile device

Build a release APK:

```bash
flutter build apk --release
```

Or with explicit configuration:

```bash
flutter build apk --release \
  --dart-define=CLIENT_ID=<client_id> \
  --dart-define=API_BASE_URL=https://indexcodex.com/api/v1
```

The APK is written to:

```
build/app/outputs/flutter-apk/app-release.apk
```

### Install it on your phone

1. Transfer `app-release.apk` to the device (USB file transfer, email, or cloud
   storage).
2. On the phone, open the file and tap **Install**.
3. If prompted, allow installation from unknown sources.

The device needs an internet connection — the app calls the login/socials API
and loads images over the network.

> On some MIUI/Xiaomi devices, installing directly over USB requires enabling
> **Install via USB** in Developer options.

## Running tests

```bash
flutter test
```

## Project structure

```
lib/
  main.dart                      App entry point and theme
  config.dart                    Build-time configuration (--dart-define)
  theme.dart                     Brand colors, shadows, shared widgets
  validators.dart               Pure validation / login-parsing helpers
  services/
    api_service.dart             HTTPS-only API client
  screens/
    splash_screen.dart           Animated launch screen
    screen1_login.dart           Login + PIN modal
    screen2_loading.dart         Login status / loading
    screen3_home.dart            Home grid + logout
    social_detail_screen.dart    Social info + in-app browser launch
    brands_carousel_screen.dart  Auto-play brand carousel
    web_view_screen.dart         In-app browser
  widgets/
    loading_view.dart            Shared spinner + caption
    waving_logo.dart             Animated / static logo
test/
  validators_test.dart           Unit tests
  widget_test.dart               Widget tests
```
