// lib/api/contest_api.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../service/user_service.dart';

class ContestApi {
  static const String baseUrl = 'http://13.60.245.44:3000';
  static final UserService _userService = UserService();

  // Default headers for JSON requests
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Verify if user has sufficient wallet balance to join contest
  static Future<Map<String, dynamic>> verifyWalletAmount({
    required String entryFee,
    required String contestId,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw ContestApiException('Authentication token not available');
      }

      final url = Uri.parse('$baseUrl/contest/join-contest-wallet-amount');

      final headers = {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final requestBody = {
        'entry_fee': entryFee,
        'contest_id': contestId,
      };

      print('Verify Wallet API Request URL: $url');
      print('Verify Wallet API Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      ).timeout(timeout);

      print('Verify Wallet API Response Status: ${response.statusCode}');
      print('Verify Wallet API Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw ContestApiException('No internet connection. Please check your network.');
    } on HttpException {
      throw ContestApiException('Server error. Please try again later.');
    } on FormatException {
      throw ContestApiException('Invalid response format from server.');
    } catch (e) {
      print('ContestApi.verifyWalletAmount Error: $e');
      if (e is ContestApiException) rethrow;
      throw ContestApiException('Service error: $e');
    }
  }

  /// Join a contest with a specific team
  static Future<Map<String, dynamic>> joinContest({
    required String matchId,
    required String contestId,
    required String playerTeamId,
    required String seriesId,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw ContestApiException('Authentication token not available');
      }

      final url = Uri.parse('$baseUrl/contest/joinContest');

      final headers = {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final requestBody = {
        'match_id': matchId,
        'contest_id': contestId,
        'player_team_id': playerTeamId,
        'series_id': seriesId,
      };

      print('Join Contest API Request URL: $url');
      print('Join Contest API Request Body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(requestBody),
      ).timeout(timeout);

      print('Join Contest API Response Status: ${response.statusCode}');
      print('Join Contest API Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw ContestApiException('No internet connection. Please check your network.');
    } on HttpException {
      throw ContestApiException('Server error. Please try again later.');
    } on FormatException {
      throw ContestApiException('Invalid response format from server.');
    } catch (e) {
      print('ContestApi.joinContest Error: $e');
      if (e is ContestApiException) rethrow;
      throw ContestApiException('Service error: $e');
    }
  }

  /// Handles the HTTP response and converts it to Map<String, dynamic>
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
        // Check if the API returned success status
          if (jsonData['status'] == true) {
            return jsonData;
          } else {
            throw ContestApiException(
              jsonData['message'] ?? 'API returned error status',
            );
          }
        case 400:
          throw ContestApiException(
            jsonData['message'] ?? 'Bad request. Please check your input.',
          );
        case 401:
          throw ContestApiException('Unauthorized. Please login again.');
        case 403:
          throw ContestApiException('Access forbidden.');
        case 404:
          throw ContestApiException('Service not found.');
        case 422:
        // Handle validation errors
          throw ContestApiException(
            jsonData['message'] ?? 'Validation error. Please check your input.',
          );
        case 500:
          throw ContestApiException('Server error. Please try again later.');
        default:
          throw ContestApiException(
            'Request failed with status: ${response.statusCode}',
          );
      }
    } catch (e) {
      if (e is ContestApiException) rethrow;
      throw ContestApiException('Failed to parse server response.');
    }
  }
}

/// Custom exception class for contest API errors
class ContestApiException implements Exception {
  final String message;

  ContestApiException(this.message);

  @override
  String toString() => 'ContestApiException: $message';
}