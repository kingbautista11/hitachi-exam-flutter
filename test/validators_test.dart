import 'package:flutter_test/flutter_test.dart';
import 'package:hitachi_exam/validators.dart';

void main() {
  group('usernameError', () {
    test('returns prompt when empty', () {
      expect(usernameError(''), 'please enter your username');
    });

    test('returns length error when over 24 characters', () {
      expect(usernameError('a' * 25), 'Must not exceed 24 characters');
    });

    test('accepts exactly 24 characters', () {
      expect(usernameError('a' * 24), isNull);
    });

    test('returns alphanumeric error for special characters', () {
      expect(usernameError('user_name'), 'Values must be alphanumeric');
    });

    test('accepts letters and numbers', () {
      expect(usernameError('user123'), isNull);
    });
  });

  group('isLoginSuccess', () {
    test('true when loginStatus is success', () {
      expect(isLoginSuccess({'loginStatus': 'success'}), isTrue);
    });

    test('false when loginStatus is not success', () {
      expect(isLoginSuccess({'loginStatus': 'failed'}), isFalse);
    });

    test('false for an error payload', () {
      expect(isLoginSuccess({'error': 'invalid otp'}), isFalse);
    });
  });
}
