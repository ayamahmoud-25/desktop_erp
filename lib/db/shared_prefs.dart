import 'dart:convert';

import 'package:desktop_erp_4s/data/models/response/CompanyInfoResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/models/branch_model.dart';

class SharedPrefs{
  static const _companyInfoKey = 'company_info';
  static const _accessTokenKey = 'access_token';
  static const _branchesKey = 'branches';
  static const _selectedBranchKey = 'selected_branch';
  static const _userIdKey = 'user_id';

  static Future<void>  saveCompanyInfo(CompanyInfoResponse companyInfo) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(companyInfo.toJson());
    await prefs.setString(_companyInfoKey, jsonString);
  }

  static Future<CompanyInfoResponse?> getCompanyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_companyInfoKey);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return CompanyInfoResponse.fromJson(jsonMap);
    }
    return null;
  }

  static Future<void> clearCompanyInfo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_companyInfoKey);
    print('Company info cleared from SharedPreferences.');
  }


 /// Save access token
  static Future<void>  saveAccessToken(String? accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, "Bearer " +accessToken!);
  }

  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString(_accessTokenKey);
    return accessToken;
  }

  /// Save userId
  static Future<void>  saveUserId(String? userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId!);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final String? userId = prefs.getString(_userIdKey);
    return userId;
  }


  static Future<void> saveBranches(List<Branches>? branches) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(branches?.map((branch) => branch.toJson()).toList());
    await prefs.setString(_branchesKey, jsonString);
  }
  static Future<List<Branches>?> getBranches() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_branchesKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((json) => Branches.fromJson(json)).toList();
    }
    return null;
  }

  //Save the selected branch
  static Future<void> saveSelectedBranch(Branches branch) async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(branch.toJson());
    await prefs.setString(_selectedBranchKey, jsonString);
  }

  static Future<void> clearSelectedBranch() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_selectedBranchKey);
    print('Selected branch cleared from SharedPreferences.');
  }

  //get selected branch as object
  static Future<Branches?> getSelectedBranch() async {
    final prefs = await SharedPreferences.getInstance();
    final String? jsonString = prefs.getString(_selectedBranchKey);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
      return Branches.fromJson(jsonMap);
    }
    return null;
  }
}

