import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MonitoringStatusWidget extends StatelessWidget {
  final bool voiceListening;
  final bool shakeDetection;
  final bool locationTracking;
  final ValueChanged<bool> onVoiceToggle;
  final ValueChanged<bool> onShakeToggle;
  final ValueChanged<bool> onLocationToggle;

  const MonitoringStatusWidget({
    super.key,
    required this.voiceListening,
    required this.shakeDetection,
    required this.locationTracking,
    required this.onVoiceToggle,
    required this.onShakeToggle,
    required this.onLocationToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monitoring Status',
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildStatusItem(
              icon: 'mic',
              title: 'Voice Listening',
              subtitle: 'Listening for secret phrase',
              isActive: voiceListening,
              onToggle: onVoiceToggle,
            ),
            SizedBox(height: 2.h),
            _buildStatusItem(
              icon: 'vibration',
              title: 'Shake Detection',
              subtitle: 'Triple shake to trigger alert',
              isActive: shakeDetection,
              onToggle: onShakeToggle,
            ),
            SizedBox(height: 2.h),
            _buildStatusItem(
              icon: 'location_on',
              title: 'Location Tracking',
              subtitle: 'GPS location for emergency alerts',
              isActive: locationTracking,
              onToggle: onLocationToggle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusItem({
    required String icon,
    required String title,
    required String subtitle,
    required bool isActive,
    required ValueChanged<bool> onToggle,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1)
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant
                    .withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomIconWidget(
            iconName: icon,
            color: isActive
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.lightTheme.textTheme.titleMedium,
              ),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.bodySmall,
              ),
            ],
          ),
        ),
        Switch(
          value: isActive,
          onChanged: onToggle,
        ),
      ],
    );
  }
}
