import 'package:desktop_erp_4s/ui/home/home_provider.dart';
import 'package:desktop_erp_4s/ui/login/login_company.dart';
import 'package:desktop_erp_4s/ui/login/login_provider.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/showTransaction/show_transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';


void main() {
// Initialize databaseFactory for sqflite_common_ffi
//flutter run -d chrome --web-browser-flag "--disable-web-security"
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // Initialize the database factory for sqflite_common_ffi
  // This is necessary for using sqflite in a desktop environment
  // You can also use the following line if you want to use the default database factory

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
