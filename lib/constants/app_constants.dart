
// lib/constants/app_constants.dart
class AppConstants {
  // Team constraints
  static const int maxPlayersInTeam = 11;
  static const int minPlayersInTeam = 11;
  static const int maxPlayersFromOneTeam = 7;
  static const double maxCredits = 100.0;

  // Role constraints
  static const int minWicketKeepers = 1;
  static const int maxWicketKeepers = 4;
  static const int minBatsmen = 3;
  static const int maxBatsmen = 6;
  static const int minAllRounders = 1;
  static const int maxAllRounders = 4;
  static const int minBowlers = 3;
  static const int maxBowlers = 6;

  // App settings
  static const String appName = 'Fantasy Cricket';
  static const String appVersion = '1.0.0';

  // Cache keys
  static const String fixturesCacheKey = 'fixtures';
  static const String contestsCacheKey = 'contests';
  static const String playersCacheKey = 'players';
  static const String userTeamsCacheKey = 'user_teams';

  // Refresh intervals
  static const Duration fixturesRefreshInterval = Duration(minutes: 5);
  static const Duration liveMatchRefreshInterval = Duration(minutes: 1);
  static const Duration contestsRefreshInterval = Duration(minutes: 2);
}
