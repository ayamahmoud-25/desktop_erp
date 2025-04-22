import 'package:flutter/material.dart';

import '../../util/Strings.dart';
import 'footer_login.dart';
import 'header_login.dart';

class BackgroundImagePage extends StatelessWidget {
  final Widget child;
  const BackgroundImagePage({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage('images/ic_background.png'), // Replace with your background image path
    fit: BoxFit.cover,
    ),),
      child: ListView(
        children: [
          HeaderLogin(),
          child,
          FooterLogin()
        ]

      ));

  }

}