class AgentData {
  final String code;
  final String name;
  final double beginDebit;
  final double beginCredit;
  final double trnsDebit;
  final double trnsCredit;
  final double endDebit;
  final double endCredit;

  AgentData({
    required this.code,
    required this.name,
    required this.beginDebit,
    required this.beginCredit,
    required this.trnsDebit,
    required this.trnsCredit,
    required this.endDebit,
    required this.endCredit,
  });

  factory AgentData.fromJson(Map<String, dynamic> json) {
    return AgentData(
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
