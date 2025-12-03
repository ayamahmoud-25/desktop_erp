class StoreTransListDependency {
  String? branch;
  String? descr;
  String? trnsCode;
  int? trnsNo;
  String? docNo;
  DateTime? trnsDate;
  DateTime? trnsStamp;
  int? fromDst;
  String? fromDstName;
  String? fromCode;
  String? fromName;
  int? toDst;
  String? toDstName;
  String? toCode;
  String? toName;
  double? trnsVal;
  double? trnsNet;
  double? paidVal;
  double? remainingVal;
  String? approved;
  TrnsApproveModel? trnsApproveModel;
  bool? isSelected = false;

  StoreTransListDependency({
    this.branch,
    this.descr,
    this.trnsCode,
    this.trnsNo,
    this.docNo,
    this.trnsDate,
    this.trnsStamp,
    this.fromDst,
    this.fromDstName,
    this.fromCode,
    this.fromName,
    this.toDst,
    this.toDstName,
    this.toCode,
    this.toName,
    this.trnsVal,
    this.trnsNet,
    this.paidVal,
    this.remainingVal,
    this.approved,
    this.trnsApproveModel,
    this.isSelected
  });

  factory StoreTransListDependency.fromJson(Map<String, dynamic> json) {
    return StoreTransListDependency(
      branch: json['BRANCH'] as String?,
      descr: json['DESCR'] as String?,
      trnsCode: json['TRNS_CODE'] as String?,
      trnsNo: json['TRNS_NO'] as int?,
      docNo: json['DOC_NO'] as String?,
      trnsDate: json['TRNS_DATE'] != null ? DateTime.parse(json['TRNS_DATE']) : null,
      trnsStamp: json['TRNS_STAMP'] != null ? DateTime.parse(json['TRNS_STAMP']) : null,
      fromDst: json['FROM_DST'] as int?,
      fromDstName: json['FROM_DST_NAME'] as String?,
      fromCode: json['FROM_CODE'] as String?,
      fromName: json['FROM_NAME'] as String?,
      toDst: json['TO_DST'] as int?,
      toDstName: json['TO_DST_NAME'] as String?,
      toCode: json['TO_CODE'] as String?,
      toName: json['TO_NAME'] as String?,
      trnsVal: (json['TRNS_VAL'] != null) ? (json['TRNS_VAL'] as num).toDouble() : null,
      trnsNet: (json['TRNS_NET'] != null) ? (json['TRNS_NET'] as num).toDouble() : null,
      paidVal: (json['PAID_VAL'] != null) ? (json['PAID_VAL'] as num).toDouble() : null,
      remainingVal: (json['REMAING_VAL'] != null) ? (json['REMAING_VAL'] as num).toDouble() : null,
      approved: json['APPROVED'] as String?,
      trnsApproveModel: json['TRNS_APPROVE_MODEL'] != null
          ? TrnsApproveModel.fromJson(json['TRNS_APPROVE_MODEL'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BRANCH': branch,
      'DESCR': descr,
      'TRNS_CODE': trnsCode,
      'TRNS_NO': trnsNo,
      'DOC_NO': docNo,
      'TRNS_DATE': trnsDate?.toIso8601String(),
      'TRNS_STAMP': trnsStamp?.toIso8601String(),
      'FROM_DST': fromDst,
      'FROM_DST_NAME': fromDstName,
      'FROM_CODE': fromCode,
      'FROM_NAME': fromName,
      'TO_DST': toDst,
      'TO_DST_NAME': toDstName,
      'TO_CODE': toCode,
      'TO_NAME': toName,
      'TRNS_VAL': trnsVal,
      'TRNS_NET': trnsNet,
      'PAID_VAL': paidVal,
      'REMAING_VAL': remainingVal,
      'APPROVED': approved,
      'TRNS_APPROVE_MODEL': trnsApproveModel?.toJson(),
    };
  }
}

class TrnsApproveModel {
  bool? acceptedInLevel;
  int? level;
  bool? userCanApprove;
  String? trnsCode;
  int? trnsNo;

  TrnsApproveModel({
    this.acceptedInLevel,
    this.level,
    this.userCanApprove,
    this.trnsCode,
    this.trnsNo,
  });

  factory TrnsApproveModel.fromJson(Map<String, dynamic> json) {
    return TrnsApproveModel(
      acceptedInLevel: json['Acceptedinlevel'] as bool?,
      level: json['Level'] as int?,
      userCanApprove: json['userCanapprove'] as bool?,
      trnsCode: json['TRNS_CODE'] as String?,
      trnsNo: json['TRNS_NO'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Acceptedinlevel': acceptedInLevel,
      'Level': level,
      'userCanapprove': userCanApprove,
      'TRNS_CODE': trnsCode,
      'TRNS_NO': trnsNo,
    };
  }
}
