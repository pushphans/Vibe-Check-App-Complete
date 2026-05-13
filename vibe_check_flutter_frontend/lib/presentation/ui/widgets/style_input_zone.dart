import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/colors/app_colors.dart';
import '../../providers/style_provider.dart';

class StyleInputZone extends StatefulWidget {
  const StyleInputZone({super.key});

  @override
  State<StyleInputZone> createState() => _StyleInputZoneState();
}

class _StyleInputZoneState extends State<StyleInputZone> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<StyleProvider>();
    final isProcessing = provider.state == AnalysisState.processing;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        if (!isProcessing) {
          context.read<StyleProvider>().analyzeImage('mock_path');
        }
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppTheme.background(isDark),
          borderRadius: BorderRadius.circular(24),
          boxShadow: _isPressed
              ? AppTheme.neumorphicPressed(isDark)
              : AppTheme.neumorphicRaised(isDark),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Center(
              child: isProcessing
                  ? _buildProcessingState(isDark)
                  : _buildIdleState(isDark),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIdleState(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.background(isDark),
            shape: BoxShape.circle,
            boxShadow: AppTheme.neumorphicSmall(isDark),
          ),
          child: Icon(
            Icons.add_photo_alternate_outlined,
            size: 44,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Drop your photo or outfit image',
          style: TextStyle(
            color: AppTheme.textSecondary(isDark),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        _NeuButton(isDark: isDark),
      ],
    );
  }

  Widget _buildProcessingState(bool isDark) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.background(isDark),
            shape: BoxShape.circle,
            boxShadow: AppTheme.neumorphicSmall(isDark),
          ),
          child: SizedBox(
            width: 44,
            height: 44,
            child: CircularProgressIndicator(
              color: AppColors.accent,
              strokeWidth: 3,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Scanning Vibe...',
          style: TextStyle(color: AppTheme.textSecondary(isDark), fontSize: 15),
        ),
      ],
    );
  }
}

class _NeuButton extends StatefulWidget {
  final bool isDark;
  const _NeuButton({required this.isDark});

  @override
  State<_NeuButton> createState() => _NeuButtonState();
}

class _NeuButtonState extends State<_NeuButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        context.read<StyleProvider>().analyzeImage('mock_path');
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.background(widget.isDark),
          borderRadius: BorderRadius.circular(30),
          boxShadow: _isPressed
              ? AppTheme.neumorphicPressed(widget.isDark)
              : AppTheme.neumorphicSmall(widget.isDark),
        ),
        child: Text(
          'Scan Vibe',
          style: TextStyle(
            color: AppColors.accent,
            fontWeight: FontWeight.w700,
            fontSize: 15,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }
}