import 'package:desktop_erp_4s/ui/reports/ui/PieChartReport.dart';
import 'package:desktop_erp_4s/util/spinner_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../util/report_custom_spinner_dialog.dart';
import '../../../util/strings.dart' show Strings;
import '../../widgets/custom_spinner_dialog.dart';
import '../../widgets/show_message.dart';
import 'SyncfusionPieChartReport.dart';
import 'finance_balance_report_provider.dart';

class FinanceBalanceReport extends StatefulWidget {
  const FinanceBalanceReport({super.key});

  @override
  _FinanceBalanceReportState createState() => _FinanceBalanceReportState();
}

class _FinanceBalanceReportState extends State<FinanceBalanceReport> {
  late FinanceBalanceReportProvider provider;

  @override
  void initState() {
    super.initState();
    provider = FinanceBalanceReportProvider();
    provider.context = context;

    provider.initial().then((_) {
      setState(() {}); // علشان تعيد بناء الصفحة بعد تحميل البيانات
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "أرصده مالية", // refactor
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 23, 111, 153),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              //1.report to
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align children to the left
                  children: [
                    Container(
                      margin: EdgeInsets.all(7),
                      child: Text(
                        Strings.REPORT_ABOUT,
                        style: TextStyle(fontSize: 17, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 1),
                    InkWell(
                      onTap: () async {
                        // Fetch branches dynamically
                        /* final List<SpinnerModel> spinnerModel = await MapListModel().mapListToSpinnerModelList();
                         if (spinnerModel.length > 0) {*/
                        final result = await showDialog<SpinnerModel>(
                          context: context,
                          builder:
                              (context) => CustomSpinnerDialog(
                                spinnerModels: provider.getReportTypeList(),
                                onItemSelected: (items) {
                                  setState(() {
                                    provider.reportType = items;
                                  });
                                },
                              ),
                        );

                        if (result != null) {
                          setState(() {
                            provider.reportType = result;
                          });
                        }
                        /* else {
                           // Show a message if no items are available
                           ShowMessage().showSnackBar(
                             context,
                             Strings.ERROR_NO_DATA_FOUND,
                           );
                         }*/
                      },
                      child: Container(
                        margin: EdgeInsets.all(5),
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 15,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFFf7f7f7),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xFFDADADA),
                            width: 1.3,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              provider.reportType?.name ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                            Icon(Icons.arrow_drop_down, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1),

              //2.From & To Date
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align columns to the top if they have different heights
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(7),
                            child: Text(
                              Strings.FROM_DATE,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 1),
                          InkWell(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  provider.reportDataModel.fromDate =
                                      "${pickedDate.toLocal()}".split(' ')[0];
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              // width: double.infinity, // This is okay here because the parent Column's width
                              // is controlled by Expanded.
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFf7f7f7),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color(0xFFDADADA),
                                  width: 1.3,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    // << WRAP TEXT WIDGET WITH EXPANDED
                                    child: Text(
                                      provider.reportDataModel.fromDate == null
                                          ? ''
                                          : provider.reportDataModel.fromDate!
                                              .substring(0, 10)
                                              .replaceAll('-', '/'),
                                      overflow: TextOverflow.ellipsis,
                                      // Good to keep
                                      maxLines: 1,
                                      // Optional: ensure it's one line
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 10),
                    // Add spacing between the two containers
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(7),
                            child: Text(
                              Strings.TO_DATE,
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 1),
                          InkWell(
                            onTap: () async {
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  provider.reportDataModel.toDate =
                                      "${pickedDate.toLocal()}".split(' ')[0];
                                });
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              // width: double.infinity, // Okay here
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFf7f7f7),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color(0xFFDADADA),
                                  width: 1.3,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    // << WRAP TEXT WIDGET WITH EXPANDED
                                    child: Text(
                                      provider.reportDataModel.toDate == null
                                          ? ''
                                          : provider.reportDataModel.toDate!
                                              .substring(0, 10)
                                              .replaceAll('-', '/'),
                                      overflow: TextOverflow.ellipsis,
                                      // << ADD THIS TOO
                                      maxLines: 1,
                                      // Optional: ensure it's one line
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1),

              //3.From & To Report Type Fields
              Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // Align columns to the top if they have different heights
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(7),
                            child: Text(
                              "${Strings.FROM} ${provider.reportType?.name ?? ''}",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 1),
                          InkWell(
                            onTap: () async {
                              try {
                                final List<SpinnerModel> spinnerModel =
                                    await provider.getSpinnerModelListByIndex();

                                if (spinnerModel.isNotEmpty) {
                                  // Use dialogContext here
                                  final result = await showDialog<SpinnerModel>(
                                    useRootNavigator: false, //
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return ReportCustomSpinnerDialog(
                                        spinnerModels: spinnerModel,
                                        onItemSelected: (item) {
                                          provider.reportDataModel.fromName =
                                              item.name;
                                          provider.reportDataModel.fromCode =
                                              item.id;

                                        }, // no use now
                                      );
                                    },
                                  );

                                  if (result != null) {
                                    setState(() {
                                      provider.reportDataModel.fromName =
                                          result.name;
                                      provider.reportDataModel.fromCode =
                                          result.id;

                                    });
                                  }
                                } else {
                                  ShowMessage().showSnackBar(
                                    context,
                                    Strings.ERROR_NO_DATA_FOUND,
                                  );
                                }
                              } catch (e) {
                                print("Error fetching spinner models: $e");
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.all(5),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFf7f7f7),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: const Color(0xFFDADADA),
                                  width: 1.3,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                              "${provider.reportDataModel.fromName?? "${Strings.FROM} ${provider.reportType?.name ?? ''}"}",

                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    // Add spacing between the two containers
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.all(7),
                            child: Text(
                              "${Strings.TO} ${provider.reportType?.name ?? ''}",
                              style: TextStyle(
                                fontSize: 17,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 1),
                          InkWell(
                            onTap: () async {
                              try {
                                // Fetch spinner models
                                final List<SpinnerModel> spinnerModel =
                                    await provider.getSpinnerModelListByIndex();
                                if (spinnerModel.length > 0) {
                                  // Show dialog with fetched spinner models
                                  final result = await showDialog<SpinnerModel>(
                                    context: context,
                                    builder:
                                        (context) => CustomSpinnerDialog(
                                          spinnerModels: spinnerModel,
                                          onItemSelected: (item) {
                                            setState(() {
                                              provider.reportDataModel.toName =
                                                  item.name;
                                              provider.reportDataModel.toCode =
                                                  item.id;
                                            });
                                          },
                                        ),
                                  );

                                  if (result != null) {
                                    setState(() {
                                      provider.reportDataModel.toName =
                                          result.name;
                                      provider.reportDataModel.toCode =
                                          result.id;
                                    });
                                  }
                                } else {
                                  // Show a message if no items are available
                                  ShowMessage().showSnackBar(
                                    context,
                                    Strings.ERROR_NO_DATA_FOUND,
                                  );
                                }
                              } catch (e) {
                                print("Error fetching spinner models: $e");
                              }
                            },
                            child: Container(
                              margin: EdgeInsets.all(5),
                              // width: double.infinity, // Okay here
                              padding: EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 15,
                              ),
                              decoration: BoxDecoration(
                                color: Color(0xFFf7f7f7),
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Color(0xFFDADADA),
                                  width: 1.3,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    // << WRAP TEXT WIDGET WITH EXPANDED
                                    child: Text(
                                      "${provider.reportDataModel.toName?? "${Strings.TO} ${provider.reportType?.name ?? ''}"}",
                                      overflow: TextOverflow.ellipsis,
                                      // << ADD THIS TOO
                                      maxLines: 1,
                                      // Optional: ensure it's one line
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  if (provider.validateForm()) {
                    // استني لما الداتا ترجع
                    await provider.getFinanceBalanceReport();

                    // استخدمي WidgetsBinding علشان تضمني إن الـ UI خلص بناءه
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() {});
                    });
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 23, 111, 153),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    Strings.SHOW_REPORT,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

// ✅ الرسم البياني داخل Box ثابت
              if (provider.financeBalanceReportList.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Center(
                    child: SizedBox(
                      height: 300,
                      width: 300, // ✅ مهم جدًا
                      child: SyncfusionPieChartReport(agents: provider.financeBalanceReportList),
                    ),
                  ),
                ),

              /*   InkWell(
                  onTap: () async {
                    if (provider.validateForm()) {
                      await provider.getFinanceBalanceReport(); // ✅ استنى الداتا
                      if (mounted) setState(() {}); // ✅ بعد ما الداتا تجهز، ارسم الصفحة
                    }
                  },
                *//*onTap: () async {
                  if (provider.validateForm()) {
                    await provider.getFinanceBalanceReport();
                    setState(() {});
                  }
                }*//*
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 23, 111, 153),
                  ),
                  child: Text(
                    Strings.SHOW_REPORT,
                    style: TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Visibility(
                visible: provider.financeBalanceReportList.isNotEmpty,
                child: SizedBox(
                  height: 300, // ✅ حددّي حجم واضح للـ Chart
                  child: PieChartReport(data: provider.financeBalanceReportList),
                ),
              )*/
            ],
          ),
        ),
      ),
    );
  }
}
