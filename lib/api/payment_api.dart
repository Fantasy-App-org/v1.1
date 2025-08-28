import 'dart:convert';
import 'package:fantasy/model/payment_models.dart';
import 'package:fantasy/service/user_service.dart';

class PaymentApiService {
  static final UserService _userService = UserService();

  // Initialize Payment
  static Future<PaymentInitiateResponse> initiatePayment({
    required double amount,
    required String mobileNumber,
  }) async {
    try {
      final request = PaymentInitiateRequest(
        price: amount.toStringAsFixed(2),
        mobileNumber: mobileNumber,
      );

      final response = await _userService.makeAuthenticatedRequest(
        endpoint: '/payment/newpayment',
        method: 'POST',
        body: request.toJson(),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return PaymentInitiateResponse.fromJson(responseData);
      } else {
        throw Exception(responseData['message'] ?? 'Payment initiation failed');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }

  // Check Payment Status
  static Future<PaymentStatusResponse> checkPaymentStatus({
    required String txnId,
  }) async {
    try {
      final request = PaymentStatusRequest(txnId: txnId);

      final response = await _userService.makeAuthenticatedRequest(
        endpoint: '/payment/checkpaymentstatus',
        method: 'POST',
        body: request.toJson(),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return PaymentStatusResponse.fromJson(responseData);
      } else {
        throw Exception(responseData['message'] ?? 'Status check failed');
      }
    } catch (e) {
      throw Exception('Network error: ${e.toString()}');
    }
  }
}