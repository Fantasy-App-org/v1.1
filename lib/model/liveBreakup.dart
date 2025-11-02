class LiveBreakup {
  String? id;
  int? fixtureId;
  int? contestId;
  int? winningAmount;
  int? size;
  String? name;
  int? start;
  int? end;
  String? prize;
  double? percentage;

  LiveBreakup({
    this.id,
    this.fixtureId,
    this.contestId,
    this.winningAmount,
    this.size,
    this.name,
    this.start,
    this.end,
    this.prize,
    this.percentage,
  });

  factory LiveBreakup.fromJson(Map<String, dynamic> json) {
    return LiveBreakup(
      id: json['id']?.toString(),
      fixtureId: json['fixture_id'],
      contestId: json['contest_id'],
      winningAmount: json['winning_amount'],
      size: json['size'],
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
      'winning_amount': winningAmount,
      'size': size,
      'name': name,
      'start': start,
      'end': end,
      'prize': prize,
      'percentage': percentage,
    };
  }
}