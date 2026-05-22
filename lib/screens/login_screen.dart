import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/login_controller.dart';
import '../enums/enums.dart';
import '../utils/validators.dart';
import 'registration_screen.dart';
import 'dashboard_screen.dart';
import '../utils/app_theme.dart';

/// Login Screen - Handles user authentication
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final LoginController _loginController;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _loginController = LoginController();
    _formKey = GlobalKey<FormState>();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _loginController.dispose();
    super.dispose();
  }

  /// Handle login button press
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await _loginController.login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (success && mounted) {
      final user = _loginController.authenticatedUser;
      if (user != null) {
        // Navigate to dashboard with user data
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => DashboardScreen(user: user)),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _loginController,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppTheme.earthDark, AppTheme.earthMid],
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 40),
                  // Rounded Container with Form
                  Container(
                    decoration: BoxDecoration(
                      color: AppTheme.cream,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.earthDark.withValues(alpha: 0.18),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildEmailField(),
                          const SizedBox(height: 20),
                          _buildPasswordField(),
                          const SizedBox(height: 16),
                          _buildRememberMeCheckbox(),
                          const SizedBox(height: 24),
                          _buildErrorMessage(),
                          _buildLoginButton(),
                          const SizedBox(height: 20),
                          _buildSignUpLink(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build header section with title and lock icon
  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.cream.withValues(alpha: 0.18),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_outline,
            size: 50,
            color: AppTheme.cream,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Login',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.cream,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Welcome back to your dashboard',
          style: TextStyle(fontSize: 14, color: AppTheme.sand),
        ),
      ],
    );
  }

  /// Build email input field
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          validator: Validator.validateEmail,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            hintText: 'Enter your email',
            prefixIcon: const Icon(Icons.email_outlined),
            prefixIconColor: AppTheme.muted,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.muted),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.sand),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.terracotta, width: 2),
            ),
            filled: true,
            fillColor: AppTheme.sand,
          ),
        ),
      ],
    );
  }

  /// Build password input field with toggle visibility
  Widget _buildPasswordField() {
    return Consumer<LoginController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _passwordController,
              validator: Validator.validatePasswordNotEmpty,
              obscureText: !controller.passwordVisible,
              decoration: InputDecoration(
                hintText: 'Enter your password',
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: AppTheme.muted,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.passwordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.muted),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.sand),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: AppTheme.terracotta, width: 2),
                ),
                filled: true,
                fillColor: AppTheme.sand,
              ),
            ),
          ],
        );
      },
    );
  }

  /// Build remember me checkbox
  Widget _buildRememberMeCheckbox() {
    return Consumer<LoginController>(
      builder: (context, controller, child) {
        return Row(
          children: [
            Checkbox(
              value: controller.rememberMe,
              onChanged: (value) {
                controller.toggleRememberMe(value ?? false);
              },
              activeColor: AppTheme.olive,
            ),
            const Text(
              'Remember me',
              style: TextStyle(fontSize: 14, color: AppTheme.ink),
            ),
          ],
        );
      },
    );
  }

  /// Build error message display
  Widget _buildErrorMessage() {
    return Consumer<LoginController>(
      builder: (context, controller, child) {
        if (controller.errorMessage != null) {
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.error.withValues(alpha: 0.12),
              border: Border.all(color: AppTheme.error.withValues(alpha: 0.6)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: AppTheme.error),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.errorMessage!,
                    style: const TextStyle(
                      color: AppTheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  /// Build login button
  Widget _buildLoginButton() {
    return Consumer<LoginController>(
      builder: (context, controller, child) {
        final isLoading = controller.authState == AuthState.loading;

        return ElevatedButton(
          onPressed: isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.terracotta,
            disabledBackgroundColor: AppTheme.sand,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Text(
                  'Login',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
        );
      },
    );
  }

  /// Build sign up link
  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Don't have an account? ",
          style: TextStyle(color: AppTheme.ink, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const RegistrationScreen(),
              ),
            );
          },
          child: Text(
            'Sign up',
            style: TextStyle(
              color: AppTheme.terracotta,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }
}
