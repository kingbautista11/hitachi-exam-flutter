# Security Notes

Summary of the security controls in this app and how to configure it safely.

## Configuration / secrets

The API client id and base URL are **not hardcoded**. They are injected at
build time via `--dart-define` and centralized in `lib/config.dart`:

```bash
flutter run \
  --dart-define=CLIENT_ID=<client_id> \
  --dart-define=API_BASE_URL=https://indexcodex.com/api/v1

flutter build apk --release \
  --dart-define=CLIENT_ID=<client_id> \
  --dart-define=API_BASE_URL=https://indexcodex.com/api/v1
```

Defaults are provided for the assessment environment so local runs work without
flags.

## Controls in place

| Area | Control |
|------|---------|
| Screen capture | `FLAG_SECURE` on release builds — blocks screenshots, screen recording, and app-switcher preview of PIN/account data (`MainActivity.kt`). |
| Transport | HTTPS enforced in code (`ApiService`) and at the platform level — cleartext disabled via `network_security_config.xml` and `usesCleartextTraffic="false"`. |
| Data at rest | `allowBackup="false"` and `fullBackupContent="false"` prevent extraction via device/cloud backups. |
| Sensitive data | PIN/OTP held only transiently in memory; never persisted or logged. Numeric-only PIN input; alphanumeric-validated username. |
| Error handling | Network/parse errors are wrapped in `ApiException` with user-safe messages; raw server responses are never surfaced. |
| Network resiliency | 20s request timeouts to avoid hung connections. |
| In-app WebView | Navigation restricted to `https` only; blocks `javascript:`, `file:`, `intent:`, and cleartext redirects. |

## Known limitations / next steps

- **Client id in the binary:** any secret shipped in a mobile app is
  extractable. `--dart-define` keeps it out of source control, but a
  production fintech app should proxy privileged calls through a backend and
  never embed long-lived secrets client-side.
- **Certificate pinning** is not implemented (it requires the server's pin and
  must be rotated with the cert). It is the recommended next hardening step to
  defend against a compromised CA.
