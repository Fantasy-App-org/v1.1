import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service/user_service.dart';

class LeaderboardApi {
  static const String baseUrl = 'http://13.60.210.139:3000';

  // Get leaderboard for a specific match and contest with pagination
  static Future<Map<String, dynamic>> getLeaderboard({
    required String matchId,
    required String contestId, // Added contest_id parameter
    int page = 1,
    int limit = 50,
  }) async {
    try {
      final userService = UserService();

      if (!userService.isLoggedIn || userService.authToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/leader_board'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userService.authToken}',
        },
        body: jsonEncode({
          'match_id': matchId,
          'contest_id': contestId, // Include contest_id in the request
          'page': page,
          'limit': limit,
        }),
      );

      print('Leaderboard API Response Status: ${response.statusCode}');
      print('Leaderboard API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        return {
          'status': true,
          'data': responseData,
        };
      } else {
        print('Failed to fetch leaderboard. Status: ${response.statusCode}');
        return {
          'status': false,
          'error': 'Failed to fetch leaderboard',
          'statusCode': response.statusCode,
        };
      }
    } catch (e) {
      print('Error fetching leaderboard: $e');
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  // Get top leaderboard entries for a specific contest
  static Future<Map<String, dynamic>> getTopLeaderboard({
    required String matchId,
    required String contestId, // Added contest_id parameter
    int limit = 10,
  }) async {
    return await getLeaderboard(
      matchId: matchId,
      contestId: contestId,
      page: 1,
      limit: limit,
    );
  }

  // Get user teams from leaderboard for a specific contest
  static Future<Map<String, dynamic>> getUserTeams({
    required String matchId,
    required String contestId, // Added contest_id parameter
  }) async {
    try {
      print('Fetching user teams for match: $matchId, contest: $contestId');

      int currentPage = 1;
      const int limit = 50;
      List<Map<String, dynamic>> userTeams = [];
      int totalPages = 1;

      // Search through all pages to find user's teams
      while (currentPage <= totalPages) {
        print('Searching page $currentPage for user teams...');

        final response = await getLeaderboard(
          matchId: matchId,
          contestId: contestId,
          page: currentPage,
          limit: limit,
        );

        if (!response['status']) {
          print('Failed to get leaderboard for page $currentPage: ${response['error']}');
          break;
        }

        final leaderboardData = response['data'];
        if (leaderboardData == null ||
            leaderboardData['data'] == null ||
            leaderboardData['data']['data'] == null) {
          print('No data found in leaderboard response for page $currentPage');
          break;
        }

        // Update total pages from first page
        if (currentPage == 1) {
          if (leaderboardData['data']['total_pages'] != null) {
            totalPages = leaderboardData['data']['total_pages'];
          } else if (leaderboardData['data']['last_page'] != null) {
            totalPages = leaderboardData['data']['last_page'];
          }
          print('Total pages to search: $totalPages');
        }

        final List<dynamic> entries = leaderboardData['data']['data'];
        if (entries.isEmpty) {
          print('No entries found in page $currentPage');
          break;
        }

        print('Found ${entries.length} entries in page $currentPage');

        // Filter user's teams (where is_yours == 1)
        for (final entry in entries) {
          print('Checking entry: is_yours=${entry['is_yours']}, team_name=${entry['team_name']}, team_count=${entry['team_count']}');

          if (entry['is_yours'] == 1 || entry['is_yours'] == true) {
            print('Found user team: ${entry['team_name']} - Team ${entry['team_count']}');
            userTeams.add({
              'teamNumber': entry['team_count'] ?? entry['team_number'] ?? userTeams.length + 1,
              'teamName': entry['team_name'] ?? 'My Team ${userTeams.length + 1}',
              'teamId': entry['team_id'],
              'points': double.tryParse(entry['point']?.toString() ?? '0') ?? 0.0,
              'rank': int.tryParse(entry['rank']?.toString() ?? '0') ?? 0,
              'previousRank': entry['previous_rank'] ?? entry['prev_rank'],
              'winningAmount': double.tryParse(entry['winning_amount']?.toString() ?? '0') ?? 0.0,
              'inWinningZone': entry['in_winning_zone'] ?? entry['winning_zone'] ?? false,
            });
          }
        }

        currentPage++;

        // Safety limit to prevent infinite loop
        if (currentPage > 100) {
          print('Reached maximum page limit while fetching user teams');
          break;
        }
      }

      print('Found ${userTeams.length} user teams total');

      // Remove duplicates based on teamId and teamNumber combination
      final Map<String, Map<String, dynamic>> uniqueTeamsMap = {};
      for (final team in userTeams) {
        final uniqueKey = '${team['teamId']}_${team['teamNumber']}';
        if (!uniqueTeamsMap.containsKey(uniqueKey)) {
          uniqueTeamsMap[uniqueKey] = team;
        } else {
          print('Duplicate team found and removed: ${team['teamName']} - T${team['teamNumber']}');
        }
      }

      final uniqueUserTeams = uniqueTeamsMap.values.toList();
      print('After removing duplicates: ${uniqueUserTeams.length} unique teams');

      // Sort teams by rank (best rank first)
      uniqueUserTeams.sort((a, b) => (a['rank'] as int).compareTo(b['rank'] as int));

      return {
        'status': true,
        'userTeams': uniqueUserTeams,
        'totalTeams': uniqueUserTeams.length,
        'bestRank': uniqueUserTeams.isNotEmpty ? uniqueUserTeams.first['rank'] : null,
        'totalPoints': uniqueUserTeams.isNotEmpty
            ? uniqueUserTeams.fold(0.0, (sum, team) => sum + double.parse(team['points'].toString()))
            : 0.0,
      };
    } catch (e) {
      print('Error getting user teams: $e');
      return {
        'status': false,
        'error': e.toString(),
        'userTeams': [],
        'totalTeams': 0,
      };
    }
  }

  // Get user teams summary for a specific contest
  static Future<Map<String, dynamic>> getUserTeamsSummary({
    required String matchId,
    required String contestId, // Added contest_id parameter
  }) async {
    try {
      print('Getting user teams summary for match: $matchId, contest: $contestId');

      final userTeamsResponse = await getUserTeams(
        matchId: matchId,
        contestId: contestId,
      );

      if (!userTeamsResponse['status']) {
        return userTeamsResponse;
      }

      final List<Map<String, dynamic>> userTeams = userTeamsResponse['userTeams'];

      // Calculate additional statistics
      final teamsInWinningZone = userTeams.where((team) => team['inWinningZone'] == true).length;
      final totalWinnings = userTeams.fold(0.0, (sum, team) => sum + ((team['winningAmount'] ?? 0) as num).toDouble());

      print('Teams summary calculated:');
      print('- Total teams: ${userTeams.length}');
      print('- Teams in winning zone: $teamsInWinningZone');
      print('- Best rank: ${userTeams.isNotEmpty ? userTeams.first['rank'] : 'N/A'}');
      print('- Total points: ${userTeamsResponse['totalPoints']}');
      print('- Total winnings: $totalWinnings');

      return {
        'status': true,
        'userTeams': userTeams,
        'summary': {
          'totalTeams': userTeams.length,
          'teamsInWinningZone': teamsInWinningZone,
          'bestRank': userTeams.isNotEmpty ? userTeams.first['rank'] : null,
          'totalPoints': userTeamsResponse['totalPoints'],
          'totalWinnings': totalWinnings,
        }
      };
    } catch (e) {
      print('Error getting user teams summary: $e');
      return {
        'status': false,
        'error': e.toString(),
      };
    }
  }

  // Get first available contest ID for a match
  static Future<String?> getFirstContestId({required String matchId}) async {
    try {
      final userService = UserService();

      if (!userService.isLoggedIn || userService.authToken == null) {
        throw Exception('User not authenticated');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/joined-contest-list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${userService.authToken}',
        },
        body: jsonEncode({
          'match_id': int.parse(matchId),
          'filter_key': 1,
          'filter_type': 1,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData['status'] == true &&
            responseData['data'] != null &&
            responseData['data']['joined_contest'] != null &&
            responseData['data']['joined_contest'].isNotEmpty) {

          final firstContest = responseData['data']['joined_contest'][0];
          return firstContest['contest_id']?.toString();
        }
      }

      return null;
    } catch (e) {
      print('Error getting first contest ID: $e');
      return null;
    }
  }

  // DEPRECATED methods - keeping for backward compatibility
  static Future<Map<String, dynamic>> getUserPosition({
    required String matchId,
  }) async {
    print('getUserPosition is deprecated. Use getUserTeams instead.');
    return {
      'status': false,
      'error': 'This method is deprecated. Use getUserTeams instead.',
      'found': false,
    };
  }

  static Future<Map<String, dynamic>> getLeaderboardSummary({
    required String matchId,
  }) async {
    print('getLeaderboardSummary is deprecated. Use getUserTeamsSummary instead.');
    return {
      'status': false,
      'error': 'This method is deprecated. Use getUserTeamsSummary instead.',
    };
  }
}