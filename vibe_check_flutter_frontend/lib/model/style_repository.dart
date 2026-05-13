import 'style_result.dart';

class StyleRepository {
  Future<StyleResult> analyzeStyle(String imagePath) async {
    await Future.delayed(const Duration(seconds: 2));
    return const StyleResult(
      fitScore: 87,
      verdict: 'This outfit complements your oval face shape perfectly. The neckline creates a balanced silhouette.',
      complementaryColors: ['#00F2FF', '#FF6B6B', '#4ECDC4'],
      quickFix: 'Consider adding a silver chain to enhance the look further.',
    );
  }
}