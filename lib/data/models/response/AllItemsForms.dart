import 'Entity.dart';

class AllItemsForms extends Entity {
  AllItemsForms({
    required String codeForm,
    required String formDesc,
  }) : super(
          code: codeForm,
          description: formDesc,
        );
  factory AllItemsForms.fromJson(Map<String, dynamic> json) {
    return AllItemsForms(
      codeForm: json['CODE_FORM'] ?? '',
      formDesc: json['FORMDESC'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return super.toJson();
  }

}