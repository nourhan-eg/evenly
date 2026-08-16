import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/utils/app_images.dart';
import 'package:flutter/material.dart';

import '../login/login.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String routeName = 'onboarding_screen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onFinish();
    }
  }

  void _previousPage() {
    if (_currentIndex == 0) {
      Navigator.pop(context);
    } else {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skip() {
    _pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onFinish() {
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness == Brightness.dark;
    var primaryColor = Theme.of(context).primaryColor;

    final List<Map<String, String>> pages = [
      {
        'title': 'onboarding_2_title',
        'desc': 'onboarding_2_desc',
        'image': isDark
            ? AppImagesDarkMode.onboardingLikes
            : AppImagesWhiteMode.onboardingLikes,
      },
      {
        'title': 'onboarding_3_title',
        'desc': 'onboarding_3_desc',
        'image': isDark
            ? AppImagesDarkMode.onboardingPlanning
            : AppImagesWhiteMode.onboardingPlanning,
      },
      {
        'title': 'onboarding_4_title',
        'desc': 'onboarding_4_desc',
        'image': isDark
            ? AppImagesDarkMode.onboardingSocialMedia
            : AppImagesWhiteMode.onboardingSocialMedia,
      },
    ];

    var eventlyTopLogo = isDark
        ? AppImagesDarkMode.eventlyTop
        : AppImagesWhiteMode.eventlyTop;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            children: [
              // Top Header Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Back button
                  _currentIndex >= 0
                      ? IconButton(
                          onPressed: _previousPage,
                          icon: Icon(
                            Icons.arrow_back_ios_new,
                            color: primaryColor,
                            size: 20,
                          ),
                        )
                      : const SizedBox(width: 48, height: 48),

                  // Logo
                  Image.asset(
                    eventlyTopLogo,
                    height: 24,
                  ),

                  // Skip button
                  _currentIndex < 2
                      ? TextButton(
                          onPressed: _skip,
                          style: TextButton.styleFrom(
                            backgroundColor: isDark
                                ? Colors.white.withOpacity(0.1)
                                : primaryColor.withOpacity(0.08),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                          ),
                          child: Text(
                            "skip".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  color: primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        )
                      : const SizedBox(width: 48, height: 48),
                ],
              ),
              const SizedBox(height: 16),

              // PageView content
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: pages.length,
                  itemBuilder: (context, index) {
                    final item = pages[index];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 5,
                          child: Container(
                            alignment: Alignment.center,
                            child: ClipRect(
                              child: Align(
                                alignment: Alignment.topCenter,
                                heightFactor: 0.86,
                                child: Image.asset(
                                  item['image']!,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Page Indicator Dots
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (dotIndex) {
                            bool isActive = _currentIndex == dotIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 250),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              height: 8,
                              width: isActive ? 18 : 8,
                              decoration: BoxDecoration(
                                color: isActive
                                    ? primaryColor
                                    : (isDark
                                        ? Colors.grey.shade700
                                        : Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          item['title']!.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                        ),
                        const SizedBox(height: 12),

                        // Description
                        Text(
                          item['desc']!.tr(),
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontSize: 14,
                                height: 1.4,
                              ),
                        ),
                        const Spacer(),

                        // Bottom Navigation Button
                        ElevatedButton(
                          onPressed: _nextPage,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            _currentIndex == 2
                                ? "get_started".tr()
                                : "next".tr(),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
