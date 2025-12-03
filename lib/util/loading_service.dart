// loading_service.dart (new file)
import 'package:flutter/material.dart';

class LoadingService {
  static bool _isLoadingVisible = false;

  static void showLoading(BuildContext context) {
    if (_isLoadingVisible) {
      // Avoid showing multiple loaders
      return;
    }
    _isLoadingVisible = true;
    showDialog(
      context: context,
      barrierDismissible: false, // User cannot dismiss by tapping outside
      builder: (BuildContext dialogContext) {
        // Use a WillPopScope to prevent back button from dismissing if needed
        return WillPopScope(
          onWillPop: () async => false, // Prevents back button dismissal
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    )
                  ]
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                 /* SizedBox(height: 15),
                  Text(
                    "Loading...", // You can make this text configurable
                    style: TextStyle(fontSize: 16),
                  )*/
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static void hideLoading(BuildContext context) {
    if (_isLoadingVisible) {
      Navigator.of(context, rootNavigator: true).pop(); // Dismiss the dialog
      _isLoadingVisible = false;
    }
  }
}
