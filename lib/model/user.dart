import 'package:fantasy/model/referredFriend.dart';

class User {
  final int userId;
  final String? teamName;
  final String? name;
  final String? email;
  final String? dateOfBirth;
  final String? address;
  final String? city;
  final String? pinCode;
  final String? country;
  final String? state;
  final int? gender;
  final String? mobileNo;  // Changed from mobileNumber
  final int? paidContestCount;
  final double? cashback;
  final double? winnings;
  final double? cashDeposit;
  final double? levelIncome;
  final double? withdrawableAmount;
  final double? nonWithdrawableAmount;
  final double? bonus;
  final String? inviteFriendCode;
  final int? contestFinished;
  final int? totalMatch;
  final int? totalSeries;
  final String? seriesWins;
  final bool? teamNameUpdated;
  final String? panNumber;
  final String? accountNumber;
  final String? image;
  final List<ReferredFriend>? referredToFriend;
  final String? referralBonus;
  final int? accountVerified;
  final int? bankVerify;
  final int? panVerify;
  final bool? isNotifications;
  final int? currentLevel;

  User({
    required this.userId,
    this.teamName,
    this.name,
    this.email,
    this.dateOfBirth,
    this.address,
    this.city,
    this.pinCode,
    this.country,
    this.state,
    this.gender,
    this.mobileNo,
    this.paidContestCount,
    this.cashback,
    this.winnings,
    this.cashDeposit,
    this.levelIncome,
    this.withdrawableAmount,
    this.nonWithdrawableAmount,
    this.bonus,
    this.inviteFriendCode,
    this.contestFinished,
    this.totalMatch,
    this.totalSeries,
    this.seriesWins,
    this.teamNameUpdated,
    this.panNumber,
    this.accountNumber,
    this.image,
    this.referredToFriend,
    this.referralBonus,
    this.accountVerified,
    this.bankVerify,
    this.panVerify,
    this.isNotifications,
    this.currentLevel,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'] ?? 0,
      teamName: json['team_name'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      pinCode: json['pinCode'] ?? '',
      country: json['country'] ?? '',
      state: json['state'] ?? '',
      gender: json['gender'] ?? 0,
      mobileNo: json['mobile_no'] ?? '',  // Fixed field name
      paidContestCount: json['paid_contest_count'] ?? 0,
      cashback: (json['cashback'] ?? 0).toDouble(),
      winnings: (json['winnings'] ?? 0).toDouble(),
      cashDeposit: (json['cash_deposit'] ?? 0).toDouble(),
      levelIncome: (json['level_income'] ?? 0).toDouble(),
      withdrawableAmount: (json['withdrawabale_amount'] ?? 0).toDouble(),
      nonWithdrawableAmount: (json['non_withdrawabale_amount'] ?? 0).toDouble(),
      bonus: (json['bonus'] ?? 0).toDouble(),
      inviteFriendCode: json['invite_friend_code'] ?? '',
      contestFinished: json['contest_finished'] ?? 0,
      totalMatch: json['total_match'] ?? 0,
      totalSeries: json['total_series'] ?? 0,
      seriesWins: json['series_wins'] ?? '',
      teamNameUpdated: json['team_name_updated'] ?? false,
      panNumber: json['pan_number'] ?? '',
      accountNumber: json['account_number'] ?? '',
      image: json['image'] ?? '',
      referredToFriend: (json['refered_to_friend'] as List<dynamic>?)
          ?.map((item) => ReferredFriend.fromJson(item))
          .toList() ?? [],
      referralBonus: json['referral_bonus'] ?? '',
      accountVerified: json['account_verified'] ?? 0,
      bankVerify: json['bank_verify'] ?? 0,
      panVerify: json['pan_verify'] ?? 0,
      isNotifications: json['isNotifications'] ?? false,
      currentLevel: json['current_level'] ?? 0,
    );
  }

  // Helper getters
  String get displayName => name?.isNotEmpty == true ? name! : (teamName ?? 'User');
  String get profileImage => image?.isNotEmpty == true ? image! : '';
  bool get isVerified => accountVerified == 1;
  bool get isPanVerified => panVerify == 2;
  bool get isBankVerified => bankVerify == 2;
}