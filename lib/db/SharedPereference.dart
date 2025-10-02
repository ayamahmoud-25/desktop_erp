import 'package:desktop_erp_4s/db/shared_prefs.dart';

import '../data/models/branch_model.dart';
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

  //clear company info
  Future<void> clearCompanyInfo() async {
    await SharedPrefs.clearCompanyInfo();
  }

  Future<void> SaveAccessToken(String? accessToken) async {
    await SharedPrefs.saveAccessToken(accessToken);
  }
  // --- Loading ---
  Future<String?> loadAccessToken() async {
    final accessToken = await SharedPrefs.getAccessToken();
    return accessToken;
  }


  Future<void> saveUserId(String? accessToken) async {
    await SharedPrefs.saveUserId(accessToken);
  }
  // --- Loading ---
  Future<String?> loadUserId() async {
    final userId = await SharedPrefs.getUserId();
    return userId;
  }

  void saveBranchesToPrefs(List<Branches>? branches) async {
    await SharedPrefs.saveBranches(branches);
  }

  Future<List<Branches>?> loadBranchesFromPrefs() async {
    return await SharedPrefs.getBranches();
  }

  // --- Saving ---
  Future<void> saveSelectedBranch(Branches  selectedBranch) async {
    await SharedPrefs.saveSelectedBranch(selectedBranch);
  }
  // --- Loading ---
  Future<Branches?> loadSelectedBranch() async {
    final selectedBranch = await SharedPrefs.getSelectedBranch();
    return selectedBranch;
  }

  //l
}