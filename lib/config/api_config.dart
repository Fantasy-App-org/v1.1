// lib/config/api_config.dart
class ApiConfig {
  // Production API
  static const String baseUrl = "http://api.start25pro.com:3000";
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(seconds: 60);

  // API Endpoints
  static const String fixturesEndpoint = '/web-services/fixtures';
  static const String activateFixtureEndpoint = '/web-services/fixtures/activate';
  static const String contestListEndpoint = '/web-services/contest_list';
  static const String contestDetailEndpoint = '/web-services/contest-detail';
  static const String joinedContestListEndpoint = '/web-services/joined-contest-list';
  static const String joinedContestDetailsEndpoint = '/web-services/joined-contest-details';
  static const String joinedContestDetailEndpoint = '/web-services/joined-contest-detail';
  static const String joinedContestMatchesEndpoint = '/web-services/joined-contest-matches';
  static const String getUserTeamEndpoint = '/web-services/getuserteam';
  static const String getUserTeamByIdEndpoint = '/web-services/getuserteambyid';
  static const String myMatchesEndpoint = '/web-services/my-matches';
  static const String squadListEndpoint = '/web-services/squadlist';
  static const String createUserTeamEndpoint = '/web-services/creatuserteam';
  static const String switchTeamEndpoint = '/web-services/switchteam';
  static const String getScorecardEndpoint = '/web-services/getscorecard';
  static const String getFullScorecardEndpoint = '/web-services/getfullscoredata';
  static const String teamDetailsEndpoint = '/web-services/team-details';
  static const String getPlayerStatsEndpoint = '/web-services/getplayerstats';
  static const String leaderboardEndpoint = '/web-services/leader_board';
  static const String signinEndpoint = '/web-services/signin';
  static const String logoutEndpoint = '/web-services/logout';
  static const String getReferralCodeEndpoint = '/web-services/getrefferalcode';
  static const String signupEndpoint = '/web-services/signup';
  static const String verifyOtpEndpoint = '/web-services/verify-otp';
  static const String profileEndpoint = '/web-services/profile';
  static const String updatePersonalDetailsEndpoint = '/web-services/update_personal_details';
  static const String uploadProfileImageEndpoint = '/web-services/upload-profile-image';
  static const String referralsEndpoint = '/web-services/referrals';
  static const String walletEndpoint = '/web-services/MLMWallet';
  static const String addCashEndpoint = '/web-services/AddCash';
  static const String withdrawAmountEndpoint = '/web-services/WithdrawAmount';
  static const String transactionHistoryEndpoint = '/web-services/TransactionHistory';
  static const String joinContestEndpoint = '/web-services/joinContest';

  // Request Headers
  static Map<String, String> getDefaultHeaders(String? authToken) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
    };

    if (authToken != null) {
      headers['Authorization'] = 'Bearer $authToken';
    }

    return headers;
  }

  // Environment-specific configurations
  static bool get isProduction => baseUrl.contains('production-url.com');
  static bool get isDevelopment => !isProduction;

  // Logging configuration
  static bool get enableApiLogging => isDevelopment;
  static bool get enableErrorLogging => true;
}


// lib/main.dart - Updated imports and initialization
/*
Add these imports to your main.dart:

import 'package:fantasy/config/api_config.dart';
import 'package:fantasy/utils/logger.dart';
import 'package:fantasy/utils/network_utils.dart';

Then in your main() function, add:

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logging
  Logger.setLoggingEnabled(ApiConfig.enableApiLogging);

  // Check initial network status
  final hasInternet = await NetworkUtils.hasInternetConnection();
  Logger.info('Initial network status: ${hasInternet ? 'Connected' : 'Disconnected'}');

  runApp(MyApp());
}
*/

// Add to pubspec.yaml dependencies:
/*
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0
  shared_preferences: ^2.2.2
    connectivity_plus: ^5.0.1

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
*/