
class ApproveTransactionModelResponse {
  String? transCode;
  int? transNo;
  String? branch;
  String? userId;
  int? approveNo;
  int? approveDate;
  String? approveStatus;
  String? transFlag;

  ApproveTransactionModelResponse({
    this.transCode,
    this.transNo,
    this.branch,
    this.userId,
    this.approveNo,
    this.approveDate,
    this.approveStatus,
    this.transFlag,
  });

  Map<String, dynamic> toJson() {
    return {
      'TRNS_CODE': transCode,
      'TRNS_NO': transNo,
      'BRANCH': branch,
      'USERID': userId,
      'APPROVE_NO': approveNo,
      'APPROVE_DATE': approveDate,
      'APPROVE_STATUS': approveStatus,
      'TRNS_FLAG': transFlag,
    };
  }
  factory ApproveTransactionModelResponse.fromJson(Map<String, dynamic> json) {
    return ApproveTransactionModelResponse(
      transCode: json['TRNS_CODE'],
      transNo: json['TRNS_NO'],
      branch: json['BRANCH'],
      userId: json['USERID'],
      approveNo: json['APPROVE_NO'],
      approveDate: json['APPROVE_DATE'],
      approveStatus: json['APPROVE_STATUS'],
      transFlag: json['TRNS_FLAG'],

    );
  }
}