
import 'package:desktop_erp_4s/data/models/response/CompanyInfoResponse.dart';


class APIResult {
  bool? status;
  String? msg;
  String? code;
  dynamic data;

  APIResult({this.status, this.msg, this.code,  this.data});

 /* Map<String, dynamic> toJson() {
    return {
      'status': status,
      'msg': msg,
      'code': code,
      'data': data,
    };
  }
*/

}
