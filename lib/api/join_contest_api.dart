
// lib/api/join_contest_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service/user_service.dart';

class JoinContestApi {
  static const String baseUrl = 'http://api.start25pro.com:3000';
  static final UserService _userService = UserService();

  /// Join a contest with a selected team
  static Future<Map<String, dynamic>> joinContest({
    required int seriesId,
    required int matchId,
    required int teamId,
    required int contestId,
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final requestBody = {
        'series_id': seriesId,
        'match_id': matchId,
        'team_id': [teamId], // API expects array format
        'contest_id': contestId,
      };

      print('JoinContestApi - Request URL: $baseUrl/web-services/joinContest');
      print('JoinContestApi - Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/joinContest'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('JoinContestApi - Response status: ${response.statusCode}');
      print('JoinContestApi - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to join contest: HTTP ${response.statusCode}');
      }
    } catch (e) {
      print('JoinContestApi Error: $e');
      throw Exception('Service error: $e');
    }
  }
}