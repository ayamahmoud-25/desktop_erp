import 'package:desktop_erp_4s/util/loading_service.dart';
import 'package:flutter/material.dart';

import '../../../data/api/api_service.dart';
import '../../../data/models/request/transaction_creating_model.dart';
import '../../../data/models/response/TransactionDetailsResponseModel.dart';
import '../../widgets/show_message.dart';

class TransactionDetails extends StatefulWidget {
  final String transName;

  final String branch;
  final String transCode;
  final int transNo;



  const TransactionDetails({Key? key,
    required this.transName,
    required this.branch,
    required this.transCode,
    required this.transNo,
    }) : super(key: key);
  
  
  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}


class _TransactionDetailsState extends State<TransactionDetails> {
  TransactionCreatingModel? _transDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Use addPostFrameCallback to ensure context is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoadingService.showLoading(context); // Show dialog loader
      getTransactionOneDetails();
    });


    
    // call api to get details

  }

  Future<void> getTransactionOneDetails() async {
    //showLoading();
    final apiResult = await APIService().getOneStoreTrans(widget.branch,widget.transCode,widget.transNo.toString());

    if (apiResult.status == true && apiResult.data != null) {
      //hideLoading();
      LoadingService.showLoading(context); // Show dialog loader
      // Map API response to SpinnerModel list
      //List<ItemList> itemList = apiResult.data.items;`
      //TransactionDepListResponseModel transactionDepListResponseModel = apiResult.data;


      _transDetails = apiResult.data;

      // ShowMessage().showSnackBar(context, apiResult.msg!);

      // Navigate to transaction details
      ///Navigation().navigateToTransactionDetails(context!,_transaction.trnsCode! ,transactionDeOnData!.trnsNo!);

      // Return the spinner model list
      // return transactionDeOnData;
      /*} else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
      // Handle unauthorized access
      print("Unauthorized access");
      ShowMessage().showSnackBar(_context!, apiResult.msg!);
      // You can navigate to the login screen or show a message
      Navigation().logout(_context!);
      return TransactionDetailsResponseModel();
    } else {
      ShowMessage().showToast(apiResult.msg!);
      // Handle other cases, such as API failure or no data
      print("API call failed or no data");
      return TransactionDetailsResponseModel();
      ;
    }*/
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transName),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "تمت بنجاح",
              style: TextStyle(
                color: Colors.green,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // البيانات الأساسية
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("البيانات الأساسية", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                    const SizedBox(height: 8),

                    const Text("الفرع-الكود-الرقم",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${_transDetails!.branch}-${_transDetails!.trnsCode}-${_transDetails!.trnsNo}"),

                    const Text("التاريخ",style: TextStyle(fontWeight: FontWeight.bold)),
                    Text("${_transDetails!.trnsDate}"),

                    Visibility(visible:(_transDetails?.toName!=null)?true: false,
                        child: Text("الطرف من",style: TextStyle(fontWeight: FontWeight.bold))),

                    Visibility(visible:(_transDetails?.toName!=null)?true: false,
                        child: Text("${_transDetails?.toName}")),

                    Visibility(visible:(_transDetails?.fromName!=null)?true: false,
                        child: Text("الطرف إلى",style: TextStyle(fontWeight: FontWeight.bold))),

                    Visibility(visible:(_transDetails?.fromName!=null)?true: false,
                        child: Text("${_transDetails?.fromName}"))
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // جدول الأصناف
            Card(
              child: Table(
                border: TableBorder.all(color: Colors.black),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(3),
                  4: FlexColumnWidth(3),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
                    children: [
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("المجموعة"))),
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("الصنف"))),
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("السعر"))),
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("الكمية"))),
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("الإجمالي"))),
                    ],
                  ),
                  const TableRow(
                    children: [
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("منتج تام"))),
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("لانشون بالزيتون 400 جم الطاهى"))),
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("50.0"))),
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("0.0 كمية"))),
                      Center(child: Padding(padding: EdgeInsets.all(8), child: Text("0.00"))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // الإجماليات
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: const [
                    Text("الإجمالي: 150.0"),
                    Text("خصم الأصناف: 7.5"),
                    Text("خصم الإجمالي: 2.0"),
                    Divider(),
                    Text("الصافي: 139.5", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Buttons
            OutlinedButton(
              onPressed: () {},
              child: const Text("إعدادات الطباعة"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text("طباعة"),
            ),
          ],
        ),
      ),
    );
  }

  void showLoading(){
    LoadingService.showLoading(context); // Hide custom loading dialog
  }

  void hideLoading(){
    LoadingService.hideLoading(context); // Hide custom loading dialog
  }

}
