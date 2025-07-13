import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late AnimationController _loadingAnimationController;
  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitializing = true;
  String _initializationStatus = 'Initializing safety services...';
  double _initializationProgress = 0.0;

  // Mock user data for navigation logic
  final Map<String, dynamic> _mockUserData = {
    'isAuthenticated': false,
    'hasEmergencyContacts': false,
    'isFirstTime': true,
    'voiceSetupComplete': false,
    'alternativeTriggersSetup': false,
  };

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    _logoAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _loadingAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoAnimationController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingAnimationController,
      curve: Curves.easeInOut,
    ));

    _logoAnimationController.forward();
  }

  Future<void> _initializeApp() async {
    try {
      // Hide system status bar for immersive experience
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

      // Simulate initialization steps
      await _performInitializationSteps();

      // Determine navigation path based on user state
      await _navigateToNextScreen();
    } catch (e) {
      _handleInitializationError(e.toString());
    }
  }

  Future<void> _performInitializationSteps() async {
    final List<Map<String, dynamic>> initSteps = [
      {
        'message': 'Checking authentication status...',
        'duration': 400,
        'progress': 0.2,
      },
      {
        'message': 'Loading emergency contacts...',
        'duration': 500,
        'progress': 0.4,
      },
      {
        'message': 'Initializing voice recognition...',
        'duration': 600,
        'progress': 0.6,
      },
      {
        'message': 'Preparing GPS services...',
        'duration': 500,
        'progress': 0.8,
      },
      {
        'message': 'Finalizing setup...',
        'duration': 400,
        'progress': 1.0,
      },
    ];

    _loadingAnimationController.forward();

    for (final step in initSteps) {
      if (mounted) {
        setState(() {
          _initializationStatus = step['message'] as String;
          _initializationProgress = step['progress'] as double;
        });

        await Future.delayed(Duration(milliseconds: step['duration'] as int));
      }
    }

    if (mounted) {
      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Ready!';
      });
    }

    await Future.delayed(const Duration(milliseconds: 500));
  }

  Future<void> _navigateToNextScreen() async {
    if (!mounted) return;

    // Restore system UI before navigation
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    String nextRoute;

    // Navigation logic based on user state
    if (_mockUserData['isFirstTime'] == true) {
      nextRoute = '/user-registration';
    } else if (_mockUserData['isAuthenticated'] == false) {
      nextRoute = '/user-registration';
    } else if (_mockUserData['hasEmergencyContacts'] == false) {
      nextRoute = '/emergency-contacts-management';
    } else if (_mockUserData['voiceSetupComplete'] == false) {
      nextRoute = '/voice-trigger-setup';
    } else if (_mockUserData['alternativeTriggersSetup'] == false) {
      nextRoute = '/alternative-triggers-setup';
    } else {
      nextRoute = '/main-dashboard';
    }

    // Smooth transition to next screen
    await Future.delayed(const Duration(milliseconds: 300));

    if (mounted) {
      Navigator.pushReplacementNamed(context, nextRoute);
    }
  }

  void _handleInitializationError(String error) {
    if (mounted) {
      setState(() {
        _isInitializing = false;
        _initializationStatus = 'Initialization failed';
      });

      _showErrorDialog(error);
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Initialization Error',
            style: AppTheme.lightTheme.textTheme.titleLarge,
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Failed to initialize safety services:',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
              SizedBox(height: 2.h),
              Text(
                error,
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.error,
                ),
              ),
              SizedBox(height: 3.h),
              Text(
                'Please check your permissions and try again.',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryInitialization();
              },
              child: const Text('Retry'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _navigateToNextScreen();
              },
              child: const Text('Continue'),
            ),
          ],
        );
      },
    );
  }

  void _retryInitialization() {
    setState(() {
      _isInitializing = true;
      _initializationStatus = 'Retrying initialization...';
      _initializationProgress = 0.0;
    });

    _logoAnimationController.reset();
    _loadingAnimationController.reset();
    _logoAnimationController.forward();
    _initializeApp();
  }

  @override
  void dispose() {
    _logoAnimationController.dispose();
    _loadingAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1),
              AppTheme.lightTheme.colorScheme.surface,
              AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.05),
            ],
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                flex: 3,
                child: Center(
                  child: AnimatedBuilder(
                    animation: _logoAnimationController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _logoFadeAnimation,
                        child: ScaleTransition(
                          scale: _logoScaleAnimation,
                          child: _buildAppLogo(),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildLoadingIndicator(),
                      SizedBox(height: 3.h),
                      _buildStatusText(),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 4.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppLogo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 25.w,
          height: 25.w,
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.colorScheme.primary,
            borderRadius: BorderRadius.circular(4.w),
            boxShadow: [
              BoxShadow(
                color: AppTheme.lightTheme.colorScheme.primary
                    .withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: 'security',
              color: AppTheme.lightTheme.colorScheme.onPrimary,
              size: 12.w,
            ),
          ),
        ),
        SizedBox(height: 3.h),
        Text(
          'Silent Help',
          style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppTheme.lightTheme.colorScheme.primary,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          'Your Personal Safety Companion',
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        Container(
          width: 60.w,
          height: 0.8.h,
          decoration: BoxDecoration(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(0.4.h),
          ),
          child: AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _initializationProgress,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppTheme.lightTheme.colorScheme.primary,
                        AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(0.4.h),
                  ),
                ),
              );
            },
          ),
        ),
        SizedBox(height: 1.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(_initializationProgress * 100).toInt()}%',
              style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (_isInitializing)
              SizedBox(
                width: 4.w,
                height: 4.w,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppTheme.lightTheme.colorScheme.primary,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusText() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: Text(
        _initializationStatus,
        key: ValueKey(_initializationStatus),
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color:
              AppTheme.lightTheme.colorScheme.onSurface.withValues(alpha: 0.8),
          fontWeight: FontWeight.w500,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
