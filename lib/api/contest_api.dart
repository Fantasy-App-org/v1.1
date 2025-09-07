// lib/api/contest_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service/user_service.dart';

class ContestApi {
  static const String baseUrl = 'http://api.start25pro.com:3000';
  static final UserService _userService = UserService();

  // Get contest list for a match
  static Future<Map<String, dynamic>> getContestList(int matchId) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/contest_list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'match_id': matchId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load contests: ${response.statusCode}');
      }
    } catch (e) {
      print('ContestApi.getContestList Error: $e');
      throw Exception('Service error: $e');
    }
  }

  static Future<Map<String, dynamic>> getContestDetail(int contestId) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/contest-detail'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'contest_id': contestId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load contest detail: ${response.statusCode}');
      }
    } catch (e) {
      print('ContestApi.getContestDetail Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // Get joined contest list for a match
  static Future<Map<String, dynamic>> getJoinedContestList({
    required int matchId,
    int filterKey = 1,
    int filterType = 1,
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/joined-contest-list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'match_id': matchId,
          'filter_key': filterKey,
          'filter_type': filterType,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load joined contests: ${response.statusCode}');
      }
    } catch (e) {
      print('ContestApi.getJoinedContestList Error: $e');
      throw Exception('Service error: $e');
    }
  }

  static Future<int?> getContestIdByMatchId(int matchId) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/joined-contest-list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'match_id': matchId,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Extract contest_id from the response
        if (responseData['status'] == true &&
            responseData['data'] != null &&
            responseData['data']['joined_contest'] != null &&
            responseData['data']['joined_contest'].isNotEmpty) {

          final contestId = responseData['data']['joined_contest'][0]['contest_id'];
          return contestId is int ? contestId : int.tryParse(contestId.toString());
        } else {
          print('No joined contests found for match ID: $matchId');
          return null;
        }
      } else {
        throw Exception('Failed to load joined contest list: ${response.statusCode}');
      }
    } catch (e) {
      print('ContestApi.getContestIdByMatchId Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // Get joined contest details
  static Future<Map<String, dynamic>> getJoinedContestDetails(Map<String, dynamic> requestData) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/joined-contest-details'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load joined contest details: ${response.statusCode}');
      }
    } catch (e) {
      print('ContestApi.getJoinedContestDetails Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // Get joined contest detail (singular)
  static Future<Map<String, dynamic>> getJoinedContestDetail(Map<String, dynamic> requestData) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/joined-contest-detail'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestData),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load joined contest detail: ${response.statusCode}');
      }
    } catch (e) {
      print('ContestApi.getJoinedContestDetail Error: $e');
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
      print('ContestApi.getJoinedContestMatches Error: $e');
      throw Exception('Service error: $e');
    }
  }

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
      print('ContestApi.getMyMatches Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // Get scorecard for a match
  static Future<Map<String, dynamic>> getScorecard(String matchId) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/getscorecard'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'match_id': matchId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load scorecard: ${response.statusCode}');
      }
    } catch (e) {
      print('ContestApi.getScorecard Error: $e');
      throw Exception('Service error: $e');
    }
  }

  static Future<Map<String, dynamic>> getFullScorecard(String matchId) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/getfullscoredata'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'match_id': matchId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load scorecard: ${response.statusCode}');
      }
    } catch (e) {
      print('ContestApi.getScorecard Error: $e');
      throw Exception('Service error: $e');
    }
  }

  // NEW: Get complete team details with all players
  static Future<Map<String, dynamic>> getTeamDetails(int teamId) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/team-details'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'team_id': teamId,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load team details: ${response.statusCode}');
      }
    } catch (e) {
      print('ContestApi.getTeamDetails Error: $e');
      throw Exception('Service error: $e');
    }
  }
}