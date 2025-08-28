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
  final bool? isJoined;
  final String? useBonus;
  final int? multipleTeams;
  final String? inviteCode;
  final List<MyTeamDetails>? myTeamsDetails;
  final List<BreakupDetails>? breakupDetails;
  final int? myTeams;
  final bool? isInfinite;
  final InfiniteBreakup? infiniteBreakup;

  // ADDED: Computed property for contest name
  String? get contestName {
    // Generate a contest name based on available data
    if (prizeMoney != null && entryFee != null) {
      return 'Contest ₹$prizeMoney (₹$entryFee entry)';
    }
    return 'Contest $contestId';
  }

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
    this.isJoined,
    this.useBonus,
    this.multipleTeams,
    this.inviteCode,
    this.myTeamsDetails,
    this.breakupDetails,
    this.myTeams,
    this.isInfinite,
    this.infiniteBreakup,
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
      isJoined: json['is_joined'],
      useBonus: json['use_bonus'],
      multipleTeams: json['multiple_teams'],
      inviteCode: json['invite_code'],
      myTeamsDetails: json['my_teams_details'] != null
          ? (json['my_teams_details'] as List)
          .map((team) => MyTeamDetails.fromJson(team))
          .toList()
          : null,
      breakupDetails: json['breakup_details'] != null
          ? (json['breakup_details'] as List)
          .map((breakup) => BreakupDetails.fromJson(breakup))
          .toList()
          : null,
      myTeams: json['my_teams'],
      isInfinite: json['is_infinite'],
      infiniteBreakup: json['infinite_breakup'] != null
          ? InfiniteBreakup.fromJson(json['infinite_breakup'])
          : null,
    );
  }
}

class MyTeamDetails {
  final int? teamId;
  final int? teamName;  // Keep as int? since API returns integer
  final bool? inWinningZone;
  final int? points;
  final int? rank;
  final String? capName;
  final String? vcName;

  // ADDED: Computed property for team name as string
  String get teamNameString {
    return teamName != null ? 'Team $teamName' : 'Unknown Team';
  }

  MyTeamDetails({
    this.teamId,
    this.teamName,
    this.inWinningZone,
    this.points,
    this.rank,
    this.capName,
    this.vcName,
  });

  factory MyTeamDetails.fromJson(Map<String, dynamic> json) {
    return MyTeamDetails(
      teamId: json['team_id'],
      teamName: json['team_name'],
      inWinningZone: json['in_winning_zone'],
      points: json['points'],
      rank: json['rank'],
      capName: json['cap_name'],
      vcName: json['vc_name'],
    );
  }

  @override
  String toString() {
    return 'MyTeamDetails(teamId: $teamId, teamName: $teamName, capName: $capName, vcName: $vcName, points: $points, rank: $rank)';
  }
}

class BreakupDetails {
  final String? name;
  final String? prize;
  final int? end;

  BreakupDetails({
    this.name,
    this.prize,
    this.end,
  });

  factory BreakupDetails.fromJson(Map<String, dynamic> json) {
    return BreakupDetails(
      name: json['name'],
      prize: json['prize'],
      end: json['end'],
    );
  }
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
      winnerPercent: json['winner_percent'],
      winnerAmount: json['winner_amount'],
    );
  }
}