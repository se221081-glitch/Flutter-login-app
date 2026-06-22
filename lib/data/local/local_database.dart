import 'package:hive_flutter/hive_flutter.dart';
import '../../models/course.dart';

/// Local database service using Hive for offline storage
/// 
/// This service handles all local storage operations for courses data
/// enabling offline-first functionality
class LocalDatabase {
  static const String _boxName = 'courses_box';
  static final LocalDatabase _instance = LocalDatabase._internal();

  late Box<Course> _coursesBox;

  LocalDatabase._internal();

  factory LocalDatabase() {
    return _instance;
  }

  /// Initialize the local database
  /// Must be called before using any database operations
  Future<void> initialize() async {
    await Hive.initFlutter();
    
    // Register the Course adapter if not already registered
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(CourseAdapter());
    }
    
    _coursesBox = await Hive.openBox<Course>(_boxName);
  }

  /// Check if database is initialized
  bool get isInitialized => Hive.isBoxOpen(_boxName);

  /// Save courses to local storage
  Future<void> saveCourses(List<Course> courses) async {
    try {
      // Clear existing courses
      await _coursesBox.clear();
      
      // Save all courses with their ID as key
      for (int i = 0; i < courses.length; i++) {
        await _coursesBox.put(i, courses[i]);
      }
    } catch (e) {
      throw Exception('Failed to save courses: $e');
    }
  }

  /// Get all courses from local storage
  Future<List<Course>> getAllCourses() async {
    try {
      return _coursesBox.values.toList();
    } catch (e) {
      throw Exception('Failed to get courses: $e');
    }
  }

  /// Save a single course
  Future<void> saveCourse(Course course) async {
    try {
      await _coursesBox.put(course.id, course);
    } catch (e) {
      throw Exception('Failed to save course: $e');
    }
  }

  /// Get a specific course by ID
  Future<Course?> getCourseById(int id) async {
    try {
      return _coursesBox.get(id);
    } catch (e) {
      throw Exception('Failed to get course: $e');
    }
  }

  /// Delete a course from local storage
  Future<void> deleteCourse(int id) async {
    try {
      await _coursesBox.delete(id);
    } catch (e) {
      throw Exception('Failed to delete course: $e');
    }
  }

  /// Delete all courses from local storage
  Future<void> deleteAllCourses() async {
    try {
      await _coursesBox.clear();
    } catch (e) {
      throw Exception('Failed to delete all courses: $e');
    }
  }

  /// Update a course in local storage
  Future<void> updateCourse(Course course) async {
    try {
      await _coursesBox.put(course.id, course);
    } catch (e) {
      throw Exception('Failed to update course: $e');
    }
  }

  /// Get the count of courses in local storage
  Future<int> getCoursesCount() async {
    try {
      return _coursesBox.length;
    } catch (e) {
      throw Exception('Failed to get courses count: $e');
    }
  }

  /// Close the database
  Future<void> close() async {
    await _coursesBox.close();
  }
}
