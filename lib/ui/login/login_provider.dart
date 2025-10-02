import 'package:desktop_erp_4s/data/api/api_service.dart';
import 'package:desktop_erp_4s/data/api_state.dart';
import 'package:desktop_erp_4s/data/models/response/UserInfoResponse.dart';
import 'package:desktop_erp_4s/db/SharedPereference.dart';
import 'package:desktop_erp_4s/ui/home/home_page.dart';
import 'package:desktop_erp_4s/util/navigation.dart';
import 'package:flutter/cupertino.dart';

import '../../data/app_constants.dart';
import '../../db/database_helper.dart';
import '../../util/loading_service.dart';
import 'login_user.dart';

class LoginProvider extends ChangeNotifier{
  final  APIService _apiService = APIService();

  APIStatue _state = APIStatue.initial;
  String? _errorMessage;

  APIStatue get state => _state;
  String? get errorMessage => _errorMessage;




  Future<void> userInfo(BuildContext context,String companyName) async{
   // _state =APIStatue .loading;
    LoadingService.showLoading(context);
    notifyListeners();
    final response = await _apiService.getUserInfo(companyName);
    if(response.status==true){
      _state = APIStatue.success;
      LoadingService.hideLoading(context);

      SharedPreferences().saveCompanyInfoData(response.data!);
      notifyListeners();

      Navigation().pushNavigation(context, UserLogin());

    }else{
      LoadingService.hideLoading(context);
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }

  }

  Future<void> userLogin(BuildContext context,String userName,String password) async{
    //_state =APIStatue .loading;
    LoadingService.showLoading(context);
    notifyListeners();
    final response = await _apiService.loginUserInfo(userName,password);
    if(response.status!=null){
        _state = APIStatue.success;
        LoadingService.hideLoading(context);

        await DatabaseHelper().database; // ده هيعيد فتح وإنشاء الـ db
        UserInfoResponse userInfo =response.data;

        SharedPreferences().SaveAccessToken(userInfo.accessToken);
        SharedPreferences().saveBranchesToPrefs(userInfo.branchesList);

        String userId = SharedPreferences().loadUserId().toString();
        if(userId.isNotEmpty){
          if(userId!=userInfo.userId){
            DatabaseHelper().clearDatabase();
            await DatabaseHelper().database; // ده هيعيد فتح وإنشاء الـ db
            SharedPreferences().saveUserId(userInfo.userId);
          }
        }else SharedPreferences().saveUserId(userInfo.userId);


        notifyListeners();
        //
        Navigation().pushNavigation(context, HomePage());

      }else{
      LoadingService.hideLoading(context);

      _state = APIStatue.error;
         if(response.msg!=null)
        _errorMessage = response.msg;
         else _errorMessage = AppConstants.ERROR_DATA_ORACLE;
        notifyListeners();
      }
  }


}

