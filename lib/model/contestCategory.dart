class ContestCategory {
  String? id;
  String contestName;
  String? description;
  String? image;
  int status;

  ContestCategory({
    this.id,
    required this.contestName,
    this.description,
    this.image,
    required this.status,
  });

  factory ContestCategory.fromJson(Map<String, dynamic> json) {
    return ContestCategory(
      id: json['id']?.toString(),
      contestName: json['contest_name'],
      description: json['description'],
      image: json['image'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contest_name': contestName,
      'description': description,
      'image': image,
      'status': status,
    };
  }
}