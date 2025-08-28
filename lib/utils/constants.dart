class ApiConstants {
  static const String baseUrl = 'http://api.start25pro.com:3000';

  // Payment endpoints
  static const String initiatePayment = '/payment/newpayment';
  static const String checkPaymentStatus = '/payment/checkpaymentstatus';
  static const String paymentCallback = '/payment/paymentstatus';

  // Withdrawal endpoints
  static const String withDrawRequest = '/payment/withdrawrequest';
}

class PaymentConstants {
  static const double minAmount = 10.0;
  static const double maxAmount = 50000.0;
  static const List<int> quickAmounts = [100, 500, 1000, 2000, 5000];
}

class WithdrawalConstants {
  static const double minAmount = 10.0;
  static const double maxAmount = 50000.0;
}