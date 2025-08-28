// lib/api/team_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service/user_service.dart';
import 'package:fantasy/model/create_team_request.dart';

class TeamApi {
  static const String baseUrl = 'http://api.start25pro.com:3000';
  static final UserService _userService = UserService();

  // Get user team (existing method)
  static Future<Map<String, dynamic>> getUserTeam({
    required int matchId,
    required int seriesId,
    String contestId = "",
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/getuserteam'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'match_id': matchId,
          'series_id': seriesId,
          'contest_id': contestId,
        }),
      );

      print('getUserTeam Response Status: ${response.statusCode}');
      print('getUserTeam Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user team: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('TeamApi.getUserTeam Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // NEW METHOD: Get detailed team information by team ID
  static Future<Map<String, dynamic>> getUserTeamById({
    required String teamId,  // Accept as String
    required int seriesId,
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      print('🔍 getUserTeamById - TeamId: $teamId (${teamId.runtimeType}), SeriesId: $seriesId (${seriesId.runtimeType})');

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/getuserteambyid'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'team_id': teamId,     // Send as string
          'series_id': seriesId, // Send as int
        }),
      );

      print('getUserTeamById Response Status: ${response.statusCode}');
      print('getUserTeamById Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Add response validation
        if (responseData['status'] != true) {
          throw Exception(responseData['message'] ?? 'API returned false status');
        }

        if (responseData['data'] == null) {
          throw Exception('No data in API response');
        }

        return responseData;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ TeamApi.getUserTeamById Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // NEW METHOD: Switch team in contest
  static Future<Map<String, dynamic>> switchTeam({
    required int matchId,
    required int contestId,
    required int oldTeamId,
    required int newTeamId,
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      print('🔄 switchTeam - MatchId: $matchId, ContestId: $contestId, OldTeam: $oldTeamId, NewTeam: $newTeamId');

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/switchteam'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'match_id': matchId,
          'contest_id': contestId,
          'old_team': oldTeamId,
          'new_team': newTeamId,
        }),
      );

      print('switchTeam Response Status: ${response.statusCode}');
      print('switchTeam Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] != true) {
          throw Exception(responseData['message'] ?? 'Failed to switch team');
        }

        return responseData;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ TeamApi.switchTeam Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // Get squad list (existing method)
  static Future<Map<String, dynamic>> getSquadList({
    required int seriesId,
    required int matchId,
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/squadlist'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'series_id': seriesId,
          'match_id': matchId,
        }),
      );

      print('getSquadList Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load squad list: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('TeamApi.getSquadList Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // Create user team (existing method)
  static Future<Map<String, dynamic>> createUserTeam(CreateTeamRequest request) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final requestBody = request.toJson();
      print('Create Team Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/creatuserteam'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print('Create Team Response Status: ${response.statusCode}');
      print('Create Team Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true) {
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to create team');
        }
      } else {
        throw Exception('Failed to create user team: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('TeamApi.createUserTeam Error: $e');
      throw Exception('Service error: $e');
    }
  }
}