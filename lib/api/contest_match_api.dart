import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service/user_service.dart';

class ContestMatchApi {
  static const String baseUrl = 'http://13.232.147.237:3000';

  // Get player stats for a specific match and contest
  static Future<Map<String, dynamic>> getPlayerStats({
    required String matchId,
    required String contestId,
  }) async {
    try {
      final userService = UserService();

      if (!userService.isLoggedIn || userService.authToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/getplayerstats'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userService.authToken}',
        },
        body: jsonEncode({
          'match_id': matchId,
          'contest_id': contestId,
        }),
      );

      print('Player Stats API Response Status: ${response.statusCode}');
      print('Player Stats API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          return {
            'status': true,
            'data': responseData['data'],
            'message': responseData['message'],
          };
        } else {
          return {
            'status': false,
            'error': responseData['message'] ?? 'Failed to fetch player stats',
          };
        }
      } else {
        print('Failed to fetch player stats. Status: ${response.statusCode}');
        return {
          'status': false,
          'error': 'Failed to fetch player stats',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('Error fetching player stats: $e');
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  // Get top performing players from the stats
  static Future<Map<String, dynamic>> getTopPlayers({
    required String matchId,
    required String contestId,
    int limit = 10,
  }) async {
    try {
      final response = await getPlayerStats(
        matchId: matchId,
        contestId: contestId,
      );

      if (response['status'] == true) {
        final List<dynamic> playersData = response['data'] ?? [];

        // Sort players by points (descending) and take top performers
        playersData.sort((a, b) {
          final aPoints = a['player_points'] ?? 0;
          final bPoints = b['player_points'] ?? 0;
          return bPoints.compareTo(aPoints);
        });

        final topPlayers = playersData.take(limit).toList();

        return {
          'status': true,
          'data': topPlayers,
          'totalPlayers': playersData.length,
        };
      } else {
        return response;
      }
    } catch (e) {
      print('Error getting top players: $e');
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  // Get team-wise player stats
  static Future<Map<String, dynamic>> getTeamWiseStats({
    required String matchId,
    required String contestId,
  }) async {
    try {
      final response = await getPlayerStats(
        matchId: matchId,
        contestId: contestId,
      );

      if (response['status'] == true) {
        final List<dynamic> playersData = response['data'] ?? [];

        // Separate players by team
        final Map<String, List<Map<String, dynamic>>> teamWiseStats = {
          'team_a': [],
          'team_b': [],
        };

        for (final player in playersData) {
          final isTeamA = player['team_a'] == true;
          final teamKey = isTeamA ? 'team_a' : 'team_b';
          teamWiseStats[teamKey]!.add(player);
        }

        // Sort each team's players by points
        teamWiseStats['team_a']!.sort((a, b) {
          final aPoints = a['player_points'] ?? 0;
          final bPoints = b['player_points'] ?? 0;
          return bPoints.compareTo(aPoints);
        });

        teamWiseStats['team_b']!.sort((a, b) {
          final aPoints = a['player_points'] ?? 0;
          final bPoints = b['player_points'] ?? 0;
          return bPoints.compareTo(aPoints);
        });

        return {
          'status': true,
          'data': teamWiseStats,
          'totalPlayers': playersData.length,
        };
      } else {
        return response;
      }
    } catch (e) {
      print('Error getting team-wise stats: $e');
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  // Get player details by player ID
  static Future<Map<String, dynamic>> getPlayerDetails({
    required String matchId,
    required String contestId,
    required int playerId,
  }) async {
    try {
      final response = await getPlayerStats(
        matchId: matchId,
        contestId: contestId,
      );

      if (response['status'] == true) {
        final List<dynamic> playersData = response['data'] ?? [];

        // Find the specific player
        final playerData = playersData.firstWhere(
              (player) => player['player_id'] == playerId,
          orElse: () => null,
        );

        if (playerData != null) {
          return {
            'status': true,
            'data': playerData,
          };
        } else {
          return {
            'status': false,
            'error': 'Player not found',
          };
        }
      } else {
        return response;
      }
    } catch (e) {
      print('Error getting player details: $e');
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }
}