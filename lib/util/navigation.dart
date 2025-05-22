import 'package:flutter/material.dart';

import '../ui/login/login_company.dart';


class Navigation{

  void pushNavigation(BuildContext context,Widget widget){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
  void logout(BuildContext context){
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => CompanyLogin()),
          (Route<dynamic> route) => false,
    );
  }

}