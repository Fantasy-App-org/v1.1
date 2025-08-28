// lib/service/wallet_check_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/wallet_balance.dart';
import '../service/user_service.dart';

class WalletCheckService {
  static const String baseUrl = 'http://api.start25pro.com:3000/web-services';
  static final UserService _userService = UserService();

  // Get wallet balance for contest joining
  Future<WalletBalance> getWalletBalance({
    required String entryFee,
    required String contestId,
  }) async {
    try {
      final token = _userService.authToken;
      if (token == null) {
        throw Exception('Authentication token not available');
      }

      final url = Uri.parse('$baseUrl/join-contest-wallet-amount');

      // Request body
      final requestBody = {
        'entry_fee': entryFee,
        'contest_id': contestId,
      };

      print('Making wallet balance request to: $url');
      print('Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(requestBody),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == true) {
          return WalletBalance.fromJson(data['data']);
        } else {
          throw Exception(data['message'] ?? 'Failed to fetch wallet balance');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: Failed to fetch wallet balance');
      }
    } catch (e) {
      print('Wallet check service error: $e');
      throw Exception('Failed to fetch wallet balance: $e');
    }
  }

  // Check if user has sufficient balance
  bool hasSufficientBalance(WalletBalance balance, double entryFee) {
    return balance.totalAmount >= entryFee;
  }

  // Get formatted balance string
  String getFormattedBalance(WalletBalance balance) {
    return '₹${balance.cashBalance.toStringAsFixed(2)}';
  }

  // Get formatted bonus string
  String getFormattedBonus(WalletBalance balance) {
    if (balance.usableBonus > 0) {
      return '₹${balance.usableBonus.toStringAsFixed(2)} (${balance.usableBonusPercent}%)';
    }
    return '₹0.00';
  }

  // Get total amount string
  String getFormattedTotal(WalletBalance balance) {
    return '₹${balance.totalAmount.toStringAsFixed(2)}';
  }
}