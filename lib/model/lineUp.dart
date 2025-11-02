class Lineup {
  String? id;
  int? mId;
  String? teamType;
  int? teamId;
  String? teamName;
  int? playerId;
  String? playerName;
  String? playerType;
  bool? isPlaying;

  Lineup({
    this.id,
    this.mId,
    this.teamType,
    this.teamId,
    this.teamName,
    this.playerId,
    this.playerName,
    this.playerType,
    this.isPlaying,
  });

  factory Lineup.fromJson(Map<String, dynamic> json) {
    return Lineup(
      id: json['id']?.toString(),
      mId: json['m_id'],
      teamType: json['team_type'],
      teamId: json['team_id'],
      teamName: json['team_name'],
      playerId: json['player_id'],
      playerName: json['player_name'],
      playerType: json['player_type'],
      isPlaying: json['is_playing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'm_id': mId,
      'team_type': teamType,
      'team_id': teamId,
      'team_name': teamName,
      'player_id': playerId,
      'player_name': playerName,
      'player_type': playerType,
      'is_playing': isPlaying,
    };
  }
}