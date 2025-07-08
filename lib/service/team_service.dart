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

  /// Clear cached data
  void clearCache() {
    _userTeams.clear();
    _players.clear();
    _lastError = null;
  }
}