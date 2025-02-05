import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

import 'package:tontiflex/routes/app_router.dart';
import 'package:tontiflex/utility/shareprferences.dart';

import 'database/user_db/user_controller.dart';
@RoutePage(name: 'SplashScreenRoute')
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  CustomSharePreference prefs = CustomSharePreference();
  final log = Logger();

  void checkToken() async {
    try {
      String? token = await prefs.getPreferenceValue("user");

      if (token != null) {
        final userController = context.read<UserController>();
        await userController.initializeCurrentUser();
        log.e(userController.currentUser?.userId);
        log.e('Token exists, navigating to EntryPointRoute');
        AutoRouter.of(context).replace(EntryPointRoute());
      } else {
        log.e('No token found, navigating to OnboardingScreenRoute');
        AutoRouter.of(context).replace(OnboardingScreenRoute());
      }
    } catch (e) {
      log.e('Error checking token: $e');
      AutoRouter.of(context).replace(OnboardingScreenRoute());
    }
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000), // Reduced duration
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _controller.forward();

    Timer(Duration(seconds: 2), () {
      checkToken();
    });
  }

  Widget _buildSplashContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'TontiFlex',
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Shared Futures, Shared Rewards.',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.blue,
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: _buildSplashContent(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}