import 'package:desktop_erp_4s/data/models/response/CompanyInfoResponse.dart';
import 'package:desktop_erp_4s/db/shared_prefs.dart';
import 'package:desktop_erp_4s/ui/widgets/background_image_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:desktop_erp_4s/ui/login/login_provider.dart';
import 'package:provider/provider.dart';

import '../../data/api_state.dart';
import '../../db/SharedPereference.dart';
import '../../util/Strings.dart';
import '../../util/show_message.dart';
import '../../util/validate.dart';

class UserLogin extends StatefulWidget{

  @override
  State<UserLogin>  createState()=> _UserLoginState();

}

class _UserLoginState extends State<UserLogin>{
  GlobalKey<FormState> _userNameFormKey =  GlobalKey();
  GlobalKey<FormState> _passwordFormKey =  GlobalKey();

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordNameController = TextEditingController();


  String?  userName;
  String? password;
  bool showPassword = true;




  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return Scaffold
      (extendBodyBehindAppBar: true, // Allows the body to extend behind the AppBar
        appBar: AppBar(
          backgroundColor: Colors.transparent, // Transparent AppBar
          elevation: 0, // Remove shadow
          iconTheme: IconThemeData(color: Colors.white), // Set back button color to white
        ),
      body: BackgroundImagePage(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 10),
              Container(
                margin: EdgeInsets.all(6.0),
                padding: EdgeInsets.all(6.0),
                child: Form(
                  key: _userNameFormKey,
                  child: TextFormField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                        hintTextDirection: TextDirection.rtl,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: Strings.Enter_User_Name,
                        suffixIcon:Icon(Icons.person),
                        errorStyle: TextStyle(color: Colors.red),
                        border: OutlineInputBorder()
                    ),
                    validator:
                        (value) {
                      return Validator().validate(value);
                    },
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(6.0),
                padding: EdgeInsets.all(6.0),
                child: Form(
                  key: _passwordFormKey,
                  child: TextFormField(
                    controller: _passwordNameController,
                    obscureText: showPassword,
                    decoration: InputDecoration(
                        hintTextDirection: TextDirection.rtl,
                        filled: true,
                        fillColor: Colors.white,
                        hintText: Strings.Password,
                        errorStyle: TextStyle(color: Colors.red),
                        suffixIcon: InkWell(
                          child: Icon(showPassword
                              ? Icons.remove_red_eye
                              : Icons.remove_red_eye_outlined),
                          onTap: () {
                            setState(() {
                              if(_passwordNameController.text.isNotEmpty)
                                showPassword = !showPassword;
                            });
                        },) ,
                        border: OutlineInputBorder()
                    ),
                    validator: (value) {
                      return Validator().validate(value);
                    },
                  ),
                ),
              ),
              MaterialButton(onPressed: () async{
                if(_userNameFormKey.currentState!.validate()
                    &&_passwordFormKey.currentState!.validate()){

                   await loginProvider.userLogin(context, _userNameController.text.trim(),
                      _passwordNameController.text.trim() );

                  if(loginProvider.state == APIStatue.loading)
                    CircularProgressIndicator();
                  else if(loginProvider.state == APIStatue.error )
                    ShowMessage().showSnackBar(context, loginProvider.errorMessage!);

                }
              },
                textColor: Colors.white,
                child: Text(Strings.Save),
                color: Color.fromARGB(255, 23, 111, 153),),
              SizedBox(height: 20,),

            ],
          ),
        ),
      ),
    );
  }



}