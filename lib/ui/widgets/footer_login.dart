
import 'package:flutter/material.dart';

import '../../util/Strings.dart';

class FooterLogin extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 80.0,bottom: 80.0),
        child: Text(Strings.Version_Name,
          style:
          TextStyle(color: Colors.white,fontSize: 20,))
      ),
    );
  }


}