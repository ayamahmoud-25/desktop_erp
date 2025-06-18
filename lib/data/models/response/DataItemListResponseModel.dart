
import 'package:desktop_erp_4s/data/models/response/ItemList.dart';
import 'Pagination.dart';

class DataItemListResponseModel {
  Pagination? pagination;
  List<ItemList>? itemList;

  DataItemListResponseModel({
    this.pagination,
    this.itemList,
  });

  factory DataItemListResponseModel.fromJson(Map<String, dynamic> json) {
    return DataItemListResponseModel(
      pagination: Pagination.fromJson(json['pagination']),
      itemList: (json['items'] as List)
          .map((item) => ItemList.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination?.toJson(),
      'items': itemList?.map((item) => item.toJson()).toList(),
    };
  }
}