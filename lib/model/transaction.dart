class Transaction {
  String? id;
  int? userId;
  int? transTypeId;
  String? orderId;
  String? txnId;
  String? bankTxnId;
  DateTime? txnDate;
  double? txnAmount;
  int? currency;
  String? gatewayName;
  String? tnxNote;
  int? checksum;
  int? localTxnId;
  String? merchantTransactionId;
  String? transactionId;
  String? payApiResponse;
  int? status;

  Transaction({
    this.id,
    this.userId,
    this.transTypeId,
    this.orderId,
    this.txnId,
    this.bankTxnId,
    this.txnDate,
    this.txnAmount,
    this.currency,
    this.gatewayName,
    this.tnxNote,
    this.checksum,
    this.localTxnId,
    this.merchantTransactionId,
    this.transactionId,
    this.payApiResponse,
    this.status,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id']?.toString(),
      userId: json['user_id'],
      transTypeId: json['trans_type_id'],
      orderId: json['order_id'],
      txnId: json['txn_id'],
      bankTxnId: json['banktxn_id'],
      txnDate: json['txn_date'] != null ? DateTime.parse(json['txn_date']) : null,
      txnAmount: json['txn_amount'] != null ? double.parse(json['txn_amount'].toString()) : null,
      currency: json['currency'],
      gatewayName: json['gateway_name'],
      tnxNote: json['tnx_note'],
      checksum: json['checksum'],
      localTxnId: json['local_txn_id'],
      merchantTransactionId: json['merchantTransactionId'],
      transactionId: json['transactionId'],
      payApiResponse: json['pay_api_response'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'trans_type_id': transTypeId,
      'order_id': orderId,
      'txn_id': txnId,
      'banktxn_id': bankTxnId,
      'txn_date': txnDate?.toIso8601String(),
      'txn_amount': txnAmount,
      'currency': currency,
      'gateway_name': gatewayName,
      'tnx_note': tnxNote,
      'checksum': checksum,
      'local_txn_id': localTxnId,
      'merchantTransactionId': merchantTransactionId,
      'transactionId': transactionId,
      'pay_api_response': payApiResponse,
      'status': status,
    };
  }
}