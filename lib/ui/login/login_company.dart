import 'package:desktop_erp_4s/data/api_state.dart';
import 'package:desktop_erp_4s/ui/login/login_provider.dart';
import 'package:desktop_erp_4s/ui/widgets/background_image_page.dart';
import 'package:desktop_erp_4s/ui/widgets/show_message.dart';
import 'package:desktop_erp_4s/util/validate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/SharedPereference.dart';
import '../../util/Strings.dart';
import '../../util/shared_data.dart';

class CompanyLogin extends StatefulWidget {
  @override
  State<CompanyLogin> createState() => _CompanyLoginState();
}

class _CompanyLoginState extends State<CompanyLogin> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _companyNameController = TextEditingController();

  //initialize the controller
  //initial state
  @override
  void initState() {
    super.initState();
    print("initState:");

    /*
   later  to fix change url from start it
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = SharedPreferences();
      prefs.clearCompanyInfo();
    });*/


  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return Scaffold(
      body: BackgroundImagePage(
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: Column(
            children: [
              Container(
                child: Text(
                  Strings.Enter_Company_Name,
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
              SizedBox(height: 5),
              Container(
                margin: EdgeInsets.all(6.0),
                padding: EdgeInsets.all(6.0),
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _companyNameController,
                    decoration: InputDecoration(
                      hintTextDirection: TextDirection.rtl,
                      filled: true,
                      fillColor: Colors.white,
                      hintText: Strings.Company_Name,
                      errorStyle: TextStyle(color: Colors.red),
                      border: OutlineInputBorder(),
                      /* errorStyle: TextStyle(color: Colors.orange), //Error text color
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red), // error border color
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red), //focused error border color
                    ),*/
                    ),
                    validator: (value) {
                      return Validator().validate(value);
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              MaterialButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    //do something
                    await loginProvider.userInfo(
                      context,
                      _companyNameController.text.trim(),
                    );
                    if (loginProvider.state == APIStatue.loading)
                      CircularProgressIndicator();
                    else if (loginProvider.state == APIStatue.error)
                      ShowMessage().showSnackBar(
                        context,
                        loginProvider.errorMessage!,
                      );
                  }
                  else if (loginProvider.state == APIStatue.success) {
                    print("Navigation to UserLogin successful");
                  }
                },
                textColor: Colors.white,
                child: Text(Strings.Save),
                color: Color.fromARGB(255, 23, 111, 153),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
    /*;*/
  }
}


/*
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../db/SharedPereference.dart';
import '../../util/Strings.dart';
import '../../util/validate.dart';
import '../../util/show_message.dart';
import 'login_provider.dart';

class CompanyLogin extends StatefulWidget {
  @override
  State<CompanyLogin> createState() => _CompanyLoginState();
}

class _CompanyLoginState extends State<CompanyLogin> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController _companyNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BackgroundImagePage(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 600), // Limit width for larger screens
              margin: EdgeInsets.only(top: 40),
              padding: EdgeInsets.symmetric(horizontal: screenWidth > 600 ? 32.0 : 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    Strings.Enter_Company_Name,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(height: 10),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: _companyNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: Strings.Company_Name,
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        return Validator().validate(value);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity, // Make button match parent width
                    child: MaterialButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await loginProvider.userInfo(
                            context,
                            _companyNameController.text.trim(),
                          );
                          if (loginProvider.state == APIStatue.loading) {
                            CircularProgressIndicator();
                          } else if (loginProvider.state == APIStatue.error) {
                            ShowMessage().showSnackBar(
                              context,
                              loginProvider.errorMessage!,
                            );
                          } else if (loginProvider.state == APIStatue.success) {
                            print("Navigation to UserLogin successful");
                          }
                        }
                      },
                      textColor: Colors.white,
                      child: Text(Strings.Save),
                      color: Color.fromARGB(255, 23, 111, 153),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/
