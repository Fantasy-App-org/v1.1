class JoinContest {
  String? id;
  int? groupId;
  int? playerTeamId;
  double? playerPoints;
  int previousRank;
  int currentRank;
  int position;
  int? userId;
  int? contestId;
  int? seriesId;
  int? fixtureId;
  int? adminCommission;
  int? bonusAmount;
  int? winningAmount;
  int? totalAmount;
  int? depositCash;
  int? walletType;
  int status;
  int? winningAmountNotification;
  int? winningAmountDistributed;

  JoinContest({
    this.id,
    this.groupId,
    this.playerTeamId,
    this.playerPoints,
    this.previousRank = 0,
    this.currentRank = 0,
    this.position = 0,
    this.userId,
    this.contestId,
    this.seriesId,
    this.fixtureId,
    this.adminCommission,
    this.bonusAmount,
    this.winningAmount,
    this.totalAmount,
    this.depositCash,
    this.walletType,
    required this.status,
    this.winningAmountNotification,
    this.winningAmountDistributed,
  });

  factory JoinContest.fromJson(Map<String, dynamic> json) {
    return JoinContest(
      id: json['id']?.toString(),
      groupId: json['group_id'],
      playerTeamId: json['player_team_id'],
      playerPoints: json['player_points'] != null ? double.parse(json['player_points'].toString()) : null,
      previousRank: json['previous_rank'] ?? 0,
      currentRank: json['current_rank'] ?? 0,
      position: json['position'] ?? 0,
      userId: json['user_id'],
      contestId: json['contest_id'],
      seriesId: json['series_id'],
      fixtureId: json['fixture_id'],
      adminCommission: json['admin_comission'],
      bonusAmount: json['bonus_amount'],
      winningAmount: json['winning_amount'],
      totalAmount: json['total_amount'],
      depositCash: json['deposit_cash'],
      walletType: json['wallet_type'],
      status: json['status'],
      winningAmountNotification: json['winning_amount_notification'],
      winningAmountDistributed: json['winning_amount_distributed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'group_id': groupId,
      'player_team_id': playerTeamId,
      'player_points': playerPoints,
      'previous_rank': previousRank,
      'current_rank': currentRank,
      'position': position,
      'user_id': userId,
      'contest_id': contestId,
      'series_id': seriesId,
      'fixture_id': fixtureId,
      'admin_comission': adminCommission,
      'bonus_amount': bonusAmount,
      'winning_amount': winningAmount,
      'total_amount': totalAmount,
      'deposit_cash': depositCash,
      'wallet_type': walletType,
      'status': status,
      'winning_amount_notification': winningAmountNotification,
      'winning_amount_distributed': winningAmountDistributed,
    };
  }
}