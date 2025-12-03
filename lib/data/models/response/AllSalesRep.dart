import 'Entity.dart';

class AllSalesRep extends Entity {
  AllSalesRep({
    required String code,
    required String description,
    dynamic allBranch,
  }) : super(
    code: code,
    description: description,
    allBranch: allBranch,
  );

  factory AllSalesRep.fromJson(Map<String, dynamic> json) {
    return AllSalesRep(
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