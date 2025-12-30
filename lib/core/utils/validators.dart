class Validators {
  static final RegExp _emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  static String? validateEmail(
    String? value, {
    String? emptyMessage,
    String? invalidMessage,
  }) {
    if (value == null || value.trim().isEmpty) {
      return emptyMessage ?? 'Email is required';
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return invalidMessage ?? 'Please enter a valid email';
    }
    return null;
  }

  static String? validatePassword(
    String? value, {
    String? emptyMessage,
    String? tooShortMessage,
    int minLength = 6,
  }) {
    if (value == null || value.isEmpty) {
      return emptyMessage ?? 'Password is required';
    }
    if (value.length < minLength) {
      return tooShortMessage ??
          'Password must be at least $minLength characters';
    }
    return null;
  }

  static String? validateConfirmPassword(
    String? value,
    String? originalPassword, {
    String? emptyMessage,
    String? mismatchMessage,
  }) {
    if (value == null || value.isEmpty) {
      return emptyMessage ?? 'Please confirm your password';
    }
    if (value != originalPassword) {
      return mismatchMessage ?? 'Passwords do not match';
    }
    return null;
  }

  static String? validateName(
    String? value, {
    String? emptyMessage,
    String? tooShortMessage,
    int minLength = 2,
  }) {
    if (value == null || value.trim().isEmpty) {
      return emptyMessage ?? 'Name is required';
    }
    if (value.trim().length < minLength) {
      return tooShortMessage ?? 'Name must be at least $minLength characters';
    }
    return null;
  }

  static String? validateRequired(String? value, {String? message}) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  }
}
