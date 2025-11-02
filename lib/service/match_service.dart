// lib/service/match_service.dart
import '../model/fixture.dart';
import '../api/match_api.dart';
import '../service/user_service.dart';

class MatchService {
  static final MatchService _instance = MatchService._internal();
  static final UserService _userService = UserService();

  List<FixtureModel> _myMatches = [];
  List<FixtureModel> _joinedContestMatches = [];
  bool _isLoading = false;
  String? _lastError;

  factory MatchService() {
    return _instance;
  }

  MatchService._internal();

  /// Getters
  List<FixtureModel> get myMatches => _myMatches;
  List<FixtureModel> get joinedContestMatches => _joinedContestMatches;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  /// Load my matches
  Future<List<FixtureModel>> getMyMatches() async {
    try {
      _isLoading = true;
      _lastError = null;

      // Ensure user is authenticated
      await _ensureAuthenticated();

      print('Loading my matches...');
      final response = await MatchApi.getMyMatches();

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> matchesData = response['data'];
        _myMatches = matchesData.map((json) => FixtureModel.fromJson(json)).toList();

        print('Successfully loaded ${_myMatches.length} my matches');
        return _myMatches;
      } else {
        throw Exception(response['message'] ?? 'Failed to load my matches');
      }
    } catch (e) {
      _lastError = e.toString();
      print('MatchService.getMyMatches Error: $e');

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

  /// Load joined contest matches
  Future<List<FixtureModel>> getJoinedContestMatches() async {
    try {
      _isLoading = true;
      _lastError = null;

      // Ensure user is authenticated
      await _ensureAuthenticated();

      print('Loading joined contest matches...');
      final response = await MatchApi.getJoinedContestMatches();

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> matchesData = response['data'];
        _joinedContestMatches = matchesData.map((json) => FixtureModel.fromJson(json)).toList();

        print('Successfully loaded ${_joinedContestMatches.length} joined contest matches');
        return _joinedContestMatches;
      } else {
        throw Exception(response['message'] ?? 'Failed to load joined contest matches');
      }
    } catch (e) {
      _lastError = e.toString();
      print('MatchService.getJoinedContestMatches Error: $e');

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

  /// Get match players
  Future<Map<String, dynamic>> getMatchPlayers({
    required int seriesId,
    required int matchId,
  }) async {
    try {
      await _ensureAuthenticated();
      return await MatchApi.getMatchPlayers(
        seriesId: seriesId,
        matchId: matchId,
      );
    } catch (e) {
      print('MatchService.getMatchPlayers Error: $e');
      throw Exception('Service error: $e');
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
    _myMatches.clear();
    _joinedContestMatches.clear();
    _lastError = null;
  }
}
