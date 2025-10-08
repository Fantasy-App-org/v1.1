// lib/model/create_team_request.dart
class CreateTeamRequest {
  final int captainId;
  final int viceCaptainId;
  final int matchId;
  final int sportsId;
  final List<int> playerIds;
  final String teamId;
  final int seriesId;

  CreateTeamRequest({
    required this.captainId,
    required this.viceCaptainId,
    required this.matchId,
    required this.sportsId,
    required this.playerIds,
    required this.teamId,
    required this.seriesId,
  });

  Map<String, dynamic> toJson() {
    return {
      'captain_id': captainId,
      'vice_captain_id': viceCaptainId,
      'match_id': matchId,
      'sports_id': sportsId,
      'player_id': playerIds,
      'team_id': teamId,
      'series_id': seriesId,
    };
  }
}