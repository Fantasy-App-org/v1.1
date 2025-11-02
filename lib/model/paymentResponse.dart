class PaymentResponse {
  String? id;
  Map<String, dynamic> response;

  PaymentResponse({
    this.id,
    required this.response,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) {
    return PaymentResponse(
      id: json['id']?.toString(),
      response: json['response'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'response': response,
    };
  }
}