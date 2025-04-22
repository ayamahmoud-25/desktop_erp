import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
   final String? authToken;


   const HomePage(this.authToken);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Login Successful!', style: TextStyle(fontSize: 20)),
            if (authToken != null)
              Text('Auth Token: $authToken', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
