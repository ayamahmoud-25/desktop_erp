import 'TransactionApproveModel.dart';

class Transaction {
  String? branch;
  String? descr;
  String? trnsCode;
  int trnsNo;
  String? docNo;
  String? trnsDate;
  String trnsStamp;
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
  TransactionApproveModel? trnsApproveModel;

  Transaction({
    this.branch,
    this.descr,
    this.trnsCode,
    required this.trnsNo,
    this.docNo,
    this.trnsDate,
    required this.trnsStamp,
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
    this.approved
  });

  Map<String, dynamic> toJson() {
    return {
      'BRANCH': branch,
      'DESCR': descr,
      'TRNS_CODE': trnsCode,
      'TRNS_NO': trnsNo,
      'DOC_NO': docNo,
      'TRNS_DATE': trnsDate,
      'TRNS_STAMP': trnsStamp,
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
      'REMAINING_VAL': remainingVal,
      'APPROVED': approved,
    };
  }
    factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      branch: json['BRANCH'],
      descr: json['DESCR'],
      trnsCode: json['TRNS_CODE'],
      trnsNo: json['TRNS_NO'],
      docNo: json['DOC_NO'],
      trnsDate: json['TRNS_DATE'],
      trnsStamp: json['TRNS_STAMP'],
      fromDst: json['FROM_DST'],
      fromDstName: json['FROM_DST_NAME'],
      fromCode: json['FROM_CODE'],
      fromName: json['FROM_NAME'],
      toDst: json['TO_DST'],
      toDstName: json['TO_DST_NAME'],
      toCode: json['TO_CODE'],
      toName: json['TO_NAME'],
      trnsVal: (json['TRNS_VAL'] ?? 0).toDouble(),
      trnsNet: (json['TRNS_NET'] ?? 0).toDouble(),
      paidVal: (json['PAID_VAL'] ?? 0).toDouble(),
      remainingVal: (json['REMAINING_VAL'] ?? 0).toDouble(),
      approved: json['APPROVED'],
    );
    }
}