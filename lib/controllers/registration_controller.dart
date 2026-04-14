import 'package:flutter/material.dart';
import '../enums/enums.dart';

/// Controller for managing registration screen logic and state
class RegistrationController with ChangeNotifier {
  // State variables
  AuthState _authState = AuthState.initial;
  String? _errorMessage;
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  Gender? _selectedGender;

  // Getters
  AuthState get authState => _authState;
  String? get errorMessage => _errorMessage;
  bool get passwordVisible => _passwordVisible;
  bool get confirmPasswordVisible => _confirmPasswordVisible;
  Gender? get selectedGender => _selectedGender;

  /// Toggle password visibility
  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    _confirmPasswordVisible = !_confirmPasswordVisible;
    notifyListeners();
  }

  /// Set selected gender
  void setGender(Gender? gender) {
    _selectedGender = gender;
    notifyListeners();
  }

  /// Handle registration action
  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required String confirmPassword,
    required Gender? gender,
  }) async {
    _authState = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));

      // Validate all fields are filled
      if (fullName.isEmpty ||
          email.isEmpty ||
          password.isEmpty ||
          confirmPassword.isEmpty ||
          gender == null) {
        _authState = AuthState.error;
        _errorMessage = 'All fields are required';
        notifyListeners();
        return false;
      }

      // Validate passwords match
      if (password != confirmPassword) {
        _authState = AuthState.error;
        _errorMessage = 'Passwords do not match';
        notifyListeners();
        return false;
      }

      // Simulate successful registration
      // In a real app, you would send data to backend
      _authState = AuthState.authenticated;
      notifyListeners();
      return true;
    } catch (e) {
      _authState = AuthState.error;
      _errorMessage = 'Registration failed: $e';
      notifyListeners();
      return false;
    }
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
    _confirmPasswordVisible = false;
    _selectedGender = null;
    notifyListeners();
  }
}
