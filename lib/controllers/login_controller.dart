import 'package:flutter/material.dart';
import '../enums/enums.dart';
import '../models/user.dart';

/// Controller for managing login screen logic and state
class LoginController with ChangeNotifier {
  // State variables
  AuthState _authState = AuthState.initial;
  String? _errorMessage;
  bool _rememberMe = false;
  bool _passwordVisible = false;
  User? _authenticatedUser;

  // Getters
  AuthState get authState => _authState;
  String? get errorMessage => _errorMessage;
  bool get rememberMe => _rememberMe;
  bool get passwordVisible => _passwordVisible;
  User? get authenticatedUser => _authenticatedUser;

  /// Initialize controller with saved credentials if remember me was enabled
  LoginController() {
    _loadSavedCredentials();
  }

  /// Load saved credentials from local storage (simulated)
  void _loadSavedCredentials() {
    // TODO: Implement savedCredentials retrieval from local storage
    // For now, this is a placeholder
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  /// Toggle remember me checkbox
  void toggleRememberMe(bool value) {
    _rememberMe = value;
    notifyListeners();
  }

  /// Handle login action
  Future<bool> login(String email, String password) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Basic authentication validation (in real app, call backend)
      if (email.isEmpty || password.isEmpty) {
        _authState = AuthState.error;
        _errorMessage = 'Email and password are required';
        notifyListeners();
        return false;
      }

      // Simulate successful login and create user object
      _authenticatedUser = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        fullName: _extractNameFromEmail(email),
        email: email,
        gender: null,
        loginTime: DateTime.now(),
      );

      _authState = AuthState.authenticated;

      if (_rememberMe) {
        _saveCredentials(email, password);
      }

      notifyListeners();
      return true;
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = 'Login failed: $e';
      notifyListeners();
      return false;
    }
  }

  /// Extract a display name from email (simulated)
  String _extractNameFromEmail(String email) {
    final parts = email.split('@');
    final namePart = parts[0].replaceAll('.', ' ').replaceAll('_', ' ');
    return namePart
        .split(' ')
        .map((word) {
          return word.isNotEmpty
              ? word[0].toUpperCase() + word.substring(1)
              : '';
        })
        .join(' ');
  }

  /// Save credentials locally (simulated)
  void _saveCredentials(String email, String password) {
    // TODO: Implement secure credential storage
    // This could use flutter_secure_storage or similar
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Reset controller state
  void resetState() {
    _authState = AuthState.initial;
    _errorMessage = null;
    _passwordVisible = false;
    _authenticatedUser = null;
    notifyListeners();
  }
}
