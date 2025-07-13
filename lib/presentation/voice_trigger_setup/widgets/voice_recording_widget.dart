import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class VoiceRecordingWidget extends StatelessWidget {
  final String secretPhrase;
  final List<String> recordedSamples;
  final bool isRecording;
  final bool isNoisyEnvironment;
  final Animation<double> recordingAnimation;
  final VoidCallback onStartRecording;
  final VoidCallback onStopRecording;
  final VoidCallback? onNext;

  const VoiceRecordingWidget({
    super.key,
    required this.secretPhrase,
    required this.recordedSamples,
    required this.isRecording,
    required this.isNoisyEnvironment,
    required this.recordingAnimation,
    required this.onStartRecording,
    required this.onStopRecording,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(6.w),
      child: Column(
        children: [
          Text(
            'Record Your Voice',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Say your phrase naturally 3 times to train voice recognition',
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
                Text(
                  'Your Secret Phrase:',
                  style: AppTheme.lightTheme.textTheme.labelMedium,
                ),
                SizedBox(height: 1.h),
                Text(
                  '"$secretPhrase"',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: AppTheme.lightTheme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 4.h),
          if (isNoisyEnvironment) ...[
            Container(
              padding: EdgeInsets.all(4.w),
              margin: EdgeInsets.only(bottom: 3.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.tertiary
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.tertiary
                      .withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'volume_up',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    size: 5.w,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      'Background noise detected. Consider finding a quieter location for better recording quality.',
                      style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Center(
            child: Column(
              children: [
                AnimatedBuilder(
                  animation: recordingAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: isRecording ? recordingAnimation.value : 1.0,
                      child: GestureDetector(
                        onTap: isRecording ? onStopRecording : onStartRecording,
                        child: Container(
                          width: 35.w,
                          height: 35.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isRecording
                                ? AppTheme.lightTheme.colorScheme.tertiary
                                : AppTheme.lightTheme.colorScheme.primary,
                            boxShadow: [
                              BoxShadow(
                                color: (isRecording
                                        ? AppTheme
                                            .lightTheme.colorScheme.tertiary
                                        : AppTheme
                                            .lightTheme.colorScheme.primary)
                                    .withValues(alpha: 0.3),
                                blurRadius: isRecording ? 20 : 10,
                                spreadRadius: isRecording ? 5 : 2,
                              ),
                            ],
                          ),
                          child: Center(
                            child: CustomIconWidget(
                              iconName: isRecording ? 'stop' : 'mic',
                              color: Colors.white,
                              size: 15.w,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 3.h),
                Text(
                  isRecording
                      ? 'Recording... Tap to stop'
                      : recordedSamples.length < 3
                          ? 'Tap to record (${recordedSamples.length}/3)'
                          : 'All recordings complete!',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: isRecording
                        ? AppTheme.lightTheme.colorScheme.tertiary
                        : AppTheme.lightTheme.colorScheme.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (isRecording) ...[
                  SizedBox(height: 2.h),
                  Text(
                    'Say your phrase naturally',
                    style: AppTheme.lightTheme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(height: 4.h),
          if (isRecording) _buildWaveformVisualization(),
          if (!isRecording && recordedSamples.isNotEmpty) ...[
            _buildRecordingsList(),
            SizedBox(height: 4.h),
          ],
          if (recordedSamples.length >= 3) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onNext,
                child: const Text('Continue to Review'),
              ),
            ),
          ] else ...[
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: recordedSamples.isNotEmpty
                    ? () {
                        HapticFeedback.lightImpact();
                        // Clear last recording for retry
                      }
                    : null,
                child: Text(
                  recordedSamples.isNotEmpty
                      ? 'Clear Last Recording'
                      : 'Record to Continue',
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildWaveformVisualization() {
    return Container(
      height: 15.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(20, (index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 100 + (index * 50)),
            width: 1.w,
            height: (5 + (index % 8) * 2).h,
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.tertiary
                  .withValues(alpha: 0.7),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRecordingsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recorded Samples',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 2.h),
        ...List.generate(recordedSamples.length, (index) {
          return Container(
            margin: EdgeInsets.only(bottom: 2.h),
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 10.w,
                  height: 10.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                  ),
                  child: Center(
                    child: CustomIconWidget(
                      iconName: 'check_circle',
                      color: AppTheme.lightTheme.colorScheme.primary,
                      size: 5.w,
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recording ${index + 1}',
                        style: AppTheme.lightTheme.textTheme.titleSmall,
                      ),
                      Text(
                        'Clear quality • 3.2s duration',
                        style: AppTheme.lightTheme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    // Play recording preview
                  },
                  icon: CustomIconWidget(
                    iconName: 'play_arrow',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 6.w,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
