import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/dashboard_controller.dart';
import '../models/user.dart';
import 'login_screen.dart';

/// Dashboard Screen - Protected screen showing user information and subjects
class DashboardScreen extends StatefulWidget {
  final User user;

  const DashboardScreen({super.key, required this.user});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final DashboardController _dashboardController;

  // Sample subjects data
  final List<Map<String, String>> subjects = [
    {
      'name': 'Mobile App Development',
      'icon': '📱',
      'description': 'Learn Flutter and Dart',
    },
    {
      'name': 'Software Re-engineering',
      'icon': '⚙️',
      'description': 'Code optimization and refactoring',
    },
    {
      'name': 'Management Information Systems',
      'icon': '💼',
      'description': 'Enterprise systems and databases',
    },
  ];

  @override
  void initState() {
    super.initState();
    _dashboardController = DashboardController(widget.user);
  }

  @override
  void dispose() {
    _dashboardController.dispose();
    super.dispose();
  }

  /// Handle logout action
  Future<void> _handleLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirmed ?? false) {
      final success = await _dashboardController.logout();

      if (success && mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _dashboardController,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade900, Colors.blue.shade800],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildUserCard(),
                  const SizedBox(height: 40),
                  _buildSubjectsSection(),
                  const SizedBox(height: 30),
                  _buildLogoutButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build header with title
  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back, ${widget.user.fullName}!',
          style: const TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ],
    );
  }

  /// Build user information card
  Widget _buildUserCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    _getInitials(widget.user.fullName),
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.user.fullName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.user.email,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildUserInfoRow('Gender', widget.user.gender ?? 'Not specified'),
          const SizedBox(height: 16),
          _buildUserInfoRow('Login Time', _formatTime(widget.user.loginTime)),
        ],
      ),
    );
  }

  /// Build individual user info row
  Widget _buildUserInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// Build subjects section
  Widget _buildSubjectsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Subjects',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: subjects.length,
          itemBuilder: (context, index) {
            final subject = subjects[index];
            return _buildSubjectCard(subject);
          },
        ),
      ],
    );
  }

  /// Build individual subject card
  Widget _buildSubjectCard(Map<String, String> subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // TODO: Navigate to detail screen with subject data
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening ${subject['name']}...')),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text(
                  subject['icon'] ?? '',
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject['name'] ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subject['description'] ?? '',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Build logout button
  Widget _buildLogoutButton() {
    return Consumer<DashboardController>(
      builder: (context, controller, child) {
        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.isLogoutLoading ? null : _handleLogout,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              disabledBackgroundColor: Colors.grey.shade300,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLogoutLoading
                ? SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      },
    );
  }

  /// Get initials from full name
  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  /// Format time to readable format
  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final loginDay = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (today == loginDay) {
      return 'Today at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    } else {
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    }
  }
}
