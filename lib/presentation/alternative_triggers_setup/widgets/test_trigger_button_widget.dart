import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TestTriggerButton extends StatelessWidget {
  final String label;
  final bool isLoading;
  final VoidCallback onPressed;

  const TestTriggerButton({
    super.key,
    required this.label,
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: isLoading ? null : onPressed,
        icon: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              )
            : CustomIconWidget(
                iconName: 'play_arrow',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 20,
              ),
        label: Text(
          isLoading ? 'Testing...' : label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: isLoading
                ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                : AppTheme.lightTheme.colorScheme.primary,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          side: BorderSide(
            color: isLoading
                ? AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.3)
                : AppTheme.lightTheme.colorScheme.primary,
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
