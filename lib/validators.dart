// Pure validation/parsing helpers, kept separate from the widgets so they
// can be unit-tested in isolation.

/// Returns the error message for an invalid username, or null when valid.
/// Rules (from the exam spec): required, max 24 chars, alphanumeric only.
String? usernameError(String value) {
  if (value.isEmpty) return 'please enter your username';
  if (value.length > 24) return 'Must not exceed 24 characters';
  if (RegExp(r'[^a-zA-Z0-9]').hasMatch(value)) return 'Values must be alphanumeric';
  return null;
}

/// Whether a login API response represents a successful login.
bool isLoginSuccess(Map<String, dynamic> result) {
  return result['loginStatus'] == 'success' ||
      result['status'] == true ||
      result['success'] == true;
}
