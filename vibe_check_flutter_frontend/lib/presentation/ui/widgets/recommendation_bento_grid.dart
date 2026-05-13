import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/colors/app_colors.dart';
import '../../../model/style_result.dart';

class RecommendationBentoGrid extends StatelessWidget {
  final StyleResult result;

  const RecommendationBentoGrid({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        children: [
          _TheVerdict(result: result, isDark: isDark),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _ColorPalette(colors: result.complementaryColors, isDark: isDark)),
              const SizedBox(width: 16),
              Expanded(child: _QuickFix(tip: result.quickFix, isDark: isDark)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TheVerdict extends StatelessWidget {
  final StyleResult result;
  final bool isDark;

  const _TheVerdict({required this.result, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 60 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.background(isDark),
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.neumorphicRaised(isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.background(isDark),
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.neumorphicPressed(isDark),
                  ),
                  child: Icon(Icons.verified, color: AppColors.accent, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'The Verdict',
                  style: TextStyle(
                    color: AppTheme.textPrimary(isDark),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              result.verdict,
              style: TextStyle(
                color: AppTheme.textSecondary(isDark),
                fontSize: 15,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 20),
            _FitScoreCircle(score: result.fitScore, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

class _FitScoreCircle extends StatelessWidget {
  final int score;
  final bool isDark;

  const _FitScoreCircle({required this.score, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: score.toDouble()),
        duration: const Duration(milliseconds: 1500),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppTheme.background(isDark),
              shape: BoxShape.circle,
              boxShadow: AppTheme.neumorphicRaised(isDark),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: CustomPaint(
                    painter: _CircularProgressPainter(value / 100, isDark),
                  ),
                ),
                Text(
                  '${value.toInt()}%',
                  style: TextStyle(
                    color: AppTheme.textPrimary(isDark),
                    fontWeight: FontWeight.w700,
                    fontSize: 22,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _ColorPalette extends StatelessWidget {
  final List<String> colors;
  final bool isDark;

  const _ColorPalette({required this.colors, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.background(isDark),
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.neumorphicRaised(isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.background(isDark),
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.neumorphicPressed(isDark),
                  ),
                  child: Icon(Icons.palette_outlined, color: AppColors.accent, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'Colors',
                  style: TextStyle(
                    color: AppTheme.textPrimary(isDark),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: colors.map((colorHex) {
                return Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _parseColor(colorHex),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _parseColor(colorHex).withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                      BoxShadow(
                        color: AppTheme.lightShadow(isDark),
                        offset: const Offset(-2, -2),
                        blurRadius: 4,
                      ),
                      BoxShadow(
                        color: AppTheme.darkShadow(isDark),
                        offset: const Offset(2, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String hex) {
    return Color(int.parse(hex.replaceFirst('#', '0xFF')));
  }
}

class _QuickFix extends StatelessWidget {
  final String tip;
  final bool isDark;

  const _QuickFix({required this.tip, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 40 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.background(isDark),
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.neumorphicRaised(isDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.background(isDark),
                    shape: BoxShape.circle,
                    boxShadow: AppTheme.neumorphicPressed(isDark),
                  ),
                  child: Icon(Icons.lightbulb_outline, color: AppColors.accent, size: 20),
                ),
                const SizedBox(width: 10),
                Text(
                  'Quick Fix',
                  style: TextStyle(
                    color: AppTheme.textPrimary(isDark),
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              tip,
              style: TextStyle(
                color: AppTheme.textSecondary(isDark),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _CircularProgressPainter(this.progress, this.isDark);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 3;

    final bgPaint = Paint()
      ..color = AppTheme.darkShadow(isDark).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: 3 * math.pi / 2,
        colors: [
          AppColors.accent,
          AppColors.accent.withValues(alpha: 0.6),
        ],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}