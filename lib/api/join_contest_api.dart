// lib/api/join_contest_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fantasy/config/api_config.dart';
import '../service/user_service.dart';

class JoinContestApi {
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

      print('JoinContestApi - Request URL: ${ApiConfig.baseUrl}${ApiConfig.joinContestEndpoint}');
      print('JoinContestApi - Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}${ApiConfig.joinContestEndpoint}'),
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