class WithdrawRequest {
  String? id;
  int userId;
  double amount;
  double refundAmount;
  int? requestStatus;
  String? email;
  String? type;
  String? referenceId;
  String? transferId;
  String? txId;
  int? refundInitiate;

  WithdrawRequest({
    this.id,
    required this.userId,
    required this.amount,
    required this.refundAmount,
    this.requestStatus,
    this.email,
    this.type,
    this.referenceId,
    this.transferId,
    this.txId,
    this.refundInitiate,
  });

  factory WithdrawRequest.fromJson(Map<String, dynamic> json) {
    return WithdrawRequest(
      id: json['id']?.toString(),
      userId: json['user_id'],
      amount: json['amount'] != null ? double.parse(json['amount'].toString()) : 0,
      refundAmount: json['refund_amount'] != null ? double.parse(json['refund_amount'].toString()) : 0,
      requestStatus: json['request_status'],
      email: json['email'],
      type: json['type'],
      referenceId: json['reference_id'],
      transferId: json['transfer_id'],
      txId: json['tx_id'],
      refundInitiate: json['refund_initiate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'amount': amount,
      'refund_amount': refundAmount,
      'request_status': requestStatus,
      'email': email,
      'type': type,
      'reference_id': referenceId,
      'transfer_id': transferId,
      'tx_id': txId,
      'refund_initiate': refundInitiate,
    };
  }
}