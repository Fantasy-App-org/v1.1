// Create this as a new file: lib/config/debug_config.dart

import 'dart:io';
import 'package:flutter/foundation.dart';

class DebugConfig {
  // Main debug switch - set to false for production
  static const bool isDebugMode = false;

  // Platform-specific checks
  static bool get isDesktop => !kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS);
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);
  static bool get isWeb => kIsWeb;

  // Feature flags for debugging
  static bool get enableApiCalls => !isDebugMode || !isDesktop;
  static bool get enableImagePicker => !isDebugMode || isMobile;
  static bool get enableAuthentication => !isDebugMode || !isDesktop;
  static bool get enableNetworkFeatures => !isDebugMode || !isDesktop;

  // Mock data for debugging
  static const Map<String, dynamic> mockUserData = {
    'name': 'Debug User',
    'username': 'debug_user',
    'email': 'debug@example.com',
    'mobile_number': '+91 9876543210',
    'wallet_balance': '1250.50',
    'notification_count': '3',
    'is_premium': false,
    'total_matches': 45,
    'total_wins': 12,
    'win_rate': 26.7,
    'total_earnings': '5420.75',
    'contests_joined': 78,
    'best_rank': 3,
    'current_level': 5,
    'date_of_birth': '1995-06-15',
    'address': '123 Debug Street, Test City',
    'image': null,
  };

  static const List<Map<String, dynamic>> mockFixtures = [
    {
      'id': 1,
      'teamA': 'Mumbai Indians',
      'teamB': 'Chennai Super Kings',
      'teamAShort': 'MI',
      'teamBShort': 'CSK',
      'matchTitle': 'IPL 2024 - Match 1',
      'matchType': 'T20',
      'matchDate': '2024-06-20T14:30:00Z',
      'totalContest': 25,
      'matchContest': '₹10,000',
      'lineupOut': true,
      'status': 'upcoming'
    },
    {
      'id': 2,
      'teamA': 'Royal Challengers Bangalore',
      'teamB': 'Delhi Capitals',
      'teamAShort': 'RCB',
      'teamBShort': 'DC',
      'matchTitle': 'IPL 2024 - Match 2',
      'matchType': 'T20',
      'matchDate': '2024-06-21T19:30:00Z',
      'totalContest': 18,
      'matchContest': '₹7,500',
      'lineupOut': false,
      'status': 'live'
    },
  ];

  static void debugPrint(String message) {
    if (isDebugMode) {
      print('🐛 DEBUG: $message');
    }
  }

  static Future<void> mockDelay() async {
    if (isDebugMode) {
      await Future.delayed(Duration(milliseconds: 500)); // Simulate network delay
    }
  }
}