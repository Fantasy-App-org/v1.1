// lib/model/wallet_balance.dart
class WalletBalance {
  final double cashBalance;
  final double usableBonus;
  final double? entryFee;
  final double usableBonusPercent;
  final double totalAmount;

  WalletBalance({
    required this.cashBalance,
    required this.usableBonus,
    this.entryFee,
    required this.usableBonusPercent,
    required this.totalAmount,
  });

  factory WalletBalance.fromJson(Map<String, dynamic> json) {
    return WalletBalance(
      cashBalance: (json['cash_balance'] ?? 0).toDouble(),
      usableBonus: (json['usable_bonus'] ?? 0).toDouble(),
      entryFee: json['entry_fee'] != null ? (json['entry_fee']).toDouble() : null,
      usableBonusPercent: (json['usable_bonus_percent'] ?? 0).toDouble(),
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cash_balance': cashBalance,
      'usable_bonus': usableBonus,
      'entry_fee': entryFee,
      'usable_bonus_percent': usableBonusPercent,
      'total_amount': totalAmount,
    };
  }

  // Helper method to check if balance is sufficient
  bool isSufficientForEntry(double requiredAmount) {
    return totalAmount >= requiredAmount;
  }

  // Helper method to get formatted cash balance
  String get formattedCashBalance => '₹${cashBalance.toStringAsFixed(2)}';

  // Helper method to get formatted total amount
  String get formattedTotalAmount => '₹${totalAmount.toStringAsFixed(2)}';

  // Helper method to get formatted bonus
  String get formattedBonus => usableBonus > 0
      ? '₹${usableBonus.toStringAsFixed(2)} (${usableBonusPercent.toInt()}%)'
      : '₹0.00';
}