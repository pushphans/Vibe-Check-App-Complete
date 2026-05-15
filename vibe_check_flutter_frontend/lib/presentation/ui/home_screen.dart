import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/colors/app_colors.dart';
import '../providers/style_provider.dart';
import '../widgets/glassmorphic_header.dart';
import '../widgets/style_input_zone.dart';
import '../widgets/recommendation_bento_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppTheme.background(isDark),
      body: SafeArea(
        child: Column(
          children: [
            const GlassmorphicHeader(),
            const SizedBox(height: 28),
            Consumer<StyleProvider>(
              builder: (context, provider, _) {
                if (provider.imageUrl != null) {
                  return _SelectedImageCard(
                    dataUrl: provider.imageUrl!,
                    isDark: isDark,
                    onRetake: () => provider.reset(),
                  );
                }
                return const StyleInputZone();
              },
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Consumer<StyleProvider>(
                builder: (context, provider, _) {
                  if (provider.state == AnalysisState.success &&
                      provider.result != null) {
                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: RecommendationBentoGrid(result: provider.result!),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectedImageCard extends StatelessWidget {
  final String dataUrl;
  final bool isDark;
  final VoidCallback onRetake;

  const _SelectedImageCard({
    required this.dataUrl,
    required this.isDark,
    required this.onRetake,
  });

  Uint8List _dataUrlToBytes(String url) {
    final parts = url.split(',');
    return base64Decode(parts.length > 1 ? parts[1] : parts[0]);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: 220,
              child: Image.memory(
                _dataUrlToBytes(dataUrl),
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 12,
              right: 12,
              child: GestureDetector(
                onTap: onRetake,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.background(isDark).withValues(alpha: 0.85),
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.neumorphicSmall(isDark),
                  ),
                  child: Icon(
                    Icons.swap_horiz_rounded,
                    color: AppColors.accent,
                    size: 22,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}