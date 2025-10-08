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
  final int? points; // maps from fantasy_points or player_points
  final bool? isPlaying; // maps from is_playing
  final String? playerImage;
  final double? selectedBy; // parsed from selected_by percentage string
  final int? fantasyPoints;

  // UI state fields (not from API)
  bool isSelected;
  bool get isAnnounced => isPlaying == true; // derive from is_playing

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
    try {
      return Player(
        // Use safe parsing for all fields
        id: _parseInt(json['player_id']) ?? _parseInt(json['id']),
        pId: _parseInt(json['p_id']),
        cId: _parseInt(json['c_id']),
        seriesId: _parseInt(json['series_id']),
        teamId: _parseInt(json['team_id']),
        teamName: _parseString(json['team_name']), // FIXED: Use _parseString
        playerName: _parseString(json['player_name']), // FIXED: Use _parseString
        playerShortName: _parseString(json['player_short_name']), // FIXED: Use _parseString
        role: _parseString(json['player_type']), // FIXED: Use _parseString
        battingStyle: _parseString(json['batting_style']), // FIXED: Use _parseString
        bowlingStyle: _parseString(json['bowling_style']), // FIXED: Use _parseString
        nationality: _parseString(json['nationality']), // FIXED: Use _parseString
        credits: _parseDouble(json['player_credit']),
        type: _parseString(json['type']), // FIXED: Use _parseString
        status: _parseInt(json['status']),
        points: _parseInt(json['fantasy_points']) ?? _parseInt(json['player_points']),
        isPlaying: _parseBool(json['is_playing']),
        playerImage: _parseString(json['player_image']), // FIXED: Use _parseString
        selectedBy: _parseSelectedBy(json['selected_by']),
        fantasyPoints: _parseInt(json['fantasy_points']) ?? _parseInt(json['player_points']),
      );
    } catch (e) {
      print('Error parsing Player JSON: $e');
      print('Raw JSON: $json');
      rethrow;
    }
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    if (value is bool) return value.toString();
    return value.toString(); // Fallback for any other type
  }

  // ADDED: Method to safely parse integers from dynamic values
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      // Handle empty strings
      if (value.trim().isEmpty) return null;
      return int.tryParse(value);
    }
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) {
      // Handle empty strings
      if (value.trim().isEmpty) return null;
      return double.tryParse(value);
    }
    return null;
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase().trim();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    return false;
  }

  static double? _parseSelectedBy(dynamic value) {
    if (value == null) return 0.0;
    if (value is String) {
      // Remove % and parse: "68.8 %" -> 68.8
      String cleaned = value.replaceAll('%', '').trim();
      return double.tryParse(cleaned) ?? 0.0;
    }
    if (value is num) {
      return value.toDouble();
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

  @override
  String toString() {
    return 'Player(id: $id, name: $playerName, role: $role, teamName: $teamName)';
  }
}