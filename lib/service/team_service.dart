// lib/service/team_service.dart
import '../model/user_team.dart';
import '../model/player.dart';
import '../model/create_team_request.dart';
import '../api/team_api.dart';
import '../service/user_service.dart';

class TeamService {
  static final TeamService _instance = TeamService._internal();
  static final UserService _userService = UserService();

  List<UserTeam> _userTeams = [];
  List<Player> _players = [];
  bool _isLoading = false;
  String? _lastError;

  factory TeamService() {
    return _instance;
  }

  TeamService._internal();

  /// Getters
  List<UserTeam> get userTeams => _userTeams;
  List<Player> get players => _players;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  /// Get user teams for a specific match
  Future<List<UserTeam>> getUserTeamsForMatch({
    required int matchId,
    required int seriesId,
    String contestId = "",
  }) async {
    try {
      _isLoading = true;
      _lastError = null;

      // Ensure user is authenticated
      await _ensureAuthenticated();

      print('Loading user teams for match ID: $matchId, series ID: $seriesId');
      final response = await TeamApi.getUserTeam(
        matchId: matchId,
        seriesId: seriesId,
        contestId: contestId,
      );

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> teamsData = response['data']['data'];
        _userTeams = teamsData.map((json) => UserTeam.fromJson(json)).toList();

        print('Successfully loaded ${_userTeams.length} user teams');
        return _userTeams;
      } else {
        throw Exception(response['message'] ?? 'Failed to load user teams');
      }
    } catch (e) {
      _lastError = e.toString();
      print('TeamService.getUserTeamsForMatch Error: $e');

      // Handle authentication errors
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// NEW METHOD: Get detailed team information by team ID
  Future<UserTeam> getUserTeamById({
    required String teamId,
    required int seriesId,
  }) async {
    try {
      _isLoading = true;
      _lastError = null;

      await _ensureAuthenticated();

      print('Loading team details for team ID: $teamId, series ID: $seriesId');
      final response = await TeamApi.getUserTeamById(
        teamId: teamId,
        seriesId: seriesId,
      );

      if (response['status'] == true && response['data'] != null) {
        // Handle the actual API response structure
        dynamic responseData = response['data'];

        // Extract the players array from data.data
        List<dynamic> playersArray = [];
        if (responseData is Map && responseData.containsKey('data')) {
          playersArray = responseData['data'] as List<dynamic>;
        } else if (responseData is List) {
          playersArray = responseData;
        }

        if (playersArray.isEmpty) {
          throw Exception('No players found in team');
        }

        // Parse all players
        List<Player> players = [];
        String? captain;
        String? viceCaptain;
        String? teamAName;
        String? teamBName;
        int teamACount = 0;
        int teamBCount = 0;
        int batCount = 0;
        int wkCount = 0;
        int arCount = 0;
        int bowlCount = 0;

        // Get team info from first player
        final firstPlayer = playersArray.first as Map<String, dynamic>;
        final teamName = firstPlayer['team_name']?.toString() ?? 'Unknown';

        for (var playerData in playersArray) {
          try {
            final player = Player.fromJson(playerData as Map<String, dynamic>);
            players.add(player);

            // Extract captain and vice-captain
            if (_parseBool(playerData['is_captain'])) {
              captain = player.playerName;
            }
            if (_parseBool(playerData['is_vice_captain'])) {
              viceCaptain = player.playerName;
            }

            // Count player types
            switch (player.role?.toLowerCase()) {
              case 'bat':
                batCount++;
                break;
              case 'wk':
                wkCount++;
                break;
              case 'ar':
                arCount++;
                break;
              case 'bowl':
                bowlCount++;
                break;
            }

            // Count team distribution (you'll need to determine this logic)
            // For now, just counting all as team A
            teamACount++;

          } catch (playerError) {
            print('Error parsing player: $playerError');
            // Continue with other players
          }
        }

        // Create UserTeam from extracted data
        final userTeam = UserTeam(
          teamId: int.tryParse(teamId),
          teamName: teamName,
          captain: captain,
          viceCaptain: viceCaptain,
          teamAName: teamAName ?? 'Team A',
          teamBName: teamBName ?? 'Team B',
          teamACount: teamACount,
          teamBCount: teamBCount,
          noOfBat: batCount,
          noOfWk: wkCount,
          noOfAr: arCount,
          noOfBowl: bowlCount,
          teamPlayers: players,
        );

        print('Successfully created team: ${userTeam.teamName}');
        print('Players count: ${players.length}');
        print('Captain: $captain, Vice Captain: $viceCaptain');

        return userTeam;
      } else {
        throw Exception(response['message'] ?? 'Failed to load team details');
      }
    } catch (e) {
      _lastError = e.toString();
      print('TeamService.getUserTeamById Error: $e');
      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// NEW METHOD: Switch team in contest
  Future<bool> switchTeam({
    required int matchId,
    required int contestId,
    required int oldTeamId,
    required int newTeamId,
  }) async {
    try {
      _isLoading = true;
      _lastError = null;

      await _ensureAuthenticated();

      print('Switching team - Match: $matchId, Contest: $contestId, Old: $oldTeamId, New: $newTeamId');

      final response = await TeamApi.switchTeam(
        matchId: matchId,
        contestId: contestId,
        oldTeamId: oldTeamId,
        newTeamId: newTeamId,
      );

      if (response['status'] == true) {
        print('Successfully switched team');
        return true;
      } else {
        throw Exception(response['message'] ?? 'Failed to switch team');
      }
    } catch (e) {
      _lastError = e.toString();
      print('TeamService.switchTeam Error: $e');

      // Handle authentication errors
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Get squad list for a specific match
  Future<List<Player>> getSquadListForMatch({
    required int seriesId,
    required int matchId,
  }) async {
    try {
      _isLoading = true;
      _lastError = null;

      // Ensure user is authenticated
      await _ensureAuthenticated();

      print('Loading squad list for match ID: $matchId, series ID: $seriesId');
      final response = await TeamApi.getSquadList(
        seriesId: seriesId,
        matchId: matchId,
      );

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> playersData = response['data']['data'];
        _players = playersData.map((json) => Player.fromJson(json)).toList();

        print('Successfully loaded ${_players.length} players');
        return _players;
      } else {
        throw Exception(response['message'] ?? 'Failed to load squad list');
      }
    } catch (e) {
      _lastError = e.toString();
      print('TeamService.getSquadListForMatch Error: $e');

      // Handle authentication errors
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Create a new user team
  Future<Map<String, dynamic>> createTeam({
    required int captainId,
    required int viceCaptainId,
    required int matchId,
    required int sportsId,
    required List<int> playerIds,
    String teamId = "",
    required int seriesId,
  }) async {
    try {
      _isLoading = true;
      _lastError = null;

      // Ensure user is authenticated
      await _ensureAuthenticated();

      final request = CreateTeamRequest(
        captainId: captainId,
        viceCaptainId: viceCaptainId,
        matchId: matchId,
        sportsId: sportsId,
        playerIds: playerIds,
        teamId: teamId,
        seriesId: seriesId,
      );

      print('Creating team for match ID: $matchId');
      final response = await TeamApi.createUserTeam(request);

      if (response['status'] == true) {
        print('Successfully created team');
        return response;
      } else {
        throw Exception(response['message'] ?? 'Failed to create team');
      }
    } catch (e) {
      _lastError = e.toString();
      print('TeamService.createTeam Error: $e');

      // Handle authentication errors
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  /// Helper method to ensure authentication
  Future<void> _ensureAuthenticated() async {
    if (!_userService.isLoggedIn) {
      final isLoggedIn = await _userService.checkLoginStatus();
      if (!isLoggedIn) {
        throw Exception('Authentication required. Please login first.');
      }
    }

    if (_userService.authToken == null) {
      throw Exception('Authentication token not available. Please login again.');
    }
  }

  /// NEW METHOD: Get lineup for a match
  Future<int?> getLineupForMatch({
    required int seriesId,
    required int matchId,
  }) async {
    try {
      _isLoading = true;
      _lastError = null;

      await _ensureAuthenticated();

      print('Fetching lineup for match $matchId, series $seriesId');
      final lineup = await TeamApi.getLineup(
        seriesId: seriesId,
        matchId: matchId,
      );

      print('✅ Lineup fetched: $lineup');
      return lineup;
    } catch (e) {
      _lastError = e.toString();
      print('TeamService.getLineupForMatch Error: $e');
      throw Exception('Service error: $e');
    } finally {
      _isLoading = false;
    }
  }

  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase().trim();
      return lower == 'true' || lower == '1' || lower == 'yes';
    }
    return false;
  }

  /// Clear cached data
  void clearCache() {
    _userTeams.clear();
    _players.clear();
    _lastError = null;
  }
}