// lib/utils/api_utils.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiUtils {
  static const String baseUrl = 'http://13.232.147.237:3000';

  /// Generic API call method with error handling
  static Future<Map<String, dynamic>> makeApiCall({
    required String endpoint,
    required String method,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    Duration timeout = const Duration(seconds: 30),
  }) async {
    try {
      final uri = Uri.parse('$baseUrl$endpoint');
      http.Response response;

      final defaultHeaders = {
        'Content-Type': 'application/json',
        ...?headers,
      };

      switch (method.toUpperCase()) {
        case 'GET':
          response = await http.get(uri, headers: defaultHeaders).timeout(timeout);
          break;
        case 'POST':
          response = await http.post(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          ).timeout(timeout);
          break;
        case 'PUT':
          response = await http.put(
            uri,
            headers: defaultHeaders,
            body: body != null ? jsonEncode(body) : null,
          ).timeout(timeout);
          break;
        case 'DELETE':
          response = await http.delete(uri, headers: defaultHeaders).timeout(timeout);
          break;
        default:
          throw Exception('Unsupported HTTP method: $method');
      }

      // Log API call details for debugging
      print('API Call: $method $endpoint');
      print('Status Code: ${response.statusCode}');
      print('Response Length: ${response.body.length}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonDecode(response.body);
      } else {
        // Handle specific HTTP error codes
        String errorMessage = 'API call failed';
        try {
          final errorData = jsonDecode(response.body);
          errorMessage = errorData['message'] ?? errorMessage;
        } catch (e) {
          // If we can't parse the error response, use status code
          errorMessage = 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
        }

        throw ApiException(
          statusCode: response.statusCode,
          message: errorMessage,
          endpoint: endpoint,
        );
      }
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      print('API Utils Error: $e');
      throw ApiException(
        statusCode: 0,
        message: 'Network error: ${e.toString()}',
        endpoint: endpoint,
      );
    }
  }

  /// Check if the API response indicates success
  static bool isSuccessResponse(Map<String, dynamic> response) {
    return response['status'] == true;
  }

  /// Extract data from API response
  static dynamic extractData(Map<String, dynamic> response) {
    return response['data'];
  }

  /// Extract message from API response
  static String extractMessage(Map<String, dynamic> response) {
    return response['message'] ?? 'Unknown response';
  }
}

/// Custom exception for API errors
class ApiException implements Exception {
  final int statusCode;
  final String message;
  final String endpoint;

  ApiException({
    required this.statusCode,
    required this.message,
    required this.endpoint,
  });

  @override
  String toString() {
    return 'ApiException: $message (Status: $statusCode, Endpoint: $endpoint)';
  }

  bool get isAuthenticationError {
    return statusCode == 401 || statusCode == 403;
  }

  bool get isNetworkError {
    return statusCode == 0;
  }
}