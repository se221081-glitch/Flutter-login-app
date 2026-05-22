import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/course.dart';

/// Service class for handling all API calls to JSONPlaceholder
/// 
/// Documentation: https://jsonplaceholder.typicode.com/guide
class ApiService {
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';
  static const String _coursesEndpoint = '$_baseUrl/posts';
  static const Duration _timeout = Duration(seconds: 10);

  /// Fetch all courses from the API
  /// 
  /// Returns a list of Course objects from the /posts endpoint
  /// Note: JSONPlaceholder uses /posts as course data
  static Future<List<Course>> fetchCourses() async {
    try {
      final response = await http
          .get(Uri.parse(_coursesEndpoint))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList
            .map((json) => Course.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to fetch courses. Status: ${response.statusCode}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: $e');
    } catch (e) {
      throw Exception('Error fetching courses: $e');
    }
  }

  /// Fetch a single course by ID
  static Future<Course> fetchCourseById(int id) async {
    try {
      final response = await http
          .get(Uri.parse('$_coursesEndpoint/$id'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Course.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to fetch course. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching course: $e');
    }
  }

  /// Create a new course via POST request
  /// 
  /// Sends course data to the API and returns the created course
  /// Note: JSONPlaceholder returns a mock response with ID
  static Future<Course> createCourse({
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final requestBody = {
        'title': title,
        'body': body,
        'userId': userId,
      };

      final response = await http
          .post(
            Uri.parse(_coursesEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(_timeout);

      if (response.statusCode == 201) {
        return Course.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to create course. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error creating course: $e');
    }
  }

  /// Update an existing course via PUT request
  /// 
  /// Sends updated course data to the API
  static Future<Course> updateCourse({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) async {
    try {
      final requestBody = {
        'id': id,
        'title': title,
        'body': body,
        'userId': userId,
      };

      final response = await http
          .put(
            Uri.parse('$_coursesEndpoint/$id'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return Course.fromJson(jsonDecode(response.body));
      } else {
        throw Exception(
          'Failed to update course. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error updating course: $e');
    }
  }

  /// Delete a course via DELETE request
  /// 
  /// Removes a course from the API
  /// Returns true if deletion was successful
  static Future<bool> deleteCourse(int id) async {
    try {
      final response = await http
          .delete(Uri.parse('$_coursesEndpoint/$id'))
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception(
          'Failed to delete course. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error deleting course: $e');
    }
  }
}
