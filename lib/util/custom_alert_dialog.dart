


import 'package:flutter/material.dart';

class AlertDialog{

  showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:Icon(Icons.warning_amber_outlined, color: Color.fromARGB(255, 23, 111, 153), size: 40),
          content: Text(Strings.ALERT_SELECT_BRANCH),
          actions: <Widget>[
            TextButton(
              child: Text(Strings.OK),
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
