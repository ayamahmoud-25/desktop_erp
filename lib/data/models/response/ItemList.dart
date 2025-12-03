class ItemList {
  String? itemCode;
  String? itemDesc;
  double? cPurchPrice;
  double? cDealPrice;
  double? cSalePrice;
  double? cBranPrice;
  double? avPurchPrice;

  ItemList({
    this.itemCode,
    this.itemDesc,
    this.cPurchPrice,
    this.cDealPrice,
    this.cSalePrice,
    this.cBranPrice,
    this.avPurchPrice,
  });

  factory ItemList.fromJson(Map<String, dynamic> json) {
    return ItemList(
      itemCode: json['ITEM_CODE'],
      itemDesc: json['ITEM_DESC'],
      cPurchPrice: json['C_PURCH_PRICE'],
      cDealPrice: json['C_DEAL_PRICE'],
      cSalePrice: json['C_SALE_PRICE'],
      cBranPrice: json['C_BRAN_PRICE'],
      avPurchPrice: json['AV_PURCH_PRICE'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ITEM_CODE': itemCode,
      'ITEM_DESC': itemDesc,
      'C_PURCH_PRICE': cPurchPrice,
      'C_DEAL_PRICE': cDealPrice,
      'C_SALE_PRICE': cSalePrice,
      'C_BRAN_PRICE': cBranPrice,
      'AV_PURCH_PRICE': avPurchPrice,
    };
  }
}