import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PlaybackReviewWidget extends StatefulWidget {
  final String secretPhrase;
  final List<String> recordedSamples;
  final VoidCallback onConfirm;
  final VoidCallback onRecordAgain;

  const PlaybackReviewWidget({
    super.key,
    required this.secretPhrase,
    required this.recordedSamples,
    required this.onConfirm,
    required this.onRecordAgain,
  });

  @override
  State<PlaybackReviewWidget> createState() => _PlaybackReviewWidgetState();
}

class _PlaybackReviewWidgetState extends State<PlaybackReviewWidget> {
  int? currentlyPlaying;
  bool isPlaying = false;

  void _playRecording(int index) {
    setState(() {
      currentlyPlaying = index;
      isPlaying = true;
    });

    HapticFeedback.lightImpact();

    // Simulate playback duration
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          currentlyPlaying = null;
          isPlaying = false;
        });
      }
    });
  }

  void _stopPlayback() {
    setState(() {
      currentlyPlaying = null;
      isPlaying = false;
    });
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          Text(
            'Review & Confirm',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Listen to your recordings and confirm they sound clear',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4.h),
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'record_voice_over',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 6.w,
                    ),
                    SizedBox(width: 3.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Secret Phrase',
                            style: AppTheme.lightTheme.textTheme.labelMedium,
                          ),
                          Text(
                            '"${widget.secretPhrase}"',
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: AppTheme.lightTheme.colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  children: [
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      '${widget.recordedSamples.length} voice samples recorded',
                      style: AppTheme.lightTheme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          _buildRecordingsList(),
          SizedBox(height: 4.h),
          _buildQualityIndicator(),
          SizedBox(height: 4.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: widget.onRecordAgain,
                  child: const Text('Record Again'),
                ),
              ),
              SizedBox(width: 4.w),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: widget.onConfirm,
                  child: const Text('Sounds Good'),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Text(
            'You can always change your voice trigger in Settings later',
            style: AppTheme.lightTheme.textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecordingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Recordings',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        ...List.generate(widget.recordedSamples.length, (index) {
          final isCurrentlyPlaying = currentlyPlaying == index;

          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: isCurrentlyPlaying
                  ? AppTheme.lightTheme.colorScheme.primary
                      .withValues(alpha: 0.1)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isCurrentlyPlaying
                    ? AppTheme.lightTheme.colorScheme.primary
                    : AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (isCurrentlyPlaying) {
                      _stopPlayback();
                    } else {
                      _playRecording(index);
                    }
                  },
                  child: Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCurrentlyPlaying
                          ? AppTheme.lightTheme.colorScheme.tertiary
                          : AppTheme.lightTheme.colorScheme.primary,
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: isCurrentlyPlaying ? 'pause' : 'play_arrow',
                        color: Colors.white,
                        size: 6.w,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recording ${index + 1}',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      Text(
                        isCurrentlyPlaying
                            ? 'Playing...'
                            : 'Tap to play • 3.2s',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color: isCurrentlyPlaying
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme
                                  .lightTheme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'graphic_eq',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 4.w,
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildQualityIndicator() {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'verified',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 6.w,
              ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  'Voice Quality Assessment',
                  style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              _buildQualityMetric('Clarity', 'Excellent', true),
              SizedBox(width: 4.w),
              _buildQualityMetric('Consistency', 'Good', true),
              SizedBox(width: 4.w),
              _buildQualityMetric('Volume', 'Optimal', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityMetric(String label, String value, bool isGood) {
    return Expanded(
      child: Column(
        children: [
          CustomIconWidget(
            iconName: isGood ? 'check_circle' : 'warning',
            color: isGood
                ? AppTheme.lightTheme.colorScheme.primary
                : AppTheme.lightTheme.colorScheme.tertiary,
            size: 5.w,
          ),
          SizedBox(height: 0.5.h),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.labelSmall,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: isGood
                  ? AppTheme.lightTheme.colorScheme.primary
                  : AppTheme.lightTheme.colorScheme.tertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
