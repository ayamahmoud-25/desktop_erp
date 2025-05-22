class TransactionSpec {
   String? trnsCode;
   int? trnsType;
   String? trnsDesc;
   int? fromDst;
   int? toDst;
   String? fromCode;
   String? toCode;
   int? quantityEffect;
   int? payEffect;
   int? notes;
   int? immediatePay;
   String? itemForm;
   int? showPrice;
   int? itemPrice;
   int? salesTax;
   double? taxRate;
   int? commTax;
   double? commRate;
   String? needApprove;
   String? approveName;
   int? hasChats;
   int? salesRep;
   String? depOnTrnsCodeVal;
   int? noCalcDep;
   int? onlyOneDep;
   int? getDepQty;
   int? depSign;
   String? filterApproved;
   int? getFrom;
   int? getTo;
   int? reversePoles;
   int? trnsItemsDiscount;
   int? trnsDiscount;
   double? trnsDeducRate;
   int? showDeducRate;
   int? depMust;
   int? allowMobileEdit;

  TransactionSpec({
     this.trnsCode,
     this.trnsType,
     this.trnsDesc,
     this.fromDst,
     this.toDst,
     this.fromCode,
     this.toCode,
     this.quantityEffect,
     this.payEffect,
     this.notes,
     this.immediatePay,
     this.itemForm,
     this.showPrice,
     this.itemPrice,
     this.salesTax,
     this.taxRate,
     this.commTax,
     this.commRate,
     this.needApprove,
     this.approveName,
     this.hasChats,
     this.salesRep,
     this.depOnTrnsCodeVal,
     this.noCalcDep,
     this.onlyOneDep,
     this.getDepQty,
     this.depSign,
     this.filterApproved,
     this.getFrom,
     this.getTo,
     this.reversePoles,
     this.trnsItemsDiscount,
     this.trnsDiscount,
     this.trnsDeducRate,
     this.showDeducRate,
     this.depMust,
     this.allowMobileEdit,
  });

  factory TransactionSpec.fromJson(Map<String, dynamic> json) {
    TransactionSpec spec = TransactionSpec();
    spec.trnsCode =  json['TRNS_CODE'];
    spec.trnsType = json['TRNS_TYPE'];
    spec.trnsDesc = json['TRNS_DESC'];
    spec.fromDst = json['FROM_DST'];
    spec.toDst = json['TO_DST'];
    spec.fromCode = json['FROM_CODE'];
    spec.toCode = json['TO_CODE'];
    spec.quantityEffect = json['QUANTITY_EFFECT'];
    spec.payEffect = json['PAY_EFFECT'];
    spec.notes = json['NOTES'];
    spec.immediatePay = json['IMMEDIATE_PAY'];
    spec.itemForm = json['ITEM_FORM'];
    spec.showPrice = json['SHOW_PRICE'];
    spec.itemPrice = json['ITEM_PRICE'];
    spec.salesTax = json['SALES_TAX'];
    spec.taxRate = json['TAX_RATE'] != null ? double.parse(json['TAX_RATE'].toString()) : null;
    spec.commTax = json['COMM_TAX'];
    spec.commRate = json['COMM_RATE'] != null ? double.parse(json['COMM_RATE'].toString()) : null;
    spec.needApprove = json['NEEDAPPROVE'];
    spec.approveName = json['APPROVE_NAME'];
    spec.hasChats = json['HAS_CHATS'];
    spec.salesRep = json['SALES_REP'];
    spec.depOnTrnsCodeVal = json['DEP_ON_TRNS_CODE_VAL'];
    spec.noCalcDep = json['NO_CALC_DEP'];
    spec.onlyOneDep = json['ONLYONEDEP'];
    spec.getDepQty = json['GET_DEP_QTY'];
    spec.depSign = json['DEPSIGN'];
    spec.filterApproved = json['FILTER_APPROVED'];
    spec.getFrom = json['GET_FROM'];
    spec.getTo = json['GET_TO'];
    spec.reversePoles = json['REVERSE_POLES'];
    spec.trnsItemsDiscount = json['TRNS_ITEMS_DISCOUNT'];
    spec.trnsDiscount = json['TRNS_DISCOUNT'];
    spec.trnsDeducRate = json['TRNSDEDUCRATE'] != null ? double.parse(json['TRNSDEDUCRATE'].toString()) : null;
    spec.showDeducRate = json['SHOW_DEDUC_RATE'];
    spec.depMust = json['DEP_MUST'];
    spec.allowMobileEdit = json['ALLOW_MOBILE_EDIT'];
    return spec;
  }

  Map<String, dynamic> toJson() {
    return {
      'TRNS_CODE': trnsCode,
      'TRNS_TYPE': trnsType,
      'TRNS_DESC': trnsDesc,
      'FROM_DST': fromDst,
      'TO_DST': toDst,
      'FROM_CODE': fromCode,
      'TO_CODE': toCode,
      'QUANTITY_EFFECT': quantityEffect,
      'PAY_EFFECT': payEffect,
      'NOTES': notes,
      'IMMEDIATE_PAY': immediatePay,
      'ITEM_FORM': itemForm,
      'SHOW_PRICE': showPrice,
      'ITEM_PRICE': itemPrice,
      'SALES_TAX': salesTax,
      'TAX_RATE': taxRate,
      'COMM_TAX': commTax,
      'COMM_RATE': commRate,
      'NEEDAPPROVE': needApprove,
      'APPROVE_NAME': approveName,
      'HAS_CHATS': hasChats,
      'SALES_REP': salesRep,
      'DEP_ON_TRNS_CODE_VAL': depOnTrnsCodeVal,
      'NO_CALC_DEP': noCalcDep,
      'ONLYONEDEP': onlyOneDep,
      'GET_DEP_QTY': getDepQty,
      'DEPSIGN': depSign,
      'FILTER_APPROVED': filterApproved,
      'GET_FROM': getFrom,
      'GET_TO': getTo,
      'REVERSE_POLES': reversePoles,
      'TRNS_ITEMS_DISCOUNT': trnsItemsDiscount,
      'TRNS_DISCOUNT': trnsDiscount,
      'TRNSDEDUCRATE': trnsDeducRate,
      'SHOW_DEDUC_RATE': showDeducRate,
      'DEP_MUST': depMust,
      'ALLOW_MOBILE_EDIT': allowMobileEdit,
    };
  }
}