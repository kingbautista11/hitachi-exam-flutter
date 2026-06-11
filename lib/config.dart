/// Build-time configuration. Values are injected with `--dart-define` so the
/// client id and endpoint are never hardcoded in source control, e.g.:
///
///   flutter run --dart-define=CLIENT_ID=xxx --dart-define=API_BASE_URL=https://...
///
/// Defaults match the assessment environment for local runs.
class AppConfig {
  const AppConfig._();

  static const String clientId =
      String.fromEnvironment('CLIENT_ID', defaultValue: 'rgbexam');

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://indexcodex.com/api/v1',
  );

  static const Duration apiTimeout = Duration(seconds: 20);
}
