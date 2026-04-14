/// Enum for gender selection
enum Gender {
  male('Male'),
  female('Female'),
  other('Other');

  final String displayName;

  const Gender(this.displayName);
}

/// Enum for authentication states
enum AuthState { initial, loading, authenticated, unauthenticated, error }

/// Enum for password visibility
enum PasswordVisibility { visible, hidden }
