import 'Entity.dart';

class AllWorkAreas extends Entity {
  AllWorkAreas({
    required String code,
    required String description,
    dynamic allBranch,
  }) : super(
    code: code,
    description: description,
    allBranch: allBranch,
  );

  factory AllWorkAreas.fromJson(Map<String, dynamic> json) {
    return AllWorkAreas(
      code: json['CODE'] ?? '',
      description: json['DESCR'] ?? '',
      allBranch: json['ALL_BRANCH'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }
}