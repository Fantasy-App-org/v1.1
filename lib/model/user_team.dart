import 'package:fantasy/model/player.dart';

class UserTeam {
  final int? teamId;
  final String? teamName;
  final String? captain; // Changed from dynamic to String?
  final String? viceCaptain; // Changed from dynamic to String?
  final String? teamAName;
  final String? teamBName;
  final int? teamACount;
  final int? teamBCount;
  final int? noOfBat;
  final int? noOfWk;
  final int? noOfAr;
  final int? noOfBowl;
  final List<Player>? teamPlayers;

  UserTeam({
    this.teamId,
    this.teamName,
    this.captain,
    this.viceCaptain,
    this.teamAName,
    this.teamBName,
    this.teamACount,
    this.teamBCount,
    this.noOfBat,
    this.noOfWk,
    this.noOfAr,
    this.noOfBowl,
    this.teamPlayers,
  });

  factory UserTeam.fromJson(Map<String, dynamic> json) {
    try {
      return UserTeam(
        teamId: _parseInt(json['team_id']),
        teamName: _parseString(json['team_name']), // FIXED: Use _parseString
        captain: _parseString(json['captain']), // FIXED: Use _parseString
        viceCaptain: _parseString(json['vice_captain'] ?? json['vc']), // FIXED: Use _parseString
        teamAName: _parseString(json['team_a_name']),
        teamBName: _parseString(json['team_b_name']),
        teamACount: _parseInt(json['team_a_count']),
        teamBCount: _parseInt(json['team_b_count']),
        noOfBat: _parseInt(json['no_of_bat']),
        noOfWk: _parseInt(json['no_of_wk']),
        noOfAr: _parseInt(json['no_of_ar']),
        noOfBowl: _parseInt(json['no_of_bowl']),
        teamPlayers: json['teamplayers'] != null || json['team_players'] != null
            ? _parsePlayersList(json['teamplayers'] ?? json['team_players'])
            : null,
      );
    } catch (e) {
      print('Error parsing UserTeam JSON: $e');
      print('Raw JSON: $json');
      rethrow;
    }
  }

  // ADDED: Method to safely parse strings from any type
  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    if (value is bool) return value.toString();
    return value.toString(); // Fallback for any other type
  }

  // ADDED: Method to safely parse integers
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) {
      if (value.trim().isEmpty) return null;
      return int.tryParse(value);
    }
    return null;
  }

  // ENHANCED: Better players list parsing
  static List<Player>? _parsePlayersList(dynamic playersData) {
    if (playersData == null) return null;

    try {
      if (playersData is List) {
        List<Player> players = [];
        for (var playerData in playersData) {
          if (playerData != null) {
            try {
              final player = Player.fromJson(playerData as Map<String, dynamic>);
              players.add(player);
            } catch (playerError) {
              print('Error parsing individual player: $playerError');
              // Continue with other players
            }
          }
        }
        return players.isNotEmpty ? players : null;
      }
    } catch (e) {
      print('Error parsing players list: $e');
    }

    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'team_name': teamName,
      'captain': captain,
      'vice_captain': viceCaptain,
      'team_a_name': teamAName,
      'team_b_name': teamBName,
      'team_a_count': teamACount,
      'team_b_count': teamBCount,
      'no_of_bat': noOfBat,
      'no_of_wk': noOfWk,
      'no_of_ar': noOfAr,
      'no_of_bowl': noOfBowl,
      'teamplayers': teamPlayers?.map((player) => player.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'UserTeam(id: $teamId, name: $teamName, captain: $captain, players: ${teamPlayers?.length ?? 0})';
  }
}