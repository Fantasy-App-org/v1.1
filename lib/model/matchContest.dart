class MatchContest {
  String? id;
  int? fixtureId;
  int? contestId;
  int? isCancelled;
  int status;

  MatchContest({
    this.id,
    this.fixtureId,
    this.contestId,
    this.isCancelled,
    required this.status,
  });

  factory MatchContest.fromJson(Map<String, dynamic> json) {
    return MatchContest(
      id: json['id']?.toString(),
      fixtureId: json['fixture_id'],
      contestId: json['contest_id'],
      isCancelled: json['is_cancelled'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fixture_id': fixtureId,
      'contest_id': contestId,
      'is_cancelled': isCancelled,
      'status': status,
    };
  }
}