import 'dart:ffi';

import 'package:desktop_erp_4s/data/api/api_result.dart';
import 'package:desktop_erp_4s/data/api/api_service.dart';
import 'package:desktop_erp_4s/data/api_state.dart';
import 'package:desktop_erp_4s/data/models/response/UserInfoResponse.dart';
import 'package:desktop_erp_4s/db/SharedPereference.dart';
import 'package:desktop_erp_4s/learn/futuerbuilderproviderlogin/home_page.dart';
import 'package:desktop_erp_4s/util/navigation.dart';
import 'package:flutter/cupertino.dart';

import 'login_user.dart';

class LoginProvider extends ChangeNotifier{
  final  APIService _apiService = APIService();

  APIStatue _state = APIStatue.initial;
  String? _errorMessage;

  APIStatue get state => _state;
  String? get errorMessage => _errorMessage;




  Future<void> userInfo(BuildContext context,String companyName) async{
    _state =APIStatue .loading;
    notifyListeners();
    final response = await _apiService.getUserInfo(companyName);
    if(response.status!){
      _state = APIStatue.success;
      SharedPreferences().saveCompanyInfoData(response.data!);
      notifyListeners();

      Navigation().pushNavigation(context, UserLogin());

    }else{
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }

  }

  Future<void> userLogin(BuildContext context,String userName,String password) async{
    _state =APIStatue .loading;
    notifyListeners();
    final response = await _apiService.loginUserInfo(userName,password);
    if(response.status!){
      _state = APIStatue.success;
      UserInfoResponse userInfo =response.data;
      //SharedPreferences().saveCompanyInfoData(response.data!);
      notifyListeners();
    //
      Navigation().pushNavigation(context, HomePage(userInfo.accessToken));

    }else{
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }

  }



}

