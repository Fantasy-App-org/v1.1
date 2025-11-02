// lib/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://13.232.147.237:3000';
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 10);
  static const Duration longTimeout = Duration(seconds: 60);

  // API Endpoints
  static const String fixturesEndpoint = '/web-services/fixtures';
  static const String contestListEndpoint = '/web-services/contest_list';
  static const String joinedContestListEndpoint = '/web-services/joined-contest-list';
  static const String joinedContestDetailsEndpoint = '/web-services/joined-contest-details';
  static const String joinedContestDetailEndpoint = '/web-services/joined-contest-detail';
  static const String joinedContestMatchesEndpoint = '/web-services/joined-contest-matches';
  static const String getUserTeamEndpoint = '/web-services/getuserteam';
  static const String myMatchesEndpoint = '/web-services/my-matches';
  static const String squadListEndpoint = '/web-services/squadlist';
  static const String createUserTeamEndpoint = '/web-services/createuserteam';

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