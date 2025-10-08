class Referral {
  String? referralId;
  int? userId;
  String referralCode;
  int? referredCount;
  int? referredBy;
  int? status;

  Referral({
    this.referralId,
    this.userId,
    required this.referralCode,
    this.referredCount,
    this.referredBy,
    this.status,
  });

  factory Referral.fromJson(Map<String, dynamic> json) {
    return Referral(
      referralId: json['referral_id']?.toString(),
      userId: json['user_id'],
      referralCode: json['referral_code'],
      referredCount: json['referred_count'],
      referredBy: json['referred_by'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'referral_code': referralCode,
      'referred_count': referredCount,
      'referred_by': referredBy,
      'status': status,
    };
  }
}