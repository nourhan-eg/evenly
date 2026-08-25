import 'package:flutter/material.dart';

abstract class AppColors {
  Color primaryColor();
  Color backgroundColor();
  Color darkFormColor();
}

class LightModeColors implements AppColors {
  @override
  Color primaryColor() => const Color(0xFF0E3A99);

  @override
  Color backgroundColor() => const Color(0xFFF4F7FF);

  @override
  Color darkFormColor() => const Color(0xFF002D8F);
}

class DarkModeColors implements AppColors {
  @override
  Color primaryColor() => const Color(0xFF5687F0);

  @override
  Color backgroundColor() => const Color(0xFF000F30);

  @override
  Color darkFormColor() => const Color(0xFF002D8F);
}