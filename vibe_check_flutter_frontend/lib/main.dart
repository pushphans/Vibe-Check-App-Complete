import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/theme/app_theme.dart';
import 'core/colors/app_colors.dart';
import 'model/style_repository.dart';
import 'presentation/providers/style_provider.dart';
import 'presentation/providers/theme_provider.dart';
import 'presentation/ui/home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => StyleProvider(StyleRepository())),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'VibeCheck 2026',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light().copyWith(
              textTheme: GoogleFonts.lexendTextTheme(
                AppTheme.light().textTheme,
              ).apply(
                bodyColor: AppColors.lightBackground,
                displayColor: AppColors.lightBackground,
              ),
            ),
            darkTheme: AppTheme.dark().copyWith(
              textTheme: GoogleFonts.lexendTextTheme(
                AppTheme.dark().textTheme,
              ).apply(
                bodyColor: Colors.white,
                displayColor: Colors.white,
              ),
            ),
            themeMode: _getThemeMode(themeProvider.themeMode),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }

  ThemeMode _getThemeMode(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }
}