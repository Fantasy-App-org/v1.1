// models/transaction_model.dart
class ApiResponse {
  final bool status;
  final String message;
  final TransactionData data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: TransactionData.fromJson(json['data'] ?? {}),
    );
  }
}

class TransactionData {
  final List<Transaction> transactions;
  final String currentPages;
  final int totalPages;

  TransactionData({
    required this.transactions,
    required this.currentPages,
    required this.totalPages,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      transactions: (json['data'] as List<dynamic>?)
          ?.map((item) => Transaction.fromJson(item))
          .toList() ?? [],
      currentPages: json['currentPages']?.toString() ?? '1',
      totalPages: int.tryParse(json['totalPages']?.toString() ?? '0') ?? 0,
    );
  }
}

class Transaction {
  final String transactionId;
  final String txnType;
  final String teamName;
  final double amount;
  final DateTime txnDate;
  final String status;
  final String result;

  Transaction({
    required this.transactionId,
    required this.txnType,
    required this.teamName,
    required this.amount,
    required this.txnDate,
    required this.status,
    required this.result,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    // Parse amount from string (e.g., "+105.00" or "-2000.00")
    String amountStr = json['amount']?.toString() ?? '0';
    double parsedAmount = double.tryParse(amountStr.replaceAll('+', '')) ?? 0.0;

    // Parse date
    DateTime parsedDate;
    try {
      parsedDate = DateTime.parse(json['txn_date'] ?? '');
    } catch (e) {
      parsedDate = DateTime.now();
    }

    // Determine status based on transaction type and amount
    String status = 'Completed';
    String result = 'Success';

    if (json['txn_type']?.toString().contains('Won') == true) {
      result = 'Won';
    }

    return Transaction(
      transactionId: json['transaction_id']?.toString() ?? '',
      txnType: json['txn_type']?.toString() ?? '',
      teamName: json['team_name']?.toString() ?? '',
      amount: parsedAmount,
      txnDate: parsedDate,
      status: status,
      result: result,
    );
  }

  // Helper getters to match your existing UI
  String get type {
    if (txnType.contains('Won')) return 'Contest Entry';
    if (txnType.contains('Joined')) return 'Contest Entry';
    if (txnType.contains('Add') || txnType.contains('Deposit')) return 'Wallet Add';
    if (txnType.contains('Withdrawal')) return 'Withdrawal';
    if (txnType.contains('Bonus')) return 'Bonus Added';
    return 'Contest Entry';
  }

  String get game => teamName.isNotEmpty ? 'Team: $teamName' : 'Contest';

  String get date => '${txnDate.year}-${txnDate.month.toString().padLeft(2, '0')}-${txnDate.day.toString().padLeft(2, '0')}';

  String get time => '${txnDate.hour.toString().padLeft(2, '0')}:${txnDate.minute.toString().padLeft(2, '0')}';

  double get winAmount => amount > 0 ? amount : 0.0;
}