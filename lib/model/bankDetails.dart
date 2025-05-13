class BankDetails {
  String? id;
  int userId;
  String accountNumber;
  String ifscCode;
  String bankName;
  String branch;
  String? bankImage;
  int isVerified;
  int? beneficiaryId;

  BankDetails({
    this.id,
    required this.userId,
    required this.accountNumber,
    required this.ifscCode,
    required this.bankName,
    required this.branch,
    this.bankImage,
    required this.isVerified,
    this.beneficiaryId,
  });

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
      id: json['id']?.toString(),
      userId: json['user_id'],
      accountNumber: json['account_number'],
      ifscCode: json['ifsc_code'],
      bankName: json['bank_name'],
      branch: json['branch'],
      bankImage: json['bank_image'],
      isVerified: json['is_verified'],
      beneficiaryId: json['beneficiary_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'account_number': accountNumber,
      'ifsc_code': ifscCode,
      'bank_name': bankName,
      'branch': branch,
      'bank_image': bankImage,
      'is_verified': isVerified,
      'beneficiary_id': beneficiaryId,
    };
  }
}