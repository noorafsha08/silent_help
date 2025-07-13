import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/practice_mode_toggle_widget.dart';
import './widgets/sensitivity_slider_widget.dart';
import './widgets/test_trigger_button_widget.dart';
import './widgets/trigger_option_card_widget.dart';

class AlternativeTriggersSetup extends StatefulWidget {
  const AlternativeTriggersSetup({super.key});

  @override
  State<AlternativeTriggersSetup> createState() =>
      _AlternativeTriggersSetupState();
}

class _AlternativeTriggersSetupState extends State<AlternativeTriggersSetup> {
  bool _tripleShakeEnabled = false;
  bool _tripleBackTapEnabled = false;
  bool _volumeButtonEnabled = false;
  bool _practiceMode = false;
  double _shakeSensitivity = 2.0; // 1=Low, 2=Medium, 3=High
  String _selectedVolumeCombo = 'Volume Up+Down';
  bool _isTestingShake = false;
  bool _isTestingBackTap = false;
  bool _isTestingVolume = false;

  final List<String> _volumeCombinations = [
    'Volume Up+Down',
    'Volume Down 3x',
    'Power+Volume Down'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeaderSection(),
              SizedBox(height: 3.h),
              _buildTripleShakeSection(),
              SizedBox(height: 2.h),
              _buildTripleBackTapSection(),
              SizedBox(height: 2.h),
              _buildVolumeButtonSection(),
              SizedBox(height: 3.h),
              _buildPracticeModeSection(),
              SizedBox(height: 4.h),
              _buildNavigationButtons(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
      elevation: AppTheme.lightTheme.appBarTheme.elevation,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color: AppTheme.lightTheme.colorScheme.onSurface,
          size: 24,
        ),
      ),
      title: Text(
        'Alternative Triggers',
        style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
      ),
      actions: [
        IconButton(
          onPressed: () => _showHelpDialog(),
          icon: CustomIconWidget(
            iconName: 'help_outline',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          CustomIconWidget(
            iconName: 'security',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 48,
          ),
          SizedBox(height: 2.h),
          Text(
            'Backup Emergency Triggers',
            style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),
          Text(
            'Configure device gestures as backup methods to activate emergency alerts when voice commands aren\'t available.',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTripleShakeSection() {
    return TriggerOptionCard(
      title: 'Triple Shake Detection',
      description:
          'Shake your phone three times quickly to trigger emergency alert',
      icon: 'phone_android',
      isEnabled: _tripleShakeEnabled,
      onToggle: (value) {
        setState(() {
          _tripleShakeEnabled = value;
        });
        _showToggleConfirmation('Triple Shake', value);
      },
      child: Column(
        children: [
          if (_tripleShakeEnabled) ...[
            SizedBox(height: 2.h),
            SensitivitySlider(
              value: _shakeSensitivity,
              onChanged: (value) {
                setState(() {
                  _shakeSensitivity = value;
                });
              },
            ),
            SizedBox(height: 2.h),
            TestTriggerButton(
              label: 'Test Shake Detection',
              isLoading: _isTestingShake,
              onPressed: () => _testShakeDetection(),
            ),
            if (_isTestingShake) ...[
              SizedBox(height: 2.h),
              _buildAccelerometerVisualization(),
            ],
          ],
        ],
      ),
    );
  }

  Widget _buildTripleBackTapSection() {
    return TriggerOptionCard(
      title: 'Triple Back-Tap Detection',
      description:
          'Tap the back of your phone three times to trigger emergency alert (iOS only)',
      icon: 'touch_app',
      isEnabled: _tripleBackTapEnabled,
      onToggle: (value) {
        setState(() {
          _tripleBackTapEnabled = value;
        });
        _showToggleConfirmation('Triple Back-Tap', value);
      },
      child: Column(
        children: [
          if (_tripleBackTapEnabled) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  CustomIconWidget(
                    iconName: 'info_outline',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 20,
                  ),
                  SizedBox(width: 2.w),
                  Expanded(
                    child: Text(
                      'This feature requires iOS system integration. Tap below to configure in Settings.',
                      style: AppTheme.lightTheme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            ElevatedButton.icon(
              onPressed: () => _openSystemSettings(),
              icon: CustomIconWidget(
                iconName: 'settings',
                color: AppTheme.lightTheme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text('Open iOS Settings'),
              style: AppTheme.lightTheme.elevatedButtonTheme.style,
            ),
            SizedBox(height: 2.h),
            TestTriggerButton(
              label: 'Test Back-Tap',
              isLoading: _isTestingBackTap,
              onPressed: () => _testBackTapDetection(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildVolumeButtonSection() {
    return TriggerOptionCard(
      title: 'Volume Button Combination',
      description:
          'Use hardware button combinations to trigger emergency alert',
      icon: 'volume_up',
      isEnabled: _volumeButtonEnabled,
      onToggle: (value) {
        setState(() {
          _volumeButtonEnabled = value;
        });
        _showToggleConfirmation('Volume Button Combination', value);
      },
      child: Column(
        children: [
          if (_volumeButtonEnabled) ...[
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Combination:',
                    style: AppTheme.lightTheme.textTheme.titleSmall,
                  ),
                  SizedBox(height: 1.h),
                  ..._volumeCombinations.map((combo) => RadioListTile<String>(
                        title: Text(
                          combo,
                          style: AppTheme.lightTheme.textTheme.bodyMedium,
                        ),
                        value: combo,
                        groupValue: _selectedVolumeCombo,
                        onChanged: (value) {
                          setState(() {
                            _selectedVolumeCombo = value!;
                          });
                        },
                        contentPadding: EdgeInsets.zero,
                      )),
                ],
              ),
            ),
            SizedBox(height: 2.h),
            TestTriggerButton(
              label: 'Test Volume Combination',
              isLoading: _isTestingVolume,
              onPressed: () => _testVolumeDetection(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPracticeModeSection() {
    return PracticeModeToggle(
      isEnabled: _practiceMode,
      onToggle: (value) {
        setState(() {
          _practiceMode = value;
        });
        _showPracticeModeInfo(value);
      },
    );
  }

  Widget _buildAccelerometerVisualization() {
    return Container(
      height: 15.h,
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Shake Detection Active',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.lightTheme.colorScheme.primary,
            ),
          ),
          SizedBox(height: 1.h),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomIconWidget(
                    iconName: 'vibration',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    size: 32,
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'Shake your device now...',
                    style: AppTheme.lightTheme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, '/main-dashboard'),
            style: AppTheme.lightTheme.elevatedButtonTheme.style,
            child: Text('Continue to Dashboard'),
          ),
        ),
        SizedBox(height: 2.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () =>
                Navigator.pushNamed(context, '/voice-trigger-setup'),
            style: AppTheme.lightTheme.outlinedButtonTheme.style,
            child: Text('Back to Voice Setup'),
          ),
        ),
      ],
    );
  }

  void _showToggleConfirmation(String triggerType, bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$triggerType ${enabled ? 'enabled' : 'disabled'} successfully',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: enabled
            ? AppTheme.lightTheme.colorScheme.primary
            : AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showPracticeModeInfo(bool enabled) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          enabled
              ? 'Practice mode enabled - No real alerts will be sent'
              : 'Practice mode disabled - Real alerts will be sent',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        backgroundColor: enabled
            ? AppTheme.warningLight
            : AppTheme.lightTheme.colorScheme.primary,
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _testShakeDetection() async {
    setState(() {
      _isTestingShake = true;
    });

    // Simulate shake detection test
    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isTestingShake = false;
    });

    _showTestResult('Shake Detection', true);
  }

  Future<void> _testBackTapDetection() async {
    setState(() {
      _isTestingBackTap = true;
    });

    // Simulate back-tap detection test
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isTestingBackTap = false;
    });

    _showTestResult('Back-Tap Detection', true);
  }

  Future<void> _testVolumeDetection() async {
    setState(() {
      _isTestingVolume = true;
    });

    // Simulate volume button detection test
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isTestingVolume = false;
    });

    _showTestResult('Volume Button Combination', true);
  }

  void _showTestResult(String triggerType, bool success) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Row(
          children: [
            CustomIconWidget(
              iconName: success ? 'check_circle' : 'error',
              color: success ? AppTheme.successLight : AppTheme.errorLight,
              size: 24,
            ),
            SizedBox(width: 2.w),
            Text(
              success ? 'Test Successful' : 'Test Failed',
              style: AppTheme.lightTheme.textTheme.titleMedium,
            ),
          ],
        ),
        content: Text(
          _practiceMode
              ? '$triggerType test completed successfully. No real alert was sent due to practice mode.'
              : '$triggerType test completed successfully. In real scenarios, this would trigger an emergency alert.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _openSystemSettings() {
    // In a real app, this would open iOS Settings
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Opening iOS Settings... Navigate to Accessibility > Touch > Back Tap',
          style: AppTheme.lightTheme.snackBarTheme.contentTextStyle,
        ),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.lightTheme.dialogBackgroundColor,
        title: Text(
          'Alternative Triggers Help',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Alternative triggers provide backup methods to activate emergency alerts:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              _buildHelpItem(
                  'Triple Shake', 'Shake your phone three times quickly'),
              _buildHelpItem('Back-Tap',
                  'Tap the back of your phone three times (iOS only)'),
              _buildHelpItem(
                  'Volume Buttons', 'Use hardware button combinations'),
              SizedBox(height: 2.h),
              Text(
                'Practice Mode allows you to test triggers without sending real alerts.',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Got it'),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomIconWidget(
            iconName: 'circle',
            color: AppTheme.lightTheme.colorScheme.primary,
            size: 8,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
