class UpcomingBreakup {
  String? id;
  int? fixtureId;
  int? contestId;
  String? name;
  int? start;
  int? end;
  String? prize;
  double? percentage;

  UpcomingBreakup({
    this.id,
    this.fixtureId,
    this.contestId,
    this.name,
    this.start,
    this.end,
    this.prize,
    this.percentage,
  });

  factory UpcomingBreakup.fromJson(Map<String, dynamic> json) {
    return UpcomingBreakup(
      id: json['id']?.toString(),
      fixtureId: json['fixture_id'],
      contestId: json['contest_id'],
      name: json['name'],
      start: json['start'],
      end: json['end'],
      prize: json['prize'],
      percentage: json['percentage'] != null ? double.parse(json['percentage'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fixture_id': fixtureId,
      'contest_id': contestId,
      'name': name,
      'start': start,
      'end': end,
      'prize': prize,
      'percentage': percentage,
    };
  }
}