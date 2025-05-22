import 'Entity.dart';

class AllCustomer extends Entity {
  AllCustomer({
    required String code,
    required String description,
    dynamic allBranch,
  }) : super(
    code: code,
    description: description,
    allBranch: allBranch,
  );

  factory AllCustomer.fromJson(Map<String, dynamic> json) {
    return AllCustomer(
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