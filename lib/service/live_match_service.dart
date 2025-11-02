import '../model/fixture.dart';
import '../api/live_match_api.dart';
import '../service/user_service.dart';
import '../config/debug_config.dart';

class LiveMatchService {
  static final LiveMatchService _instance = LiveMatchService._internal();
  static final UserService _userService = UserService();

  List<FixtureModel> _liveMatches = [];
  bool _isLoading = false;
  String? _lastError;

  factory LiveMatchService() {
    return _instance;
  }

  LiveMatchService._internal();

  /// Getters
  List<FixtureModel> get liveMatches => _liveMatches;
  bool get isLoading => _isLoading;
  String? get lastError => _lastError;

  /// Load live matches only
  Future<List<FixtureModel>> getLiveMatches() async {
    try {
      _isLoading = true;
      _lastError = null;

      // Ensure user is authenticated
      await _ensureAuthenticated();

      DebugConfig.debugPrint('LiveMatchService: Loading live matches...');
      final response = await LiveMatchApi.getLiveMatches();

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> matchesData = response['data'];
        _liveMatches = matchesData.map((json) => FixtureModel.fromJson(json)).toList();

        DebugConfig.debugPrint('LiveMatchService: Successfully loaded ${_liveMatches.length} live matches');
        return _liveMatches;
      } else {
        throw Exception(response['message'] ?? 'Failed to load live matches');
      }
    } catch (e) {
      _lastError = e.toString();
      DebugConfig.debugPrint('LiveMatchService.getLiveMatches Error: $e');

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

  /// Refresh live matches
  Future<void> refreshLiveMatches() async {
    await getLiveMatches();
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

  /// Clear cached live matches
  void clearCache() {
    _liveMatches.clear();
    _lastError = null;
  }

  /// Check authentication status
  bool needsAuthentication() {
    return !_userService.isLoggedIn || _userService.authToken == null;
  }

  String getAuthStatus() {
    if (!_userService.isLoggedIn) {
      return 'Not logged in';
    }
    if (_userService.authToken == null) {
      return 'No auth token';
    }
    return 'Authenticated';
  }
}