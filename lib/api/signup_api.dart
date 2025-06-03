import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fantasy/service/signup_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignupApi {
  static final SignupService _signupService = SignupService();

  // Initialize the signup service
  static Future<void> initialize() async {
    await _signupService.initialize();
  }

  // Request OTP for signup
  static Future<Map<String, dynamic>> requestSignupOtp(String contact, String userName, String inviteCode) async {
    try {
      // Ensure service is initialized
      await _signupService.initialize();

      bool success = await _signupService.requestSignupOtp(contact, userName, inviteCode);

      if (success) {
        return {
          'success': true,
          'message': 'OTP sent successfully'
        };
      } else {
        return {
          'success': false,
          'message': 'Failed to send OTP. Please try again.'
        };
      }
    } catch (e) {
      print('SignupApi requestSignupOtp error: $e');
      return {
        'success': false,
        'message': 'An error occurred: ${e.toString()}'
      };
    }
  }

  // Verify OTP for signup
  static Future<bool> verifySignupOtp(String otp) async {
    try {
      return await _signupService.verifySignupOtp(otp);
    } catch (e) {
      print('Error verifying signup OTP: $e');
      return false;
    }
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
}