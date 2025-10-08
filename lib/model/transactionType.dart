class TransactionType {
  String? id;
  String? transactionsName;
  int? status;

  TransactionType({
    this.id,
    this.transactionsName,
    this.status,
  });

  factory TransactionType.fromJson(Map<String, dynamic> json) {
    return TransactionType(
      id: json['id']?.toString(),
      transactionsName: json['transactions_name'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'transactions_name': transactionsName,
      'status': status,
    };
  }
}