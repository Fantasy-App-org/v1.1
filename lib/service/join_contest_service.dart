// lib/service/join_contest_service.dart
import '../api/join_contest_api.dart';
import '../model/contest.dart';
import '../model/user_team.dart';
import '../model/fixture.dart';

class JoinContestService {

  /// Join a contest with the selected team
  Future<Map<String, dynamic>> joinContest({
    required FixtureModel fixture,
    required Contest contest,
    required UserTeam team,
  }) async {
    try {
      // Extract UserTeam ID from the teamId field
      if (team.teamId == null) {
        throw Exception('Team ID is null. Cannot join contest without valid team ID.');
      }

      final result = await JoinContestApi.joinContest(
        seriesId: fixture.seriesId,
        matchId: fixture.id,
        teamId: team.teamId!, // Use the teamId from UserTeam model
        contestId: contest.contestId ?? 0,
      );

      return result;
    } catch (e) {
      print('JoinContestService Error: $e');
      throw Exception('Failed to join contest: $e');
    }
  }

  /// Check if join was successful
  bool isJoinSuccessful(Map<String, dynamic> response) {
    return response['status'] == true || response['success'] == true;
  }

  /// Get success message from response
  String getSuccessMessage(Map<String, dynamic> response) {
    return response['message'] ?? 'Successfully joined contest!';
  }

  /// Get error message from response
  String getErrorMessage(Map<String, dynamic> response) {
    return response['message'] ?? 'Failed to join contest';
  }
}