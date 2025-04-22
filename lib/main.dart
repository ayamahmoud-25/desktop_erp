import 'package:desktop_erp_4s/ui/login/login_company.dart';
import 'package:desktop_erp_4s/ui/login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'learn/futuerbuilderproviderlogin/new_login_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: MyApp(), // Your root application widget
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(),
      home: CompanyLogin(),
    );
  }
}
