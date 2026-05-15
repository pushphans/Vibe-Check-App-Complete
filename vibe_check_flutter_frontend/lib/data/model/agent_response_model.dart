class AgentResponseModel {
  int vibeScore;
  int fitScore;
  String verdict;
  List<String> dominantColors;
  String quickFix;

  AgentResponseModel({
    required this.vibeScore,
    required this.fitScore,
    required this.verdict,
    required this.dominantColors,
    required this.quickFix,
  });

  AgentResponseModel copyWith({
    int? vibeScore,
    int? fitScore,
    String? verdict,
    List<String>? dominantColors,
    String? quickFix,
  }) => AgentResponseModel(
    vibeScore: vibeScore ?? this.vibeScore,
    fitScore: fitScore ?? this.fitScore,
    verdict: verdict ?? this.verdict,
    dominantColors: dominantColors ?? this.dominantColors,
    quickFix: quickFix ?? this.quickFix,
  );

  factory AgentResponseModel.fromMap(Map<String, dynamic> json) =>
      AgentResponseModel(
        vibeScore: json["vibeScore"],
        fitScore: json["fitScore"],
        verdict: json["verdict"],
        dominantColors: List<String>.from(json["dominantColors"].map((x) => x)),
        quickFix: json["quickFix"],
      );

  Map<String, dynamic> toMap() => {
    "vibeScore": vibeScore,
    "fitScore": fitScore,
    "verdict": verdict,
    "dominantColors": List<dynamic>.from(dominantColors.map((x) => x)),
    "quickFix": quickFix,
  };
}
