// File: lib/shared_data.dart
import '../db/SharedPereference.dart';

class SharedData {
  static final SharedData _instance = SharedData._internal();

  factory SharedData() {
    return _instance;
  }

  SharedData._internal();

  String sharedVariable = "Accessible globally";
  String pubUrl = "";

  //create function to get the pubUrl from the shared preference
/*
 Future<String> getPubUrl() async {
    // Load the company info data from shared preferences
   CompanyInfoResponse companyInfo = await SharedPreferences().loadCompanyInfoData();

    // Check if the company info is not null and return the pubUrl
    if (companyInfo != null) {
      return companyInfo.pubUrl?.toString() ?? "";
    }

    // If company info is null, return null or handle accordingly
    return pubUrl.toString();
  }
*/
}