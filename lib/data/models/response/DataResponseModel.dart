
import 'Pagination.dart';
import 'TransactionSpec.dart';

class DataResponseModel {
   Pagination? pagination;
   List<TransactionSpec>? transactionSpecs;

  DataResponseModel({
     this.pagination,
     this.transactionSpecs,
  });

  factory DataResponseModel.fromJson(Map<String, dynamic> json) {
    return DataResponseModel(
      pagination: Pagination.fromJson(json['pagination']),
      transactionSpecs: (json['transaction_specs'] as List)
          .map((item) => TransactionSpec.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pagination': pagination?.toJson(),
      'transaction_specs': transactionSpecs?.map((item) => item.toJson()).toList(),
    };
  }
}