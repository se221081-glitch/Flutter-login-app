import 'package:flutter/material.dart';
import '../models/course.dart';
import '../utils/api_service.dart';

/// Enum for tracking API operation states
enum ApiState { initial, loading, success, error }

/// Controller for managing course CRUD operations
/// 
/// Handles all business logic for courses including:
/// - Fetching courses from API
/// - Creating new courses
/// - Updating existing courses
/// - Deleting courses
/// - State management for UI updates
class CourseController extends ChangeNotifier {
  // State variables
  ApiState _state = ApiState.initial;
  List<Course> _courses = [];
  String? _errorMessage;
  Course? _selectedCourse;
  bool _isLoading = false;

  // Getters
  ApiState get state => _state;
  List<Course> get courses => _courses;
  String? get errorMessage => _errorMessage;
  Course? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;

  /// Fetch all courses from the API
  Future<void> fetchCourses() async {
    _state = ApiState.loading;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _courses = await ApiService.fetchCourses();
      // Limit to first 10 courses for better performance
      if (_courses.length > 10) {
        _courses = _courses.sublist(0, 10);
      }
      _state = ApiState.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ApiState.error;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create a new course
  Future<bool> createCourse({
    required String title,
    required String body,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCourse = await ApiService.createCourse(
        title: title,
        body: body,
        userId: 1, // Default user ID
      );
      
      // Add to the beginning of the list for UX
      _courses.insert(0, newCourse);
      _state = ApiState.success;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ApiState.error;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update an existing course
  Future<bool> updateCourse({
    required int id,
    required String title,
    required String body,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updatedCourse = await ApiService.updateCourse(
        id: id,
        title: title,
        body: body,
        userId: 1,
      );

      // Update in the list
      final index = _courses.indexWhere((c) => c.id == id);
      if (index != -1) {
        _courses[index] = updatedCourse;
      }

      _state = ApiState.success;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ApiState.error;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete a course
  Future<bool> deleteCourse(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final success = await ApiService.deleteCourse(id);
      
      if (success) {
        // Remove from the list
        _courses.removeWhere((c) => c.id == id);
        _state = ApiState.success;
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ApiState.error;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Set selected course for editing
  void selectCourse(Course course) {
    _selectedCourse = course;
    notifyListeners();
  }

  /// Clear selected course
  void clearSelectedCourse() {
    _selectedCourse = null;
    notifyListeners();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
