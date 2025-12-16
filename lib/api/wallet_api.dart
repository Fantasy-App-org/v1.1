import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:fantasy/config/api_config.dart';
import '../service/user_service.dart';
import 'package:fantasy/model/wallet.dart';

class WalletApi {
  static final UserService _userService = UserService();

  // Default headers for JSON requests
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  /// Fetches wallet data from the API with authentication
  static Future<WalletResponse> getWalletData({
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      // Get authentication token
      final token = _userService.authToken;
      if (token == null) {
        throw WalletApiException('Authentication token not available');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.walletEndpoint}');

      // Add authorization header
      final headers = {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      print('Wallet API Request URL: $url');
      print('Wallet API Request Headers: $headers');

      final response = await http.get(
        url,
        headers: headers,
      ).timeout(timeout);

      print('Wallet API Response Status: ${response.statusCode}');
      print('Wallet API Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw WalletApiException('No internet connection. Please check your network.');
    } on HttpException {
      throw WalletApiException('Server error. Please try again later.');
    } on FormatException {
      throw WalletApiException('Invalid response format from server.');
    } catch (e) {
      print('WalletApi.getWalletData Error: $e');
      throw WalletApiException('Service error: $e');
    }
  }

  /// Handles the HTTP response and converts it to WalletResponse
  static WalletResponse _handleResponse(http.Response response) {
    try {
      final Map<String, dynamic> jsonData = json.decode(response.body);

      switch (response.statusCode) {
        case 200:
        // Check if the API returned success status
          if (jsonData['status'] == true) {
            return WalletResponse.fromJson(jsonData);
          } else {
            throw WalletApiException(
              jsonData['message'] ?? 'API returned error status',
            );
          }
        case 400:
          throw WalletApiException(
            jsonData['message'] ?? 'Bad request. Please check your input.',
          );
        case 401:
          throw WalletApiException('Unauthorized. Please login again.');
        case 403:
          throw WalletApiException('Access forbidden.');
        case 404:
          throw WalletApiException('Service not found.');
        case 500:
          throw WalletApiException('Server error. Please try again later.');
        default:
          throw WalletApiException(
            'Request failed with status: ${response.statusCode}',
          );
      }
    } catch (e) {
      if (e is WalletApiException) rethrow;
      throw WalletApiException('Failed to parse server response.');
    }
  }

  /// POST method for wallet operations (e.g., adding cash, withdrawing)
  static Future<WalletResponse> postWalletData({
    required String endpoint,
    required Map<String, dynamic> data,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      // Get authentication token
      final token = _userService.authToken;
      if (token == null) {
        throw WalletApiException('Authentication token not available');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');

      // Add authorization header
      final headers = {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      print('Wallet API POST Request URL: $url');
      print('Wallet API POST Request Body: ${jsonEncode(data)}');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(data),
      ).timeout(timeout);

      print('Wallet API POST Response Status: ${response.statusCode}');
      print('Wallet API POST Response Body: ${response.body}');

      return _handleResponse(response);
    } on SocketException {
      throw WalletApiException('No internet connection. Please check your network.');
    } on HttpException {
      throw WalletApiException('Server error. Please try again later.');
    } on FormatException {
      throw WalletApiException('Invalid response format from server.');
    } catch (e) {
      print('WalletApi.postWalletData Error: $e');
      throw WalletApiException('Service error: $e');
    }
  }

  /// Add cash to wallet
  static Future<WalletResponse> addCash({
    required double amount,
    required String paymentMethod,
  }) async {
    return await postWalletData(
      endpoint: ApiConfig.addCashEndpoint,
      data: {
        'amount': amount,
        'payment_method': paymentMethod,
      },
    );
  }

  /// Withdraw amount from wallet
  static Future<WalletResponse> withdrawAmount({
    required double amount,
    required String bankAccount,
  }) async {
    return await postWalletData(
      endpoint: ApiConfig.withdrawAmountEndpoint,
      data: {
        'amount': amount,
        'bank_account': bankAccount,
      },
    );
  }

  /// Get transaction history
  static Future<Map<String, dynamic>> getTransactionHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw WalletApiException('Authentication token not available');
      }

      final url = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.transactionHistoryEndpoint}');

      final headers = {
        ...defaultHeaders,
        'Authorization': 'Bearer $token',
      };

      final requestBody = {
        'page': page,
        'limit': limit,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(requestBody),
      );

      print('Transaction History Response Status: ${response.statusCode}');
      print('Transaction History Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          return responseData;
        } else {
          throw WalletApiException(responseData['message'] ?? 'Failed to fetch transactions');
        }
      } else {
        throw WalletApiException('Failed to fetch transaction history: ${response.statusCode}');
      }
    } catch (e) {
      print('WalletApi.getTransactionHistory Error: $e');
      throw WalletApiException('Service error: $e');
    }
  }

  /// Refresh wallet data (same as getWalletData but with different logging)
  static Future<WalletResponse> refreshWalletData() async {
    print('Refreshing wallet data...');
    return await getWalletData();
  }
}

/// Custom exception class for wallet API errors
class WalletApiException implements Exception {
  final String message;

  WalletApiException(this.message);

  @override
  String toString() => 'WalletApiException: $message';
}