import 'package:flutter/material.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/main_dashboard/main_dashboard.dart';
import '../presentation/alternative_triggers_setup/alternative_triggers_setup.dart';
import '../presentation/user_registration/user_registration.dart';
import '../presentation/voice_trigger_setup/voice_trigger_setup.dart';
import '../presentation/emergency_contacts_management/emergency_contacts_management.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String splashScreen = '/splash-screen';
  static const String mainDashboard = '/main-dashboard';
  static const String alternativeTriggersSetup = '/alternative-triggers-setup';
  static const String userRegistration = '/user-registration';
  static const String voiceTriggerSetup = '/voice-trigger-setup';
  static const String emergencyContactsManagement =
      '/emergency-contacts-management';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const SplashScreen(),
    splashScreen: (context) => const SplashScreen(),
    mainDashboard: (context) => const MainDashboard(),
    alternativeTriggersSetup: (context) => const AlternativeTriggersSetup(),
    userRegistration: (context) => const UserRegistration(),
    voiceTriggerSetup: (context) => const VoiceTriggerSetup(),
    emergencyContactsManagement: (context) =>
        const EmergencyContactsManagement(),
    // TODO: Add your other routes here
  };
}
