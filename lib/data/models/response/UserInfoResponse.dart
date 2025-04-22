import 'package:desktop_erp_4s/data/models/branch_model.dart';

class UserInfoResponse{
  String? accessToken; //access_token
  String? name;
  String? userId;
  String? codeLevel;
  List<Branches>? branchesList;

  UserInfoResponse({this.accessToken});


  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'name': name,
      'UserID': userId,
      'Code_Level': codeLevel,
      'Branches': branchesList,
    };
  }

  factory UserInfoResponse.fromJson(Map<String,dynamic> json){
    UserInfoResponse c = UserInfoResponse();
    c.accessToken = json['access_token'];
    c.name = json['name'];
    c.userId = json['UserID'];
    c.codeLevel = json['Code_Level'];
    if (json['Branches'] != null && json['Branches'] is List) {
      c.branchesList = (json['Branches'] as List)
          .map((branch) => Branches.fromJson(branch as Map<String, dynamic>))
          .toList();
    }
    return c;
  }
}