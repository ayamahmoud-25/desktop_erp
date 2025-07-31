import 'package:desktop_erp_4s/data/models/response/store_trans_list_dependency.dart';

import 'Pagination.dart';

class   StoreTransDepListResponseModel {
  Pagination? pagination;
  List<StoreTransListDependency>? storeTransDepList;

  StoreTransDepListResponseModel({
    this.pagination,
    this.storeTransDepList,
  });

  factory StoreTransDepListResponseModel.fromJson(Map<String, dynamic> json) {
    return StoreTransDepListResponseModel(
      pagination: Pagination.fromJson(json['pagination']),
      storeTransDepList: (json['Transaction'] as List)
          .map((item) => StoreTransListDependency.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination?.toJson(),
      'Transaction': storeTransDepList?.map((item) => item.toJson()).toList(),
    };
  }
}