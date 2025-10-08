class ReportDataModel {
  String? agentType;
  String? fromCode;
  String? fromDate;
  String? fromName;
  String? toCode;
  String? toDate;
  String? toName;

  ReportDataModel({
    this.agentType,
    this.fromCode,
    this.fromDate,
    this.fromName,
    this.toCode,
    this.toDate,
    this.toName,
  });

  // Named constructor: create from JSON
  factory ReportDataModel.fromJson(Map<String, dynamic> json) {
    return ReportDataModel(
      agentType: json['agent_type'] as String?,
      fromCode: json['from_code'] as String?,
      fromDate: json['from_date'] as String?,
      fromName: json['fromName'] as String?,
      toCode: json['to_code'] as String?,
      toDate: json['to_date'] as String?,
      toName: json['toName'] as String?,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'agent_type': agentType,
      'from_code': fromCode,
      'from_date': fromDate,
      'fromName': fromName,
      'to_code': toCode,
      'to_date': toDate,
      'toName': toName,
    };
  }
}