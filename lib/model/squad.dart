class Squad {
  String? pId;
  int? cId;
  int? seriesId;
  int? teamId;
  String? teamName;
  int playerId;
  String? playerName;
  String? playerShortName;
  String? playerType;
  String? battingStyle;
  String? bowlingStyle;
  String? nationality;
  String? playerCredit;
  String? type;
  int? status;
  int? playerPoints;
  int? isPlaying;

  Squad({
    this.pId,
    this.cId,
    this.seriesId,
    this.teamId,
    this.teamName,
    required this.playerId,
    this.playerName,
    this.playerShortName,
    this.playerType,
    this.battingStyle,
    this.bowlingStyle,
    this.nationality,
    this.playerCredit,
    this.type,
    this.status,
    this.playerPoints,
    this.isPlaying,
  });

  factory Squad.fromJson(Map<String, dynamic> json) {
    return Squad(
      pId: json['p_id']?.toString(),
      cId: json['c_id'],
      seriesId: json['series_id'],
      teamId: json['team_id'],
      teamName: json['team_name'],
      playerId: json['player_id'],
      playerName: json['player_name'],
      playerShortName: json['player_short_name'],
      playerType: json['player_type'],
      battingStyle: json['batting_style'],
      bowlingStyle: json['bowling_style'],
      nationality: json['nationality'],
      playerCredit: json['player_credit'],
      type: json['type'],
      status: json['status'],
      playerPoints: json['player_points'],
      isPlaying: json['is_playing'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'p_Id': pId,
      'c_id': cId,
      'series_id': seriesId,
      'team_id': teamId,
      'team_name': teamName,
      'player_id': playerId,
      'player_name': playerName,
      'player_short_name': playerShortName,
      'player_type': playerType,
      'batting_style': battingStyle,
      'bowling_style': bowlingStyle,
      'nationality': nationality,
      'player_credit': playerCredit,
      'type': type,
      'status': status,
      'player_points': playerPoints,
      'is_playing': isPlaying,
    };
  }
}