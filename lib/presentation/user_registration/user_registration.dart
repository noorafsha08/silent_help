import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/privacy_notice_widget.dart';
import './widgets/registration_form_widget.dart';

class UserRegistration extends StatefulWidget {
  const UserRegistration({super.key});

  @override
  State<UserRegistration> createState() => _UserRegistrationState();
}

class _UserRegistrationState extends State<UserRegistration> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _scrollController = ScrollController();

  bool _isPinVisible = false;
  bool _isConfirmPinVisible = false;
  bool _isLoading = false;
  bool _acceptTerms = false;
  String _selectedCountryCode = '+1';
  String? _nameError;
  String? _phoneError;
  String? _pinError;
  String? _confirmPinError;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+91', 'country': 'IN'},
    {'code': '+86', 'country': 'CN'},
    {'code': '+49', 'country': 'DE'},
    {'code': '+33', 'country': 'FR'},
    {'code': '+81', 'country': 'JP'},
    {'code': '+61', 'country': 'AU'},
    {'code': '+55', 'country': 'BR'},
    {'code': '+7', 'country': 'RU'},
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _validateName(String value) {
    setState(() {
      if (value.isEmpty) {
        _nameError = 'Name is required for emergency identification';
      } else if (value.length < 2) {
        _nameError = 'Name must be at least 2 characters';
      } else if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
        _nameError = 'Name can only contain letters and spaces';
      } else {
        _nameError = null;
      }
    });
  }

  void _validatePhone(String value) {
    setState(() {
      if (value.isEmpty) {
        _phoneError = 'Phone number is required for emergency SMS';
      } else if (value.length < 10) {
        _phoneError = 'Phone number must be at least 10 digits';
      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        _phoneError = 'Phone number can only contain digits';
      } else {
        _phoneError = null;
      }
    });
  }

  void _validatePin(String value) {
    setState(() {
      if (value.isEmpty) {
        _pinError = 'PIN is required to secure your settings';
      } else if (value.length != 4) {
        _pinError = 'PIN must be exactly 4 digits';
      } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        _pinError = 'PIN can only contain numbers';
      } else {
        _pinError = null;
      }
    });

    // Validate confirm PIN if it has content
    if (_confirmPinController.text.isNotEmpty) {
      _validateConfirmPin(_confirmPinController.text);
    }
  }

  void _validateConfirmPin(String value) {
    setState(() {
      if (value.isEmpty) {
        _confirmPinError = 'Please confirm your PIN';
      } else if (value != _pinController.text) {
        _confirmPinError = 'PINs do not match';
      } else {
        _confirmPinError = null;
      }
    });
  }

  bool get _isFormValid {
    return _nameError == null &&
        _phoneError == null &&
        _pinError == null &&
        _confirmPinError == null &&
        _nameController.text.isNotEmpty &&
        _phoneController.text.isNotEmpty &&
        _pinController.text.isNotEmpty &&
        _confirmPinController.text.isNotEmpty &&
        _acceptTerms;
  }

  void _showCountryCodePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        height: 50.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Country Code',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: _countryCodes.length,
                itemBuilder: (context, index) {
                  final country = _countryCodes[index];
                  return ListTile(
                    leading: Text(
                      country['country']!,
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                    title: Text(
                      country['code']!,
                      style: AppTheme.lightTheme.textTheme.bodyLarge,
                    ),
                    onTap: () {
                      setState(() {
                        _selectedCountryCode = country['code']!;
                      });
                      Navigator.pop(context);
                    },
                    selected: _selectedCountryCode == country['code'],
                    selectedTileColor: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createAccount() async {
    if (!_isFormValid) return;

    setState(() {
      _isLoading = true;
    });

    // Haptic feedback
    HapticFeedback.lightImpact();

    try {
      // Simulate account creation
      await Future.delayed(Duration(seconds: 2));

      // Success haptic feedback
      HapticFeedback.mediumImpact();

      // Navigate to emergency contacts setup
      if (mounted) {
        Navigator.pushReplacementNamed(
            context, '/emergency-contacts-management');
      }
    } catch (e) {
      // Error haptic feedback
      HapticFeedback.heavyImpact();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Account creation failed. Please try again.'),
            backgroundColor: AppTheme.lightTheme.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showUnsavedChangesDialog() {
    if (_nameController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty ||
        _pinController.text.isNotEmpty ||
        _confirmPinController.text.isNotEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Unsaved Changes'),
          content: Text(
              'You have unsaved changes. Are you sure you want to go back?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Stay'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Text('Leave'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // App Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: _showUnsavedChangesDialog,
                    child: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.shadow,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 6.w,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        'Create Account',
                        style: AppTheme.lightTheme.textTheme.titleLarge,
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w), // Balance the back button
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 3.h),

                    // App Logo
                    Container(
                      width: 20.w,
                      height: 20.w,
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.lightTheme.colorScheme.primary
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CustomIconWidget(
                          iconName: 'security',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 10.w,
                        ),
                      ),
                    ),

                    SizedBox(height: 2.h),

                    Text(
                      'Silent Help',
                      style:
                          AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.lightTheme.colorScheme.primary,
                      ),
                    ),

                    SizedBox(height: 1.h),

                    Text(
                      'Your safety, our priority',
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    // Registration Form
                    RegistrationFormWidget(
                      formKey: _formKey,
                      nameController: _nameController,
                      phoneController: _phoneController,
                      pinController: _pinController,
                      confirmPinController: _confirmPinController,
                      selectedCountryCode: _selectedCountryCode,
                      isPinVisible: _isPinVisible,
                      isConfirmPinVisible: _isConfirmPinVisible,
                      nameError: _nameError,
                      phoneError: _phoneError,
                      pinError: _pinError,
                      confirmPinError: _confirmPinError,
                      onNameChanged: _validateName,
                      onPhoneChanged: _validatePhone,
                      onPinChanged: _validatePin,
                      onConfirmPinChanged: _validateConfirmPin,
                      onCountryCodeTap: _showCountryCodePicker,
                      onPinVisibilityToggle: () {
                        setState(() {
                          _isPinVisible = !_isPinVisible;
                        });
                      },
                      onConfirmPinVisibilityToggle: () {
                        setState(() {
                          _isConfirmPinVisible = !_isConfirmPinVisible;
                        });
                      },
                    ),

                    SizedBox(height: 3.h),

                    // Privacy Notice
                    PrivacyNoticeWidget(
                      acceptTerms: _acceptTerms,
                      onTermsChanged: (value) {
                        setState(() {
                          _acceptTerms = value ?? false;
                        });
                      },
                    ),

                    SizedBox(height: 4.h),

                    // Create Account Button
                    SizedBox(
                      width: double.infinity,
                      height: 7.h,
                      child: ElevatedButton(
                        onPressed:
                            _isFormValid && !_isLoading ? _createAccount : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isFormValid
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.3),
                          foregroundColor:
                              AppTheme.lightTheme.colorScheme.onPrimary,
                          elevation: _isFormValid ? 4 : 0,
                          shadowColor: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? SizedBox(
                                width: 6.w,
                                height: 6.w,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                  ),
                                ),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'person_add',
                                    color: AppTheme
                                        .lightTheme.colorScheme.onPrimary,
                                    size: 5.w,
                                  ),
                                  SizedBox(width: 2.w),
                                  Text(
                                    'Create Account',
                                    style: AppTheme
                                        .lightTheme.textTheme.labelLarge
                                        ?.copyWith(
                                      color: AppTheme
                                          .lightTheme.colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),

                    SizedBox(height: 3.h),

                    // Already have account
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account? ',
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                                context, '/splash-screen');
                          },
                          child: Text(
                            'Sign In',
                            style: AppTheme.lightTheme.textTheme.bodyMedium
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
