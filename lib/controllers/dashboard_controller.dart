import 'package:flutter/material.dart';
import '../models/user.dart';

/// Controller for managing dashboard screen logic and user session
class DashboardController with ChangeNotifier {
  final User user;
  bool _isLogoutLoading = false;

  DashboardController(this.user);

  bool get isLogoutLoading => _isLogoutLoading;

  /// Handle logout action
  Future<bool> logout() async {
    _isLogoutLoading = true;
    notifyListeners();

    try {
      // Simulate logout delay
      await Future.delayed(const Duration(seconds: 1));

      _isLogoutLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLogoutLoading = false;
      notifyListeners();
      return false;
    }
  }
}
