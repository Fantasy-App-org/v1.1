import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginApi {
  static const String baseUrl = 'http://localhost:3000';

  static Future<bool> requestOtp(String mobileNumber) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/web-services/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile_number': mobileNumber}),
      );
      return response.statusCode == 200;
    } catch (e) {
      print('OTP request error: $e');
      return false;
    }
  }

  static Future<Map<String, dynamic>?> verifyOtp(String mobileNumber, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/web-services/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'mobile_number': mobileNumber, 'otp': otp}),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return null;
    } catch (e) {
      print('OTP verification error: $e');
      return null;
    }
  }
}