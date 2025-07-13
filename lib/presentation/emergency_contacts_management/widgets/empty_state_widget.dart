import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyStateWidget extends StatelessWidget {
  final VoidCallback onAddContact;

  const EmptyStateWidget({
    super.key,
    required this.onAddContact,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildIllustration(),
          SizedBox(height: 4.h),
          _buildTitle(),
          SizedBox(height: 2.h),
          _buildDescription(),
          SizedBox(height: 6.h),
          _buildAddButton(),
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circles for depth
          Container(
            width: 30.w,
            height: 30.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              shape: BoxShape.circle,
            ),
          ),
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
          ),
          // Main icon
          CustomIconWidget(
            iconName: 'contacts',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 60,
          ),
          // Plus icon overlay
          Positioned(
            bottom: 8.w,
            right: 8.w,
            child: Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppTheme.lightTheme.scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Add Your First Emergency Contact',
      style: TextStyle(
        color: AppTheme.lightTheme.colorScheme.onSurface,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        height: 1.2,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Text(
        'Emergency contacts will receive alerts with your location when you trigger the SOS feature. Add trusted family members, friends, or colleagues.',
        style: TextStyle(
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.7),
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          height: 1.5,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 8.w),
      child: ElevatedButton.icon(
        onPressed: onAddContact,
        icon: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onPrimary,
          size: 20,
        ),
        label: Text(
          'Add Emergency Contact',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.lightTheme.colorScheme.primary,
          foregroundColor: AppTheme.lightTheme.colorScheme.onPrimary,
          padding: EdgeInsets.symmetric(vertical: 2.5.h),
          elevation: 4,
          shadowColor:
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
