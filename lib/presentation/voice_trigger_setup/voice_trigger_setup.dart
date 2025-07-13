import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/phrase_input_widget.dart';
import './widgets/playback_review_widget.dart';
import './widgets/step_indicator_widget.dart';
import './widgets/success_confirmation_widget.dart';
import './widgets/voice_recording_widget.dart';

class VoiceTriggerSetup extends StatefulWidget {
  const VoiceTriggerSetup({super.key});

  @override
  State<VoiceTriggerSetup> createState() => _VoiceTriggerSetupState();
}

class _VoiceTriggerSetupState extends State<VoiceTriggerSetup>
    with TickerProviderStateMixin {
  int currentStep = 0;
  String secretPhrase = '';
  List<String> recordedSamples = [];
  bool isRecording = false;
  bool hasPermission = true;
  bool isNoisyEnvironment = false;
  late AnimationController _recordingAnimationController;
  late AnimationController _successAnimationController;
  late Animation<double> _recordingAnimation;
  late Animation<double> _successAnimation;

  final List<Map<String, dynamic>> setupSteps = [
    {
      'title': 'Create Secret Phrase',
      'description': 'Choose a unique phrase that only you know',
      'isCompleted': false,
    },
    {
      'title': 'Record Your Voice',
      'description': 'Train the system to recognize your voice',
      'isCompleted': false,
    },
    {
      'title': 'Review & Confirm',
      'description': 'Test your voice trigger setup',
      'isCompleted': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _checkMicrophonePermission();
  }

  void _initializeAnimations() {
    _recordingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _successAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _recordingAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _recordingAnimationController,
      curve: Curves.easeInOut,
    ));

    _successAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _successAnimationController,
      curve: Curves.elasticOut,
    ));
  }

  Future<void> _checkMicrophonePermission() async {
    // Simulate permission check
    await Future.delayed(const Duration(milliseconds: 500));
    if (mounted) {
      setState(() {
        hasPermission = true; // Mock permission granted
      });
    }
  }

  void _nextStep() {
    if (currentStep < setupSteps.length - 1) {
      setState(() {
        setupSteps[currentStep]['isCompleted'] = true;
        currentStep++;
      });
    } else {
      _completeSetup();
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
    }
  }

  void _completeSetup() {
    setupSteps[currentStep]['isCompleted'] = true;
    _successAnimationController.forward();

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main-dashboard');
      }
    });
  }

  void _skipSetup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Skip Voice Setup?',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'You can set up voice triggers later in Settings. You\'ll receive reminder notifications.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue Setup'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/main-dashboard');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
            ),
            child: const Text('Skip for Now'),
          ),
        ],
      ),
    );
  }

  void _redirectToSettings() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Microphone Permission Required',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Please enable microphone access in Settings to use voice triggers.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // In real app, would open system settings
              HapticFeedback.lightImpact();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStepContent() {
    if (!hasPermission) {
      return _buildPermissionDeniedContent();
    }

    switch (currentStep) {
      case 0:
        return PhraseInputWidget(
          secretPhrase: secretPhrase,
          onPhraseChanged: (phrase) {
            setState(() {
              secretPhrase = phrase;
            });
          },
          onNext: secretPhrase.length >= 5 ? _nextStep : null,
        );
      case 1:
        return VoiceRecordingWidget(
          secretPhrase: secretPhrase,
          recordedSamples: recordedSamples,
          isRecording: isRecording,
          isNoisyEnvironment: isNoisyEnvironment,
          recordingAnimation: _recordingAnimation,
          onStartRecording: _startRecording,
          onStopRecording: _stopRecording,
          onNext: recordedSamples.length >= 3 ? _nextStep : null,
        );
      case 2:
        return PlaybackReviewWidget(
          secretPhrase: secretPhrase,
          recordedSamples: recordedSamples,
          onConfirm: _nextStep,
          onRecordAgain: () {
            setState(() {
              recordedSamples.clear();
              currentStep = 1;
            });
          },
        );
      default:
        return SuccessConfirmationWidget(
          successAnimation: _successAnimation,
          onComplete: () =>
              Navigator.pushReplacementNamed(context, '/main-dashboard'),
        );
    }
  }

  Widget _buildPermissionDeniedContent() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'mic_off',
              size: 20.w,
              color: AppTheme.lightTheme.colorScheme.tertiary,
            ),
            SizedBox(height: 4.h),
            Text(
              'Microphone Access Required',
              style: AppTheme.lightTheme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Voice triggers need microphone permission to work. Please enable access in your device settings.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: _redirectToSettings,
              child: const Text('Open Settings'),
            ),
            SizedBox(height: 2.h),
            TextButton(
              onPressed: () => Navigator.pushReplacementNamed(
                  context, '/alternative-triggers-setup'),
              child: const Text('Use Alternative Triggers'),
            ),
          ],
        ),
      ),
    );
  }

  void _startRecording() {
    if (recordedSamples.length < 3) {
      setState(() {
        isRecording = true;
        isNoisyEnvironment = false; // Mock environment check
      });
      _recordingAnimationController.repeat(reverse: true);
      HapticFeedback.mediumImpact();

      // Simulate recording duration
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted && isRecording) {
          _stopRecording();
        }
      });
    }
  }

  void _stopRecording() {
    setState(() {
      isRecording = false;
      recordedSamples.add('Recording ${recordedSamples.length + 1}');
    });
    _recordingAnimationController.stop();
    _recordingAnimationController.reset();
    HapticFeedback.lightImpact();
  }

  @override
  void dispose() {
    _recordingAnimationController.dispose();
    _successAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: currentStep > 0 && hasPermission
            ? IconButton(
                onPressed: _previousStep,
                icon: CustomIconWidget(
                  iconName: 'arrow_back',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              )
            : IconButton(
                onPressed: () => Navigator.pop(context),
                icon: CustomIconWidget(
                  iconName: 'close',
                  color: AppTheme.lightTheme.colorScheme.onSurface,
                  size: 6.w,
                ),
              ),
        title: Text(
          'Voice Trigger Setup',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          if (hasPermission)
            TextButton(
              onPressed: _skipSetup,
              child: Text(
                'Skip',
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          if (hasPermission) ...[
            StepIndicatorWidget(
              steps: setupSteps,
              currentStep: currentStep,
            ),
            SizedBox(height: 3.h),
          ],
          Expanded(
            child: _buildCurrentStepContent(),
          ),
        ],
      ),
    );
  }
}
