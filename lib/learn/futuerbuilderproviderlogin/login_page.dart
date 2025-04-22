import 'package:desktop_erp_4s/data/api/api_result.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth_response.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  Future<APIResult>? _authResponseFuture;

  void _login() {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      setState(() {
       // _authResponseFuture = loginUser(username, password);
      //   _authResponseFuture = getCompanyInfo2("MG24");

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
           //   SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: _login,
                child: Text('Login'),
              ),
              SizedBox(height: 20),
              if (_authResponseFuture != null)
                FutureBuilder<APIResult>(
                  future: _authResponseFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.red));
                    } else if (snapshot.data?.status == true) {
                 //     WidgetsBinding.instance.addPostFrameCallback((_) {
                        /*Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomePage(authToken: snapshot.data?.code),
                          ),
                        );*/
                        // Optionally reset the future and clear fields
                        _authResponseFuture = null;
                        _usernameController.clear();
                        _passwordController.clear();
                    //  });
                      return SizedBox.shrink(); // Placeholder
                    } else {
                      return Text(snapshot.data?.msg ?? 'Login failed', style: TextStyle(color: Colors.red));
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
