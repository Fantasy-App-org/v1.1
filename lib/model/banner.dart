class Banner {
  String? id;
  int sequence;
  double bannerType;
  String image;
  int? offerId;
  int? seriesId;
  int? fixtureId;
  int status;

  Banner({
    this.id,
    required this.sequence,
    required this.bannerType,
    required this.image,
    this.offerId,
    this.seriesId,
    this.fixtureId,
    required this.status,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id']?.toString(),
      sequence: json['sequence'],
      bannerType: json['banner_type'],
      image: json['image'],
      offerId: json['offer_id'],
      seriesId: json['series_id'],
      fixtureId: json['fixture_id'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sequence': sequence,
      'banner_type': bannerType,
      'image': image,
      'offer_id': offerId,
      'series_id': seriesId,
      'fixture_id': fixtureId,
      'status': status,
    };
  }
}