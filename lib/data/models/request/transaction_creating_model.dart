import '../response/StoreTrnsDepModel.dart';
import '../response/StoreTrnsOModel.dart';

class TransactionCreatingModel {
  String? branch;
  String? descr;
  String? trnsCode;
  String? itemForm;

  int? payMethod;
  double? trnsVal=0.0;
  double? trnsNet=0.0;
  double? salesTaxRate=0.0;
  double? salesTaxVal=0.0;
  double? commTaxRate=0.0;
  double? commTaxVal=0.0;
  String? rem;

  String? approved;
  String? approvedDate;
  String? approvedRem;
  String? username;
  String? depOnCode;
  String? salesRepCode;
  String? repName;
  int? trnsNo;
  String? trnsDate;
  String? trnsStamp;
  int? fromDst;
  String? fromCode;
  int? toDst;
  String? toCode;
  int? trnsType;
  List<StoreTrnsOModel>? storeTrnsOModels;
  List<StoreTrnsDepModel>? storeTrnsDepModels;

  //for view
  String? branchName;
  String? fromName;
  String? toName;
  String? itemFormName;
  String? payMethodName;



  TransactionCreatingModel({
    this.branch,
    this.descr,
    this.branchName,
    this.trnsCode,
    this.itemForm,
    this.trnsVal,
    this.trnsNet,
    this.salesTaxRate,
    this.salesTaxVal,
    this.commTaxRate,
    this.commTaxVal,
    this.payMethod,
    this.approved,
    this.approvedDate,
    this.approvedRem,
    this.username,
    this.depOnCode,
    this.rem,
    this.salesRepCode,
    this.repName,
    this.trnsNo,
    this.trnsDate,
    this.trnsStamp,
    this.fromDst,
    this.fromCode,
    this.fromName,
    this.toDst,
    this.toCode,
    this.toName,
    this.trnsType,
    this.storeTrnsOModels,
    this.storeTrnsDepModels,
  });

  factory TransactionCreatingModel.fromJson(Map<String, dynamic> json) {
    return TransactionCreatingModel(
      branch: json['BRANCH'],
      descr: json['DESCR'],
      trnsCode: json['TRNS_CODE'],
      itemForm: json['ITEM_FORM'],
      trnsVal: json['TRNS_VAL'],
      trnsNet: json['TRNS_NET'],
      salesTaxRate: json['SALES_TAX_RATE'],
      salesTaxVal: json['SALES_TAX_VAL'],
      commTaxRate: json['COMM_TAX_RATE'],
      commTaxVal: json['COMM_TAX_VAL'],
      payMethod: json['PAY_METHOD'],
      approved: json['APPROVED'],
      approvedDate: json['APPROVED_DATE'],
      approvedRem: json['APPROVED_REM'],
      username: json['USERNAME'],
      depOnCode: json['DEP_ON_CODE'],
      rem: json['REM'],
      salesRepCode: json['SALES_REP_CODE'],
      repName: json['REP_NAME'],
      trnsNo: json['TRNS_NO'],
      trnsDate: json['TRNS_DATE'],
      trnsStamp: json['TRNS_STAMP'],
      fromDst: json['FROM_DST'],
      fromCode: json['FROM_CODE'],
      fromName: json['FROM_NAME'],
      toDst: json['TO_DST'],
      toCode: json['TO_CODE'],
      toName: json['TO_NAME'],
      trnsType: json['TRNS_TYPE'],
      storeTrnsOModels: (json['store_trns_o_models'] as List<dynamic>?)
          ?.map((e) => StoreTrnsOModel.fromJson(e))
          .toList(),
      storeTrnsDepModels: (json['store_trns_dep_models'] as List<dynamic>?)
          ?.map((e) => StoreTrnsDepModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BRANCH': branch,
      'DESCR': descr,
      'TRNS_CODE': trnsCode,
      'ITEM_FORM': itemForm,
      'TRNS_VAL': trnsVal,
      'TRNS_NET': trnsNet,
      'SALES_TAX_RATE': salesTaxRate,
      'SALES_TAX_VAL': salesTaxVal,
      'COMM_TAX_RATE': commTaxRate,
      'COMM_TAX_VAL': commTaxVal,
      'PAY_METHOD': payMethod,
      'APPROVED': approved,
      'APPROVED_DATE': approvedDate,
      'APPROVED_REM': approvedRem,
      'USERNAME': username,
      'DEP_ON_CODE': depOnCode,
      'REM': rem,
      'TRNS_NO': trnsNo,
      'TRNS_DATE': trnsDate,
      'TRNS_STAMP': trnsStamp,
      'FROM_DST': fromDst,
      'FROM_CODE': fromCode,
      'FROM_NAME': fromName,
      'TO_DST': toDst,
      'TO_CODE': toCode,
      'TO_NAME': toName,
      'TRNS_TYPE': trnsType,
      'store_trns_o_models': storeTrnsOModels?.map((e) => e.toJson()).toList(),
      'store_trns_dep_models': storeTrnsDepModels?.map((e) => e.toJson()).toList(),
    };
  }
}



