import 'package:desktop_erp_4s/util/shared_data.dart';

class APIConstants {

  //URL
  static String STATIC_BASE_URL = "http://196.219.86.38:1212/api/";
 // static String COMPANY_PUB_URL = SharedData().getPubUrl().toString();
 //check if shared data get pub url null or not
  //check getPubUrl() is not null
  //if null then return static base url
  //if not null then return the pub url
  // String BASE_URL = COMPANY_PUB_URL.toString().length>0 ? COMPANY_PUB_URL+ "api/" : STATIC_BASE_URL;

  // String BASE_URL = COMPANY_PUB_URL.toString().length>0 ? COMPANY_PUB_URL+ "api/" : STATIC_BASE_URL;
  static String BASE_URL = STATIC_BASE_URL;

  //Login Company & user to get info
  static String GET_USER_INFO = BASE_URL +"Transactions/Get_User_Info?CompanyName=";
  static String LOGIN = BASE_URL +"users/Login?servicename=";

  //Stock & RecPay Transaction
  static String TRANSACTION_URL = "Transactions/";
  static String STOCK_TRANSACTION = BASE_URL +TRANSACTION_URL+"Get_transaction_specs?servicename=";
  static String REC_PAY_TRANSACTION = BASE_URL +TRANSACTION_URL+"Get_transaction_specs?servicename=";


  static String GET_ALL_TRANSACTION_LIST = BASE_URL + "Transactions/Get_StoreTrnsList?servicename=";


  //Basic Data
  //ALL CUSTOMER
  static String GET_ALL_CUSTOMER = BASE_URL + "Transactions/Get_allcustomers?servicename=";
  static String GET_ALL_VENDORS= BASE_URL + "Transactions/Get_allvendors?servicename=";
  static String GET_ALL_AGENTS= BASE_URL + "Transactions/Get_allagents?servicename=";
  static String GET_ALL_WORK_AREAS= BASE_URL + "Transactions/Get_allworkarea?servicename=";
  static String GET_ALL_PERSONS= BASE_URL + "Transactions/Get_allpersons?servicename=";
  static String GET_ALL_CONTRACTOR= BASE_URL + "Transactions/Get_allcontractor?servicename=";
  static String GET_ALL_STORES= BASE_URL + "Transactions/Get_allstores?servicename=";
  static String Get_ALL_DEPART= BASE_URL + "Transactions/Get_alldepart?servicename=";
  static String GET_ALL_ITEMS_FORMS= BASE_URL + "Transactions/Get_allitemforms?servicename=";


  //Response Codes
  static const String RESPONSE_CODE_UNAUTHORIZED = "401";

}