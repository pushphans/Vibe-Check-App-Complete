import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../providers/style_provider.dart';
import 'widgets/glassmorphic_header.dart';
import 'widgets/style_input_zone.dart';
import 'widgets/recommendation_bento_grid.dart';

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
            const StyleInputZone(),
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