import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SignupService {
  static final SignupService _instance = SignupService._internal();
  Map<String, dynamic>? _signupData;
  bool _isSignupInProgress = false;
  String? _otpToken;
  String? _deviceToken;

  static const String _signupDataKey = 'signup_data';
  static const String _isSignupInProgressKey = 'is_signup_in_progress';
  static const String _otpTokenKey = 'otp_token';
  static const String _deviceTokenKey = 'device_token';
  final String baseUrl = 'http://13.232.147.237:3000'; // Update with your localhost port

  factory SignupService() {
    return _instance;
  }

  SignupService._internal();

  Future<void> initialize() async {
    await _loadSignupState();
    await _initDeviceToken();
  }

  // Initialize device token
  Future<void> _initDeviceToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? existingToken = prefs.getString(_deviceTokenKey);

      if (existingToken != null) {
        _deviceToken = existingToken;
        return;
      }

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
        deviceId = 'unknown_${DateTime.now().millisecondsSinceEpoch}';
        deviceModel = 'unknown';
        osVersion = 'unknown';
      }

      final tokenData = {
        'deviceId': deviceId,
        'model': deviceModel,
        'osVersion': osVersion,
        'appVersion': appVersion,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      _deviceToken = base64Encode(utf8.encode(json.encode(tokenData)));
      await prefs.setString(_deviceTokenKey, _deviceToken!);
    } catch (e) {
      print('Error generating device token: $e');
      _deviceToken = 'device_${DateTime.now().millisecondsSinceEpoch}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_deviceTokenKey, _deviceToken!);
    }
  }

  Future<bool> requestSignupOtp(String contact, String userName, [String? inviteCode]) async {
    try {
      print('Requesting signup OTP for: $contact');

      // Use provided invite code or default
      final String finalInviteCode = inviteCode ?? 'W1MRB9O422';

      // Determine if contact is email or mobile
      bool isEmail = contact.contains('@');

      Map<String, dynamic> requestBody = {
        'user_name': userName,
        'invite_code': finalInviteCode,
      };

      if (isEmail) {
        requestBody['email'] = contact;
      } else {
        requestBody['mobile_number'] = contact;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Signup OTP Request Response Status: ${response.statusCode}');
      print('Signup OTP Request Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        if (responseData != null &&
            responseData['data'] != null &&
            responseData['data']['otpToken'] != null) {

          _otpToken = responseData['data']['otpToken'];
          _isSignupInProgress = true;

          // Store signup data for later use
          _signupData = {
            'contact': contact,
            'userName': userName,
            'inviteCode': finalInviteCode,
            'isEmail': isEmail,
          };

          // Save signup state
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_otpTokenKey, _otpToken!);
          await prefs.setBool(_isSignupInProgressKey, true);
          await prefs.setString(_signupDataKey, jsonEncode(_signupData));

          print('Signup OTP Token received: ${_otpToken!.substring(0, 20)}...');
          return true;
        } else {
          print('Signup OTP token not found in response');
          return false;
        }
      } else {
        print('Signup OTP request failed. Status code: ${response.statusCode}');
        try {
          final errorResponse = jsonDecode(response.body);
          print('Error message: ${errorResponse['message'] ?? 'Unknown error'}');
        } catch (e) {
          print('Failed to parse error response: $e');
        }
        return false;
      }
    } catch (e) {
      print('Signup OTP request error: $e');
      return false;
    }
  }

  Future<bool> verifySignupOtp(String otp) async {
    if (_otpToken == null) {
      print('Signup OTP token is null. Cannot verify OTP.');
      return false;
    }

    try {
      print('Verifying signup OTP with token: ${_otpToken!.substring(0, 20)}...');

      final Map<String, dynamic> requestBody = {
        'user_otp': otp,
        'otpToken': _otpToken,
        'isSignUp': true,
        'fcm_token': _deviceToken ?? 'device_token_placeholder'
      };

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Verify Signup OTP Response Status: ${response.statusCode}');
      print('Verify Signup OTP Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        // Update signup data with response data
        if (responseData['data'] != null) {
          _signupData = {
            ..._signupData ?? {},
            ...responseData['data']
          };
        }

        // Clear signup state after successful verification
        await _clearSignupState();

        return true;
      } else {
        print('Signup OTP verification failed. Status code: ${response.statusCode}');
        try {
          final errorResponse = jsonDecode(response.body);
          print('Error message: ${errorResponse['message'] ?? 'Unknown error'}');
        } catch (e) {
          print('Failed to parse error response: $e');
        }
        return false;
      }
    } catch (e) {
      print('Signup OTP verification error: $e');
      return false;
    }
  }

  Future<void> _clearSignupState() async {
    _isSignupInProgress = false;
    _otpToken = null;
    // Don't clear _signupData here as it might be needed after successful signup

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_otpTokenKey);
    await prefs.setBool(_isSignupInProgressKey, false);
    // Keep signup data until explicitly cleared
  }

  Future<void> cancelSignup() async {
    _signupData = null;
    _isSignupInProgress = false;
    _otpToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_signupDataKey);
    await prefs.remove(_otpTokenKey);
    await prefs.setBool(_isSignupInProgressKey, false);
  }

  Future<bool> _loadSignupState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isSignupInProgress = prefs.getBool(_isSignupInProgressKey) ?? false;
      final otpToken = prefs.getString(_otpTokenKey);
      final signupDataString = prefs.getString(_signupDataKey);

      if (!isSignupInProgress) {
        _isSignupInProgress = false;
        _otpToken = null;
        return false;
      }

      _otpToken = otpToken;
      _isSignupInProgress = isSignupInProgress;

      if (signupDataString != null) {
        _signupData = jsonDecode(signupDataString);
      }

      return true;
    } catch (e) {
      print('Error loading signup state: $e');
      return false;
    }
  }

  // Getters
  Map<String, dynamic>? get signupData => _signupData;
  bool get isSignupInProgress => _isSignupInProgress;
  String? get otpToken => _otpToken;
  String? get deviceToken => _deviceToken;

  // Method to get signup status for debugging
  Map<String, dynamic> getSignupStatus() {
    return {
      'isSignupInProgress': _isSignupInProgress,
      'hasOtpToken': _otpToken != null && _otpToken!.isNotEmpty,
      'otpTokenLength': _otpToken?.length ?? 0,
      'otpTokenPreview': _otpToken != null && _otpToken!.length > 20
          ? '${_otpToken!.substring(0, 20)}...'
          : _otpToken,
      'signupData': _signupData != null,
      'deviceToken': _deviceToken != null,
      'signupDataKeys': _signupData?.keys.toList() ?? [],
    };
  }
}