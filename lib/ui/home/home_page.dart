
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/api_state.dart';
import '../../data/models/branch_model.dart';
import '../../db/SharedPereference.dart';
import '../../db/database_helper.dart';
import '../../util/loading_service.dart';
import '../../util/navigation.dart';
import '../reports/report_type.dart';
import '../reports/ui/demo/dash_board_page.dart';
import '../widgets/show_message.dart';
import '../../util/strings.dart';
import 'branches/BranchListDialog.dart';
import 'home_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? authToken;
  String? username;
  String? userId;


  @override
  void initState() {
    super.initState();
    initialValue();

  }

  void initialValue()async {
    authToken = await SharedPreferences().loadAccessToken();
    username = await SharedPreferences().loadUserNameId();
    userId = await SharedPreferences().loadUserId();

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
            Row(
              children: [

                SizedBox(width: 8),
                Column(
                  children: [
                    Text(
                      username ?? "Loading...",  // your username
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      userId ?? "Loading...",  // your username
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                SizedBox(width: 16),
              CircleAvatar(
                radius: 16,
                backgroundColor: Colors.white,
                child: Icon(Icons.person,
                    color: Color.fromARGB(255, 23, 111, 153)),
              ),
              ],
            ),

            // your existing menu
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == Strings.POP_MENU_ITEM_REPORTS) {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => ReportType()));
                } else if (value == Strings.POP_MENU_ITEM_LOGOUT) {
                  DatabaseHelper().clearDatabase();
                  Navigation().logout(context);
                }
              },
              itemBuilder: (_) => [
                PopupMenuItem(
                    value: Strings.POP_MENU_ITEM_REPORTS,
                    child: Text(Strings.POP_MENU_ITEM_REPORTS)),
                PopupMenuItem(
                    value: Strings.POP_MENU_ITEM_SETTINGS,
                    child: Text(Strings.POP_MENU_ITEM_SETTINGS)),
                PopupMenuItem(
                    value: Strings.POP_MENU_ITEM_LOGOUT,
                    child: Text(Strings.POP_MENU_ITEM_LOGOUT)),
              ],
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
                    //CircularProgressIndicator();
                    LoadingService.showLoading(context);
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