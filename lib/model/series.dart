class Series {
  String? id;
  int cId;
  String? seriesName;
  String? seriesTitle;
  String? matchType;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  int? active;

  Series({
    this.id,
    required this.cId,
    this.seriesName,
    this.seriesTitle,
    this.matchType,
    this.status,
    this.startDate,
    this.endDate,
    this.active,
  });

  factory Series.fromJson(Map<String, dynamic> json) {
    return Series(
      id: json['id']?.toString(),
      cId: json['c_id'],
      seriesName: json['series_name'],
      seriesTitle: json['series_title'],
      matchType: json['match_type'],
      status: json['status'],
      startDate: json['start_date'] != null ? DateTime.parse(json['start_date']) : null,
      endDate: json['end_date'] != null ? DateTime.parse(json['end_date']) : null,
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'c_id': cId,
      'series_name': seriesName,
      'series_title': seriesTitle,
      'match_type': matchType,
      'status': status,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'active': active,
    };
  }
}