// lib/model/player.dart
class Player {
  final int? id;
  final int? pId;
  final int? cId;
  final int? seriesId;
  final int? teamId;
  final String? teamName;
  final String? playerName;
  final String? playerShortName;
  final String? role; // maps from player_type
  final String? battingStyle;
  final String? bowlingStyle;
  final String? nationality;
  final double? credits; // parsed from player_credit string
  final String? type;
  final int? status;
  final int? points; // maps from fantasy_points
  final bool? isPlaying; // maps from is_playing
  final String? playerImage;
  final double? selectedBy; // parsed from selected_by percentage string
  final int? fantasyPoints;

  // UI state fields (not from API)
  bool isSelected;
  bool get isAnnounced => isPlaying == 1; // derive from is_playing

  Player({
    this.id,
    this.pId,
    this.cId,
    this.seriesId,
    this.teamId,
    this.teamName,
    this.playerName,
    this.playerShortName,
    this.role,
    this.battingStyle,
    this.bowlingStyle,
    this.nationality,
    this.credits,
    this.type,
    this.status,
    this.points,
    this.isPlaying,
    this.playerImage,
    this.selectedBy,
    this.fantasyPoints,
    this.isSelected = false,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['player_id'],
      pId: json['p_id'],
      cId: json['c_id'],
      seriesId: json['series_id'],
      teamId: json['team_id'],
      teamName: json['team_name'],
      playerName: json['player_name'],
      playerShortName: json['player_short_name'],
      role: json['player_type'],
      battingStyle: json['batting_style'],
      bowlingStyle: json['bowling_style'],
      nationality: json['nationality'],
      credits: _parseDouble(json['player_credit']),
      type: json['type'],
      status: json['status'],
      points: json['fantasy_points'],
      isPlaying: json['is_playing'] == 1,
      playerImage: json['player_image'],
      selectedBy: _parseSelectedBy(json['selected_by']),
      fantasyPoints: json['fantasy_points'],
    );
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      return double.tryParse(value);
    }
    return null;
  }

  static double? _parseSelectedBy(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) {
      // Remove % and parse: "68.8 %" -> 68.8
      String cleaned = value.replaceAll('%', '').trim();
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'player_id': id,
      'p_id': pId,
      'c_id': cId,
      'series_id': seriesId,
      'team_id': teamId,
      'team_name': teamName,
      'player_name': playerName,
      'player_short_name': playerShortName,
      'player_type': role,
      'batting_style': battingStyle,
      'bowling_style': bowlingStyle,
      'nationality': nationality,
      'player_credit': credits?.toString(),
      'type': type,
      'status': status,
      'fantasy_points': points,
      'is_playing': isPlaying == true ? 1 : 0,
      'player_image': playerImage,
      'selected_by': selectedBy != null ? '${selectedBy!.toStringAsFixed(1)} %' : '0 %',
    };
  }
}