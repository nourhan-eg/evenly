import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/features/login/forget_password/forget_password_form.dart';
import 'package:flutter/material.dart';
import '../../../utils/app_images.dart';

class ForgetPasswordScreen extends StatelessWidget {
  static const String routeName = "forget_password";
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    final illustration = isDark
        ? AppImagesDarkMode.onboardingSettings
        : AppImagesWhiteMode.onboardingSettings;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: primaryColor,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "forget_password_title".tr(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDark ? Colors.white : Colors.black87,
              ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Center(
                child: Image.asset(
                  illustration,
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height * 0.32,
                ),
              ),
              const SizedBox(height: 24),
              const ForgetPasswordForm(),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
