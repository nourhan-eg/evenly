import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/features/onboarding/onboarding_screen.dart';
import 'package:evently_app/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/theme_provider.dart';

class OnboardingIntroScreen extends StatelessWidget {
  const OnboardingIntroScreen({super.key});

  static const routeName = "on boarding route";

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    var primaryColor = Theme.of(context).primaryColor;
    var scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    var isDark = Theme.of(context).brightness == Brightness.dark;
    var labelColor = isDark ? Colors.white : primaryColor;

    var isEnglishSelected = context.locale.languageCode == 'en';
    var isLightSelected = provider.themeMode == ThemeMode.light;

    var eventlyTopLogo = isDark
        ? AppImagesDarkMode.eventlyTop
        : AppImagesWhiteMode.eventlyTop;
    var welcomeImage = isDark
        ? AppImagesDarkMode.onboardingWelcome
        : AppImagesWhiteMode.onboardingWelcome;
    var moonImage = isDark
        ? AppImagesDarkMode.moonIcon
        : AppImagesWhiteMode.moonIcon;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(eventlyTopLogo),
              SizedBox(height: 24),
              Image.asset(welcomeImage),
              SizedBox(height: 24),
              Text(
                "onboarding_1_title".tr(),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: 8),
              Text(
                "onboarding_1_desc".tr(),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 18),
              Row(
                children: [
                  Text(
                    "language_label".tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: labelColor),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      context.setLocale(Locale('en'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnglishSelected ? primaryColor : scaffoldColor,
                    ),
                    child: Text(
                        "English".tr(),
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: isEnglishSelected ? Colors.white : labelColor,
                        )
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      context.setLocale(Locale('ar'));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isEnglishSelected ? primaryColor : scaffoldColor,
                    ),
                    child: Text(
                        "Arabic".tr(),
                        style:Theme.of(context).textTheme.titleSmall?.copyWith(
                          color: !isEnglishSelected ? Colors.white : labelColor,
                        )
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Text(
                    "theme_label".tr(),
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: labelColor),
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      provider.changeTheme(ThemeMode.light);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isLightSelected ? primaryColor : scaffoldColor,
                    ),
                    child: Image.asset(AppImagesWhiteMode.sunIcon),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      provider.changeTheme(ThemeMode.dark);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isLightSelected ? primaryColor : scaffoldColor,
                    ),
                    child: Image.asset(moonImage),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, OnboardingScreen.routeName);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(top: 16, bottom: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "lets_start".tr(),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white, fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}