

import 'package:flutter/cupertino.dart';

class Responsive extends StatelessWidget{

  final Widget mobile;
  final Widget desktop;


  const Responsive({super.key, required this.mobile, required this.desktop});


  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 767;
  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >=1025 ;




  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
     if(screenSize.width>=1025){
       return desktop;
     }
     else{
       return mobile;
     }


  }


}