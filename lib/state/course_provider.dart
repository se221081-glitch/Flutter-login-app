import 'package:flutter/material.dart';
import '../models/course.dart';
import '../data/repositories/course_repository.dart';

/// Enum for tracking API operation states with more granular control
enum ApiState { initial, loading, success, error, empty }

/// Enhanced Course Controller with Repository Pattern & Offline Support
/// 
/// This controller manages all course-related state and operations using the repository pattern.
/// It provides:
/// - Clean separation between UI and business logic
/// - Offline-first data management
/// - Optimistic UI updates
/// - Comprehensive error handling
/// - Search and filter capabilities
/// 
/// Architecture: UI → Controller (ChangeNotifier) → Repository → (API / Local DB)
class CourseController extends ChangeNotifier {
  final CourseRepository _repository;

  // State variables
  ApiState _state = ApiState.initial;
  List<Course> _courses = [];
  List<Course> _filteredCourses = [];
  String? _errorMessage;
  Course? _selectedCourse;
  bool _isLoading = false;
  bool _isOnline = true;
  String _searchQuery = '';

  // Getters
  ApiState get state => _state;
  List<Course> get courses => _filteredCourses.isEmpty ? _courses : _filteredCourses;
  List<Course> get allCourses => _courses;
  String? get errorMessage => _errorMessage;
  Course? get selectedCourse => _selectedCourse;
  bool get isLoading => _isLoading;
  bool get isOnline => _isOnline;
  String get searchQuery => _searchQuery;
  bool get isEmpty => _courses.isEmpty && _state == ApiState.success;

  CourseController({required CourseRepository repository})
      : _repository = repository;

  /// Initialize the controller
  /// 
  /// Must be called before using the controller
  Future<void> initialize() async {
    await _repository.initialize();
  }

  /// Fetch all courses with offline support
  /// 
  /// - Attempts API call if online
  /// - Falls back to local storage if offline or on failure
  /// - Caches successful API responses locally
  Future<void> fetchCourses() async {
    _state = ApiState.loading;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();
      
      // Limit to first 10 courses for better performance
      if (_courses.length > 10) {
        _courses = _courses.sublist(0, 10);
      }

      _state = _courses.isEmpty ? ApiState.empty : ApiState.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ApiState.error;
    } finally {
      _isLoading = false;
      _filteredCourses = [];
      notifyListeners();
    }
  }

  /// Refresh courses from the API
  /// 
  /// This is typically called by pull-to-refresh
  Future<void> refreshCourses() async {
    _errorMessage = null;
    notifyListeners();

    try {
      _courses = await _repository.getCourses();

      if (_courses.length > 10) {
        _courses = _courses.sublist(0, 10);
      }

      _state = _courses.isEmpty ? ApiState.empty : ApiState.success;
    } catch (e) {
      _errorMessage = 'Failed to refresh: ${e.toString().replaceFirst('Exception: ', '')}';
      _state = ApiState.error;
    } finally {
      _filteredCourses = [];
      notifyListeners();
    }
  }

  /// Create a new course with optimistic update
  /// 
  /// - Updates UI immediately (optimistic)
  /// - Syncs with API in background
  /// - Handles offline creation with local sync marker
  Future<bool> createCourse({
    required String title,
    required String body,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final newCourse = await _repository.createCourse(
        title: title,
        body: body,
      );

      // Optimistic update: add to the beginning of the list
      _courses.insert(0, newCourse);
      _state = ApiState.success;
      _isLoading = false;
      _filteredCourses = [];
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

  /// Update an existing course with optimistic update
  /// 
  /// - Updates local storage immediately (optimistic)
  /// - Syncs with API in background
  /// - Rolls back on failure
  Future<bool> updateCourse({
    required int id,
    required String title,
    required String body,
  }) async {
    _isLoading = true;
    _errorMessage = null;

    // Store original for potential rollback
    final index = _courses.indexWhere((c) => c.id == id);
    final originalCourse = index != -1 ? _courses[index] : null;

    // Optimistic update
    if (index != -1) {
      _courses[index] = Course(
        id: id,
        title: title,
        body: body,
        userId: _courses[index].userId,
      );
    }

    notifyListeners();

    try {
      final updatedCourse = await _repository.updateCourse(
        id: id,
        title: title,
        body: body,
      );

      // Update with confirmed response
      if (index != -1) {
        _courses[index] = updatedCourse;
      }

      _state = ApiState.success;
      _isLoading = false;
      _filteredCourses = [];
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ApiState.error;

      // Rollback on failure
      if (index != -1 && originalCourse != null) {
        _courses[index] = originalCourse;
      }

      _isLoading = false;
      _filteredCourses = [];
      notifyListeners();
      return false;
    }
  }

  /// Delete a course with optimistic delete
  /// 
  /// - Removes from UI immediately (optimistic)
  /// - Syncs delete with API in background
  /// - Rolls back on failure
  Future<bool> deleteCourse(int id) async {
    _isLoading = true;
    _errorMessage = null;

    // Store original for potential rollback
    final index = _courses.indexWhere((c) => c.id == id);
    final deletedCourse = index != -1 ? _courses[index] : null;

    // Optimistic delete
    if (index != -1) {
      _courses.removeAt(index);
    }

    notifyListeners();

    try {
      await _repository.deleteCourse(id);

      _state = _courses.isEmpty ? ApiState.empty : ApiState.success;
      _isLoading = false;
      _filteredCourses = [];
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ApiState.error;

      // Rollback on failure
      if (deletedCourse != null) {
        _courses.insert(index ?? 0, deletedCourse);
      }

      _isLoading = false;
      _filteredCourses = [];
      notifyListeners();
      return false;
    }
  }

  /// Search courses by title or body
  /// 
  /// Filters the current cached courses list
  Future<void> searchCourses(String query) async {
    _searchQuery = query;

    if (query.isEmpty) {
      _filteredCourses = [];
    } else {
      try {
        _filteredCourses = await _repository.searchCourses(query);
      } catch (e) {
        _errorMessage = 'Search failed: ${e.toString().replaceFirst('Exception: ', '')}';
        _filteredCourses = [];
      }
    }

    notifyListeners();
  }

  /// Clear search query
  void clearSearch() {
    _searchQuery = '';
    _filteredCourses = [];
    notifyListeners();
  }

  /// Get courses filtered by user ID
  Future<void> getCoursesByUserId(int userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _courses = await _repository.getCoursesByUserId(userId);
      _state = _courses.isEmpty ? ApiState.empty : ApiState.success;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _state = ApiState.error;
    } finally {
      _isLoading = false;
      _filteredCourses = [];
      notifyListeners();
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

  /// Clear all cached data
  Future<void> clearCache() async {
    try {
      await _repository.clearCache();
      _courses = [];
      _filteredCourses = [];
      _state = ApiState.initial;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear cache: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Set online status
  void setOnlineStatus(bool status) {
    _isOnline = status;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
