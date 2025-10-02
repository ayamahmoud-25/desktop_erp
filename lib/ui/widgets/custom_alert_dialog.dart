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

  Future<bool?> showCustomAlertDialog({
    required BuildContext context,
    required String title,
    required String message,
    String okText = "OK",
    String cancelText = "Cancel",
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // prevent dismiss by tapping outside
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title)

          /*Center(
            child: Icon(
              Icons.warning_amber_outlined,
              color: const Color.fromARGB(255, 23, 111, 153),
              size: 40,
            )*/,

          content: Text(
            message,
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
               Navigator.of(context).pop(false); // return false (cancel)
              },
              child: Text(
                cancelText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // return true (ok)
              },
              child: Text(
                okText,
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 23, 111, 153),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}