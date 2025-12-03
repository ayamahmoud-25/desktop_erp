import 'Entity.dart';

class AllStores extends Entity {
  AllStores({
    required String code,
    required String description,
    dynamic allBranch,
  }) : super(
    code: code,
    description: description,
    allBranch: allBranch,
  );

  factory AllStores.fromJson(Map<String, dynamic> json) {
    return AllStores(
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