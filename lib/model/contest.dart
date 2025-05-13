class Contest {
  String? id;
  int? categoryId;
  int adminCommision;
  int? winningAmount;
  int? contestSize;
  int? minContestSize;
  int? contestType;
  String? inviteCode;
  int? priceBreakup;
  int? entryFee;
  String? confirmedWinning;
  int? multipleTeam;
  int? autoCreate;
  int status;

  Contest({
    this.id,
    this.categoryId,
    required this.adminCommision,
    this.winningAmount,
    this.contestSize,
    this.minContestSize,
    this.contestType,
    this.inviteCode,
    this.priceBreakup,
    this.entryFee,
    this.confirmedWinning,
    this.multipleTeam,
    this.autoCreate,
    required this.status,
  });

  factory Contest.fromJson(Map<String, dynamic> json) {
    return Contest(
      id: json['id']?.toString(),
      categoryId: json['category_id'],
      adminCommision: json['admin_commision'],
      winningAmount: json['winning_amount'],
      contestSize: json['contest_size'],
      minContestSize: json['min_contest_size'],
      contestType: json['contest_type'],
      inviteCode: json['invite_code'],
      priceBreakup: json['price_breakup'],
      entryFee: json['entry_fee'],
      confirmedWinning: json['confirmed_winning'],
      multipleTeam: json['multiple_team'],
      autoCreate: json['auto_create'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category_id': categoryId,
      'admin_commision': adminCommision,
      'winning_amount': winningAmount,
      'contest_size': contestSize,
      'min_contest_size': minContestSize,
      'contest_type': contestType,
      'invite_code': inviteCode,
      'price_breakup': priceBreakup,
      'entry_fee': entryFee,
      'confirmed_winning': confirmedWinning,
      'multiple_team': multipleTeam,
      'auto_create': autoCreate,
      'status': status,
    };
  }
}