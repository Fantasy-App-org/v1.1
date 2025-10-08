// lib/model/scorecard_model.dart
class ScorecardModel {
  final String teamAScore;
  final int teamAId;
  final String teamBScore;
  final int teamBId;
  final String winningComment;

  ScorecardModel({
    required this.teamAScore,
    required this.teamAId,
    required this.teamBScore,
    required this.teamBId,
    required this.winningComment,
  });

  factory ScorecardModel.fromJson(Map<String, dynamic> json) {
    return ScorecardModel(
      teamAScore: json['team_a_score']?.toString() ?? '0/0',
      teamAId: json['team_a_id'] ?? 0,
      teamBScore: json['team_b_score']?.toString() ?? '0/0',
      teamBId: json['team_b_id'] ?? 0,
      winningComment: json['winning_comment']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_a_score': teamAScore,
      'team_a_id': teamAId,
      'team_b_score': teamBScore,
      'team_b_id': teamBId,
      'winning_comment': winningComment,
    };
  }

  // Helper methods
  String get formattedTeamAScore {
    if (teamAScore.isEmpty || teamAScore == 'null') {
      return '0/0';
    }
    return teamAScore;
  }

  String get formattedTeamBScore {
    if (teamBScore.isEmpty || teamBScore == 'null') {
      return '0/0';
    }
    return teamBScore;
  }

  bool get hasValidScores {
    return teamAScore.isNotEmpty && teamBScore.isNotEmpty &&
        teamAScore != 'null' && teamBScore != 'null';
  }

  String get currentStatus {
    if (winningComment.isNotEmpty) {
      return winningComment;
    }
    return 'Match in progress';
  }

  // Extract overs from score string like "*19/0 (2 ov)"
  String getOversFromScore(String score) {
    final RegExp oversRegex = RegExp(r'\(([^)]+)\)');
    final match = oversRegex.firstMatch(score);
    return match?.group(1) ?? '';
  }

  // Extract runs/wickets from score string
  String getRunsWicketsFromScore(String score) {
    // Remove asterisk and overs part
    String cleaned = score.replaceAll('*', '').split(' ')[0];
    return cleaned;
  }

  String get teamARunsWickets => getRunsWicketsFromScore(teamAScore);
  String get teamBRunsWickets => getRunsWicketsFromScore(teamBScore);
  String get teamAOvers => getOversFromScore(teamAScore);
  String get teamBOvers => getOversFromScore(teamBScore);
}