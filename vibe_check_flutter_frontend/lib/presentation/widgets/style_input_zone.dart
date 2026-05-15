import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/permissions/app_permissions.dart';
import '../../core/theme/app_theme.dart';
import '../../core/colors/app_colors.dart';
import '../providers/style_provider.dart';

class StyleInputZone extends StatefulWidget {
  const StyleInputZone({super.key});

  @override
  State<StyleInputZone> createState() => _StyleInputZoneState();
}

class _StyleInputZoneState extends State<StyleInputZone> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickFromGallery() async {
    final perms = context.read<AppPermissions>();
    if (!perms.isGalleryGranted()) {
      final granted = await perms.requestGallery();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to open gallery'),
          ),
        );
        return;
      }
    }
    final file = await _picker.pickImage(source: ImageSource.gallery, maxWidth: 1024);
    if (file != null) await _analyzeImage(file);
  }

  Future<void> _pickFromCamera() async {
    final perms = context.read<AppPermissions>();
    if (!perms.isCameraGranted()) {
      final granted = await perms.requestCamera();
      if (!granted && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Camera permission is required to use camera'),
          ),
        );
        return;
      }
    }
    final file = await _picker.pickImage(source: ImageSource.camera, maxWidth: 1024);
    if (file != null) await _analyzeImage(file);
  }

  Future<void> _analyzeImage(XFile file) async {
    final bytes = await file.readAsBytes();
    final base64Str = base64Encode(bytes);
    final mimeType = file.mimeType ?? 'image/jpeg';
    final dataUrl = 'data:$mimeType;base64,$base64Str';
    if (mounted) {
      context.read<StyleProvider>().analyzeImage(dataUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final provider = context.watch<StyleProvider>();
    final isProcessing = provider.state == AnalysisState.processing;

    return Container(
      height: 220,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppTheme.background(isDark),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.neumorphicRaised(isDark),
      ),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.transparent,
            ),
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
            Icons.add_a_photo_outlined,
            size: 44,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Upload or capture your outfit',
          style: TextStyle(
            color: AppTheme.textSecondary(isDark),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NeuButton(
              isDark: isDark,
              icon: Icons.photo_library_outlined,
              label: 'Gallery',
              onTap: _pickFromGallery,
            ),
            const SizedBox(width: 16),
            _NeuButton(
              isDark: isDark,
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              onTap: _pickFromCamera,
            ),
          ],
        ),
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
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _NeuButton({
    required this.isDark,
    required this.icon,
    required this.label,
    required this.onTap,
  });

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
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.background(widget.isDark),
          borderRadius: BorderRadius.circular(30),
          boxShadow: _isPressed
              ? AppTheme.neumorphicPressed(widget.isDark)
              : AppTheme.neumorphicSmall(widget.isDark),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.icon, color: AppColors.accent, size: 18),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w700,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
