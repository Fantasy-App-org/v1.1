class PaymentInitiateRequest {
  final String price;
  final String mobileNumber;

  PaymentInitiateRequest({
    required this.price,
    required this.mobileNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'price': price,
      'mobile_number': mobileNumber,
    };
  }
}

class PaymentInitiateResponse {
  final bool status;
  final String message;
  final PaymentData? data;

  PaymentInitiateResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory PaymentInitiateResponse.fromJson(Map<String, dynamic> json) {
    return PaymentInitiateResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? PaymentData.fromJson(json['data']) : null,
    );
  }
}

class PaymentData {
  final String txnId;
  final String url;

  PaymentData({
    required this.txnId,
    required this.url,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) {
    return PaymentData(
      txnId: json['txnId'] ?? '',
      url: json['url'] ?? '',
    );
  }
}

class PaymentStatusRequest {
  final String txnId;

  PaymentStatusRequest({required this.txnId});

  Map<String, dynamic> toJson() {
    return {
      'txnId': txnId,
    };
  }
}

class PaymentStatusResponse {
  final bool success;
  final String message;

  PaymentStatusResponse({
    required this.success,
    required this.message,
  });

  factory PaymentStatusResponse.fromJson(Map<String, dynamic> json) {
    return PaymentStatusResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }
}

class AddMoneyTransaction {
  final String txnId;
  final double amount;
  final DateTime timestamp;
  final PaymentStatus status;

  AddMoneyTransaction({
    required this.txnId,
    required this.amount,
    required this.timestamp,
    required this.status,
  });
}

enum PaymentStatus {
  initiated,
  processing,
  success,
  failed,
  pending
}