import 'package:flutter/material.dart';
import '../colors/app_colors.dart';

class AppTheme {
  static Color background(bool isDark) => 
    isDark ? AppColors.darkBackground : AppColors.lightBackground;
  
  static Color surface(bool isDark) => 
    isDark ? AppColors.darkSurface : AppColors.lightSurface;
  
  static Color darkShadow(bool isDark) => 
    isDark ? AppColors.darkDarkShadow : AppColors.lightDarkShadow;
  
  static Color lightShadow(bool isDark) => 
    isDark ? AppColors.darkLightShadow : AppColors.lightLightShadow;
  
  static Color textPrimary(bool isDark) => 
    isDark ? Colors.white : const Color(0xFF2D3436);
  
  static Color textSecondary(bool isDark) => 
    isDark ? const Color(0xFFB0B0B0) : const Color(0xFF636E72);
  
  static Color accent(bool isDark) => 
    isDark ? AppColors.accent : AppColors.accentLight;

  static List<BoxShadow> neumorphicRaised(bool isDark) => [
    BoxShadow(
      color: lightShadow(isDark),
      offset: const Offset(-6, -6),
      blurRadius: 12,
    ),
    BoxShadow(
      color: darkShadow(isDark),
      offset: const Offset(6, 6),
      blurRadius: 12,
    ),
  ];

  static List<BoxShadow> neumorphicPressed(bool isDark) => [
    BoxShadow(
      color: darkShadow(isDark).withValues(alpha: 0.5),
      offset: const Offset(-2, -2),
      blurRadius: 4,
    ),
    BoxShadow(
      color: lightShadow(isDark).withValues(alpha: 0.7),
      offset: const Offset(2, 2),
      blurRadius: 4,
    ),
  ];

  static List<BoxShadow> neumorphicSmall(bool isDark) => [
    BoxShadow(
      color: lightShadow(isDark),
      offset: const Offset(-4, -4),
      blurRadius: 8,
    ),
    BoxShadow(
      color: darkShadow(isDark),
      offset: const Offset(4, 4),
      blurRadius: 8,
    ),
  ];

  static ThemeData light() => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    primaryColor: AppColors.accent,
    colorScheme: const ColorScheme.light(
      primary: AppColors.accent,
      surface: AppColors.lightSurface,
    ),
  );

  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    primaryColor: AppColors.accent,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.accent,
      surface: AppColors.darkSurface,
    ),
  );
}