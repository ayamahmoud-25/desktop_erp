
import 'package:desktop_erp/ui/reports/ui/demo/dash_board_page.dart';
import 'package:desktop_erp/ui/reports/ui/finace_balance_report.dart';
import 'package:flutter/material.dart';
import '../../util/helper.dart';
import '../../util/my_app_color.dart';
import '../../util/strings.dart';

class ReportType extends StatelessWidget {
  const ReportType({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl,
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: MyAppColor.backgroundColor,
        title:  Text(Strings.REPORT,style: TextStyle(color: MyAppColor.whiteColor),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: MyAppColor.whiteColor),
          onPressed: () {
            Navigator.pop(context); // زر الرجوع
          },
        ),
      ),
      body: /*Center(
        child:*/  Column(children: [
        Container(
          margin: EdgeInsets.fromLTRB(20, 100, 20, 5), // Set left and right margins to 10
          child: MaterialButton(
            minWidth: double.infinity,
            height: 50,
            onPressed: ()  {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FinanceBalanceReport(),
                ),
              );
            },
            textColor: Colors.white,
            child: Text(Strings.REPORT_FINANCE_BALANCE),
            color: Color.fromARGB(255, 23, 111, 153),),
        ),
        Container(
          margin: EdgeInsets.fromLTRB(20, 100, 20, 5), // Set left and right margins to 10
          child: MaterialButton(
            minWidth: double.infinity,
            height: 50,
            onPressed: ()  {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardPage(agents: Helper().getListOfAgentData()),
                ),
              );
            },
            textColor: Colors.white,
            child: Text(Strings.REPORT_FINANCE_BALANCE_DEMO),
            color: Color.fromARGB(255, 23, 111, 153),),
        )

      ],

      )));

    //));
  }
}
