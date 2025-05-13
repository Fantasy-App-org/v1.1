class WalletTransaction {
  String? id;
  int? userId;
  String? transactionType;
  int? joinContestDetailsId;
  double? debitAmount;
  double? creditAmount;
  int? groupId;
  int? teamId;
  int? level;
  int? referralIncomeLevel;
  int? walletTransactionId;
  int? referralIncomeFrom;
  DateTime? createdAt;
  DateTime? updatedAt;

  WalletTransaction({
    this.id,
    this.userId,
    this.transactionType,
    this.joinContestDetailsId,
    this.debitAmount,
    this.creditAmount,
    this.groupId,
    this.teamId,
    this.level,
    this.referralIncomeLevel,
    this.walletTransactionId,
    this.referralIncomeFrom,
    this.createdAt,
    this.updatedAt,
  });

  factory WalletTransaction.fromJson(Map<String, dynamic> json) {
    return WalletTransaction(
      id: json['id']?.toString(),
      userId: json['user_id'],
      transactionType: json['transaction_type'],
      joinContestDetailsId: json['join_contest_details_id'],
      debitAmount: json['debit_amount'] != null ? double.parse(json['debit_amount'].toString()) : null,
      creditAmount: json['credit_amount'] != null ? double.parse(json['credit_amount'].toString()) : null,
      groupId: json['group_id'],
      teamId: json['team_id'],
      level: json['level'],
      referralIncomeLevel: json['referral_income_level'],
      walletTransactionId: json['wallet_transaction_id'],
      referralIncomeFrom: json['referral_income_from'],
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'transaction_type': transactionType,
      'join_contest_details_id': joinContestDetailsId,
      'debit_amount': debitAmount,
      'credit_amount': creditAmount,
      'group_id': groupId,
      'team_id': teamId,
      'level': level,
      'referral_income_level': referralIncomeLevel,
      'wallet_transaction_id': walletTransactionId,
      'referral_income_from': referralIncomeFrom,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}