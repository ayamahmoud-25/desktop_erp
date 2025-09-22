import 'package:desktop_erp_4s/data/models/response/TransactionSpec.dart';
import 'package:flutter/material.dart';

import '../ui/login/login_company.dart';
import '../ui/stockTransaction/detailsTransaction/transaction_details.dart';


class Navigation{

  void pushNavigation(BuildContext context,Widget widget){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => widget),
    );
  }
  void logout(BuildContext context){
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => CompanyLogin()),
          (Route<dynamic> route) => false,
    );
  }

  void navigateToTransactionDetails(BuildContext buildContext, TransactionSpec transSpec,String branch,String transCode ,int transNo,bool isDetails) {
    Navigator.push(
      buildContext,
      MaterialPageRoute(
        builder: (context) => TransactionDetails(
          transactionSpec: transSpec,
          branch: branch,
          transCode: transCode,
          transNo: transNo,
          isDetails: isDetails,
        ),
      ));
  }


}