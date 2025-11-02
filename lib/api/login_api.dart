import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fantasy/service/user_service.dart'; // Import the UserService

class LoginApi {
  static final UserService _userService = UserService();

  // Use UserService methods directly instead of duplicating logic
  static Future<bool> requestOtp(String mobileNumber) async {
    return await _userService.requestOtp(mobileNumber);
  }

  static Future<bool> verifyOtp(String mobileNumber, String otp) async {
    return await _userService.verifyOtp(mobileNumber, otp);
  }

  // Additional helper method to get user data after login
  static Map<String, dynamic>? getUserData() {
    return _userService.userData;
  }

  // Helper method to get auth token
  static String? getAuthToken() {
    return _userService.authToken;
  }

  // Helper method to check if user is logged in
  static bool isLoggedIn() {
    return _userService.isLoggedIn;
  }

  // Helper method to logout
  static Future<void> logout() async {
    await _userService.logout();
  }

  // Helper method to make authenticated API calls
  static Future<http.Response> makeAuthenticatedRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    return await _userService.makeAuthenticatedRequest(
      endpoint: endpoint,
      method: method,
      body: body,
      additionalHeaders: additionalHeaders,
    );
  }
}