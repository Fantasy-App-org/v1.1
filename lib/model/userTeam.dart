class UserTeam {
  String? id;
  int? sportsId;
  int? userId;
  int? matchId;
  int? playerId;
  int? teamId;
  int? teamCount;

  UserTeam({
    this.id,
    this.sportsId,
    this.userId,
    this.matchId,
    this.playerId,
    this.teamId,
    this.teamCount,
  });

  factory UserTeam.fromJson(Map<String, dynamic> json) {
    return UserTeam(
      id: json['id']?.toString(),
      sportsId: json['sports_id'],
      userId: json['user_id'],
      matchId: json['match_id'],
      playerId: json['player_id'],
      teamId: json['team_id'],
      teamCount: json['team_count'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sports_id': sportsId,
      'user_id': userId,
      'match_id': matchId,
      'player_id': playerId,
      'team_id': teamId,
      'team_count': teamCount,
    };
  }
}