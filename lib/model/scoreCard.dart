class Scorecard {
  String? id;
  int? matchId;
  int? teamId;
  int? tossWon;
  String? totalScore;
  int? byes;
  int? legbyes;
  int? wides;
  int? noballs;
  int? extras;
  int? winningId;
  String? winningComment;

  Scorecard({
    this.id,
    this.matchId,
    this.teamId,
    this.tossWon,
    this.totalScore,
    this.byes,
    this.legbyes,
    this.wides,
    this.noballs,
    this.extras,
    this.winningId,
    this.winningComment,
  });

  factory Scorecard.fromJson(Map<String, dynamic> json) {
    return Scorecard(
      id: json['id']?.toString(),
      matchId: json['match_id'],
      teamId: json['team_id'],
      tossWon: json['toss_won'],
      totalScore: json['total_score'],
      byes: json['byes'],
      legbyes: json['legbyes'],
      wides: json['wides'],
      noballs: json['noballs'],
      extras: json['extras'],
      winningId: json['winning_id'],
      winningComment: json['winning_comment'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_id': matchId,
      'team_id': teamId,
      'toss_won': tossWon,
      'total_score': totalScore,
      'byes': byes,
      'legbyes': legbyes,
      'wides': wides,
      'noballs': noballs,
      'extras': extras,
      'winning_id': winningId,
      'winning_comment': winningComment,
    };
  }
}