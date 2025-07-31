
class StoreTrnsDepModel {
  String? branch;
  String? trnsCode;
  int? trnsNo;
  String? depOnBranch;
  String? depOnTrnsCode;
  int? depOnTrnsNo;

  StoreTrnsDepModel({
    this.branch,
    this.trnsCode,
    this.trnsNo,
    this.depOnBranch,
    this.depOnTrnsCode,
    this.depOnTrnsNo,
  });

  factory StoreTrnsDepModel.fromJson(Map<String, dynamic> json) {
    return StoreTrnsDepModel(
      branch: json['BRANCH'],
      trnsCode: json['TRNS_CODE'],
      trnsNo: json['TRNS_NO'],
      depOnBranch: json['DEP_ON_BRANCH'],
      depOnTrnsCode: json['DEP_ON_TRNS_CODE'],
      depOnTrnsNo: json['DEP_ON_TRNS_NO'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BRANCH': branch,
      'TRNS_CODE': trnsCode,
      'TRNS_NO': trnsNo,
      'DEP_ON_BRANCH': depOnBranch,
      'DEP_ON_TRNS_CODE': depOnTrnsCode,
      'DEP_ON_TRNS_NO': depOnTrnsNo,
    };
  }



}
