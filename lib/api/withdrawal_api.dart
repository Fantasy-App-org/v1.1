import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fantasy/model/withdrawal_models.dart';
import '../../utils/constants.dart';
import '../../utils/auth_manager.dart';

class WithdrawalApiService {
  static const String baseUrl = ApiConstants.baseUrl;

  // Submit withdrawal request
  static Future<WithdrawalResponse> submitWithdrawalRequest({
    required WithdrawalRequest request,
  }) async {
    try {
      final token = await AuthManager.getToken();
      if (token == null) {
        throw Exception('Authentication token not found');
      }

      final url = Uri.parse('$baseUrl/payment/withdrawrequest');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(request.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return WithdrawalResponse.fromJson(responseData);
      } else {
        throw Exception(responseData['message'] ?? 'Withdrawal request failed');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}