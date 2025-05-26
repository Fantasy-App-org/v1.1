import '../model/fixture.dart';
import '../api/fixture_api.dart';
import '../service/user_service.dart';

class FixtureService {
  static final UserService _userService = UserService();

  static Future<List<FixtureModel>> getFixtures({int page = 1}) async {
    try {
      // Ensure user is authenticated before making API call
      await _ensureAuthenticated();

      final response = await FixtureApi.getFixtures(page: page);

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> fixturesData = response['data']['data'];
        return fixturesData.map((json) => FixtureModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('FixtureService Error: $e');

      // Handle authentication errors specifically
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    }
  }

  static Future<bool> activateFixture(int fixtureId) async {
    try {
      // Ensure user is authenticated before making API call
      await _ensureAuthenticated();

      final response = await FixtureApi.activateFixture(fixtureId);
      return response['status'] == true;
    } catch (e) {
      print('FixtureService Activate Error: $e');

      // Handle authentication errors specifically
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    }
  }

  // Alternative methods using UserService directly
  static Future<List<FixtureModel>> getFixturesWithUserService({int page = 1}) async {
    try {
      // Ensure user is authenticated before making API call
      await _ensureAuthenticated();

      final response = await FixtureApi.getFixturesUsingUserService(page: page);

      if (response['status'] == true && response['data'] != null) {
        final List<dynamic> fixturesData = response['data']['data'];
        return fixturesData.map((json) => FixtureModel.fromJson(json)).toList();
      } else {
        throw Exception(response['message'] ?? 'Unknown error occurred');
      }
    } catch (e) {
      print('FixtureService Error: $e');

      // Handle authentication errors specifically
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    }
  }

  static Future<bool> activateFixtureWithUserService(int fixtureId) async {
    try {
      // Ensure user is authenticated before making API call
      await _ensureAuthenticated();

      final response = await FixtureApi.activateFixtureUsingUserService(fixtureId);
      return response['status'] == true;
    } catch (e) {
      print('FixtureService Activate Error: $e');

      // Handle authentication errors specifically
      if (e.toString().contains('Authentication required') ||
          e.toString().contains('Authentication failed')) {
        throw Exception('Authentication required');
      }

      throw Exception('Service error: $e');
    }
  }

  // Helper method to ensure authentication
  static Future<void> _ensureAuthenticated() async {
    if (!_userService.isLoggedIn) {
      // Try to load user state first
      final isLoggedIn = await _userService.checkLoginStatus();
      if (!isLoggedIn) {
        throw Exception('Authentication required. Please login first.');
      }
    }

    if (_userService.authToken == null) {
      throw Exception('Authentication token not available. Please login again.');
    }
  }

  // Utility methods remain the same
  static List<FixtureModel> filterLiveMatches(List<FixtureModel> fixtures) {
    return fixtures.where((fixture) => fixture.status == 'live').toList();
  }

  static List<FixtureModel> filterUpcomingMatches(List<FixtureModel> fixtures) {
    return fixtures.where((fixture) => fixture.status == 'upcoming').toList();
  }

  static String formatTimeLeft(DateTime matchDate) {
    final now = DateTime.now();
    final difference = matchDate.difference(now);

    if (difference.isNegative) {
      return 'Started';
    }

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    } else {
      return '${difference.inMinutes}m';
    }
  }

  static String getTeamFlag(String teamName) {
    // Map team names to flag emojis
    const flagMap = {
      'India': '🇮🇳',
      'Australia': '🇦🇺',
      'England': '🇬🇧',
      'Pakistan': '🇵🇰',
      'South Africa': '🇿🇦',
      'New Zealand': '🇳🇿',
      'Sri Lanka': '🇱🇰',
      'Bangladesh': '🇧🇩',
      'West Indies': '🇯🇲',
      'Afghanistan': '🇦🇫',
    };

    return flagMap[teamName] ?? '🏏';
  }

  // Method to check if user needs to re-authenticate
  static bool needsAuthentication() {
    return !_userService.isLoggedIn || _userService.authToken == null;
  }

  // Method to get current auth status
  static Map<String, dynamic> getAuthStatus() {
    return {
      'isLoggedIn': _userService.isLoggedIn,
      'hasToken': _userService.authToken != null,
      'tokenPreview': _userService.authToken != null
          ? '${_userService.authToken!.substring(0, 10)}...'
          : null,
    };
  }
}