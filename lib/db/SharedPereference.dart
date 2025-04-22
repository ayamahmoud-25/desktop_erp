import 'package:desktop_erp_4s/db/shared_prefs.dart';

import '../data/models/response/CompanyInfoResponse.dart';

class SharedPreferences{

  // --- Saving ---
  Future<void> saveCompanyInfoData(CompanyInfoResponse response) async {
    await SharedPrefs.saveCompanyInfo(response);
  }
  // --- Loading ---
  Future<CompanyInfoResponse?> loadCompanyInfoData() async {
    final savedInfo = await SharedPrefs.getCompanyInfo();
    if (savedInfo != null) {
      print('Retrieved Client Name: ${savedInfo.clientName}');
      print('Retrieved Login Name: ${savedInfo.loginName}');
      print('Retrieved Service Name: ${savedInfo.serviceName}');
      print('Retrieved DB Name: ${savedInfo.dbName}');
      print('Retrieved Pub URL: ${savedInfo.pubUrl}');
      // Use the retrieved CompanyInfoResponse object in your UI
      //return savedInfo;
    } else {
      print('No company info saved.');
      //return savedInfo ;
    }
    return savedInfo;


  }

}