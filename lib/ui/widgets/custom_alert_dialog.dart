import 'package:desktop_erp_4s/util/strings.dart';
import 'package:flutter/material.dart';

class CustomAlertDialog {
  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Icon(
              Icons.warning_amber_outlined,
              color: Color.fromARGB(255, 23, 111, 153),
              size: 40,
            ),
          ),
          content:/* Container(
            alignment: Alignment.topRight,

            child:*/ Text(
              Strings.ALERT_SELECT_BRANCH,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
          //  ),
          ),
          actions: <Widget>[
            TextButton(
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  Strings.OK,
                  style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 23, 111, 153),
                ),
                  textAlign: TextAlign.right,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}