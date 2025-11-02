class FixtureModel {
  final int id;
  final int sportsId;
  final int cId;
  final int seriesId;
  final int mId;
  final String matchTitle;
  final String matchType;
  final DateTime matchDate;
  final int teamAId;
  final String teamA;
  final String teamAShort;
  final String? teamAFlag;
  final int teamBId;
  final String teamB;
  final String teamBShort;
  final String? teamBFlag;
  final String status;
  final bool lineupOut;
  final int isPlaying;
  final String matchContest;
  final int totalContest;
  final int totalTeams;
  final int maxTeams;

  FixtureModel({
    required this.id,
    required this.sportsId,
    required this.cId,
    required this.seriesId,
    required this.mId,
    required this.matchTitle,
    required this.matchType,
    required this.matchDate,
    required this.teamAId,
    required this.teamA,
    required this.teamAShort,
    this.teamAFlag,
    required this.teamBId,
    required this.teamB,
    required this.teamBShort,
    this.teamBFlag,
    required this.status,
    required this.lineupOut,
    required this.isPlaying,
    required this.matchContest,
    required this.totalContest,
    required this.totalTeams,
    required this.maxTeams,
  });

  factory FixtureModel.fromJson(Map<String, dynamic> json) {
    try {
      return FixtureModel(
        id: json['id'] ?? 0,
        sportsId: json['sports_id'] ?? 0,
        cId: json['c_id'] ?? 0,
        seriesId: json['series_id'] ?? 0,
        mId: json['m_id'] ?? 0,
        matchTitle: json['match_title'] ?? '',
        matchType: json['match_type'] ?? '',
        matchDate: json['match_date'] != null
            ? DateTime.parse(json['match_date'])
            : DateTime.now(),
        teamAId: json['team_a_id'] ?? 0,
        teamA: json['team_a'] ?? '',
        teamAShort: json['team_a_short'] ?? '',
        teamAFlag: json['team_a_flag'],
        teamBId: json['team_b_id'] ?? 0,
        teamB: json['team_b'] ?? '',
        teamBShort: json['team_b_short'] ?? '',
        teamBFlag: json['team_b_flag'],
        status: json['status'] ?? 'upcoming',
        lineupOut: json['lineup_out'] ?? false,
        isPlaying: json['is_playing'] ?? 0,
        matchContest: json['match_contest'] ?? 'Coming Soon',
        totalContest: json['total_contest'] ?? 0,
        totalTeams: json['total_teams'] ?? 0,
        maxTeams: json['max_teams'] ?? 20,
      );
    } catch (e) {
      print('Error parsing fixture from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sports_id': sportsId,
      'c_id': cId,
      'series_id': seriesId,
      'm_id': mId,
      'match_title': matchTitle,
      'match_type': matchType,
      'match_date': matchDate.toIso8601String(),
      'team_a_id': teamAId,
      'team_a': teamA,
      'team_a_short': teamAShort,
      'team_a_flag': teamAFlag,
      'team_b_id': teamBId,
      'team_b': teamB,
      'team_b_short': teamBShort,
      'team_b_flag': teamBFlag,
      'status': status,
      'lineup_out': lineupOut,
      'is_playing': isPlaying,
      'match_contest': matchContest,
      'total_contest': totalContest,
      'total_teams': totalTeams,
      'max_teams': maxTeams,
    };
  }

  // Helper method to check if the match is live
  bool get isLive => status.toLowerCase() == 'live';

  // Helper method to check if the match is upcoming
  bool get isUpcoming => status.toLowerCase() == 'upcoming';

  // Helper method to check if the match is completed
  bool get isCompleted => status.toLowerCase() == 'completed';

  @override
  String toString() {
    return 'FixtureModel(id: $id, matchTitle: $matchTitle, status: $status, matchDate: $matchDate, lineupOut: $lineupOut)';
  }
}