import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/registration_controller.dart';
import '../enums/enums.dart';
import '../utils/validators.dart';
import '../utils/app_theme.dart';

/// Registration Screen - Handles user account creation
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late final RegistrationController _registrationController;
  late final GlobalKey<FormState> _formKey;
  late final TextEditingController _fullNameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;

  @override
  void initState() {
    super.initState();
    _registrationController = RegistrationController();
    _formKey = GlobalKey<FormState>();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _registrationController.dispose();
    super.dispose();
  }

  /// Handle registration button press
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final success = await _registrationController.register(
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
      gender: _registrationController.selectedGender,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Registration successful! Please login.')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _registrationController,
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
                  const SizedBox(height: 40),
                  // Header
                  _buildHeader(),
                  const SizedBox(height: 30),
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
                          _buildFullNameField(),
                          const SizedBox(height: 20),
                          _buildEmailField(),
                          const SizedBox(height: 20),
                          _buildPasswordField(),
                          const SizedBox(height: 20),
                          _buildConfirmPasswordField(),
                          const SizedBox(height: 20),
                          _buildGenderDropdown(),
                          const SizedBox(height: 24),
                          _buildErrorMessage(),
                          _buildSignUpButton(),
                          const SizedBox(height: 20),
                          _buildLoginLink(),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build header section with title
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
            Icons.person_add_outlined,
            size: 50,
            color: AppTheme.cream,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Sign Up',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.cream,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Create your account to get started',
          style: TextStyle(fontSize: 14, color: AppTheme.sand),
        ),
      ],
    );
  }

  /// Build full name input field
  Widget _buildFullNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Full Name',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _fullNameController,
          validator: Validator.validateFullName,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            hintText: 'Enter your full name',
            prefixIcon: const Icon(Icons.person_outline),
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
    return Consumer<RegistrationController>(
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
              validator: Validator.validatePassword,
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
            const SizedBox(height: 8),
            _buildPasswordRequirements(),
          ],
        );
      },
    );
  }

  /// Build password requirements helper text
  Widget _buildPasswordRequirements() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.sand,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Password requirements:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.earthMid,
            ),
          ),
          const SizedBox(height: 6),
          _buildRequirementRow('Minimum 6 characters'),
          _buildRequirementRow('At least 1 uppercase letter'),
          _buildRequirementRow('At least 1 special character'),
        ],
      ),
    );
  }

  /// Build individual requirement row
  Widget _buildRequirementRow(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          const Icon(
            Icons.check_circle_outline,
            size: 14,
            color: AppTheme.olive,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(fontSize: 12, color: AppTheme.earthMid),
          ),
        ],
      ),
    );
  }

  /// Build confirm password input field
  Widget _buildConfirmPasswordField() {
    return Consumer<RegistrationController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confirm Password',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _confirmPasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              obscureText: !controller.confirmPasswordVisible,
              decoration: InputDecoration(
                hintText: 'Re-enter your password',
                prefixIcon: const Icon(Icons.lock_outline),
                prefixIconColor: AppTheme.muted,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.confirmPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: controller.toggleConfirmPasswordVisibility,
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

  /// Build gender dropdown
  Widget _buildGenderDropdown() {
    return Consumer<RegistrationController>(
      builder: (context, controller, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Gender',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.ink,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Gender>(
              initialValue: controller.selectedGender,
              validator: Validator.validateGenderEnum,
              onChanged: controller.setGender,
              items: Gender.values.map((gender) {
                return DropdownMenuItem<Gender>(
                  value: gender,
                  child: Text(gender.displayName),
                );
              }).toList(),
              decoration: InputDecoration(
                hintText: 'Select your gender',
                prefixIcon: const Icon(Icons.wc_outlined),
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
                  borderSide:
                      const BorderSide(color: AppTheme.terracotta, width: 2),
                ),
                filled: true,
                fillColor: AppTheme.sand,
              ),
              isExpanded: true,
            ),
          ],
        );
      },
    );
  }

  /// Build error message display
  Widget _buildErrorMessage() {
    return Consumer<RegistrationController>(
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

  /// Build sign up button
  Widget _buildSignUpButton() {
    return Consumer<RegistrationController>(
      builder: (context, controller, child) {
        final isLoading = controller.authState == AuthState.loading;

        return ElevatedButton(
          onPressed: isLoading ? null : _handleRegister,
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
                  'Sign Up',
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

  /// Build login link
  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(color: AppTheme.ink, fontSize: 14),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Login',
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
