class StyleResult {
  final int fitScore;
  final String verdict;
  final List<String> complementaryColors;
  final String quickFix;

  const StyleResult({
    required this.fitScore,
    required this.verdict,
    required this.complementaryColors,
    required this.quickFix,
  });
}