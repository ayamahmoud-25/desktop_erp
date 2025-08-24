class StoreTrnsOModel {
  String? branch;
  String? descr;
  String? trnsCode;
  int? trnsNo;
  String? itemForm;
  String? formDesc;
  String? itemCode;
  String? itemDesc;
  double? qty1;
  double? qty2;
  double? qty3;
  int? basicQty;
  String? unitDesc;
  double? unitPrice;
  double? depQty1;
  double? depQty2;
  double? depQty3;
  double? discount;
  double? discountVal;

  double total=0.00;

  StoreTrnsOModel({
    this.branch,
    this.descr,
    this.trnsCode,
    this.trnsNo,
    this.itemForm,
    this.formDesc,
    this.itemCode,
    this.itemDesc,
    this.qty1,
    this.qty2,
    this.qty3,
    this.basicQty,
    this.unitDesc,
    this.unitPrice,
    this.depQty1,
    this.depQty2,
    this.depQty3,
    this.discount,
    this.discountVal,
  });

  factory StoreTrnsOModel.fromJson(Map<String, dynamic> json) {
    return StoreTrnsOModel(
      branch: json['BRANCH'] as String?,
      descr: json['DESCR'] as String?,
      trnsCode: json['TRNS_CODE'] as String?,
      trnsNo: json['TRNS_NO'] as int?,
      itemForm: json['ITEM_FORM'] as String?,
      formDesc: json['FORMDESC'] as String?,
      itemCode: json['ITEM_CODE'] as String?,
      itemDesc: json['ITEM_DESC'] as String?,
      qty1: (json['QTY1'] as num?)?.toDouble(),
      qty2: (json['QTY2'] as num?)?.toDouble(),
      qty3: (json['QTY3'] as num?)?.toDouble(),
      basicQty: json['BASIC_QTY'] as int?,
      unitDesc: json['UNIT_DESC'] as String?,
      unitPrice: (json['UNIT_PRICE'] as num?)?.toDouble(),
      depQty1: (json['DEP_QTY1'] as num?)?.toDouble(),
      depQty2: (json['DEP_QTY2'] as num?)?.toDouble(),
      depQty3: (json['DEP_QTY3'] as num?)?.toDouble(),
      discount: (json['DISCOUNT'] as num?)?.toDouble(),
      discountVal: (json['DISCOUNT_VAL'] as num?)?.toDouble(),
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
      'ITEM_CODE': itemCode,
      'ITEM_DESC': itemDesc,
      'QTY1': qty1,
      'QTY2': qty2,
      'QTY3': qty3,
      'BASIC_QTY': basicQty,
      'UNIT_DESC': unitDesc,
      'UNIT_PRICE': unitPrice,
      'DEP_QTY1': depQty1,
      'DEP_QTY2': depQty2,
      'DEP_QTY3': depQty3,
      'DISCOUNT': discount,
      'DISCOUNT_VAL': discountVal,
    };
  }

}