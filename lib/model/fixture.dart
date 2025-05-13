class Fixture {
  String? id;
  int? sportsId;
  int? cId;
  int? seriesId;
  int? mId;
  String? matchTitle;
  String? matchType;
  DateTime? matchDate;
  int? teamAId;
  String? teamA;
  String? teamAShort;
  String? teamAFlag;
  int? teamBId;
  String? teamB;
  String? teamBShort;
  String? teamBFlag;
  String? status;
  int? active;
  int? isPlaying;
  bool? lineupOut;
  String? resultFlag;

  Fixture({
    this.id,
    this.sportsId,
    this.cId,
    this.seriesId,
    this.mId,
    this.matchTitle,
    this.matchType,
    this.matchDate,
    this.teamAId,
    this.teamA,
    this.teamAShort,
    this.teamAFlag,
    this.teamBId,
    this.teamB,
    this.teamBShort,
    this.teamBFlag,
    this.status,
    this.active,
    this.isPlaying,
    this.lineupOut,
    this.resultFlag,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      id: json['id']?.toString(),
      sportsId: json['sports_id'],
      cId: json['c_id'],
      seriesId: json['series_id'],
      mId: json['m_id'],
      matchTitle: json['match_title'],
      matchType: json['match_type'],
      matchDate: json['match_date'] != null ? DateTime.parse(json['match_date']) : null,
      teamAId: json['team_a_id'],
      teamA: json['team_a'],
      teamAShort: json['team_a_short'],
      teamAFlag: json['team_a_flag'],
      teamBId: json['team_b_id'],
      teamB: json['team_b'],
      teamBShort: json['team_b_short'],
      teamBFlag: json['team_b_flag'],
      status: json['status'],
      active: json['active'],
      isPlaying: json['is_playing'],
      lineupOut: json['lineup_out'],
      resultFlag: json['result_flag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sports_id': sportsId,
      'c_id': cId,
      'series_id': seriesId,
      'm_id': mId,
      'match_title': matchTitle,
      'match_type': matchType,
      'match_date': matchDate?.toIso8601String(),
      'team_a_id': teamAId,
      'team_a': teamA,
      'team_a_short': teamAShort,
      'team_a_flag': teamAFlag,
      'team_b_id': teamBId,
      'team_b': teamB,
      'team_b_short': teamBShort,
      'team_b_flag': teamBFlag,
      'status': status,
      'active': active,
      'is_playing': isPlaying,
      'lineup_out': lineupOut,
      'result_flag': resultFlag,
    };
  }
}