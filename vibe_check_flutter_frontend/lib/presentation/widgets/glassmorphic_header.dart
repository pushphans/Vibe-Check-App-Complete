import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/colors/app_colors.dart';
import '../providers/style_provider.dart';

class GlassmorphicHeader extends StatelessWidget {
  const GlassmorphicHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<StyleProvider>();
    final result = provider.result;
    final showVibe = provider.state == AnalysisState.success && result != null;

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
                  child: Icon(Icons.track_changes, color: AppColors.accent),
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
            if (showVibe)
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
                      'Vibe: ${result.vibeScore}',
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