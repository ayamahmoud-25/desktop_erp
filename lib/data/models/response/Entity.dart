class Entity {
  final String code;
  final String description;
  final dynamic allBranch;

  Entity({
    required this.code,
    required this.description,
    this.allBranch,
  });

  factory Entity.fromJson(Map<String, dynamic> json) {
    return Entity(
      code: json['CODE'] ?? '',
      description: json['DESCR'] ?? '',
      allBranch: json['ALL_BRANCH'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CODE': code,
      'DESCR': description,
      'ALL_BRANCH': allBranch,
    };
  }
}