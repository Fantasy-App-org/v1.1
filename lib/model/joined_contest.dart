// lib/model/joined_contest.dart
class JoinedContest {
  final String? confirmWinning;
  final int? entryFee;
  final int? categoryId;
  final int? prizeMoney;
  final int? totalTeams;
  final int? contestId;
  final bool? isCancelled;
  final int? totalWinners;
  final int? teamsJoined;

  JoinedContest({
    this.confirmWinning,
    this.entryFee,
    this.categoryId,
    this.prizeMoney,
    this.totalTeams,
    this.contestId,
    this.isCancelled,
    this.totalWinners,
    this.teamsJoined,
  });

  factory JoinedContest.fromJson(Map<String, dynamic> json) {
    return JoinedContest(
      confirmWinning: json['confirm_winning'],
      entryFee: json['entry_fee'],
      categoryId: json['category_id'],
      prizeMoney: json['prize_money'],
      totalTeams: json['total_teams'],
      contestId: json['contest_id'],
      isCancelled: json['isCancelled'] ?? false,
      totalWinners: json['total_winners'],
      teamsJoined: json['teams_joined'],
    );
  }
}
