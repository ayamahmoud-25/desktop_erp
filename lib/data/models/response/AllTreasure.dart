import 'Entity.dart';

class AllTreasure extends Entity {
  AllTreasure({
    required String code,
    required String description,
    dynamic allBranch,
  }) : super(
    code: code,
    description: description,
    allBranch: allBranch,
  );

  factory AllTreasure.fromJson(Map<String, dynamic> json) {
    return AllTreasure(
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