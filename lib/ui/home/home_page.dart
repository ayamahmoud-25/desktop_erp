import 'package:desktop_erp_4s/ui/home/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/api_state.dart';
import '../../data/models/branch_model.dart';
import '../../db/SharedPereference.dart';
import '../../util/navigation.dart';
import '../widgets/show_message.dart';
import '../../util/strings.dart';
import 'branches/BranchListDialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? authToken;


  @override
  void initState() {
    super.initState();
    getToken();
  }
  void getToken() async {
    authToken = await SharedPreferences().loadAccessToken();
    setState(() {}); // Update the UI after fetching the token
  }

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomeProvider>(context);

    return  Directionality(textDirection: TextDirection.rtl, child:       Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 23, 111, 153),
        iconTheme: IconThemeData(color: Colors.white), // Set back button color to white

        title: Text(Strings.HOME_TITLE,style: TextStyle(color: Colors.white),),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              // Handle menu item selection
              if (value == Strings.POP_MENU_ITEM_REPORTS) {
                // Navigate to Profile
              } else if (value == Strings.POP_MENU_ITEM_SETTINGS) {
                // Navigate to Settings
              } else if (value == Strings.POP_MENU_ITEM_LOGOUT) {
                // Perform logout
                Navigation().logout(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: Strings.POP_MENU_ITEM_REPORTS,
                  child: Text(Strings.POP_MENU_ITEM_REPORTS),
                ),
                PopupMenuItem(
                  value: Strings.POP_MENU_ITEM_SETTINGS,
                  child: Text(Strings.POP_MENU_ITEM_SETTINGS),
                ),
                PopupMenuItem(
                  value: Strings.POP_MENU_ITEM_LOGOUT,
                  child: Text(Strings.POP_MENU_ITEM_LOGOUT),
                ),
              ];
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20), // Set left and right margins to 10
              child: MaterialButton(
                minWidth: double.infinity,
                height: 50,
                onPressed: () async {
                  await homeProvider.transactionStockSpecs(context);
                  if(homeProvider.state == APIStatue.loading){
                    print(" APIStatue.loading ${homeProvider.state}");
                    CircularProgressIndicator();
                  }else if(homeProvider.state == APIStatue.error )
                    ShowMessage().showSnackBar(context, homeProvider.errorMessage!);
 },
                textColor: Colors.white,
                child: Text(Strings.store_trans),
                color: Color.fromARGB(255, 23, 111, 153),),
            ),
            SizedBox(height: 10,),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20), // Set left and right margins to 10

              child: MaterialButton(onPressed: () async {
                if(homeProvider.state == APIStatue.loading){
                  print(" APIStatue.loading ${homeProvider.state}");
                  CircularProgressIndicator();
                }else if(homeProvider.state == APIStatue.error)
                  ShowMessage().showSnackBar(context, homeProvider.errorMessage!);
              },
                minWidth: double.infinity,
                height: 50,
                textColor: Colors.white,
                child: Text(Strings.finance_trans),
                color: Color.fromARGB(255, 23, 111, 153),),
            )
          ],
        ),
      ),
    )
    );

  }




}