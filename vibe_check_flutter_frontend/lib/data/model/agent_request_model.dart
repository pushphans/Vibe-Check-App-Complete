class AgentRequestModel {
  String imageUrl;

  AgentRequestModel({required this.imageUrl});

  AgentRequestModel copyWith({String? imageUrl}) =>
      AgentRequestModel(imageUrl: imageUrl ?? this.imageUrl);

  factory AgentRequestModel.fromMap(Map<String, dynamic> json) =>
      AgentRequestModel(imageUrl: json["imageUrl"]);

  Map<String, dynamic> toMap() => {"imageUrl": imageUrl};
}
