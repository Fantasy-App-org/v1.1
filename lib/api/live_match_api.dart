import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service/user_service.dart';
import '../config/debug_config.dart';

class LiveMatchApi {
  static const String baseUrl = 'http://13.60.245.44:3000';
  static const String myMatchesEndpoint = 'my-matches';

  /// Get live matches specifically from my-matches API
  static Future<Map<String, dynamic>> getLiveMatches() async {
    try {
      DebugConfig.debugPrint('LiveMatchApi: Fetching live matches...');

      if (!DebugConfig.enableApiCalls) {
        throw Exception('API calls disabled in debug mode');
      }

      final userService = UserService();
      final token = userService.authToken;

      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final response = await http.get(
        Uri.parse('$baseUrl$myMatchesEndpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      ).timeout(const Duration(seconds: 30));

      DebugConfig.debugPrint('LiveMatchApi: Live matches response: ${response.statusCode}');

      if (response.statusCode == 401) {
        throw Exception('Authentication failed');
      }

      if (response.statusCode != 200) {
        throw Exception('Failed to load live matches: ${response.statusCode}');
      }

      final Map<String, dynamic> jsonData = json.decode(response.body);

      // Filter only live matches and convert to FixtureModel format
      return _convertToLiveMatchesFormat(jsonData);

    } catch (e) {
      DebugConfig.debugPrint('LiveMatchApi: Error in getLiveMatches: $e');
      rethrow;
    }
  }

  /// Convert API response to FixtureModel format and filter live matches only
  static Map<String, dynamic> _convertToLiveMatchesFormat(Map<String, dynamic> apiResponse) {
    if (apiResponse['data'] == null) {
      return {
        'status': apiResponse['status'],
        'message': apiResponse['message'],
        'data': [],
      };
    }

    List<dynamic> liveMatches = [];

    for (var match in apiResponse['data']) {
      // Only include live matches
      if (match['status']?.toString().toLowerCase() == 'live') {
        liveMatches.add({
          'id': match['id'],
          'sports_id': match['sports_id'],
          'c_id': match['c_id'],
          'series_id': match['series_id'],
          'match_title': match['match_title'],
          'match_type': match['match_type'],
          'match_date': match['match_date'],
          'team_a_id': match['team_a_id'],
          'team_a': match['team_a'],
          'team_a_short': match['team_a_short'],
          'team_a_flag': match['team_a_flag'],
          'team_b_id': match['team_b_id'],
          'team_b': match['team_b'],
          'team_b_short': match['team_b_short'],
          'team_b_flag': match['team_b_flag'],
          'status': match['status'],
          'active': match['active'],
          'is_playing': match['is_playing'],
          'lineup_out': match['lineup_out'],
          'result_flag': match['result_flag'],
          'max_teams': match['max_teams'],
          'total_teams': match['total_teams'],
          'total_contest': match['total_contest'],
          'is_status': match['is_status'],
          'match_contest': '₹${(match['total_contest'] ?? 0) * 1000}',
        });
      }
    }

    return {
      'status': apiResponse['status'],
      'message': 'Live matches filtered successfully',
      'data': liveMatches,
    };
  }

}