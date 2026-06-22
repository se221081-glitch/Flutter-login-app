import '../../models/course.dart';
import '../local/local_database.dart';
import '../remote/remote_api_service.dart';
import '../../services/connectivity_service.dart';

/// Course Repository implementing the repository pattern
/// 
/// This repository acts as a data layer abstraction that decides between
/// fetching data from the API or local storage based on connectivity.
/// 
/// Architecture Flow: UI → State Management → Repository → (API / Local DB)
class CourseRepository {
  final RemoteApiService _remoteApiService;
  final LocalDatabase _localDatabase;
  final ConnectivityService _connectivityService;

  CourseRepository({
    required RemoteApiService remoteApiService,
    required LocalDatabase localDatabase,
    required ConnectivityService connectivityService,
  })  : _remoteApiService = remoteApiService,
        _localDatabase = localDatabase,
        _connectivityService = connectivityService;

  /// Fetch all courses with offline support
  /// 
  /// First attempts to fetch from API if online,
  /// then falls back to local storage if offline or on failure
  Future<List<Course>> getCourses() async {
    final hasInternet = await _connectivityService.hasInternetConnection();

    if (hasInternet) {
      try {
        final courses = await _remoteApiService.fetchCourses();
        // Cache the courses locally after successful API call
        await _localDatabase.saveCourses(courses);
        return courses;
      } catch (e) {
        // On API failure, try local storage
        try {
          return await _localDatabase.getAllCourses();
        } catch (_) {
          rethrow;
        }
      }
    } else {
      // Offline mode: load from local storage
      return await _localDatabase.getAllCourses();
    }
  }

  /// Get a single course by ID
  /// 
  /// Attempts API first if online, falls back to local storage
  Future<Course> getCourseById(int id) async {
    final hasInternet = await _connectivityService.hasInternetConnection();

    if (hasInternet) {
      try {
        final course = await _remoteApiService.fetchCourseById(id);
        // Update local storage
        await _localDatabase.updateCourse(course);
        return course;
      } catch (e) {
        // Fall back to local storage
        final localCourse = await _localDatabase.getCourseById(id);
        if (localCourse != null) {
          return localCourse;
        }
        rethrow;
      }
    } else {
      // Offline mode
      final localCourse = await _localDatabase.getCourseById(id);
      if (localCourse != null) {
        return localCourse;
      }
      throw Exception('Course not found in local storage');
    }
  }

  /// Create a new course
  /// 
  /// Optimistic update: updates local storage immediately, then syncs with API
  Future<Course> createCourse({
    required String title,
    required String body,
  }) async {
    final hasInternet = await _connectivityService.hasInternetConnection();

    try {
      if (hasInternet) {
        // Attempt API call
        final course = await _remoteApiService.createCourse(
          title: title,
          body: body,
          userId: 1,
        );
        // Save to local storage
        await _localDatabase.saveCourse(course);
        return course;
      } else {
        // Offline mode: create locally with negative ID for sync later
        final localCourse = Course(
          id: -(DateTime.now().millisecondsSinceEpoch ~/ 1000),
          title: title,
          body: body,
          userId: 1,
        );
        await _localDatabase.saveCourse(localCourse);
        return localCourse;
      }
    } catch (e) {
      throw Exception('Failed to create course: $e');
    }
  }

  /// Update an existing course
  /// 
  /// Optimistic update: updates local storage immediately,
  /// then syncs with API in the background
  Future<Course> updateCourse({
    required int id,
    required String title,
    required String body,
  }) async {
    final updatedCourse = Course(
      id: id,
      title: title,
      body: body,
      userId: 1,
    );

    // Optimistic update: update local storage immediately
    await _localDatabase.updateCourse(updatedCourse);

    final hasInternet = await _connectivityService.hasInternetConnection();

    if (hasInternet) {
      try {
        // Sync with API
        final apiCourse = await _remoteApiService.updateCourse(
          id: id,
          title: title,
          body: body,
          userId: 1,
        );
        // Update with API response
        await _localDatabase.updateCourse(apiCourse);
        return apiCourse;
      } catch (e) {
        throw Exception('Failed to sync update to server: $e');
      }
    } else {
      // Offline mode: local update is sufficient
      return updatedCourse;
    }
  }

  /// Delete a course
  /// 
  /// Optimistic delete: removes from local storage immediately,
  /// then syncs with API in the background
  Future<bool> deleteCourse(int id) async {
    // Optimistic delete: remove from local storage immediately
    await _localDatabase.deleteCourse(id);

    final hasInternet = await _connectivityService.hasInternetConnection();

    if (hasInternet) {
      try {
        // Sync delete with API
        return await _remoteApiService.deleteCourse(id);
      } catch (e) {
        throw Exception('Failed to sync deletion to server: $e');
      }
    } else {
      // Offline mode: local delete is sufficient
      return true;
    }
  }

  /// Search courses by title
  /// 
  /// Searches in the current cached courses
  Future<List<Course>> searchCourses(String query) async {
    final courses = await _localDatabase.getAllCourses();
    if (query.isEmpty) {
      return courses;
    }

    return courses
        .where((course) =>
            course.title.toLowerCase().contains(query.toLowerCase()) ||
            course.body.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  /// Get courses filtered by user ID
  Future<List<Course>> getCoursesByUserId(int userId) async {
    final courses = await _localDatabase.getAllCourses();
    return courses.where((course) => course.userId == userId).toList();
  }

  /// Clear all local cache
  Future<void> clearCache() async {
    await _localDatabase.deleteAllCourses();
  }

  /// Initialize the repository
  Future<void> initialize() async {
    if (!_localDatabase.isInitialized) {
      await _localDatabase.initialize();
    }
  }
}
