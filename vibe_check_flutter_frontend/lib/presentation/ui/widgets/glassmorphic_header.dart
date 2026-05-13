import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/colors/app_colors.dart';

class GlassmorphicHeader extends StatelessWidget {
  const GlassmorphicHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppTheme.background(isDark),
        boxShadow: AppTheme.neumorphicSmall(isDark),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppTheme.background(isDark),
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.neumorphicPressed(isDark),
                  ),
                  child: Icon(Icons.person, color: AppTheme.textSecondary(isDark)),
                ),
                const SizedBox(width: 14),
                Text(
                  'VibeCheck',
                  style: TextStyle(
                    color: AppTheme.textPrimary(isDark),
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.background(isDark),
                borderRadius: BorderRadius.circular(25),
                boxShadow: AppTheme.neumorphicPressed(isDark),
              ),
              child: Row(
                children: [
                  Icon(Icons.bolt, color: AppColors.accent, size: 18),
                  const SizedBox(width: 6),
                  Text(
                    'Vibe: 92',
                    style: TextStyle(
                      color: AppTheme.textPrimary(isDark),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}