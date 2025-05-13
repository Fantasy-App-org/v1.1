class FullScorecard {
  String? id;
  int matchId;
  Map<String, dynamic> scoreCard;

  FullScorecard({
    this.id,
    required this.matchId,
    required this.scoreCard,
  });

  factory FullScorecard.fromJson(Map<String, dynamic> json) {
    return FullScorecard(
      id: json['id']?.toString(),
      matchId: json['match_id'],
      scoreCard: json['score_card'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_id': matchId,
      'score_card': scoreCard,
    };
  }
}