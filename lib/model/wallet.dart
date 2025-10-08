class WalletResponse {
  final bool status;
  final String message;
  final WalletData? data;

  WalletResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory WalletResponse.fromJson(Map<String, dynamic> json) {
    return WalletResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? WalletData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class WalletData {
  final int joinedContest;
  final int joinedTeams;
  final double cashback;
  final double winnings;
  final double cashDeposit;
  final double levelIncome;
  final double withdrawableAmount;
  final double nonWithdrawableAmount;
  final double bonus;
  final int accountVerified;

  WalletData({
    required this.joinedContest,
    required this.joinedTeams,
    required this.cashback,
    required this.winnings,
    required this.cashDeposit,
    required this.levelIncome,
    required this.withdrawableAmount,
    required this.nonWithdrawableAmount,
    required this.bonus,
    required this.accountVerified,
  });

  factory WalletData.fromJson(Map<String, dynamic> json) {
    return WalletData(
      joinedContest: json['joined_contest'] ?? 0,
      joinedTeams: json['joined_teams'] ?? 0,
      cashback: (json['cashback'] ?? 0).toDouble(),
      winnings: (json['winnings'] ?? 0).toDouble(),
      cashDeposit: (json['cash_deposit'] ?? 0).toDouble(),
      levelIncome: (json['level_income'] ?? 0).toDouble(),
      withdrawableAmount: (json['withdrawabale_amount'] ?? 0).toDouble(), // Note: API has typo
      nonWithdrawableAmount: (json['non_withdrawabale_amount'] ?? 0).toDouble(), // Note: API has typo
      bonus: (json['bonus'] ?? 0).toDouble(),
      accountVerified: json['account_verified'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'joined_contest': joinedContest,
      'joined_teams': joinedTeams,
      'cashback': cashback,
      'winnings': winnings,
      'cash_deposit': cashDeposit,
      'level_income': levelIncome,
      'withdrawabale_amount': withdrawableAmount,
      'non_withdrawabale_amount': nonWithdrawableAmount,
      'bonus': bonus,
      'account_verified': accountVerified,
    };
  }

  // Helper getters for UI
  double get totalBalance => withdrawableAmount + nonWithdrawableAmount;

  bool get isAccountVerified => accountVerified == 1;

  // Helper method to get formatted currency string - FIXED
  String getFormattedAmount(double amount) {
    return '₹ ${amount.toStringAsFixed(2)}';
  }
}