import 'package:flutter/foundation.dart';
import 'package:fantasy/model/wallet.dart';
import 'package:fantasy/api/wallet_api.dart';

class WalletService extends ChangeNotifier {
  WalletData? _walletData;
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastUpdated;

  // Getters
  WalletData? get walletData => _walletData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;
  bool get hasData => _walletData != null;
  bool get hasError => _errorMessage != null;

  /// Fetches wallet data from the API
  Future<void> fetchWalletData({bool showLoading = true}) async {
    if (showLoading) {
      _setLoading(true);
    }

    _clearError();

    try {
      final response = await WalletApi.getWalletData();

      if (response.status && response.data != null) {
        _walletData = response.data;
        _lastUpdated = DateTime.now();
        _setLoading(false);
        notifyListeners();
      } else {
        throw WalletApiException(response.message);
      }
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }

  /// Refreshes wallet data (pull-to-refresh)
  Future<void> refreshWalletData() async {
    await fetchWalletData(showLoading: false);
  }

  /// Checks if data needs to be refreshed (older than 5 minutes)
  bool shouldRefreshData() {
    if (_lastUpdated == null) return true;
    return DateTime.now().difference(_lastUpdated!).inMinutes > 5;
  }

  /// Gets wallet data with automatic refresh if needed
  Future<WalletData?> getWalletData({bool forceRefresh = false}) async {
    if (forceRefresh || shouldRefreshData() || _walletData == null) {
      await fetchWalletData();
    }
    return _walletData;
  }

  /// Clears all data (useful for logout)
  void clearData() {
    _walletData = null;
    _errorMessage = null;
    _lastUpdated = null;
    _isLoading = false;
    notifyListeners();
  }

  /// Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }

  // Helper method to format currency properly
  String _formatCurrency(double amount) {
    return '₹ ${amount.toStringAsFixed(2)}';
  }

  // Utility methods for UI
  String getWithdrawableAmountFormatted() {
    return _formatCurrency(_walletData?.withdrawableAmount ?? 0.0);
  }

  String getNonWithdrawableAmountFormatted() {
    return _formatCurrency(_walletData?.nonWithdrawableAmount ?? 0.0);
  }

  String getTotalBalanceFormatted() {
    return _formatCurrency(_walletData?.totalBalance ?? 0.0);
  }

  String getCashDepositFormatted() {
    return _formatCurrency(_walletData?.cashDeposit ?? 0.0);
  }

  String getWinningsFormatted() {
    return _formatCurrency(_walletData?.winnings ?? 0.0);
  }

  String getCashbackFormatted() {
    return _formatCurrency(_walletData?.cashback ?? 0.0);
  }

  String getLevelIncomeFormatted() {
    return _formatCurrency(_walletData?.levelIncome ?? 0.0);
  }

  String getBonusFormatted() {
    return _formatCurrency(_walletData?.bonus ?? 0.0);
  }

  bool isAccountVerified() {
    return _walletData?.isAccountVerified ?? false;
  }
}