import 'package:hive/hive.dart';

part 'course.g.dart';

/// Model class to represent course data from JSONPlaceholder API
/// 
/// Annotated with @HiveType to enable Hive serialization for offline storage
@HiveType(typeId: 0)
class Course {
  @HiveField(0)
  final int id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String body;
  
  @HiveField(3)
  final int userId;

  Course({
    required this.id,
    required this.title,
    required this.body,
    required this.userId,
  });

  /// Factory constructor to create Course from JSON
  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int,
      title: json['title'] as String? ?? 'Untitled',
      body: json['body'] as String? ?? '',
      userId: json['userId'] as int? ?? 1,
    );
  }

  /// Convert Course to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'userId': userId,
    };
  }

  /// Create a copy of Course with modified fields
  Course copyWith({
    int? id,
    String? title,
    String? body,
    int? userId,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() =>
      'Course(id: $id, title: $title, userId: $userId)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Course &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          body == other.body &&
          userId == other.userId;

  @override
  int get hashCode =>
      id.hashCode ^ title.hashCode ^ body.hashCode ^ userId.hashCode;
}
