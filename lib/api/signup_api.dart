//api/signup_api.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fantasy/service/signup_service.dart';

class SignupApi {
  static final SignupService _signupService = SignupService();

  // Initialize the signup service
  static Future<void> initialize() async {
    await _signupService.initialize();
  }

  // Request OTP for signup - FIXED to return otpToken
  static Future<Map<String, dynamic>> requestSignupOtp(String contact, String userName, String inviteCode) async {
    try {
      // Ensure service is initialized
      await _signupService.initialize();

      bool success = await _signupService.requestSignupOtp(contact, userName, inviteCode);

      if (success) {
        // Get the otpToken from the service after successful request
        String? otpToken = _signupService.otpToken;

        return {
          'success': true,
          'message': 'OTP sent successfully',
          'otpToken': otpToken, // Include the otpToken in response
          'data': {
            'otpToken': otpToken,
            'contact': contact,
            'userName': userName,
            'inviteCode': inviteCode,
          }
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to send OTP. Please try again.'
        };
      }
    } catch (e) {
      print('SignupApi requestSignupOtp error: $e');

      // Check for specific error types
      String errorMessage = 'An error occurred. Please try again.';
      if (e.toString().contains('user already exist')) {
        errorMessage = 'This account already exists. Please login instead.';
      } else if (e.toString().contains('invalid invite code')) {
        errorMessage = 'Invalid referral code. Please check and try again.';
      } else if (e.toString().contains('network') || e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection.';
      }

      return {
        'success': false,
        'message': errorMessage
      };
    }
  }

  // Verify OTP for signup - FIXED to handle both signup and login flows
  static Future<bool> verifySignupOtp(String otp) async {
    try {
      // This is for login flow (backward compatibility)
      return await _signupService.verifySignupOtp(otp);
    } catch (e) {
      print('Error verifying login OTP: $e');
      return false;
    }
  }

  // NEW METHOD: Verify OTP specifically for signup flow
  static Future<bool> verifySignupOtpForSignup(
      String otp,
      String? otpToken, {
        String? fcmToken,
      }) async {
    try {
      print('SignupApi verifySignupOtpForSignup called with:');
      print('- OTP: $otp');
      print('- otpToken: $otpToken');
      print('- fcmToken: $fcmToken');

      // Use provided otpToken or get from service
      String? tokenToUse = otpToken ?? _signupService.otpToken;

      if (tokenToUse == null || tokenToUse.isEmpty) {
        print('Error: No otpToken available for signup verification');
        return false;
      }

      // Make the API call directly with proper signup parameters
      return await _verifySignupOtpDirectly(otp, tokenToUse, fcmToken ?? "test_fcm_token");

    } catch (e) {
      print('Error verifying signup OTP: $e');
      return false;
    }
  }

  // Direct API call for signup OTP verification with proper format
  static Future<bool> _verifySignupOtpDirectly(
      String otp,
      String otpToken,
      String fcmToken
      ) async {
    try {
      String baseUrl = _signupService.baseUrl;

      final Map<String, dynamic> requestBody = {
        'user_otp': otp,
        'isSignUp': true, // KEY FIX: This ensures signup flow
        'otpToken': otpToken,
        'fcm_token': fcmToken,
      };

      print('Verify Signup OTP request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/verify-otp'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('Verify Signup OTP response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        // Check if verification was successful
        bool isSuccess = false;
        if (responseData['status'] == true || responseData['success'] == true) {
          isSuccess = true;
        } else if (responseData['data'] != null) {
          // If there's data, assume success
          isSuccess = true;
        }

        if (isSuccess) {
          // Store any auth token received
          if (responseData.containsKey('token') || responseData.containsKey('authToken')) {
            String authToken = responseData['token'] ?? responseData['authToken'];
            await _storeAuthToken(authToken);
          }

          return true;
        }

        return false;
      } else {
        print('Signup verification failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error in direct signup OTP verification: $e');
      return false;
    }
  }

  // Store auth token securely
  static Future<void> _storeAuthToken(String token) async {
    print('Storing auth token: ${token.substring(0, 20)}...');
    // You can implement secure storage here if needed
    // For now, we'll let the SignupService handle this
  }

  // Get signup data
  static Map<String, dynamic>? getSignupData() {
    return _signupService.signupData;
  }

  // Get OTP token
  static String? getOtpToken() {
    return _signupService.otpToken;
  }

  // Check if signup is in progress
  static bool isSignupInProgress() {
    return _signupService.isSignupInProgress;
  }

  // Cancel signup process
  static Future<void> cancelSignup() async {
    await _signupService.cancelSignup();
  }

  // Get signup status for debugging
  static Map<String, dynamic> getSignupStatus() {
    return _signupService.getSignupStatus();
  }

  // Clear any stored tokens (useful for logout)
  static Future<void> clearTokens() async {
    await _signupService.cancelSignup();
  }
}