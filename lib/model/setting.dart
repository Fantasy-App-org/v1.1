class Setting {
  String? id;
  String? adminEmail;
  int? adminPercentage;
  int? vendorPercentage;
  double? referralBonusAmount;
  String? referralCode;
  String? defaultRef;
  int? totalGroupCount;
  double? minWithdrawAmount;
  double? maxWithdrawAmount;
  double? levelFirst;
  double? levelSecond;
  double? levelThird;
  double? levelFour;
  double? levelFive;
  double? levelSix;
  double? levelSeven;
  double? levelEight;
  double? levelNine;
  double? levelTen;
  double? levelEleven;
  double? levelTwelve;
  int? status;
  double? referralIncomeL1;
  double? referralIncomeL2;
  double? referralIncomeL3;
  double? referralIncomeL4;
  double? referralIncomeL5;
  double? referralIncomeL6;
  double? referralIncomeL7;
  double? referralIncomeL8;
  double? referralIncomeL9;
  double? referralIncomeL10;

  Setting({
    this.id,
    this.adminEmail,
    this.adminPercentage,
    this.vendorPercentage,
    this.referralBonusAmount,
    this.referralCode,
    this.defaultRef,
    this.totalGroupCount,
    this.minWithdrawAmount,
    this.maxWithdrawAmount,
    this.levelFirst,
    this.levelSecond,
    this.levelThird,
    this.levelFour,
    this.levelFive,
    this.levelSix,
    this.levelSeven,
    this.levelEight,
    this.levelNine,
    this.levelTen,
    this.levelEleven,
    this.levelTwelve,
    this.status,
    this.referralIncomeL1,
    this.referralIncomeL2,
    this.referralIncomeL3,
    this.referralIncomeL4,
    this.referralIncomeL5,
    this.referralIncomeL6,
    this.referralIncomeL7,
    this.referralIncomeL8,
    this.referralIncomeL9,
    this.referralIncomeL10,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      id: json['id']?.toString(),
      adminEmail: json['admin_email'],
      adminPercentage: json['admin_percentage'],
      vendorPercentage: json['vendor_percentage'],
      referralBonusAmount: json['referral_bonus_amount'] != null ? double.parse(json['referral_bonus_amount'].toString()) : null,
      referralCode: json['referral_code'],
      defaultRef: json['default_ref'],
      totalGroupCount: json['total_group_count'],
      minWithdrawAmount: json['min_withdraw_amount'] != null ? double.parse(json['min_withdraw_amount'].toString()) : null,
      maxWithdrawAmount: json['max_withdraw_amount'] != null ? double.parse(json['max_withdraw_amount'].toString()) : null,
      levelFirst: json['level_first'] != null ? double.parse(json['level_first'].toString()) : null,
      levelSecond: json['level_second'] != null ? double.parse(json['level_second'].toString()) : null,
      levelThird: json['level_third'] != null ? double.parse(json['level_third'].toString()) : null,
      levelFour: json['level_four'] != null ? double.parse(json['level_four'].toString()) : null,
      levelFive: json['level_five'] != null ? double.parse(json['level_five'].toString()) : null,
      levelSix: json['level_six'] != null ? double.parse(json['level_six'].toString()) : null,
      levelSeven: json['level_seven'] != null ? double.parse(json['level_seven'].toString()) : null,
      levelEight: json['level_eight'] != null ? double.parse(json['level_eight'].toString()) : null,
      levelNine: json['level_nine'] != null ? double.parse(json['level_nine'].toString()) : null,
      levelTen: json['level_ten'] != null ? double.parse(json['level_ten'].toString()) : null,
      levelEleven: json['level_eleven'] != null ? double.parse(json['level_eleven'].toString()) : null,
      levelTwelve: json['level_twelve'] != null ? double.parse(json['level_twelve'].toString()) : null,
      status: json['status'],
      referralIncomeL1: json['referral_income_l1'] != null ? double.parse(json['referral_income_l1'].toString()) : null,
      referralIncomeL2: json['referral_income_l2'] != null ? double.parse(json['referral_income_l2'].toString()) : null,
      referralIncomeL3: json['referral_income_l3'] != null ? double.parse(json['referral_income_l3'].toString()) : null,
      referralIncomeL4: json['referral_income_l4'] != null ? double.parse(json['referral_income_l4'].toString()) : null,
      referralIncomeL5: json['referral_income_l5'] != null ? double.parse(json['referral_income_l5'].toString()) : null,
      referralIncomeL6: json['referral_income_l6'] != null ? double.parse(json['referral_income_l6'].toString()) : null,
      referralIncomeL7: json['referral_income_l7'] != null ? double.parse(json['referral_income_l7'].toString()) : null,
      referralIncomeL8: json['referral_income_l8'] != null ? double.parse(json['referral_income_l8'].toString()) : null,
      referralIncomeL9: json['referral_income_l9'] != null ? double.parse(json['referral_income_l9'].toString()) : null,
      referralIncomeL10: json['referral_income_l10'] != null ? double.parse(json['referral_income_l10'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_email': adminEmail,
      'admin_percentage': adminPercentage,
      'vendor_percentage': vendorPercentage,
      'referral_bonus_amount': referralBonusAmount,
      'referral_code': referralCode,
      'default_ref': defaultRef,
      'total_group_count': totalGroupCount,
      'min_withdraw_amount': minWithdrawAmount,
      'max_withdraw_amount': maxWithdrawAmount,
      'level_first': levelFirst,
      'level_second': levelSecond,
      'level_third': levelThird,
      'level_four': levelFour,
      'level_five': levelFive,
      'level_six': levelSix,
      'level_seven': levelSeven,
      'level_eight': levelEight,
      'level_nine': levelNine,
      'level_ten': levelTen,
      'level_eleven': levelEleven,
      'level_twelve': levelTwelve,
      'status': status,
      'referral_income_l1': referralIncomeL1,
      'referral_income_l2': referralIncomeL2,
      'referral_income_l3': referralIncomeL3,
      'referral_income_l4': referralIncomeL4,
      'referral_income_l5': referralIncomeL5,
      'referral_income_l6': referralIncomeL6,
      'referral_income_l7': referralIncomeL7,
      'referral_income_l8': referralIncomeL8,
      'referral_income_l9': referralIncomeL9,
      'referral_income_l10': referralIncomeL10,
    };
  }
}