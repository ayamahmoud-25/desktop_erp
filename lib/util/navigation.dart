import 'package:flutter/material.dart';


class Navigation{

  void pushNavigation(BuildContext context,Widget widget){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }

}