class ReferredFriend {
  final String name;
  final String image;
  final int referredCount;

  ReferredFriend({
    required this.name,
    required this.image,
    required this.referredCount,
  });

  factory ReferredFriend.fromJson(Map<String, dynamic> json) {
    return ReferredFriend(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      referredCount: json['reffered_count'] ?? 0, // Note: API has typo "reffered"
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'reffered_count': referredCount,
    };
  }
}