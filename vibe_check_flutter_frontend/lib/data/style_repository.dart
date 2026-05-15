import 'repository/vibe_repo.dart';
import 'style_result.dart';

class StyleRepository {
  final VibeRepo _vibeRepo = VibeRepo();

  Future<StyleResult> analyzeStyle(String imagePath) async {
    final model = await _vibeRepo.analyze(imagePath);
    return StyleResult(
      vibeScore: model.vibeScore,
      fitScore: model.fitScore,
      verdict: model.verdict,
      complementaryColors: model.dominantColors,
      quickFix: model.quickFix,
    );
  }
}
