import 'StoreTrnsDepModel.dart';
import 'StoreTrnsOModel.dart';

class TransactionDetailsResponseModel {
  String? branch;
  String? descr;
  String? trnsCode;
  int? trnsNo;
  String? itemForm;
  String? formDesc;
  double? trnsVal;
  double? trnsNet;
  double? salesTaxRate;
  double? salesTaxVal;
  double? commTaxRate;
  double? commTaxVal;
  int? payMethod;
  bool? approved;
  DateTime? approvedDate;
  String? approvedRem;
  String? username;
  String? depOnCode;
  String? rem;
  DateTime? trnsDate;
  DateTime? trnsStamp;
  int? fromDst;
  String? fromCode;
  String? fromName;
  int? toDst;
  String? toCode;
  String? toName;
  int? trnsType;
  String? salesRepCode;
  String? repName;
  double? trnsDeducItem;
  double? trnsDeduc;
  double? trnsDeducRate;
  List<StoreTrnsOModel>? storeTrnsOModels=[];
  List<StoreTrnsDepModel>? storeTrnsDepModels;

  TransactionDetailsResponseModel({
    this.branch,
    this.descr,
    this.trnsCode,
    this.trnsNo,
    this.itemForm,
    this.formDesc,
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
    this.trnsDate,
    this.trnsStamp,
    this.fromDst,
    this.fromCode,
    this.fromName,
    this.toDst,
    this.toCode,
    this.toName,
    this.trnsType,
    this.salesRepCode,
    this.repName,
    this.trnsDeducItem,
    this.trnsDeduc,
    this.trnsDeducRate,
    this.storeTrnsOModels,
    this.storeTrnsDepModels,
  });

  factory TransactionDetailsResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionDetailsResponseModel(
      branch: json['BRANCH'] as String?,
      descr: json['DESCR'] as String?,
      trnsCode: json['TRNS_CODE'] as String?,
      trnsNo: json['TRNS_NO'] as int?,
      itemForm: json['ITEM_FORM'] as String?,
      formDesc: json['FORMDESC'] as String?,
      trnsVal: (json['TRNS_VAL'] as num?)?.toDouble(),
      trnsNet: (json['TRNS_NET'] as num?)?.toDouble(),
      salesTaxRate: (json['SALES_TAX_RATE'] as num?)?.toDouble(),
      salesTaxVal: (json['SALES_TAX_VAL'] as num?)?.toDouble(),
      commTaxRate: (json['COMM_TAX_RATE'] as num?)?.toDouble(),
      commTaxVal: (json['COMM_TAX_VAL'] as num?)?.toDouble(),
      payMethod: json['PAY_METHOD'] as int?,
      approved: json['APPROVED'] as bool?,
      approvedDate: json['APPROVED_DATE'] != null ? DateTime.parse(json['APPROVED_DATE']) : null,
      approvedRem: json['APPROVED_REM'] as String?,
      username: json['USERNAME'] as String?,
      depOnCode: json['DEP_ON_CODE'] as String?,
      rem: json['REM'] as String?,
      trnsDate: json['TRNS_DATE'] != null ? DateTime.parse(json['TRNS_DATE']) : null,
      trnsStamp: json['TRNS_STAMP'] != null ? DateTime.parse(json['TRNS_STAMP']) : null,
      fromDst: json['FROM_DST'] as int?,
      fromCode: json['FROM_CODE'] as String?,
      fromName: json['FROM_NAME'] as String?,
      toDst: json['TO_DST'] as int?,
      toCode: json['TO_CODE'] as String?,
      toName: json['TO_NAME'] as String?,
      trnsType: json['TRNS_TYPE'] as int?,
      salesRepCode: json['SALES_REP_CODE'] as String?,
      repName: json['REP_NAME'] as String?,
      trnsDeducItem: (json['TRNS_DEDUC_ITEM'] as num?)?.toDouble(),
      trnsDeduc: (json['TRNS_DEDUC'] as num?)?.toDouble(),
      trnsDeducRate: (json['TRNS_DEDUC_RATE'] as num?)?.toDouble(),
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
      'TRNS_NO': trnsNo,
      'ITEM_FORM': itemForm,
      'FORMDESC': formDesc,
      'TRNS_VAL': trnsVal,
      'TRNS_NET': trnsNet,
      'SALES_TAX_RATE': salesTaxRate,
      'SALES_TAX_VAL': salesTaxVal,
      'COMM_TAX_RATE': commTaxRate,
      'COMM_TAX_VAL': commTaxVal,
      'PAY_METHOD': payMethod,
      'APPROVED': approved,
      'APPROVED_DATE': approvedDate?.toIso8601String(),
      'APPROVED_REM': approvedRem,
      'USERNAME': username,
      'DEP_ON_CODE': depOnCode,
      'REM': rem,
      'TRNS_DATE': trnsDate?.toIso8601String(),
      'TRNS_STAMP': trnsStamp?.toIso8601String(),
      'FROM_DST': fromDst,
      'FROM_CODE': fromCode,
      'FROM_NAME': fromName,
      'TO_DST': toDst,
      'TO_CODE': toCode,
      'TO_NAME': toName,
      'TRNS_TYPE': trnsType,
      'SALES_REP_CODE': salesRepCode,
      'REP_NAME': repName,
      'TRNS_DEDUC_ITEM': trnsDeducItem,
      'TRNS_DEDUC': trnsDeduc,
      'TRNS_DEDUC_RATE': trnsDeducRate,
      'store_trns_o_models': storeTrnsOModels?.map((e) => e.toJson()).toList(),
      'store_trns_dep_models': storeTrnsDepModels?.map((e) => e.toJson()).toList(),
    };
  }
}

