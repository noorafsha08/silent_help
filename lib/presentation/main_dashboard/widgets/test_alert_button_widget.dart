import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TestAlertButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;

  const TestAlertButtonWidget({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 8.h,
      margin: EdgeInsets.symmetric(horizontal: 2.w),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor:
              AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'emergency',
              color: Colors.white,
              size: 28,
            ),
            SizedBox(width: 3.w),
            Text(
              'Test Alert System',
              style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
