class Branches{
  String? code;
  String? descr;
  var allBranch;


  Branches({this.code, this.descr});


  Map<String, dynamic> toJson() {
    return {
      'CODE': code,
      'DESCR': descr,
      'ALL_BRANCH': allBranch,
    };
  }

  factory Branches.fromJson(Map<String,dynamic> json){
    Branches c = Branches();
    c.code = json['CODE'];
    c.descr = json['DESCR'];
    c.allBranch = json['ALL_BRANCH'];

    return c;
  }
}