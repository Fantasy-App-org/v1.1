import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  Map<String, dynamic>? _userData;
  bool _isLoggedIn = false;
  String? _otpToken; // Store the OTP token received from signin request
  String? _deviceToken; // Device identification token

  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _deviceTokenKey = 'device_token';
  final String baseUrl = 'http://localhost:3000'; // Update with your localhost port

  factory UserService() {
    return _instance;
  }

  UserService._internal();

  Future<void> initialize() async {
    await _loadUserState();
    await _initDeviceToken();
  }

  // Generate a device token that can be used in place of FCM token
  Future<void> _initDeviceToken() async {
    try {
      // First check if we already have a device token
      final prefs = await SharedPreferences.getInstance();
      String? existingToken = prefs.getString(_deviceTokenKey);

      if (existingToken != null) {
        _deviceToken = existingToken;
        return;
      }

      // Generate a new device token based on device information
      final deviceInfo = DeviceInfoPlugin();
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String deviceId = '';
      String deviceModel = '';
      String osVersion = '';
      String appVersion = packageInfo.version;

      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id;
        deviceModel = androidInfo.model;
        osVersion = androidInfo.version.release;
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceId = iosInfo.identifierForVendor ?? '';
        deviceModel = iosInfo.model ?? '';
        osVersion = iosInfo.systemVersion ?? '';
      } else {
        // Fallback for web or other platforms
        deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
        deviceModel = 'unknown';
        osVersion = 'unknown';
      }

      // Create a unique device identifier that can be used as a token
      final tokenData = {
        'deviceId': deviceId,
        'model': deviceModel,
        'osVersion': osVersion,
        'appVersion': appVersion,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      _deviceToken = base64Encode(utf8.encode(json.encode(tokenData)));

      // Save the token for future use
      await prefs.setString(_deviceTokenKey, _deviceToken!);
      print('Device Token: $_deviceToken');
    } catch (e) {
      print('Error generating device token: $e');
      // Fallback to a basic token if there's an error
      _deviceToken = 'device_${DateTime.now().millisecondsSinceEpoch}';

      // Save the fallback token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_deviceTokenKey, _deviceToken!);
    }
  }

  Future<bool> checkLoginStatus() async {
    if (_isLoggedIn && _userData != null) {
      return true;
    }
    return await _loadUserState();
  }

  Future<bool> _loadUserState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      if (!isLoggedIn) {
        _isLoggedIn = false;
        _userData = null;
        return false;
      }
      final userDataString = prefs.getString(_userDataKey);
      if (userDataString == null) {
        _isLoggedIn = false;
        _userData = null;
        return false;
      }
      try {
        final data = jsonDecode(userDataString) as Map<String, dynamic>;
        _userData = data;
        _isLoggedIn = true;
        return true;
      } catch (e) {
        print('Error parsing user data: $e');
        _isLoggedIn = false;
        _userData = null;
        return false;
      }
    } catch (e) {
      print('Error loading user state: $e');
      return false;
    }
  }

  Future<bool> requestOtp(String contact) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/web-services/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          contact.contains('@') ? 'email' : 'mobile_number': contact,
        }),
      );

      print('OTP Request Response: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response to get OTP token
        final responseData = jsonDecode(response.body);

        // Fix: Check for the token inside the data object
        if (responseData != null &&
            responseData['data'] != null &&
            responseData['data']['otpToken'] != null) {

          _otpToken = responseData['data']['otpToken'];
          print('OTP Token received: $_otpToken');
          return true;
        } else {
          print('OTP token not found in response');
          return false;
        }
      } else {
        print('OTP request failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('OTP request error: $e');
      return false;
    }
  }

  Future<bool> verifyOtp(String contact, String otp) async {
    if (_otpToken == null) {
      print('OTP token is null. Cannot verify OTP.');
      return false;
    }

    try {
      print('Verifying OTP with token: $_otpToken');

      final Map<String, dynamic> requestBody = {
        'user_otp': otp,
        'otpToken': _otpToken,
        'fcm_token': _deviceToken ?? 'device_token_placeholder'
      };

      print('Verify OTP Request: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Verify OTP Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if the response has data field and handle accordingly
        final data = responseData['data'] ?? responseData;

        await setUserData(data);
        // Clear OTP token after successful verification
        _otpToken = null;
        return true;
      } else {
        print('OTP verification failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('OTP verification error: $e');
      return false;
    }
  }

  Future<void> setUserData(Map<String, dynamic> data) async {
    try {
      _userData = data;
      _isLoggedIn = true;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, jsonEncode(data));
      await prefs.setBool(_isLoggedInKey, true);
    } catch (e) {
      print('Error saving user data: $e');
      throw Exception('Failed to save user data');
    }
  }

  Future<void> logout() async {
    try {
      _userData = null;
      _isLoggedIn = false;
      _otpToken = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.setBool(_isLoggedInKey, false);
    } catch (e) {
      print('Error during logout: $e');
      throw Exception('Failed to logout');
    }
  }

  // Getters
  User? get getUserModel => _userData != null ? User.fromJson(_userData!) : null;
  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get userData => _userData;
  String? get otpToken => _otpToken;
}