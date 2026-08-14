import 'package:easy_localization/easy_localization.dart';
import 'package:evently_app/features/onboarding/onboarding_intro_screen.dart';
import 'package:evently_app/features/onboarding/onboarding_screen.dart';
import 'package:evently_app/features/splash_screen/splash_screen.dart';
import 'package:evently_app/providers/theme_provider.dart';
import 'package:evently_app/utils/my_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: Locale('en'),
      child: ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
          child: const MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      theme: MyThemeData.lightMode,
      darkTheme: MyThemeData.darkMode,
      themeMode: provider.themeMode,
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (context) => SplashScreen(),
        OnboardingIntroScreen.routeName: (context) => OnboardingIntroScreen(),
        OnboardingScreen.routeName: (context) => const OnboardingScreen(),
      },
    );
  }
}
