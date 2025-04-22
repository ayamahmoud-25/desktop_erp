import 'dart:convert';

import 'package:desktop_erp_4s/data/models/response/CompanyInfoResponse.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs{
  static const _companyInfoKey = 'company_info';

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
}

