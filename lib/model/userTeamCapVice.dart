class CaptainViceCaptain {
  String? id;
  int? sportsId;
  int? matchId;
  int? userId;
  int? captainId;
  int? viceCaptainId;

  CaptainViceCaptain({
    this.id,
    this.sportsId,
    this.matchId,
    this.userId,
    this.captainId,
    this.viceCaptainId,
  });

  factory CaptainViceCaptain.fromJson(Map<String, dynamic> json) {
    return CaptainViceCaptain(
      id: json['id']?.toString(),
      sportsId: json['sports_id'],
      matchId: json['match_id'],
      userId: json['user_id'],
      captainId: json['captain_id'],
      viceCaptainId: json['viceCaptain_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sports_id': sportsId,
      'match_id': matchId,
      'user_id': userId,
      'captain_id': captainId,
      'viceCaptain_id': viceCaptainId,
    };
  }
}