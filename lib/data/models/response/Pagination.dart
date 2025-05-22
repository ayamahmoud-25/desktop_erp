class Pagination {
  final int totalCount;
  final int pageSize;
  final int currentPage;
  final int totalPages;
  final String previousPage;
  final String nextPage;

  Pagination({
    required this.totalCount,
    required this.pageSize,
    required this.currentPage,
    required this.totalPages,
    required this.previousPage,
    required this.nextPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      totalCount: json['totalCount'],
      pageSize: json['PageSize'],
      currentPage: json['currentPage'],
      totalPages: json['totalPages'],
      previousPage: json['previousPage'],
      nextPage: json['nextPage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalCount': totalCount,
      'PageSize': pageSize,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'previousPage': previousPage,
      'nextPage': nextPage,
    };
  }
}