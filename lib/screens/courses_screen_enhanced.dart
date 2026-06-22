import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/course_provider.dart';
import '../models/course.dart';
import '../utils/app_theme.dart';
import '../data/repositories/course_repository.dart';
import '../data/remote/remote_api_service.dart';
import '../data/local/local_database.dart';
import '../services/connectivity_service.dart';

/// Enhanced Courses Screen with Offline Support, Search, and UX Improvements
/// 
/// Features:
/// - Pull-to-refresh functionality
/// - Search and filter capabilities
/// - Optimistic UI updates
/// - Empty state handling
/// - Loading indicators
/// - Offline/Online status indicator
class CoursesScreenEnhanced extends StatefulWidget {
  const CoursesScreenEnhanced({super.key});

  @override
  State<CoursesScreenEnhanced> createState() => _CoursesScreenEnhancedState();
}

class _CoursesScreenEnhancedState extends State<CoursesScreenEnhanced> {
  late final CourseController _courseController;
  late final TextEditingController _titleController;
  late final TextEditingController _bodyController;
  late final TextEditingController _searchController;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
    _listenToConnectivity();
  }

  /// Initialize the course controller with repository dependencies
  void _initializeController() async {
    final repository = CourseRepository(
      remoteApiService: RemoteApiService(),
      localDatabase: LocalDatabase(),
      connectivityService: ConnectivityService(),
    );

    _courseController = CourseController(repository: repository);
    await _courseController.initialize();

    // Fetch courses on screen load
    if (mounted) {
      _courseController.fetchCourses();
    }

    _titleController = TextEditingController();
    _bodyController = TextEditingController();
    _searchController = TextEditingController();
  }

  /// Listen to connectivity changes
  void _listenToConnectivity() {
    ConnectivityService().connectivityStream.listen((isOnline) {
      if (mounted) {
        _courseController.setOnlineStatus(isOnline);
        if (isOnline) {
          // Optionally refresh when coming online
          _showSnackBar(
            'You are back online',
            backgroundColor: Colors.green,
          );
        } else {
          _showSnackBar(
            'You are offline - using cached data',
            backgroundColor: Colors.orange,
          );
        }
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _searchController.dispose();
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
      _showSnackBar('Please fill in all fields');
      return;
    }

    Navigator.pop(context);

    final success = await _courseController.createCourse(
      title: _titleController.text,
      body: _bodyController.text,
    );

    if (success && mounted) {
      _showSnackBar(
        'Course created successfully',
        backgroundColor: Colors.green,
      );
    } else if (mounted) {
      _showSnackBar(
        _courseController.errorMessage ?? 'Failed to create course',
        backgroundColor: AppTheme.error,
      );
    }
  }

  /// Handle edit course submission
  Future<void> _handleEditCourse() async {
    if (_titleController.text.isEmpty || _bodyController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
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
      _showSnackBar(
        'Course updated successfully',
        backgroundColor: Colors.green,
      );
    } else if (mounted) {
      _showSnackBar(
        _courseController.errorMessage ?? 'Failed to update course',
        backgroundColor: AppTheme.error,
      );
    }
  }

  /// Handle delete course with confirmation
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
        _showSnackBar(
          'Course deleted successfully',
          backgroundColor: Colors.green,
        );
      } else if (mounted) {
        _showSnackBar(
          _courseController.errorMessage ?? 'Failed to delete course',
          backgroundColor: AppTheme.error,
        );
      }
    }
  }

  /// Show snackbar message
  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? AppTheme.olive,
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
          title: _isSearching
              ? TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search courses...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  onChanged: (value) {
                    _courseController.searchCourses(value);
                  },
                )
              : const Text('Courses'),
          backgroundColor: AppTheme.earthDark,
          foregroundColor: AppTheme.cream,
          elevation: 2,
          actions: [
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                setState(() {
                  if (_isSearching) {
                    _searchController.clear();
                    _courseController.clearSearch();
                    _isSearching = false;
                  } else {
                    _isSearching = true;
                  }
                });
              },
            ),
          ],
        ),
        body: Container(
          color: AppTheme.cream,
          child: Consumer<CourseController>(
            builder: (context, controller, child) {
              return RefreshIndicator(
                onRefresh: controller.refreshCourses,
                color: AppTheme.terracotta,
                child: _buildBody(controller),
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

  /// Build the main body content
  Widget _buildBody(CourseController controller) {
    // Loading state for initial load
    if (controller.isLoading && controller.courses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: AppTheme.terracotta,
            ),
            const SizedBox(height: 16),
            Text(
              'Loading courses...',
              style: TextStyle(
                color: AppTheme.muted,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    // Error state
    if (controller.state == ApiState.error && controller.courses.isEmpty) {
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                controller.errorMessage ?? 'Failed to load courses',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppTheme.ink,
                  fontSize: 16,
                ),
              ),
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
    if (controller.isEmpty) {
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
              style: TextStyle(
                color: AppTheme.ink,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: controller.fetchCourses,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.terracotta,
              ),
              child: const Text('Load Courses'),
            ),
          ],
        ),
      );
    }

    // Courses list with pull-to-refresh
    return Stack(
      children: [
        ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.courses.length,
          itemBuilder: (context, index) {
            final course = controller.courses[index];
            return _buildCourseCard(course, controller);
          },
        ),
        // Online/Offline indicator
        if (!controller.isOnline)
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.cloud_off, color: Colors.white, size: 16),
                  SizedBox(width: 8),
                  Text(
                    'Offline Mode - Using Cached Data',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// Build course card widget with actions
  Widget _buildCourseCard(Course course, CourseController controller) {
    final isLocalCourse = course.id < 0; // Negative IDs are local only

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
                      Row(
                        children: [
                          Text(
                            'ID: ${course.id}',
                            style: TextStyle(
                              fontSize: 12,
                              color: isLocalCourse ? Colors.orange : AppTheme.muted,
                              fontWeight: isLocalCourse ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          if (isLocalCourse)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Tooltip(
                                message: 'This course is stored locally and pending sync',
                                child: Icon(
                                  Icons.cloud_off,
                                  size: 14,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                        ],
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
