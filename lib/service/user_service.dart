// /service/user_service.dart
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fantasy/model/user.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  Map<String, dynamic>? _userData;
  bool _isLoggedIn = false;
  String? _otpToken; // Store the OTP token received from signin request
  String? _authToken; // Store the authentication token after login
  String? _deviceToken; // Device identification token

  static const String _userDataKey = 'user_data';
  static const String _isLoggedInKey = 'is_logged_in';
  static const String _authTokenKey = 'auth_token'; // Add key for auth token
  static const String _deviceTokenKey = 'device_token';
  final String baseUrl = 'http://13.60.210.139:3000'; // Fixed URL to match SignupService

  String? get inviteFriendCode {
    if (_userData != null) {
      // Check for both field names
      return _userData!['invite_code'] ?? _userData!['invite_friend_code'];
    }
    return null;
  }

  int? get userId {
    if (_userData != null && _userData!.containsKey('id')) {
      // Handle both int and string types
      final id = _userData!['id'];
      if (id is int) {
        return id;
      } else if (id is String) {
        return int.tryParse(id);
      }
      // Also check for 'user_id' key as backup
      if (_userData != null && _userData!.containsKey('user_id')) {
        final userId = _userData!['user_id'];
        if (userId is int) {
          return userId;
        } else if (userId is String) {
          return int.tryParse(userId);
        }
      }

      return null;
    }
  }

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
      print('Device Token generated: ${_deviceToken!.substring(0, 20)}...');
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
    if (_isLoggedIn && _userData != null && _authToken != null) {
      return true;
    }
    return await _loadUserState();
  }

  Future<void> _clearAuthData() async {
    print('Clearing auth data...');
    _userData = null;
    _isLoggedIn = false;
    _authToken = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userDataKey);
    await prefs.remove(_authTokenKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> _loadUserState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool(_isLoggedInKey) ?? false;
      final authToken = prefs.getString(_authTokenKey);

      print('Loading user state...');
      print('IsLoggedIn from prefs: $isLoggedIn');
      print('AuthToken from prefs: ${authToken != null ? '${authToken.substring(0, 20)}...' : 'null'}');

      if (!isLoggedIn || authToken == null) {
        print('No valid login state found');
        _isLoggedIn = false;
        _userData = null;
        _authToken = null;
        return false;
      }

      final userDataString = prefs.getString(_userDataKey);
      if (userDataString == null) {
        print('No user data found');
        _isLoggedIn = false;
        _userData = null;
        _authToken = null;
        return false;
      }

      try {
        final data = jsonDecode(userDataString) as Map<String, dynamic>;
        _userData = data;
        _authToken = authToken.trim(); // Trim any whitespace
        _isLoggedIn = true;

        print('User state loaded successfully');
        print('Auth token loaded: ${_authToken!.substring(0, 30)}...');
        print('Auth token length: ${_authToken!.length}');
        print('User data keys: ${_userData!.keys.toList()}');
        return true;
      } catch (e) {
        print('Error parsing user data: $e');
        _isLoggedIn = false;
        _userData = null;
        _authToken = null;
        return false;
      }
    } catch (e) {
      print('Error loading user state: $e');
      return false;
    }
  }

  Future<bool> requestOtp(String contact) async {
    try {
      print('Requesting login OTP for: $contact');

      final Map<String, dynamic> requestBody = {
        contact.contains('@') ? 'email' : 'mobile_number': contact,
      };

      print('Login OTP request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/signin'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Login OTP Request Response Status: ${response.statusCode}');
      print('Login OTP Request Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check different possible response structures for the token
        String? otpToken;

        if (responseData['data'] != null && responseData['data']['otpToken'] != null) {
          otpToken = responseData['data']['otpToken'];
        } else if (responseData['otpToken'] != null) {
          otpToken = responseData['otpToken'];
        } else if (responseData['data'] != null && responseData['data']['otp_token'] != null) {
          otpToken = responseData['data']['otp_token'];
        }

        if (otpToken != null && otpToken.isNotEmpty) {
          _otpToken = otpToken;
          print('Login OTP Token received: ${_otpToken!.substring(0, 20)}...');
          return true;
        } else {
          print('Login OTP token not found in response');
          print('Response structure: ${responseData.keys.toList()}');
          if (responseData['data'] != null) {
            print('Data structure: ${responseData['data'].keys.toList()}');
          }
          return false;
        }
      } else if (response.statusCode == 400) {
        try {
          final errorResponse = jsonDecode(response.body);
          final errorMessage = errorResponse['message'] ?? 'User not found';
          print('Login OTP error (400): $errorMessage');
          return false;
        } catch (e) {
          print('Failed to parse login OTP error response: $e');
          return false;
        }
      } else {
        print('Login OTP request failed. Status code: ${response.statusCode}');
        try {
          final errorResponse = jsonDecode(response.body);
          print('Error message: ${errorResponse['message'] ?? 'Unknown error'}');
        } catch (e) {
          print('Failed to parse error response: $e');
        }
        return false;
      }
    } catch (e) {
      print('Login OTP request error: $e');
      return false;
    }
  }

  Future<bool> verifyOtp(String contact, String otp) async {
    if (_otpToken == null || _otpToken!.isEmpty) {
      print('Login OTP token is null or empty. Cannot verify OTP.');
      return false;
    }

    try {
      print('Verifying login OTP with token: ${_otpToken!.substring(0, 20)}...');

      final Map<String, dynamic> requestBody = {
        'user_otp': otp,
        'otpToken': _otpToken,
        'fcm_token': _deviceToken ?? 'device_token_placeholder'
      };

      print('Verify login OTP Request: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/web-services/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );

      print('Verify Login OTP Response Status: ${response.statusCode}');
      print('Verify Login OTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if the response has data field and handle accordingly
        final data = responseData['data'] ?? responseData;

        // Extract the authentication token from the response
        String? authToken;
        if (data is Map<String, dynamic> && data.containsKey('token')) {
          authToken = data['token'];
        } else if (responseData.containsKey('token')) {
          authToken = responseData['token'];
        }

        if (authToken != null && authToken.isNotEmpty) {
          // Clean the token - remove any extra whitespace or newlines
          authToken = authToken.trim();

          print('Raw auth token received: "$authToken"');
          print('Auth token length: ${authToken.length}');
          print('Auth token starts with: ${authToken.substring(0, 10)}');

          _authToken = authToken;

          // Store user data and auth token
          await setUserData(data, authToken);

          // Clear OTP token after successful verification
          _otpToken = null;
          return true;
        } else {
          print('Authentication token not found in response or is empty');
          print('Response data keys: ${data is Map ? data.keys.toList() : 'Not a map'}');
          return false;
        }
      } else if (response.statusCode == 400) {
        try {
          final errorResponse = jsonDecode(response.body);
          final errorMessage = errorResponse['message'] ?? 'Invalid OTP';
          print('Login OTP verification error (400): $errorMessage');
          return false;
        } catch (e) {
          print('Failed to parse OTP verification error: $e');
          return false;
        }
      } else {
        print('Login OTP verification failed. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Login OTP verification error: $e');
      return false;
    }
  }

  Future<void> setUserData(Map<String, dynamic> data, String authToken) async {
    try {
      // Clean the token
      authToken = authToken.trim();

      _userData = data;
      _authToken = authToken;
      _isLoggedIn = true;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userDataKey, jsonEncode(data));
      await prefs.setString(_authTokenKey, authToken);
      await prefs.setBool(_isLoggedInKey, true);

      print('User data and auth token saved successfully');
      print('Saved auth token: ${authToken.substring(0, 30)}...');
      print('Saved auth token length: ${authToken.length}');

      // Verify what was actually saved
      final savedToken = prefs.getString(_authTokenKey);
      print('Verified saved token: ${savedToken != null ? '${savedToken.substring(0, 30)}...' : 'null'}');
      print('Verified saved token length: ${savedToken?.length}');

    } catch (e) {
      print('Error saving user data: $e');
      throw Exception('Failed to save user data');
    }
  }

  // Add this method to your UserService class
// Add this method to your UserService class
  Future<Map<String, dynamic>?> getReferralData() async {
    try {
      print('Fetching referral data...');
      print('Auth token available: ${_authToken != null}');
      print('Is logged in: $_isLoggedIn');

      // Check if user is logged in and has auth token
      if (!_isLoggedIn || _authToken == null || _authToken!.isEmpty) {
        print('User not logged in or no auth token available');
        return null;
      }

      final response = await makeAuthenticatedRequest(
        endpoint: '/web-services/getreferralcode',
        method: 'GET',
      );

      print('Referral Data Response Status: ${response.statusCode}');
      print('Referral Data Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if response structure is valid
        if (responseData['status'] == true && responseData['data'] != null) {
          final data = responseData['data'];
          print('Referral data fetched successfully');
          print('Invite code: ${data['invite_code']}');
          print('Referred count: ${data['referred_count']}');

          // Update the user data with the referral info for fallback
          if (_userData != null) {
            _userData!['invite_code'] = data['invite_code'];
            _userData!['invite_friend_code'] = data['invite_code']; // For backward compatibility

            // Save updated user data
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString(_userDataKey, jsonEncode(_userData!));
          }

          return {
            'invite_code': data['invite_code'],
            'referred_count': data['referred_count'] ?? 0,
          };
        } else {
          print('Invalid response structure or status false');
          print('Response status: ${responseData['status']}');
          print('Response data: ${responseData['data']}');
          return null;
        }
      } else if (response.statusCode == 401) {
        print('Authentication failed - token might be expired');
        await _clearAuthData();
        return null;
      } else {
        print('Failed to fetch referral data. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error fetching referral data: $e');
      return null;
    }
  }

  Future<void> logout() async {
    try {
      // Optionally, call logout API to invalidate token on server
      if (_authToken != null) {
        try {
          await http.post(
            Uri.parse('$baseUrl/web-services/logout'),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $_authToken',
            },
          );
        } catch (e) {
          print('Server logout error (continuing with local logout): $e');
        }
      }

      _userData = null;
      _isLoggedIn = false;
      _otpToken = null;
      _authToken = null;

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userDataKey);
      await prefs.remove(_authTokenKey);
      await prefs.setBool(_isLoggedInKey, false);

      print('User logged out successfully');
    } catch (e) {
      print('Error during logout: $e');
      throw Exception('Failed to logout');
    }
  }

  // Method to make authenticated API calls
  Future<http.Response> makeAuthenticatedRequest({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? additionalHeaders,
  }) async {
    if (_authToken == null || _authToken!.isEmpty) {
      throw Exception('No authentication token available. Please login first.');
    }

    // Clean the token before using
    final cleanToken = _authToken!.trim();

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $cleanToken',
      ...?additionalHeaders,
    };

    final uri = Uri.parse('$baseUrl$endpoint');

    print('Making authenticated ${method.toUpperCase()} request to: $uri');
    print('Using auth token: ${cleanToken.substring(0, 30)}...');
    print('Token length: ${cleanToken.length}');
    print('Full Authorization header: Bearer ${cleanToken.substring(0, 50)}...');

    http.Response response;

    try {
      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: headers);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      print('Authenticated request response status: ${response.statusCode}');
      print('Authenticated request response body: ${response.body}');

      // Handle 401 Unauthorized - token might be expired/invalid
      if (response.statusCode == 401) {
        print('Authentication failed (401), clearing auth data');
        await _clearAuthData();
        throw Exception('Authentication failed. Please login again.');
      }

      // Handle 400 Bad Request - might be token format issue
      if (response.statusCode == 400) {
        final responseBody = response.body;
        if (responseBody.contains('invalid token') || responseBody.contains('token')) {
          print('Token validation failed (400), clearing auth data');
          await _clearAuthData();
          throw Exception('Authentication token is invalid. Please login again.');
        }
      }

      return response;
    } catch (e) {
      print('Authenticated request error: $e');

      if (e.toString().contains('Authentication failed') ||
          e.toString().contains('Authentication token is invalid')) {
        rethrow;
      }

      throw Exception('Network error: $e');
    }
  }

  // Method to test the current token
  Future<bool> testCurrentToken() async {
    if (_authToken == null || _authToken!.isEmpty) {
      print('No token to test');
      return false;
    }

    try {
      print('Testing current token...');
      print('Token: ${_authToken!.substring(0, 50)}...');
      print('Token length: ${_authToken!.length}');

      final response = await makeAuthenticatedRequest(
        endpoint: '/web-services/fixtures?page=1',
        method: 'GET',
      );

      if (response.statusCode == 200) {
        print('Token test PASSED - token is valid');
        return true;
      } else {
        print('Token test FAILED - status: ${response.statusCode}');
        print('Response: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Token test ERROR: $e');
      return false;
    }
  }

  // Getters
  User? get getUserModel => _userData != null ? User.fromJson(_userData!) : null;
  bool get isLoggedIn => _isLoggedIn;
  Map<String, dynamic>? get userData => _userData;
  String? get otpToken => _otpToken;
  String? get authToken => _authToken?.trim(); // Always return trimmed token
  String? get deviceToken => _deviceToken;

  // Method to get authorization header for manual requests
  Map<String, String> get authHeaders => {
    'Authorization': 'Bearer ${_authToken?.trim() ?? ''}',
    'Content-Type': 'application/json',
  };

  // Method to get auth status for debugging
  Map<String, dynamic> getAuthStatus() {
    return {
      'isLoggedIn': _isLoggedIn,
      'hasToken': _authToken != null && _authToken!.isNotEmpty,
      'tokenLength': _authToken?.length ?? 0,
      'tokenPreview': _authToken != null
          ? '${_authToken!.substring(0, 20)}...'
          : null,
      'userData': _userData != null,
      'deviceToken': _deviceToken != null,
      'fullToken': _authToken, // For debugging only - remove in production
    };
  }

  // Method to manually set token for testing
  Future<void> setTestToken(String token) async {
    print('Setting test token: ${token.substring(0, 20)}...');
    _authToken = token.trim();
    _isLoggedIn = true;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authTokenKey, token.trim());
    await prefs.setBool(_isLoggedInKey, true);

    print('Test token set successfully');
  }
}