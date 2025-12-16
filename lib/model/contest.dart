// lib/model/contest.dart
class ContestCategory {
  final String? categoryTitle;
  final String? categoryDesc;
  final String? categoryImage;
  final int? categoryId;
  final List<Contest> contests;

  ContestCategory({
    this.categoryTitle,
    this.categoryDesc,
    this.categoryImage,
    this.categoryId,
    this.contests = const [],
  });

  factory ContestCategory.fromJson(Map<String, dynamic> json) {
    final contestsData = json['contests'] as List<dynamic>? ?? [];
    final contests = contestsData.map((contestJson) => Contest.fromJson(contestJson)).toList();

    return ContestCategory(
      categoryTitle: json['category_title'],
      categoryDesc: json['category_desc'],
      categoryImage: json['category_image'],
      categoryId: json['category_id'],
      contests: contests,
    );
  }
}

class Contest {
  final String? confirmWinning;
  final int? entryFee;
  final int? prizeMoney;
  final int? totalTeams;
  final int? totalWinners;
  final int? contestId;
  final int? teamsJoined;
  final bool? isJoined;
  final int? multipleTeams;
  final String? inviteCode;
  final String? useBonus;
  final List<BreakupDetail>? breakupDetails;
  final int? myTeams;
  final bool? isInfinite;
  final Map<String, dynamic>? infiniteBreakup;

  // Additional fields for UI
  final String? categoryTitle;
  final int? categoryId;

  Contest({
    this.confirmWinning,
    this.entryFee,
    this.prizeMoney,
    this.totalTeams,
    this.totalWinners,
    this.contestId,
    this.teamsJoined,
    this.isJoined,
    this.multipleTeams,
    this.inviteCode,
    this.useBonus,
    this.breakupDetails,
    this.myTeams,
    this.isInfinite,
    this.infiniteBreakup,
    this.categoryTitle,
    this.categoryId,
  });

  factory Contest.fromJson(Map<String, dynamic> json, {String? categoryTitle, int? categoryId}) {
    final breakupData = json['breakup_details'] as List<dynamic>? ?? [];
    final breakupDetails = breakupData.map((detail) => BreakupDetail.fromJson(detail)).toList();

    return Contest(
      confirmWinning: json['confirm_winning'],
      entryFee: json['entry_fee'],
      prizeMoney: json['prize_money'],
      totalTeams: json['total_teams'],
      totalWinners: json['total_winners'],
      contestId: json['contest_id'],
      teamsJoined: json['teams_joined'],
      isJoined: json['is_joined'] ?? false,
      multipleTeams: json['multiple_teams'],
      inviteCode: json['invite_code'],
      useBonus: json['use_bonus'],
      breakupDetails: breakupDetails,
      myTeams: json['my_teams'],
      isInfinite: json['is_infinite'] ?? false,
      infiniteBreakup: json['infinite_breakup'],
      categoryTitle: categoryTitle,
      categoryId: categoryId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'confirm_winning': confirmWinning,
      'entry_fee': entryFee,
      'prize_money': prizeMoney,
      'total_teams': totalTeams,
      'total_winners': totalWinners,
      'contest_id': contestId,
      'teams_joined': teamsJoined,
      'is_joined': isJoined,
      'multiple_teams': multipleTeams,
      'invite_code': inviteCode,
      'use_bonus': useBonus,
      'my_teams': myTeams,
      'is_infinite': isInfinite,
      'infinite_breakup': infiniteBreakup,
    };
  }

  // Helper getters
  bool get isGuaranteed => confirmWinning == "1";
  int get spotsLeft => (totalTeams ?? 0) - (teamsJoined ?? 0);
  double get fillPercentage => (totalTeams ?? 0) > 0 ? (teamsJoined ?? 0) / (totalTeams ?? 0) : 0.0;
  bool get isPaidContest => (entryFee ?? 0) > 0;
  int get prizePerWinner => (totalWinners ?? 0) > 0 ? (prizeMoney ?? 0) ~/ (totalWinners ?? 1) : 0;
  bool get isCancelled => false; // Default to false as it's not in API response
}

class BreakupDetail {
  final String? name;
  final String? prize;

  BreakupDetail({
    this.name,
    this.prize,
  });

  factory BreakupDetail.fromJson(Map<String, dynamic> json) {
    return BreakupDetail(
      name: json['name'],
      prize: json['prize'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'prize': prize,
    };
  }
}