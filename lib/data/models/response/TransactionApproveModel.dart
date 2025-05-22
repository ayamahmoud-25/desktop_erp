class TransactionApproveModel {
  bool? acceptedInLevel;
  int? level;
  bool? userCanApprove;
  String? trnsCode;
  int? trnsNo;

  //construct
   TransactionApproveModel({
      this.acceptedInLevel,
      this.level,
      this.userCanApprove,
      this.trnsCode,
      this.trnsNo,
    });

  //convert to json
  Map<String, dynamic> toJson() {
    return {
      'Acceptedinlevel': acceptedInLevel,
      'Level': level,
      'userCanapprove': userCanApprove,
      'TRNS_CODE': trnsCode,
      'TRNS_NO': trnsNo,
    };
  }

  //convert from json
  factory TransactionApproveModel.fromJson(Map<String, dynamic> json) {
    return TransactionApproveModel(
      acceptedInLevel: json['Acceptedinlevel'],
      level: json['Level'],
      userCanApprove: json['userCanapprove'],
      trnsCode: json['TRNS_CODE'],
      trnsNo: json['TRNS_NO'],
    );
  }


}