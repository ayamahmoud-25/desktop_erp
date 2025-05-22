import 'package:desktop_erp_4s/ui/home/home_provider.dart';
import 'package:desktop_erp_4s/ui/login/login_company.dart';
import 'package:desktop_erp_4s/ui/login/login_provider.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/showTransaction/show_transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LoginProvider(),
      child: MyApp(), // Your root application widget
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()), // Register LoginProvider
        ChangeNotifierProvider(create: (_) => HomeProvider()), // Register HomeProvider
        ChangeNotifierProvider(create: (_) => ShowTransactionProvider()), // Register ShowTransactionProvider

      ],
      child: MyApp(),
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
