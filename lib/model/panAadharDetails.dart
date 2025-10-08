class PanAadharDetails {
  String? id;
  int? userId;
  String? panCard;
  String? panImage;
  String? panName;
  String? aadharCard;
  int? isVerified;
  DateTime? dateOfBirth;
  String? state;

  PanAadharDetails({
    this.id,
    this.userId,
    this.panCard,
    this.panImage,
    this.panName,
    this.aadharCard,
    this.isVerified,
    this.dateOfBirth,
    this.state,
  });

  factory PanAadharDetails.fromJson(Map<String, dynamic> json) {
    return PanAadharDetails(
      id: json['id']?.toString(),
      userId: json['user_id'],
      panCard: json['pan_card'],
      panImage: json['pan_image'],
      panName: json['pan_name'],
      aadharCard: json['aadhar_card'],
      isVerified: json['is_verified'],
      dateOfBirth: json['date_of_birth'] != null ? DateTime.parse(json['date_of_birth']) : null,
      state: json['state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'pan_card': panCard,
      'pan_image': panImage,
      'pan_name': panName,
      'aadhar_card': aadharCard,
      'is_verified': isVerified,
      'date_of_birth': dateOfBirth?.toIso8601String(),
      'state': state,
    };
  }
}