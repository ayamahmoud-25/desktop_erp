class TransactionApproveList {
   int? approve;
   String? branchId;
   int? level;
   String? transCode;
   String? transNo; // In your JSON, TRNS_NO is "0" (a string)

  TransactionApproveList({
     this.approve,
     this.branchId,
     this.level,
     this.transCode,
     this.transNo,
  });

  factory TransactionApproveList.fromJson(Map<String, dynamic> json) {
    return TransactionApproveList(
      approve: json['APPROVE'] as int?,
      branchId: json['BRANCH_ID'] as String?,
      level: json['LEVEL'] as int?,
      transCode: json['TRNS_CODE'] as String?,
      transNo: json['TRNS_NO'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'APPROVE': approve,
      'BRANCH_ID': branchId,
      'LEVEL': level,
      'TRNS_CODE': transCode,
      'TRNS_NO': transNo,
    };
  }
}