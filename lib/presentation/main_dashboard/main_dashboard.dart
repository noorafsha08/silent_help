import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/battery_warning_widget.dart';
import './widgets/emergency_contacts_summary_widget.dart';
import './widgets/monitoring_status_widget.dart';
import './widgets/quick_actions_widget.dart';
import './widgets/recent_activity_widget.dart';
import './widgets/status_card_widget.dart';
import './widgets/test_alert_button_widget.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isProtected = true;
  bool _voiceListening = true;
  bool _shakeDetection = false;
  bool _locationTracking = true;
  bool _batteryOptimizationIssue = true;
  int _emergencyContactsCount = 3;

  // Mock data for recent activity
  final List<Map<String, dynamic>> _recentActivity = [
    {
      "id": 1,
      "type": "test",
      "message": "Test alert sent successfully",
      "timestamp": DateTime.now().subtract(const Duration(hours: 2)),
      "status": "success",
      "icon": "check_circle"
    },
    {
      "id": 2,
      "type": "voice_trigger",
      "message": "Voice trigger activated",
      "timestamp": DateTime.now().subtract(const Duration(days: 1)),
      "status": "success",
      "icon": "mic"
    },
    {
      "id": 3,
      "type": "shake_detection",
      "message": "Shake detection test",
      "timestamp": DateTime.now().subtract(const Duration(days: 2)),
      "status": "failed",
      "icon": "vibration"
    }
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _refreshStatus() async {
    // Simulate refresh delay
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // Update status indicators
    });
  }

  void _showTestAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Test Alert',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Text(
            'This will send a test alert to all your emergency contacts. Continue?',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _sendTestAlert();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
              ),
              child: const Text('Send Test'),
            ),
          ],
        );
      },
    );
  }

  void _sendTestAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Test alert sent to emergency contacts'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Silent Help',
          style: AppTheme.lightTheme.appBarTheme.titleTextStyle,
        ),
        backgroundColor: AppTheme.lightTheme.appBarTheme.backgroundColor,
        elevation: AppTheme.lightTheme.appBarTheme.elevation,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Dashboard'),
            Tab(text: 'History'),
            Tab(text: 'Settings'),
          ],
        ),
      ),
      body: SafeArea(
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildDashboardTab(),
            _buildHistoryTab(),
            _buildSettingsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardTab() {
    return RefreshIndicator(
      onRefresh: _refreshStatus,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StatusCardWidget(
              isProtected: _isProtected,
              lastActivity:
                  DateTime.now().subtract(const Duration(minutes: 15)),
            ),
            SizedBox(height: 3.h),
            MonitoringStatusWidget(
              voiceListening: _voiceListening,
              shakeDetection: _shakeDetection,
              locationTracking: _locationTracking,
              onVoiceToggle: (value) {
                setState(() {
                  _voiceListening = value;
                });
              },
              onShakeToggle: (value) {
                setState(() {
                  _shakeDetection = value;
                });
              },
              onLocationToggle: (value) {
                setState(() {
                  _locationTracking = value;
                });
              },
            ),
            SizedBox(height: 3.h),
            _batteryOptimizationIssue
                ? Column(
                    children: [
                      const BatteryWarningWidget(),
                      SizedBox(height: 3.h),
                    ],
                  )
                : const SizedBox.shrink(),
            EmergencyContactsSummaryWidget(
              contactsCount: _emergencyContactsCount,
              onManagePressed: () {
                Navigator.pushNamed(context, '/emergency-contacts-management');
              },
            ),
            SizedBox(height: 3.h),
            TestAlertButtonWidget(
              onPressed: _showTestAlertDialog,
            ),
            SizedBox(height: 3.h),
            RecentActivityWidget(
              activities: _recentActivity,
            ),
            SizedBox(height: 3.h),
            QuickActionsWidget(
              onUpdateSecretPhrase: () {
                Navigator.pushNamed(context, '/voice-trigger-setup');
              },
              onAddContact: () {
                Navigator.pushNamed(context, '/emergency-contacts-management');
              },
              onViewHelp: () {
                // Navigate to help screen
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'history',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'History',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'View your alert history here',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'settings',
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            size: 64,
          ),
          SizedBox(height: 2.h),
          Text(
            'Settings',
            style: AppTheme.lightTheme.textTheme.headlineSmall,
          ),
          SizedBox(height: 1.h),
          Text(
            'Configure your safety settings here',
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
