import 'package:flutter/material.dart';
import '../../utils/app_images.dart';
import '../onboarding/onboarding_intro_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  static const routeName = "splash route";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingIntroScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final eventlyLogo = isDark
        ? AppImagesDarkMode.eventlyLogo
        : AppImagesWhiteMode.eventlyLogo;
    final routeLogoWithSupervisor = isDark
        ? AppImagesDarkMode.routeLogoWithSupervisor
        : AppImagesWhiteMode.routeLogoWithSupervisor;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),
            Center(
              child: Image.asset(
                eventlyLogo,
                width: 309,
                height: 58,
              ),
            ),
            const Spacer(flex: 3),
            Image.asset(
              routeLogoWithSupervisor,
              width: 214,
            ),
          ],
        ),
      ),
    );
  }
}