import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:fantasy/model/withdrawal_models.dart';
import 'package:fantasy/api/withdrawal_api.dart';
import 'package:fantasy/service/wallet_service.dart';

class WithdrawalService extends ChangeNotifier {
  bool _isProcessing = false;
  String? _errorMessage;
  String? _successMessage;
  WithdrawalTransaction? _currentWithdrawal;

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  WithdrawalTransaction? get currentWithdrawal => _currentWithdrawal;

  // Submit withdrawal request
  Future<bool> submitWithdrawalRequest({
    required WithdrawalType type,
    required double amount,
    required WalletService walletService,
  }) async {
    try {
      _setProcessing(true);
      _clearMessages();

      // Validate amount
      if (amount <= 0) {
        throw Exception('Amount must be greater than 0');
      }

      // Check available balance based on type
      final walletData = walletService.walletData;
      if (walletData == null) {
        throw Exception('Wallet data not available');
      }

      double availableAmount = 0;
      switch (type) {
        case WithdrawalType.winningAmount:
          availableAmount = walletData.winnings;
          break;
        case WithdrawalType.cashBack:
          availableAmount = walletData.cashback;
          break;
        case WithdrawalType.levelIncome:
          availableAmount = walletData.levelIncome;
          break;
      }

      if (amount > availableAmount) {
        throw Exception('Insufficient ${_getTypeDisplayName(type)} balance');
      }

      // Create withdrawal request
      final request = WithdrawalRequest(
        type: type,
        winningAmount: type == WithdrawalType.winningAmount ? amount : 0,
        cashBack: type == WithdrawalType.cashBack ? amount : 0,
        levelIncome: type == WithdrawalType.levelIncome ? amount : 0,
      );

      // Submit request
      final response = await WithdrawalApiService.submitWithdrawalRequest(
        request: request,
      );

      if (response.status) {
        // Create transaction record
        _currentWithdrawal = WithdrawalTransaction(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          type: type,
          amount: amount,
          timestamp: DateTime.now(),
          status: WithdrawalStatus.pending,
        );

        // Refresh wallet data to reflect the changes
        await walletService.refreshWalletData();

        _setSuccessMessage(response.message);
        return true;
      } else {
        throw Exception(response.message);
      }

    } catch (e) {
      _setError(e.toString());
      log('Withdrawal error: $e');
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  // Get available amount for withdrawal type
  double getAvailableAmount(WithdrawalType type, WalletService walletService) {
    final walletData = walletService.walletData;
    if (walletData == null) return 0;

    switch (type) {
      case WithdrawalType.winningAmount:
        return walletData.winnings;
      case WithdrawalType.cashBack:
        return walletData.cashback;
      case WithdrawalType.levelIncome:
        return walletData.levelIncome;
    }
  }

  // Get type display name
  String _getTypeDisplayName(WithdrawalType type) {
    switch (type) {
      case WithdrawalType.winningAmount:
        return 'Winnings';
      case WithdrawalType.cashBack:
        return 'Cashback';
      case WithdrawalType.levelIncome:
        return 'Referral Bonus';
    }
  }

  String getTypeDisplayName(WithdrawalType type) {
    return _getTypeDisplayName(type);
  }

  // Helper methods
  void _setProcessing(bool processing) {
    _isProcessing = processing;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _successMessage = null;
    notifyListeners();
  }

  void _setSuccessMessage(String message) {
    _successMessage = message;
    _errorMessage = null;
    notifyListeners();
  }

  void _clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}