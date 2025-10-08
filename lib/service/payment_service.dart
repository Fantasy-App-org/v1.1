import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fantasy/model/payment_models.dart';
import 'package:fantasy/api/payment_api.dart';
import 'package:fantasy/service/wallet_service.dart';
import 'package:fantasy/service/profile_service.dart';

class PaymentService extends ChangeNotifier {
  bool _isProcessing = false;
  String? _errorMessage;
  String? _successMessage;
  AddMoneyTransaction? _currentTransaction;
  Timer? _statusCheckTimer;

  bool get isProcessing => _isProcessing;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  AddMoneyTransaction? get currentTransaction => _currentTransaction;

  // Add this method to PaymentService class
  Future<void> initialize() async {
    try {
      final profileService = ProfileService();
      await profileService.loadProfile();
      print('PaymentService initialized with user profile');
    } catch (e) {
      print('Warning: Could not load profile during PaymentService initialization: $e');
    }
  }

  // Helper method to get mobile number from profile service
  Future<String?> _getMobileNumber() async {
    try {
      final profileService = ProfileService();

      // Ensure profile is loaded
      await profileService.loadProfile();

      final mobile = profileService.currentProfile?.mobileNo;
      print('Retrieved mobile number from profile: $mobile'); // Debug log

      if (mobile == null || mobile.isEmpty) {
        throw Exception('Mobile number not found in profile. Please update your profile.');
      }

      return mobile;
    } catch (e) {
      print('Error getting mobile number from profile: $e');
      throw Exception('Failed to get mobile number: ${e.toString()}');
    }
  }

  Future<bool> addMoneyToWallet({
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

      if (amount < 10) {
        throw Exception('Minimum amount is ₹10');
      }

      if (amount > 50000) {
        throw Exception('Maximum amount is ₹50,000');
      }

      // Get mobile number from profile service
      final mobileNumber = await _getMobileNumber();
      if (mobileNumber == null) {
        throw Exception('Mobile number not found. Please update your profile.');
      }

      print('Initiating payment - Amount: $amount, Mobile: $mobileNumber'); // Debug log

      // Initiate payment
      final response = await PaymentApiService.initiatePayment(
        amount: amount,
        mobileNumber: mobileNumber,
      );

      print('Payment initiate response: ${response.status}, ${response.message}'); // Debug log

      if (!response.status || response.data == null) {
        throw Exception(response.message);
      }

      // Create transaction record
      _currentTransaction = AddMoneyTransaction(
        txnId: response.data!.txnId,
        amount: amount,
        timestamp: DateTime.now(),
        status: PaymentStatus.initiated,
      );

      notifyListeners();

      print('Opening payment gateway: ${response.data!.url}'); // Debug log

      // Open payment gateway
      final success = await _openPaymentGateway(response.data!.url);

      if (success) {
        // Start monitoring payment status after a short delay
        _startPaymentStatusMonitoring(response.data!.txnId, walletService);
        return true;
      } else {
        throw Exception('Failed to open payment gateway');
      }

    } catch (e) {
      _setError(e.toString());
      log('Add money error: $e');
      return false;
    } finally {
      _setProcessing(false);
    }
  }

  // Improved payment gateway opening method
  Future<bool> _openPaymentGateway(String paymentUrl) async {
    try {
      final uri = Uri.parse(paymentUrl);
      print('Opening payment URL: $paymentUrl');

      if (await canLaunchUrl(uri)) {
        // Try external browser first for better payment gateway compatibility
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // Changed to external browser
        );

        if (!launched) {
          // Fallback to in-app browser if external fails
          await launchUrl(
            uri,
            mode: LaunchMode.inAppBrowserView,
            browserConfiguration: const BrowserConfiguration(
              showTitle: true,
            ),
          );
        }
        return true;
      } else {
        throw Exception('Cannot open payment gateway URL');
      }
    } catch (e) {
      log('Payment gateway error: $e');

      // Try alternative launch method
      try {
        final uri = Uri.parse(paymentUrl);
        await launchUrl(uri);
        return true;
      } catch (e2) {
        log('Alternative launch also failed: $e2');
        return false;
      }
    }
  }

  // Monitor payment status
  void _startPaymentStatusMonitoring(String txnId, WalletService walletService) {
    _statusCheckTimer?.cancel();

    // Start checking after 15 seconds to allow user to complete payment
    Timer(const Duration(seconds: 15), () {
      _statusCheckTimer = Timer.periodic(
        const Duration(seconds: 15), // Check every 15 seconds
            (timer) async {
          try {
            print('Checking payment status for txnId: $txnId (attempt ${timer.tick})');

            final statusResponse = await PaymentApiService.checkPaymentStatus(
              txnId: txnId,
            );

            print('Status check response: ${statusResponse.success}, ${statusResponse.message}');

            if (statusResponse.success) {
              // Payment successful
              _updateTransactionStatus(PaymentStatus.success);

              // Refresh wallet data
              await walletService.refreshWalletData();

              // Stop monitoring
              timer.cancel();

              // Show success message
              _setSuccessMessage('₹${_currentTransaction?.amount} added successfully!');

            } else if (statusResponse.message.toLowerCase().contains('failed') ||
                statusResponse.message.toLowerCase().contains('error') ||
                statusResponse.message.toLowerCase().contains('cancelled')) {
              // Payment failed
              _updateTransactionStatus(PaymentStatus.failed);
              timer.cancel();
              _setError('Payment failed: ${statusResponse.message}');
            } else {
              // Still processing - continue monitoring
              print('Payment still processing: ${statusResponse.message}');
            }

            // Stop after 10 minutes (40 attempts * 15 seconds)
            if (timer.tick >= 40) {
              timer.cancel();
              _setError('Payment status check timeout. Please check manually or contact support.');
            }

          } catch (e) {
            log('Status check error: $e');
            // Continue monitoring unless it's been too long
            if (timer.tick > 20) { // Stop after 5 minutes if errors persist
              timer.cancel();
              _setError('Unable to verify payment status. Please check manually or contact support.');
            }
          }
        },
      );
    });
  }

  // Update transaction status
  void _updateTransactionStatus(PaymentStatus status) {
    if (_currentTransaction != null) {
      _currentTransaction = AddMoneyTransaction(
        txnId: _currentTransaction!.txnId,
        amount: _currentTransaction!.amount,
        timestamp: _currentTransaction!.timestamp,
        status: status,
      );
      notifyListeners();
    }
  }

  // Manual status check
  Future<void> checkPaymentStatusManually(String txnId, WalletService walletService) async {
    try {
      _setProcessing(true);

      final response = await PaymentApiService.checkPaymentStatus(txnId: txnId);

      if (response.success) {
        _updateTransactionStatus(PaymentStatus.success);
        await walletService.refreshWalletData();
        _setSuccessMessage('Payment confirmed!');
      } else {
        _setError('Payment status: ${response.message}');
      }

    } catch (e) {
      _setError('Failed to check payment status: ${e.toString()}');
    } finally {
      _setProcessing(false);
    }
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
    _statusCheckTimer?.cancel();
    super.dispose();
  }
}