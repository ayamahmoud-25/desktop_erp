class DependencyTransList {
  String? branch;
  String? trnsCode;
  int? trnsNo;
  String? dateTime;

  DependencyTransList({
    this.branch,
    this.trnsCode,
    this.trnsNo,
    this.dateTime,
  });

  factory DependencyTransList.fromJson(Map<String, dynamic> json) {
    return DependencyTransList(
      branch: json['BRANCH'] as String?,
      trnsCode: json['TRNS_CODE'] as String?,
      trnsNo: json['TRNS_NO'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BRANCH': branch,
      'TRNS_CODE': trnsCode,
      'TRNS_NO': trnsNo,
    };
  }
}
