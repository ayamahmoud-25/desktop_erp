import 'Pagination.dart';

class BasicDataListResponse<T> {
   Pagination? pagination;
   List<T>? items;

  BasicDataListResponse({
     this.pagination,
     this.items,
  });

  factory BasicDataListResponse.fromJson(
      Map<String, dynamic> json,
      String key,
      T Function(Map<String, dynamic>) fromJsonT,
      ) {
    return BasicDataListResponse(
      pagination: Pagination.fromJson(json['pagination']),
      items: (json[key] as List<dynamic>)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson(String key, Map<String, dynamic> Function(T) toJsonT) {
    return {
      'pagination': pagination?.toJson(),
      key: items?.map((item) => toJsonT(item)).toList(),
    };
  }
}