class MyMatchesResponse {
  final bool status;
  final String message;
  final List<Match> data;

  MyMatchesResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyMatchesResponse.fromJson(Map<String, dynamic> json) {
    return MyMatchesResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => Match.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data.map((match) => match.toJson()).toList(),
    };
  }
}

class Match {
  final int totalTeams;
  final int isStatus;
  final int totalContest;
  final int id;
  final int sportsId;
  final int cId;
  final int seriesId;
  final String matchTitle;
  final String matchType;
  final DateTime matchDate;
  final int teamAId;
  final String teamA;
  final String teamAShort;
  final String teamAFlag;
  final int teamBId;
  final String teamB;
  final String teamBShort;
  final String teamBFlag;
  final String status;
  final int active;
  final int isPlaying;
  final bool lineupOut;
  final String resultFlag;
  final int maxTeams;

  Match({
    required this.totalTeams,
    required this.isStatus,
    required this.totalContest,
    required this.id,
    required this.sportsId,
    required this.cId,
    required this.seriesId,
    required this.matchTitle,
    required this.matchType,
    required this.matchDate,
    required this.teamAId,
    required this.teamA,
    required this.teamAShort,
    required this.teamAFlag,
    required this.teamBId,
    required this.teamB,
    required this.teamBShort,
    required this.teamBFlag,
    required this.status,
    required this.active,
    required this.isPlaying,
    required this.lineupOut,
    required this.resultFlag,
    required this.maxTeams,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      totalTeams: json['total_teams'] ?? 0,
      isStatus: json['is_status'] ?? 0,
      totalContest: json['total_contest'] ?? 0,
      id: json['id'] ?? 0,
      sportsId: json['sports_id'] ?? 0,
      cId: json['c_id'] ?? 0,
      seriesId: json['series_id'] ?? 0,
      matchTitle: json['match_title'] ?? '',
      matchType: json['match_type'] ?? '',
      matchDate: _parseDateTime(json['match_date']),
      teamAId: json['team_a_id'] ?? 0,
      teamA: json['team_a'] ?? '',
      teamAShort: json['team_a_short'] ?? '',
      teamAFlag: json['team_a_flag'] ?? '',
      teamBId: json['team_b_id'] ?? 0,
      teamB: json['team_b'] ?? '',
      teamBShort: json['team_b_short'] ?? '',
      teamBFlag: json['team_b_flag'] ?? '',
      status: json['status'] ?? '',
      active: json['active'] ?? 0,
      isPlaying: json['is_playing'] ?? 0,
      lineupOut: json['lineup_out'] ?? false,
      resultFlag: json['result_flag'] ?? '',
      maxTeams: json['max_teams'] ?? 0,
    );
  }

  static DateTime _parseDateTime(dynamic dateValue) {
    if (dateValue == null) return DateTime.now();

    try {
      if (dateValue is String) {
        return DateTime.parse(dateValue);
      }
      return DateTime.now();
    } catch (e) {
      print('Error parsing date: $dateValue, error: $e');
      return DateTime.now();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'total_teams': totalTeams,
      'is_status': isStatus,
      'total_contest': totalContest,
      'id': id,
      'sports_id': sportsId,
      'c_id': cId,
      'series_id': seriesId,
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
      'active': active,
      'is_playing': isPlaying,
      'lineup_out': lineupOut,
      'result_flag': resultFlag,
      'max_teams': maxTeams,
    };
  }

  // Helper methods
  bool get isLive => status.toLowerCase() == 'live';
  bool get isUpcoming => status.toLowerCase() == 'upcoming';
  bool get isCompleted => status.toLowerCase() == 'completed';

  String get formattedMatchDate {
    return '${matchDate.day}/${matchDate.month}/${matchDate.year} ${matchDate.hour}:${matchDate.minute.toString().padLeft(2, '0')}';
  }

  String get shortMatchTitle => '$teamAShort vs $teamBShort';

  // Add convenience method for prize pool (you might want to add this field to API)
  String get matchContest => '₹${(totalContest * 1000).toStringAsFixed(0)}';
}

// Enum for match status
enum MatchStatus {
  live,
  upcoming,
  completed,
  cancelled,
}

extension MatchStatusExtension on MatchStatus {
  static MatchStatus fromString(String status) {
    switch (status.toLowerCase()) {
      case 'live':
        return MatchStatus.live;
      case 'upcoming':
        return MatchStatus.upcoming;
      case 'completed':
        return MatchStatus.completed;
      case 'cancelled':
        return MatchStatus.cancelled;
      default:
        return MatchStatus.upcoming;
    }
  }
}