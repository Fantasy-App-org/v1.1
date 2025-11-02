import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fantasy/service/user_service.dart';

class ProfileApi {
  static const String baseUrl = 'http://13.60.210.139:3000';
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

  /// Update personal details using the new API endpoint
  static Future<Map<String, dynamic>> updatePersonalDetails({
    required String name,
    required String email,
    required int gender,
    required String dateOfBirth,
    required String address,
    required String city,
    required String state,
    required String country,
    required String pincode,
  }) async {
    try {
      // Check if user is authenticated
      if (!_userService.isLoggedIn || _userService.authToken == null) {
        throw Exception('Authentication required. Please login first.');
      }

      final requestBody = {
        "name": name,
        "email": email,
        "gender": gender,
        "date_of_birth": dateOfBirth,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
      };

      print('Update Personal Details Request Body: ${json.encode(requestBody)}');

      final response = await http.put( // CHANGED FROM POST TO PUT
        Uri.parse('$baseUrl/web-services/update_personal_details'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${_userService.authToken}',
        },
        body: json.encode(requestBody),
      );

      print('Update Personal Details API Response Status: ${response.statusCode}');
      print('Update Personal Details API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to update personal details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating personal details: $e');
      throw Exception('Error updating personal details: $e');
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

  /// Update personal details using UserService
  static Future<Map<String, dynamic>> updatePersonalDetailsUsingUserService({
    required String name,
    required String email,
    required int gender,
    required String dateOfBirth,
    required String address,
    required String city,
    required String state,
    required String country,
    required String pincode,
  }) async {
    try {
      final requestBody = {
        "name": name,
        "email": email,
        "gender": gender,
        "date_of_birth": dateOfBirth,
        "address": address,
        "city": city,
        "state": state,
        "country": country,
        "pincode": pincode,
      };

      final response = await _userService.makeAuthenticatedRequest(
        endpoint: '/web-services/update_personal_details',
        method: 'PUT', // CHANGED FROM POST TO PUT
        body: requestBody,
      );

      print('Update Personal Details API Response Status: ${response.statusCode}');
      print('Update Personal Details API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else {
        throw Exception('Failed to update personal details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error updating personal details: $e');
      throw Exception('Error updating personal details: $e');
    }
  }
  static Future<Map<String, dynamic>> getReferrals() async {
    try {
      print('🔍 API: Fetching referrals from separate endpoint...');

      final response = await _userService.makeAuthenticatedRequest(
        endpoint: '/web-services/referrals',
        method: 'GET',
      );

      print('📡 Referrals API Response: ${response.statusCode}');
      print('📡 Referrals API Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return responseData;
      } else {
        throw Exception('Failed to fetch referrals: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Referrals API Error: $e');
      throw Exception('Network error: $e');
    }
  }
}