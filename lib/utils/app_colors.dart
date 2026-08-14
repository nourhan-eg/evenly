import 'package:flutter/material.dart';

abstract class AppColors {
  Color primaryColor();
  Color backgroundColor();
}

class LightModeColors implements AppColors {
  @override
  Color primaryColor() => const Color(0xFF0E3A99);

  @override
  Color backgroundColor() => const Color(0xFFF4F7FF);
}

class DarkModeColors implements AppColors {
  @override
  Color primaryColor() => const Color(0xFF457AED);

  @override
  Color backgroundColor() => const Color(0xFF000F30);
}