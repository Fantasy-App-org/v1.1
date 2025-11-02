enum WithdrawalType {
  winningAmount('WINNING_AMOUNT'),
  cashBack('CASH_BACK'),
  levelIncome('LEVEL_INCOME');

  const WithdrawalType(this.value);
  final String value;
}

class WithdrawalRequest {
  final WithdrawalType type;
  final double winningAmount;
  final double cashBack;
  final double levelIncome;

  WithdrawalRequest({
    required this.type,
    this.winningAmount = 0,
    this.cashBack = 0,
    this.levelIncome = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.value,
      'winning_amount': winningAmount,
      'cash_back': cashBack,
      'level_income': levelIncome,
    };
  }
}

class WithdrawalResponse {
  final bool status;
  final String message;
  final Map<String, dynamic>? data;

  WithdrawalResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory WithdrawalResponse.fromJson(Map<String, dynamic> json) {
    return WithdrawalResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }
}

class WithdrawalTransaction {
  final String id;
  final WithdrawalType type;
  final double amount;
  final DateTime timestamp;
  final WithdrawalStatus status;

  WithdrawalTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.timestamp,
    required this.status,
  });
}

enum WithdrawalStatus {
  pending,
  processing,
  success,
  failed,
  cancelled
}