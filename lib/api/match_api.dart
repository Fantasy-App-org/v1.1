// lib/api/match_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service/user_service.dart';

class MatchApi {
  static const String baseUrl = 'http://13.60.245.44:3000';
  static final UserService _userService = UserService();

  // Get my matches
  static Future<Map<String, dynamic>> getMyMatches() async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/web-services/my-matches'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load my matches: ${response.statusCode}');
      }
    } catch (e) {
      print('MatchApi.getMyMatches Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // Get joined contest matches
  static Future<Map<String, dynamic>> getJoinedContestMatches() async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/web-services/joined-contest-matches'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load joined contest matches: ${response.statusCode}');
      }
    } catch (e) {
      print('MatchApi.getJoinedContestMatches Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // Get match players (using existing squadlist endpoint)
  static Future<Map<String, dynamic>> getMatchPlayers({
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

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load match players: ${response.statusCode}');
      }
    } catch (e) {
      print('MatchApi.getMatchPlayers Error: $e');
      throw Exception('Service error: $e');
    }
  }
}