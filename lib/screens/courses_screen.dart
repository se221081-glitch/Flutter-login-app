import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/course_controller.dart';
import '../models/course.dart';
import '../utils/app_theme.dart';

/// Courses Screen - Displays CRUD operations for courses from JSONPlaceholder API
class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late final CourseController _courseController;
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;

  @override
  void initState() {
    super.initState();
    _courseController = CourseController();
    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    // Fetch courses on screen load
    _courseController.fetchCourses();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _courseController.dispose();
    super.dispose();
  }

  /// Show add course dialog
  void _showAddCourseDialog() {
    _titleController.clear();
    _bodyController.clear();
    _courseController.clearSelectedCourse();

    showDialog(
      context: context,
      builder: (context) => _buildCourseDialog(
        isEdit: false,
        onSubmit: _handleAddCourse,
      ),
    );
  }

  /// Show edit course dialog
  void _showEditCourseDialog(Course course) {
    _titleController.text = course.title;
    _bodyController.text = course.body;
    _courseController.selectCourse(course);

    showDialog(
      context: context,
      builder: (context) => _buildCourseDialog(
        isEdit: true,
        onSubmit: _handleEditCourse,
      ),
    );
  }

  /// Handle add course submission
  Future<void> _handleAddCourse() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    Navigator.pop(context);

    final success = await _courseController.createCourse(
      title: _titleController.text,
      body: _bodyController.text,
    );

    if (success && mounted) {
      _showSuccessSnackBar('Course created successfully');
    } else if (mounted) {
      _showErrorSnackBar(_courseController.errorMessage ?? 'Failed to create course');
    }
  }

  /// Handle edit course submission
  Future<void> _handleEditCourse() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      _showErrorSnackBar('Please fill in all fields');
      return;
    }

    final course = _courseController.selectedCourse;
    if (course == null) return;

    Navigator.pop(context);

    final success = await _courseController.updateCourse(
      id: course.id,
      title: _titleController.text,
      body: _bodyController.text,
    );

    if (success && mounted) {
      _showSuccessSnackBar('Course updated successfully');
    } else if (mounted) {
      _showErrorSnackBar(_courseController.errorMessage ?? 'Failed to update course');
    }
  }

  /// Handle delete course
  Future<void> _handleDeleteCourse(int courseId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Course'),
        content: const Text('Are you sure you want to delete this course?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      final success = await _courseController.deleteCourse(courseId);
      if (success && mounted) {
        _showSuccessSnackBar('Course deleted successfully');
      } else if (mounted) {
        _showErrorSnackBar(_courseController.errorMessage ?? 'Failed to delete course');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.olive,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.error,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  /// Build course dialog (add/edit)
  Widget _buildCourseDialog({
    required bool isEdit,
    required VoidCallback onSubmit,
  }) {
    return AlertDialog(
      title: Text(isEdit ? 'Edit Course' : 'Add New Course'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Course Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.terracotta),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(
                hintText: 'Course Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: AppTheme.terracotta),
                ),
              ),
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.terracotta,
          ),
          child: Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _courseController,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Courses'),
          backgroundColor: AppTheme.earthDark,
          foregroundColor: AppTheme.cream,
          elevation: 2,
        ),
        body: Container(
          color: AppTheme.cream,
          child: Consumer<CourseController>(
            builder: (context, controller, child) {
              // Loading state
              if (controller.isLoading && controller.courses.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.terracotta,
                  ),
                );
              }

              // Error state
              if (controller.state == ApiState.error &&
                  controller.courses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: AppTheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage ?? 'Failed to load courses',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppTheme.ink),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: controller.fetchCourses,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.terracotta,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              // Empty state
              if (controller.courses.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.folder_open_outlined,
                        size: 48,
                        color: AppTheme.muted,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No courses available',
                        style: TextStyle(color: AppTheme.ink, fontSize: 16),
                      ),
                    ],
                  ),
                );
              }

              // Courses list
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.courses.length,
                itemBuilder: (context, index) {
                  final course = controller.courses[index];
                  return _buildCourseCard(course);
                },
              );
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddCourseDialog,
          backgroundColor: AppTheme.terracotta,
          foregroundColor: Colors.white,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  /// Build course card widget
  Widget _buildCourseCard(Course course) {
    return Card(
      color: AppTheme.cream,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.sand, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ID: ${course.id}',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppTheme.muted,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.ink,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              course.body,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.muted,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: AppTheme.olive),
                  onPressed: () => _showEditCourseDialog(course),
                  tooltip: 'Edit',
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: AppTheme.error),
                  onPressed: () => _handleDeleteCourse(course.id),
                  tooltip: 'Delete',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
