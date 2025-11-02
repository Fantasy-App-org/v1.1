// lib/model/contest_detail.dart

class ContestDetailResponse {
  final bool status;
  final String message;
  final ContestDetailData data;

  ContestDetailResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ContestDetailResponse.fromJson(Map<String, dynamic> json) {
    return ContestDetailResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      data: ContestDetailData.fromJson(json['data'] ?? {}),
    );
  }
}

class ContestDetailData {
  final List<MatchContest> matchContest;
  final int myTeamsCount;
  final List<int> myTeams;
  final int myContests;

  ContestDetailData({
    required this.matchContest,
    required this.myTeamsCount,
    required this.myTeams,
    required this.myContests,
  });

  factory ContestDetailData.fromJson(Map<String, dynamic> json) {
    return ContestDetailData(
      matchContest: (json['match_contest'] as List<dynamic>? ?? [])
          .map((e) => MatchContest.fromJson(e))
          .toList(),
      myTeamsCount: json['my_teams_count'] ?? 0,
      myTeams: (json['my_teams'] as List<dynamic>? ?? [])
          .map((e) => e as int)
          .toList(),
      myContests: json['my_contests'] ?? 0,
    );
  }
}

class MatchContest {
  final String categoryTitle;
  final String categoryDesc;
  final String categoryImage;
  final int categoryId;
  final List<ContestDetail> contests;

  MatchContest({
    required this.categoryTitle,
    required this.categoryDesc,
    required this.categoryImage,
    required this.categoryId,
    required this.contests,
  });

  factory MatchContest.fromJson(Map<String, dynamic> json) {
    return MatchContest(
      categoryTitle: json['category_title'] ?? '',
      categoryDesc: json['category_desc'] ?? '',
      categoryImage: json['category_image'] ?? '',
      categoryId: json['category_id'] ?? 0,
      contests: (json['contests'] as List<dynamic>? ?? [])
          .map((e) => ContestDetail.fromJson(e))
          .toList(),
    );
  }
}

class ContestDetail {
  final String confirmWinning;
  final double entryFee;
  final double prizeMoney;
  final int totalTeams;
  final int contestId;
  final int totalWinners;
  final int teamsJoined;
  final bool isJoined;
  final int multipleTeams;
  final String? inviteCode;
  final String useBonus;
  final List<BreakupDetail> breakupDetails;
  final int myTeams;
  final bool isInfinite;
  final InfiniteBreakup infiniteBreakup;

  ContestDetail({
    required this.confirmWinning,
    required this.entryFee,
    required this.prizeMoney,
    required this.totalTeams,
    required this.contestId,
    required this.totalWinners,
    required this.teamsJoined,
    required this.isJoined,
    required this.multipleTeams,
    this.inviteCode,
    required this.useBonus,
    required this.breakupDetails,
    required this.myTeams,
    required this.isInfinite,
    required this.infiniteBreakup,
  });

  factory ContestDetail.fromJson(Map<String, dynamic> json) {
    return ContestDetail(
      confirmWinning: json['confirm_winning']?.toString() ?? '0',
      entryFee: double.tryParse(json['entry_fee']?.toString() ?? '0') ?? 0.0,
      prizeMoney: double.tryParse(json['prize_money']?.toString() ?? '0') ?? 0.0,
      totalTeams: json['total_teams'] ?? 0,
      contestId: json['contest_id'] ?? 0,
      totalWinners: json['total_winners'] ?? 0,
      teamsJoined: json['teams_joined'] ?? 0,
      isJoined: json['is_joined'] ?? false,
      multipleTeams: json['multiple_teams'] ?? 0,
      inviteCode: json['invite_code'],
      useBonus: json['use_bonus']?.toString() ?? '',
      breakupDetails: (json['breakup_details'] as List<dynamic>? ?? [])
          .map((e) => BreakupDetail.fromJson(e))
          .toList(),
      myTeams: json['my_teams'] ?? 0,
      isInfinite: json['is_infinite'] ?? false,
      infiniteBreakup: InfiniteBreakup.fromJson(json['infinite_breakup'] ?? {}),
    );
  }

  double get fillPercentage => totalTeams > 0 ? teamsJoined / totalTeams : 0.0;
  int get spotsLeft => totalTeams - teamsJoined;
  bool get isGuaranteed => confirmWinning == "1";
}

class BreakupDetail {
  final String name;
  final String prize;

  BreakupDetail({
    required this.name,
    required this.prize,
  });

  factory BreakupDetail.fromJson(Map<String, dynamic> json) {
    return BreakupDetail(
      name: json['name'] ?? '',
      prize: json['prize']?.toString() ?? '0.00',
    );
  }

  double get prizeAmount => double.tryParse(prize) ?? 0.0;
}

class InfiniteBreakup {
  final String? winnerPercent;
  final String? winnerAmount;

  InfiniteBreakup({
    this.winnerPercent,
    this.winnerAmount,
  });

  factory InfiniteBreakup.fromJson(Map<String, dynamic> json) {
    return InfiniteBreakup(
      winnerPercent: json['winner_percent']?.toString(),
      winnerAmount: json['winner_amount']?.toString(),
    );
  }
}