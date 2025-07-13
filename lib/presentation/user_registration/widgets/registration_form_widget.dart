import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RegistrationFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController pinController;
  final TextEditingController confirmPinController;
  final String selectedCountryCode;
  final bool isPinVisible;
  final bool isConfirmPinVisible;
  final String? nameError;
  final String? phoneError;
  final String? pinError;
  final String? confirmPinError;
  final Function(String) onNameChanged;
  final Function(String) onPhoneChanged;
  final Function(String) onPinChanged;
  final Function(String) onConfirmPinChanged;
  final VoidCallback onCountryCodeTap;
  final VoidCallback onPinVisibilityToggle;
  final VoidCallback onConfirmPinVisibilityToggle;

  const RegistrationFormWidget({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.phoneController,
    required this.pinController,
    required this.confirmPinController,
    required this.selectedCountryCode,
    required this.isPinVisible,
    required this.isConfirmPinVisible,
    this.nameError,
    this.phoneError,
    this.pinError,
    this.confirmPinError,
    required this.onNameChanged,
    required this.onPhoneChanged,
    required this.onPinChanged,
    required this.onConfirmPinChanged,
    required this.onCountryCodeTap,
    required this.onPinVisibilityToggle,
    required this.onConfirmPinVisibilityToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name Field
          _buildInputField(
            label: 'Full Name',
            controller: nameController,
            prefixIcon: 'person',
            keyboardType: TextInputType.name,
            textCapitalization: TextCapitalization.words,
            onChanged: onNameChanged,
            errorText: nameError,
            hint: 'Enter your full name',
          ),

          SizedBox(height: 3.h),

          // Phone Number Field
          _buildPhoneField(),

          SizedBox(height: 3.h),

          // PIN Field
          _buildInputField(
            label: 'Create PIN',
            controller: pinController,
            prefixIcon: 'lock',
            keyboardType: TextInputType.number,
            obscureText: !isPinVisible,
            onChanged: onPinChanged,
            errorText: pinError,
            hint: 'Enter 4-digit PIN',
            maxLength: 4,
            suffixIcon: GestureDetector(
              onTap: onPinVisibilityToggle,
              child: CustomIconWidget(
                iconName: isPinVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
          ),

          SizedBox(height: 3.h),

          // Confirm PIN Field
          _buildInputField(
            label: 'Confirm PIN',
            controller: confirmPinController,
            prefixIcon: 'lock_outline',
            keyboardType: TextInputType.number,
            obscureText: !isConfirmPinVisible,
            onChanged: onConfirmPinChanged,
            errorText: confirmPinError,
            hint: 'Re-enter your PIN',
            maxLength: 4,
            suffixIcon: GestureDetector(
              onTap: onConfirmPinVisibilityToggle,
              child: CustomIconWidget(
                iconName: isConfirmPinVisible ? 'visibility_off' : 'visibility',
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                size: 5.w,
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: phoneError != null
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.outline,
              width: phoneError != null ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Country Code Picker
              GestureDetector(
                onTap: onCountryCodeTap,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: AppTheme.lightTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        selectedCountryCode,
                        style:
                            AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      CustomIconWidget(
                        iconName: 'keyboard_arrow_down',
                        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        size: 4.w,
                      ),
                    ],
                  ),
                ),
              ),

              // Phone Icon
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: CustomIconWidget(
                  iconName: 'phone',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),

              // Phone Number Input
              Expanded(
                child: TextFormField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  onChanged: onPhoneChanged,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(15),
                  ],
                  decoration: InputDecoration(
                    hintText: 'Enter phone number',
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                          .withValues(alpha: 0.6),
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 2.h),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        if (phoneError != null) ...[
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  phoneError!,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String prefixIcon,
    required TextInputType keyboardType,
    required Function(String) onChanged,
    String? errorText,
    String? hint,
    bool obscureText = false,
    TextCapitalization textCapitalization = TextCapitalization.none,
    Widget? suffixIcon,
    int? maxLength,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: 1.h),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText != null
                  ? AppTheme.lightTheme.colorScheme.error
                  : AppTheme.lightTheme.colorScheme.outline,
              width: errorText != null ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.shadow
                    .withValues(alpha: 0.1),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: obscureText,
            textCapitalization: textCapitalization,
            onChanged: onChanged,
            maxLength: maxLength,
            inputFormatters: inputFormatters,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.6),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.all(3.w),
                child: CustomIconWidget(
                  iconName: prefixIcon,
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ),
              suffixIcon: suffixIcon != null
                  ? Padding(
                      padding: EdgeInsets.all(3.w),
                      child: suffixIcon,
                    )
                  : null,
              border: InputBorder.none,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              counterText: '',
            ),
            style: AppTheme.lightTheme.textTheme.bodyLarge,
          ),
        ),
        if (errorText != null) ...[
          SizedBox(height: 0.5.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'error_outline',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 4.w,
              ),
              SizedBox(width: 1.w),
              Expanded(
                child: Text(
                  errorText,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
