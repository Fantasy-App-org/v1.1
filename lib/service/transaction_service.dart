// service/transaction_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fantasy/model/transaction_model.dart';
import 'package:fantasy/service/user_service.dart';

class TransactionService {
  static const String baseUrl = 'http://13.232.147.237:3000/web-services';
  static final UserService _userService = UserService();

  // Get token dynamically when making requests
  static Future<String?> _getAuthToken() async {
    return _userService.authToken;
  }

  static Future<ApiResponse> getTransactionHistory({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      // Get token dynamically
      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final url = Uri.parse('$baseUrl/transation-history-new?page=$page');

      print('Making request to: ${url.toString()}'); // Debug log
      print('Using token: ${token.substring(0, 10)}...'); // Debug log (partial token)

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}'); // Debug log
      print('Response body: ${response.body}'); // Debug log

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ApiResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load transactions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in getTransactionHistory: $e'); // Debug log
      throw Exception('Error fetching transactions: $e');
    }
  }

  static Future<ApiResponse> searchTransactions({
    required String query,
    int page = 1,
  }) async {
    try {
      // Get token dynamically
      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        throw Exception('Authentication token not found');
      }

      final url = Uri.parse('$baseUrl/transation-history-new?page=$page&search=${Uri.encodeComponent(query)}');

      print('Making search request to: ${url.toString()}'); // Debug log

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Search response status: ${response.statusCode}'); // Debug log

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ApiResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to search transactions: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Error in searchTransactions: $e'); // Debug log
      throw Exception('Error searching transactions: $e');
    }
  }
}