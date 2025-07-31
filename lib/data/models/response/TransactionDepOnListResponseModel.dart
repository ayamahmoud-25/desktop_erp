import 'package:desktop_erp_4s/data/models/response/store_trans_list_dependency.dart';
import 'Pagination.dart';
import 'TransactionDepOnData.dart';

class TransactionDepListResponseModel {
  bool? status;
  String? msg;
  String? code;
  TransactionDepOnData? data;
 // Pagination? pagination;

  TransactionDepListResponseModel({
    this.status,
    this.msg,
    this.code,
    this.data,
  });

  factory TransactionDepListResponseModel.fromJson(Map<String, dynamic> json) {
    return TransactionDepListResponseModel(
      status: json['status'] as bool?,
      msg: json['msg'] as String?,
      code: json['code'] as String?,
      data: json['data'] != null ? TransactionDepOnData.fromJson(json['data']) : null,
     // pagination: json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'code': code,
      'data': data?.toJson(),
     // 'pagination': pagination?.toJson(),
    };
  }
}

