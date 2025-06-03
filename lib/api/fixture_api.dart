import 'dart:convert';
import 'package:http/http.dart' as http;
import '../service/user_service.dart';

class FixtureApi {
  static const String baseUrl = 'http://13.232.147.237:3000'; // Replace with your actual API URL
  static final UserService _userService = UserService();

  static Future<Map<String, dynamic>> getFixtures({int page = 1}) async {
    try {
      // Check if user is authenticated
      if (!_userService.isLoggedIn || _userService.authToken == null) {
        throw Exception('Authentication required. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/web-services/fixtures?page=$page'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_userService.authToken}', // Use Bearer token
        },
      );

      print('Fixtures API Response Status: ${response.statusCode}');
      print('Fixtures API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to load fixtures: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching fixtures: $e');
      throw Exception('Error fetching fixtures: $e');
    }
  }

  static Future<Map<String, dynamic>> activateFixture(int fixtureId) async {
    try {
      // Check if user is authenticated
      if (!_userService.isLoggedIn || _userService.authToken == null) {
        throw Exception('Authentication required. Please login first.');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/fixtures/activate'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_userService.authToken}', // Use Bearer token
        },
        body: json.encode({'id': fixtureId}),
      );

      print('Activate Fixture API Response Status: ${response.statusCode}');
      print('Activate Fixture API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to activate fixture: ${response.statusCode}');
      }
    } catch (e) {
      print('Error activating fixture: $e');
      throw Exception('Error activating fixture: $e');
    }
  }

  // Alternative method using UserService's makeAuthenticatedRequest
  static Future<Map<String, dynamic>> getFixturesUsingUserService({int page = 1}) async {
    try {
      final response = await _userService.makeAuthenticatedRequest(
        endpoint: '/web-services/fixtures?page=$page',
        method: 'GET',
      );

      print('Fixtures API Response Status: ${response.statusCode}');
      print('Fixtures API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to load fixtures: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching fixtures: $e');
      throw Exception('Error fetching fixtures: $e');
    }
  }

  static Future<Map<String, dynamic>> activateFixtureUsingUserService(int fixtureId) async {
    try {
      final response = await _userService.makeAuthenticatedRequest(
        endpoint: '/fixtures/activate',
        method: 'POST',
        body: {'id': fixtureId},
      );

      print('Activate Fixture API Response Status: ${response.statusCode}');
      print('Activate Fixture API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to activate fixture: ${response.statusCode}');
      }
    } catch (e) {
      print('Error activating fixture: $e');
      throw Exception('Error activating fixture: $e');
    }
  }
}