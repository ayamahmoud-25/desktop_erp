class FinanceBalanceReportResponse {
   String? code;
   String? name;
   double? beginDebit;
   double? beginCredit;
   double? trnsDebit;
   double? trnsCredit;
   double? endDebit;
   double? endCredit;

  FinanceBalanceReportResponse({
     this.code,
     this.name,
     this.beginDebit,
     this.beginCredit,
     this.trnsDebit,
     this.trnsCredit,
     this.endDebit,
     this.endCredit,
  });

  factory FinanceBalanceReportResponse.fromJson(Map<String, dynamic> json) {
    return FinanceBalanceReportResponse(
      code: json['AGENT_CODE'],
      name: json['AGENT_NAME'],
      beginDebit: (json['BEGIN_DEBIT'] as num).toDouble(),
      beginCredit: (json['BEGIN_CREDIT'] as num).toDouble(),
      trnsDebit: (json['TRNS_DEBIT'] as num).toDouble(),
      trnsCredit: (json['TRNS_CREDIT'] as num).toDouble(),

      endDebit: (json['END_DEBIT'] as num).toDouble(),
      endCredit: (json['END_CREDIT'] as num).toDouble(),
    );
  }
}
