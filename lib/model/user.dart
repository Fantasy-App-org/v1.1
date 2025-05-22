class User {
  String? id;
  String? userName;
  String? email;
  int? gender;
  String? dateOfBirth;
  String mobileNumber;
  int? referredBy;
  String inviteCode;
  String? fcm;
  String? userTeam;
  String? image;
  String? address;
  String? country;
  String? state;
  String? city;
  String? pincode;
  String? deviceType;
  int? isUpdated;
  int? isVerified;
  double? cashBalance;
  double? winningAmount;
  double cashback;
  double levelIncome;
  double bonusAmount;
  int? active;

  User({
    this.id,
    this.userName,
    this.email,
    this.gender,
    this.dateOfBirth,
    required this.mobileNumber,
    this.referredBy,
    required this.inviteCode,
    this.fcm,
    this.userTeam,
    this.image,
    this.address,
    this.country,
    this.state,
    this.city,
    this.pincode,
    this.deviceType,
    this.isUpdated,
    this.isVerified,
    this.cashBalance,
    this.winningAmount,
    this.cashback = 0,
    this.levelIncome = 0,
    this.bonusAmount = 0,
    this.active,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id']?.toString(),
      userName: json['user_name'],
      email: json['email'],
      gender: json['gender'],
      dateOfBirth: json['date_of_birth'],
      mobileNumber: json['mobile_number'],
      referredBy: json['referred_by'],
      inviteCode: json['invite_code'],
      fcm: json['fcm'],
      userTeam: json['user_team'],
      image: json['image'],
      address: json['address'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      pincode: json['pincode'],
      deviceType: json['device_type'],
      isUpdated: json['is_updated'],
      isVerified: json['is_verified'],
      cashBalance: json['cash_balance'] != null ? double.parse(json['cash_balance'].toString()) : null,
      winningAmount: json['winning_amount'] != null ? double.parse(json['winning_amount'].toString()) : null,
      cashback: json['cashback'] != null ? double.parse(json['cashback'].toString()) : 0,
      levelIncome: json['level_income'] != null ? double.parse(json['level_income'].toString()) : 0,
      bonusAmount: json['bonus_amount'] != null ? double.parse(json['bonus_amount'].toString()) : 0,
      active: json['active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_name': userName,
      'email': email,
      'gender': gender,
      'date_of_birth': dateOfBirth,
      'mobile_number': mobileNumber,
      'referred_by': referredBy,
      'invite_code': inviteCode,
      'fcm': fcm,
      'user_team': userTeam,
      'image': image,
      'address': address,
      'country': country,
      'state': state,
      'city': city,
      'pincode': pincode,
      'device_type': deviceType,
      'is_updated': isUpdated,
      'is_verified': isVerified,
      'cash_balance': cashBalance,
      'winning_amount': winningAmount,
      'cashback': cashback,
      'level_income': levelIncome,
      'bonus_amount': bonusAmount,
      'active': active,
    };
  }
}