import 'dart:convert' as convert;
import 'dart:core';

import 'package:desktop_erp_4s/data/api/api_constansts.dart';
import 'package:desktop_erp_4s/data/models/response/CompanyInfoResponse.dart';
import 'package:desktop_erp_4s/data/models/response/UserInfoResponse.dart';
import 'package:desktop_erp_4s/ui/login/login_user.dart';
import 'package:http/http.dart' as http;

import '../../db/SharedPereference.dart';
import 'api_result.dart';

class APIService {



  Future<APIResult> getUserInfo(String companyName) async {
    final String userInfoUrl = APIConstants.GET_USER_INFO + companyName;
    APIResult result = APIResult();
    CompanyInfoResponse companyInfoResponse;

    final response = await http.get(Uri.parse(userInfoUrl));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      companyInfoResponse = CompanyInfoResponse.fromJson(jsonResponse['data']);
     return result = APIResult(
        status: jsonResponse['status'],
        msg:  jsonResponse['msg'],
        code: jsonResponse['code'],
        data: companyInfoResponse,
      );

    } else {

      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }

  Future<APIResult> loginUserInfo(String  username,String password) async {
    final companyData = await SharedPreferences().loadCompanyInfoData();

     String loginUrl = APIConstants.LOGIN + companyData!.serviceName! +"&dbname="+companyData.dbName!;
    APIResult result = APIResult();
     UserInfoResponse userInfoResponse;

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: convert.jsonEncode(<String, String>{
          'Username': username,
          'Password': password,
        }),
      );

      if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      userInfoResponse = UserInfoResponse.fromJson(jsonResponse['data']);
      return result = APIResult(
        status: jsonResponse['status'],
        msg:  jsonResponse['msg'],
        code: jsonResponse['code'],
        data: userInfoResponse,
      );
    } else {

      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }


}


