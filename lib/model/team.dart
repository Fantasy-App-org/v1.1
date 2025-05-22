class Team {
  String? id;
  int? sportsId;
  int teamId;
  String? teamName;
  String? teamShortName;
  String? teamFlag;
  int? status;

  Team({
    this.id,
    this.sportsId,
    required this.teamId,
    this.teamName,
    this.teamShortName,
    this.teamFlag,
    this.status,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id']?.toString(),
      sportsId: json['sports_id'],
      teamId: json['team_id'],
      teamName: json['team_name'],
      teamShortName: json['team_short_name'],
      teamFlag: json['team_flag'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sports_id': sportsId,
      'team_id': teamId,
      'team_name': teamName,
      'team_short_name': teamShortName,
      'team_flag': teamFlag,
      'status': status,
    };
  }
}