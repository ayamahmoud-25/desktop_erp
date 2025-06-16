class TransactionCreatingModel {
  String? branch;


  String? trnsCode;

  String? itemForm;



  double? trnsVal;
  double? trnsNet;
  double? salesTaxRate;
  double? salesTaxVal;
  double? commTaxRate;
  double? commTaxVal;
  int? payMethod;
  String? approved;
  String? approvedDate;
  String? approvedRem;
  String? username;
  String? depOnCode;
  String? rem;
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

  String? branchName;
  String? fromName;
  String? toName;
  String? itemFormName;



  TransactionCreatingModel({
    this.branch,
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
    this.trnsNo,
    this.trnsDate,
    this.trnsStamp,
    this.fromDst,
    this.fromCode,
    this.toDst,
    this.toCode,
    this.trnsType,
    this.storeTrnsOModels,
    this.storeTrnsDepModels,
  });

  factory TransactionCreatingModel.fromJson(Map<String, dynamic> json) {
    return TransactionCreatingModel(
      branch: json['BRANCH'],
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
      trnsNo: json['TRNS_NO'],
      trnsDate: json['TRNS_DATE'],
      trnsStamp: json['TRNS_STAMP'],
      fromDst: json['FROM_DST'],
      fromCode: json['FROM_CODE'],
      toDst: json['TO_DST'],
      toCode: json['TO_CODE'],
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
      'TO_DST': toDst,
      'TO_CODE': toCode,
      'TRNS_TYPE': trnsType,
      'store_trns_o_models': storeTrnsOModels?.map((e) => e.toJson()).toList(),
      'store_trns_dep_models': storeTrnsDepModels?.map((e) => e.toJson()).toList(),
    };
  }
}

class StoreTrnsOModel {
  String? branch;
  String? trnsCode;
  int? trnsNo;
  String? itemForm;
  String? itemCode;
  double? qty1;
  double? qty2;
  double? qty3;
  int? basicQty;
  double? unitPrice;
  double? depQty1;
  double? depQty2;
  double? depQty3;

  StoreTrnsOModel({
    this.branch,
    this.trnsCode,
    this.trnsNo,
    this.itemForm,
    this.itemCode,
    this.qty1,
    this.qty2,
    this.qty3,
    this.basicQty,
    this.unitPrice,
    this.depQty1,
    this.depQty2,
    this.depQty3,
  });

  factory StoreTrnsOModel.fromJson(Map<String, dynamic> json) {
    return StoreTrnsOModel(
      branch: json['BRANCH'],
      trnsCode: json['TRNS_CODE'],
      trnsNo: json['TRNS_NO'],
      itemForm: json['ITEM_FORM'],
      itemCode: json['ITEM_CODE'],
      qty1: json['QTY1'],
      qty2: json['QTY2'],
      qty3: json['QTY3'],
      basicQty: json['BASIC_QTY'],
      unitPrice: json['UNIT_PRICE'],
      depQty1: json['DEP_QTY1'],
      depQty2: json['DEP_QTY2'],
      depQty3: json['DEP_QTY3'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'BRANCH': branch,
      'TRNS_CODE': trnsCode,
      'TRNS_NO': trnsNo,
      'ITEM_FORM': itemForm,
      'ITEM_CODE': itemCode,
      'QTY1': qty1,
      'QTY2': qty2,
      'QTY3': qty3,
      'BASIC_QTY': basicQty,
      'UNIT_PRICE': unitPrice,
      'DEP_QTY1': depQty1,
      'DEP_QTY2': depQty2,
      'DEP_QTY3': depQty3,
    };
  }
}

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