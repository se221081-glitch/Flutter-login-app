/// Custom validator class for comprehensive form validation
class Validator {
  /// Validates email format
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates password strength
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }

    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least 1 uppercase letter';
    }

    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least 1 special character';
    }

    return null;
  }

  /// Validates if password field is not empty
  static String? validatePasswordNotEmpty(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  /// Validates if full name is not empty
  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }

    if (value.length < 3) {
      return 'Full name must be at least 3 characters';
    }

    return null;
  }

  /// Validates if gender is selected (for string value)
  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a gender';
    }
    return null;
  }

  /// Validates if gender enum is selected
  static String? validateGenderEnum(dynamic value) {
    if (value == null) {
      return 'Please select a gender';
    }
    return null;
  }

  /// Validates if passwords match
  static String? validatePasswordMatch(
    String password,
    String confirmPassword,
  ) {
    if (password != confirmPassword) {
      return 'Passwords do not match';
    }
    return null;
  }
}
