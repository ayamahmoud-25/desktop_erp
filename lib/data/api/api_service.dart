import 'dart:convert' as convert;
import 'dart:core';

import 'package:desktop_erp_4s/data/api/api_constansts.dart';
import 'package:desktop_erp_4s/data/app_constants.dart';
import 'package:desktop_erp_4s/data/models/response/AllAgents.dart';
import 'package:desktop_erp_4s/data/models/response/AllContractor.dart';
import 'package:desktop_erp_4s/data/models/response/AllDeparts.dart';
import 'package:desktop_erp_4s/data/models/response/AllItemsForms.dart';
import 'package:desktop_erp_4s/data/models/response/AllPersons.dart';
import 'package:desktop_erp_4s/data/models/response/AllSalesRep.dart';
import 'package:desktop_erp_4s/data/models/response/AllStores.dart';
import 'package:desktop_erp_4s/data/models/response/AllVendors.dart';
import 'package:desktop_erp_4s/data/models/response/AllWorkAreas.dart';
import 'package:desktop_erp_4s/data/models/response/BasicDataListResponse.dart';
import 'package:desktop_erp_4s/data/models/response/CompanyInfoResponse.dart';
import 'package:desktop_erp_4s/data/models/response/DataItemListResponseModel.dart';
import 'package:desktop_erp_4s/data/models/response/DataResponseModel.dart';
import 'package:desktop_erp_4s/data/models/response/Transaction.dart';
import 'package:desktop_erp_4s/data/models/response/UserInfoResponse.dart';
import 'package:desktop_erp_4s/ui/login/login_user.dart';
import 'package:http/http.dart' as http;

import '../../db/SharedPereference.dart';
import '../models/response/AllCustomer.dart';
import 'api_result.dart';

class APIService {

  //constructor

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
    String? authUrl = await loadCompanyData();
   String loginUrl = APIConstants.LOGIN + authUrl!;
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
  Future<APIResult> getTransactionSpecs() async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();

    String loginUrl = APIConstants.STOCK_TRANSACTION + authUrl!;
    APIResult result = APIResult();
    DataResponseModel dataResponseModel;

    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },

    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
          dataResponseModel = DataResponseModel.fromJson(jsonResponse['data']);
          return result = APIResult(
            status: jsonResponse['status'],
            msg:  jsonResponse['msg'],
            code: jsonResponse['code'],
            data: dataResponseModel,
          );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }

  Future<APIResult> getItemList(String itemForm) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();

    String loginUrl = APIConstants.GET_ALL_ITEMS_LIST + authUrl! +"&_pageSize=10000"+"&item_form="+itemForm;
    APIResult result = APIResult();
    DataItemListResponseModel dataResponseModel;

    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },

    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        dataResponseModel = DataItemListResponseModel.fromJson(jsonResponse['data']);
        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataResponseModel,
        );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }


  Future<APIResult> getAllCustomer(bool isStoreTrans,String transCode) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String transType = isStoreTrans ? AppConstants.TRANS_TYPE_STORE : AppConstants.TRANS_TYPE_REC_PAY; // Determine transaction type based on isStoreTrans
    String loginUrl = APIConstants.GET_ALL_CUSTOMER + authUrl! +"&_pageSize=10000"+"&trns_code="+transCode+"&trns_type="+transType;
    APIResult result = APIResult();
    //Data<AllCustomer> allCustomerList = [] as Data<AllCustomer>;

    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },

    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){


        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllCustomer> dataList = BasicDataListResponse<AllCustomer>.fromJson(
           data,
          'customers',
          (json) => AllCustomer.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
            data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }
  Future<APIResult> getAllVendors(bool isStoreTrans,String transCode) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String transType = isStoreTrans ? AppConstants.TRANS_TYPE_STORE : AppConstants.TRANS_TYPE_REC_PAY; // Determine transaction type based on isStoreTrans

    String loginUrl = APIConstants.GET_ALL_VENDORS + authUrl! +"&_pageSize=10000"+"&trns_code="+transCode+"&trns_type="+transType;;
    APIResult result = APIResult();
    //Data<AllCustomer> allCustomerList = [] as Data<AllCustomer>;

    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },

    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllVendors> dataList = BasicDataListResponse<AllVendors>.fromJson(
          data,
          'vendors',
              (json) => AllVendors.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }
  Future<APIResult> getAllAgents(bool isStoreTrans,String transCode) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String transType = isStoreTrans ? AppConstants.TRANS_TYPE_STORE : AppConstants.TRANS_TYPE_REC_PAY; // Determine transaction type based on isStoreTrans

    String loginUrl = APIConstants.GET_ALL_AGENTS + authUrl!+"&_pageSize=10000"+"&trns_code="+transCode+"&trns_type="+transType;;
    APIResult result = APIResult();
    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllAgents> dataList = BasicDataListResponse<AllAgents>.fromJson(
          data,
          'agents',
              (json) => AllAgents.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }
  Future<APIResult> getAllWorkAreas(bool isStoreTrans,String transCode) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String transType = isStoreTrans ? AppConstants.TRANS_TYPE_STORE : AppConstants.TRANS_TYPE_REC_PAY; // Determine transaction type based on isStoreTrans

    String loginUrl = APIConstants.GET_ALL_WORK_AREAS + authUrl!+"&_pageSize=10000"+"&trns_code="+transCode+"&trns_type="+transType;;
    APIResult result = APIResult();
    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllWorkAreas> dataList = BasicDataListResponse<AllWorkAreas>.fromJson(
          data,
          'workarea',
              (json) => AllWorkAreas.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }
  Future<APIResult> getAllPersons(bool isStoreTrans,String transCode) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String transType = isStoreTrans ? AppConstants.TRANS_TYPE_STORE : AppConstants.TRANS_TYPE_REC_PAY; // Determine transaction type based on isStoreTrans

    String loginUrl = APIConstants.GET_ALL_PERSONS + authUrl!+"&_pageSize=10000"+"&trns_code="+transCode+"&trns_type="+transType;;
    APIResult result = APIResult();
    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllPersons> dataList = BasicDataListResponse<AllPersons>.fromJson(
          data,
          'persons',
              (json) => AllPersons.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }
  Future<APIResult> getAllContactor(bool isStoreTrans,String transCode) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String transType = isStoreTrans ? AppConstants.TRANS_TYPE_STORE : AppConstants.TRANS_TYPE_REC_PAY; // Determine transaction type based on isStoreTrans

    String loginUrl = APIConstants.GET_ALL_CONTRACTOR + authUrl!+"&_pageSize=10000"+"&trns_code="+transCode+"&trns_type="+transType;
    APIResult result = APIResult();
    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },
    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllContractor> dataList = BasicDataListResponse<AllContractor>.fromJson(
          data,
          'contractor',
              (json) => AllContractor.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }
  Future<APIResult> getAllStores(bool isStoreTrans,String transCode) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String transType = isStoreTrans ? AppConstants.TRANS_TYPE_STORE : AppConstants.TRANS_TYPE_REC_PAY; // Determine transaction type based on isStoreTrans

    String loginUrl = APIConstants.GET_ALL_STORES + authUrl! +"&_pageSize=10000"+"&trns_code="+transCode+"&trns_type="+transType;
    APIResult result = APIResult();

    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },

    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllStores> dataList = BasicDataListResponse<AllStores>.fromJson(
          data,
          'stores',
              (json) => AllStores.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }
  Future<APIResult> getAllDepart(bool isStoreTrans,String transCode) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String transType = isStoreTrans ? AppConstants.TRANS_TYPE_STORE : AppConstants.TRANS_TYPE_REC_PAY; // Determine transaction type based on isStoreTrans

    String loginUrl = APIConstants.Get_ALL_DEPART + authUrl! +"&_pageSize=10000"+"&trns_code="+transCode+"&trns_type="+transType;
    APIResult result = APIResult();

    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },

    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllDeparts> dataList = BasicDataListResponse<AllDeparts>.fromJson(
          data,
          'departs',
              (json) => AllDeparts.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }

  Future<APIResult> getAllItemsForms() async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String loginUrl = APIConstants.GET_ALL_ITEMS_FORMS + authUrl! ;
    APIResult result = APIResult();
    //Data<AllCustomer> allCustomerList = [] as Data<AllCustomer>;

    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },

    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){


        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllItemsForms> dataList = BasicDataListResponse<AllItemsForms>.fromJson(
          data,
          'itemforms',
              (json) => AllItemsForms.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );


    }
  }
  Future<APIResult> getAllSalesRep() async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();
    String loginUrl = APIConstants.Get_ALL_SALES_REP + authUrl!+"&_pageSize=10000" ;

    APIResult result = APIResult();

    final response = await http.get(Uri.parse(loginUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },

    );

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<AllSalesRep> dataList = BasicDataListResponse<AllSalesRep>.fromJson(
          data,
          'salesrep',
              (json) => AllSalesRep.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }


  Future<APIResult> getStoreTransactionList(String selectedBranch,String transCode) async {
    String? authUrl = await loadCompanyData();
    String? authToken = await loadAuthToken();

    String storeTransListUrl = APIConstants.GET_ALL_TRANSACTION_LIST + authUrl! + "&branch=" + selectedBranch + "&trns_code=" + transCode;
    APIResult result = APIResult();

    final response = await http.get(Uri.parse(storeTransListUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': authToken ?? '', // Add Bearer token
      },

    );


    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      if(jsonResponse['code'] == APIConstants.RESPONSE_CODE_UNAUTHORIZED){

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: [],
        );
      }else{
        var data = jsonResponse['data'];
        BasicDataListResponse<Transaction> dataList = BasicDataListResponse<Transaction>.fromJson(
          data,
          'Transaction',
              (json) => Transaction.fromJson(json),
        );

        print("dataList: ${dataList.items}"); // Debugging line

        return result = APIResult(
          status: jsonResponse['status'],
          msg:  jsonResponse['msg'],
          code: jsonResponse['code'],
          data: dataList,    );
      }

    } else {
      return APIResult(
        status: result.status,
        msg: result.msg,
        code: result.code,
        data: result.data,
      );
    }
  }
















  Future<String?> loadCompanyData() async {
      final companyData = await SharedPreferences().loadCompanyInfoData();
      String authUrl=companyData!.serviceName! +"&dbname="+companyData.dbName!;
      return authUrl;
  }
  Future<String?> loadAuthToken() async {
    return  await SharedPreferences().loadAccessToken();
  }
}


