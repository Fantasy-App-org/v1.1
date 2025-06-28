import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fantasy/service/user_service.dart';

class ProfileApi {
  static const String baseUrl = 'http://13.232.147.237:3000';
  static final UserService _userService = UserService();

  /// Get user profile data
  static Future<Map<String, dynamic>> getProfile() async {
    try {
      // Check if user is authenticated
      if (!_userService.isLoggedIn || _userService.authToken == null) {
        throw Exception('Authentication required. Please login first.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/web-services/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_userService.authToken}',
        },
      );

      print('Profile API Response Status: ${response.statusCode}');
      print('Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      throw Exception('Error fetching profile: $e');
    }
  }

  /// Update user profile data
  static Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> profileData) async {
    try {
      // Check if user is authenticated
      if (!_userService.isLoggedIn || _userService.authToken == null) {
        throw Exception('Authentication required. Please login first.');
      }

      final response = await http.put(
        Uri.parse('$baseUrl/web-services/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_userService.authToken}',
        },
        body: json.encode(profileData),
      );

      print('Update Profile API Response Status: ${response.statusCode}');
      print('Update Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Error updating profile: $e');
    }
  }

  /// Upload profile image
  static Future<Map<String, dynamic>> uploadProfileImage(String imagePath) async {
    try {
      // Check if user is authenticated
      if (!_userService.isLoggedIn || _userService.authToken == null) {
        throw Exception('Authentication required. Please login first.');
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/web-services/upload-profile-image'),
      );

      request.headers.addAll({
        'Authorization': 'Bearer ${_userService.authToken}',
      });

      request.files.add(await http.MultipartFile.fromPath('image', imagePath));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Upload Image API Response Status: ${response.statusCode}');
      print('Upload Image API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to upload image: ${response.statusCode}');
      }
    } catch (e) {
      print('Error uploading image: $e');
      throw Exception('Error uploading image: $e');
    }
  }

  /// Alternative method using UserService's makeAuthenticatedRequest
  static Future<Map<String, dynamic>> getProfileUsingUserService() async {
    try {
      final response = await _userService.makeAuthenticatedRequest(
        endpoint: '/web-services/profile',
        method: 'GET',
      );

      print('Profile API Response Status: ${response.statusCode}');
      print('Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching profile: $e');
      throw Exception('Error fetching profile: $e');
    }
  }

  /// Update profile using UserService
  static Future<Map<String, dynamic>> updateProfileUsingUserService(Map<String, dynamic> profileData) async {
    try {
      final response = await _userService.makeAuthenticatedRequest(
        endpoint: '/web-services/profile',
        method: 'PUT',
        body: profileData,
      );

      print('Update Profile API Response Status: ${response.statusCode}');
      print('Update Profile API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating profile: $e');
      throw Exception('Error updating profile: $e');
    }
  }
}