class Group {
  String? id;
  int? parentGId;
  int? level;
  int? leftLeg;
  int? rightLeg;
  String? status;
  int? incomeLevel;

  Group({
    this.id,
    this.parentGId,
    this.level,
    this.leftLeg,
    this.rightLeg,
    this.status,
    this.incomeLevel,
  });

  factory Group.fromJson(Map<String, dynamic> json) {
    return Group(
      id: json['id']?.toString(),
      parentGId: json['parent_g_id'],
      level: json['level'],
      leftLeg: json['left_leg'],
      rightLeg: json['right_leg'],
      status: json['status'],
      incomeLevel: json['incomelevel'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'parent_g_id': parentGId,
      'level': level,
      'left_leg': leftLeg,
      'right_leg': rightLeg,
      'status': status,
      'incomelevel': incomeLevel,
    };
  }
}