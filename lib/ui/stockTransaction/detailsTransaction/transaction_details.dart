import 'package:desktop_erp_4s/data/models/branch_model.dart';
import 'package:desktop_erp_4s/data/models/response/TransactionSpec.dart';
import 'package:desktop_erp_4s/util/loading_service.dart'; // Assuming this is used or was intended
import 'package:desktop_erp_4s/util/my_app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/api/api_constansts.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/request/transaction_creating_model.dart';
import '../../../util/navigation.dart';
import '../../../util/strings.dart';
import '../../widgets/show_message.dart';
import '../stock_transaction_list.dart';
import '../transactionForm/transaction_form.dart';
import '../transactionForm/transaction_form_provider.dart';

// If you have a specific model for items in TransactionCreatingModel, import it too
// import '../../../data/models/request/item_creating_model.dart';
// import '../../widgets/show_message.dart'; // If you want to use ShowMessage for errors

class TransactionDetails extends StatefulWidget {
  final TransactionSpec transactionSpec;
  final String branch;
  final String transCode;
  final int transNo;
  final bool isDetails;
  Branches? selectedBranch;

  TransactionDetails({
    Key? key,
    required this.transactionSpec,
    required this.branch,
    required this.transCode,
    required this.transNo,
    required this.isDetails,
  }) : super(key: key);

  @override
  State<TransactionDetails> createState() => _TransactionDetailsState();
}

class _TransactionDetailsState extends State<TransactionDetails> {
  TransactionCreatingModel? _transDetails;
  bool _isLoading = true;
  String? _errorMessage; // Optional: to display specific errors

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchTransactionDetails();
    });
  }

  Future<void> _fetchTransactionDetails() async {
    if (!mounted) return; // Don't do anything if the widget is disposed

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous error
    });

    try {
      final apiResult = await APIService().getOneStoreTrans(
        widget.branch,
        widget.transCode,
        widget.transNo.toString(),
      );

      if (!mounted) return; // Check again after await
      if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
        // Handle unauthorized access
        print("Unauthorized access");
        ShowMessage().showSnackBar(context, apiResult.msg!);
        // You can navigate to the login screen or show a message
        Navigation().logout(context);
      } else {
        if (apiResult.status == true && apiResult.data != null) {
          if (apiResult.data is TransactionCreatingModel) {
            setState(() {
              _transDetails = apiResult.data as TransactionCreatingModel;

              // to refactor
              widget.selectedBranch?.code = _transDetails?.branch!;
              widget.selectedBranch?.descr = _transDetails?.descr!;
            });
          } else {
            print(
              "Error: API success but data is not TransactionCreatingModel. Actual type: ${apiResult.data?.runtimeType}",
            );
            setState(() {
              _errorMessage = "Invalid data format received from server.";
            });
          }
        } else {
          print("API call failed or no data: ${apiResult.msg}");
          setState(() {
            _errorMessage = apiResult.msg ?? "Failed to load details.";
          });
        }
      }
    } catch (e, stackTrace) {
      print("Error fetching transaction details: $e\n$stackTrace");
      if (!mounted) return;
      setState(() {
        _errorMessage = "An unexpected error occurred.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget bodyContent;

    if (_isLoading) {
      bodyContent = const Center(child: CircularProgressIndicator());
    } else if (_errorMessage != null) {
      bodyContent = Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else if (_transDetails == null) {
      // This case should ideally be covered by _errorMessage if fetching fails
      bodyContent = const Center(
        child: Text(
          Strings.NO_TRANS_DETAILS,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      );
    } else {
      // Data is loaded and no errors, _transDetails is not null
      // It's now safe to use _transDetails!
      bodyContent = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: !widget.isDetails,
              child: const Text(
                Strings.SUCCESS_TRANSACTION_DONE,
                // This could be dynamic based on actual status if needed
                style: TextStyle(
                  color: const Color.fromARGB(255, 31, 165, 39),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // البيانات الأساسية
            Column(
              children: [
                Container(
                  width: 400,
                  height: 300,
                  child: Card(
                    margin: EdgeInsets.all(20.0),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "البيانات الأساسية",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "الفرع-الكود-الرقم",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          // Safely accessing properties of _transDetails!
                          Text(
                            "${_transDetails!.branch ?? 'N/A'}-${_transDetails!.trnsCode ?? 'N/A'}-${_transDetails!.trnsNo ?? 'N/A'}",
                          ),

                          const Text(
                            "التاريخ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(_transDetails!.trnsDate?.toString() ?? 'N/A'),

                          // Format DateTime appropriately
                          Visibility(
                            visible: _transDetails!.toName != null,
                            child: Text(
                              "الطرف من",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Visibility(
                            visible: _transDetails!.toName != null,
                            child: Text(_transDetails!.toName ?? ''),
                          ),

                          Visibility(
                            visible: _transDetails!.fromName != null,
                            child: Text(
                              "الطرف إلى",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Visibility(
                            visible: _transDetails!.fromName != null,
                            child: Text(_transDetails!.fromName ?? ''),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),

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
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("المجموعة"),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("الصنف"),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("السعر"),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("الكمية"),
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: Text("الإجمالي"),
                        ),
                      ),
                    ],
                  ),
                  // Assuming _transDetails.items is List<ItemCreatingModel>?
                  // and ItemCreatingModel has relevant properties.
                  if (_transDetails!.storeTrnsOModels != null &&
                      _transDetails!.storeTrnsOModels!.isNotEmpty)
                    ..._transDetails!.storeTrnsOModels!.map((item) {
                      return TableRow(
                        children: [
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(item.formDesc ?? 'N/A'),
                            ),
                          ),
                          // Example: item.groupName
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(item.itemDesc ?? 'N/A'),
                            ),
                          ),
                          // Example: item.itemName
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                item.depQty1?.toStringAsFixed(2) ?? '0.00',
                              ),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(item.qty1?.toString() ?? '0'),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                (item.depQty1! * item.qty1!).toStringAsFixed(
                                      2,
                                    ) ??
                                    '0.00',
                              ),
                            ),
                          ),
                          // Example: item.totalValue
                        ],
                      );
                    }).toList()
                  else
                    const TableRow(
                      // Show if no items
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text("لا توجد أصناف"),
                          ), // colSpan is not a direct property, handle layout
                        ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "الإجمالي: ${_transDetails!.trnsVal?.toStringAsFixed(2) ?? '0.00'}",
                    ),
                    // Text("خصم الأصناف: ${_transDetails!.itemDiscountVal?.toStringAsFixed(2) ?? '0.00'}"), // Assuming these fields exist in model
                    //Text("خصم الإجمالي: ${_transDetails!.trnsDiscVal?.toStringAsFixed(2) ?? '0.00'}"),   // Assuming these fields exist in model
                    const Divider(),
                    Text(
                      "الصافي: ${_transDetails!.trnsNet?.toStringAsFixed(2) ?? '0.00'}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // Assuming trnsNet
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            OutlinedButton(
              onPressed: () {
                /* TODO: Implement print settings */

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => ChangeNotifierProvider(
                      create: (_) => TransactionFormProvider(),
                      // Create a new instance
                      child: TransactionForm(
                        selectedBranch: widget.selectedBranch,
                        transactionSpec: widget.transactionSpec,
                      ),
                    ),
                  ),
                );

               /* if (widget.transactionSpec.allowMobileEdit ==
                    Strings.ALLOW_EDIT) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ChangeNotifierProvider(
                            create: (_) => TransactionFormProvider(),
                            // Create a new instance
                            child: TransactionForm(
                              selectedBranch: widget.selectedBranch,
                              transactionSpec: widget.transactionSpec,
                            ),
                          ),
                    ),
                  );
                } else {
                  ShowMessage().showSnackBar(
                    context,
                    Strings.NOT_ALLOW_TO_EDIT_TRANSACTION,
                  );
                }*/
              },
              child: const Text(Strings.EDIT_TRANS),
            ),

            const SizedBox(height: 20),

            Visibility(
              visible: false,
              child: Container(
                child: Column(
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        /* TODO: Implement print settings */
                      },
                      child: const Text("إعدادات الطباعة"),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        /* TODO: Implement print action */
                      },
                      child: const Text("طباعة"),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 50),

            // Buttons
          ],
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: MyAppColor.textColorWhite),
            onPressed: () {
              if (widget.isDetails) {
                Navigator.pop(context);
              } else {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StockTransactionList(),
                  ),
                  (Route<dynamic> route) => false,
                );
              }
            },
          ),
          title: Text(
            widget.transactionSpec.trnsDesc!,
            style: TextStyle(color: MyAppColor.textColorWhite),
          ),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 23, 111, 153),
        ),
        body: bodyContent,
      ),
    );
  }
}

// Make sure your TransactionCreatingModel and ItemCreatingModel have the fields
// you are trying to access (e.g., branch, trnsCode, trnsNo, trnsDate, items,
// groupName, itemName, price, qty, totalVal, trnsVal, itemDiscountVal, trnsDiscVal, trnsNet).
// Example structure:

/*
class TransactionCreatingModel {
  String? branch;
  String? trnsCode;
  String? trnsNo; // Or int?
  DateTime? trnsDate;
  String? toName;
  String? fromName;
  List<ItemCreatingModel>? items;
  double? trnsVal;
  double? itemDiscountVal;
  double? trnsDiscVal;
  double? trnsNet;

  TransactionCreatingModel({
    this.branch,
    this.trnsCode,
    this.trnsNo,
    this.trnsDate,
    this.toName,
    this.fromName,
    this.items,
    this.trnsVal,
    this.itemDiscountVal,
    this.trnsDiscVal,
    this.trnsNet,
  });

  factory TransactionCreatingModel.fromJson(Map<String, dynamic> json) {
    return TransactionCreatingModel(
      branch: json['branch'] as String?,
      trnsCode: json['trns_code'] as String?,
      trnsNo: json['trns_no']?.toString(), // Adjust parsing as needed
      trnsDate: json['trns_date'] != null ? DateTime.tryParse(json['trns_date'] as String) : null,
      toName: json['to_name'] as String?,
      fromName: json['from_name'] as String?,
      items: (json['items'] as List<dynamic>?)
          ?.map((itemJson) => ItemCreatingModel.fromJson(itemJson as Map<String, dynamic>))
          .toList(),
      trnsVal: (json['trns_val'] as num?)?.toDouble(),
      itemDiscountVal: (json['item_discount_val'] as num?)?.toDouble(),
      trnsDiscVal: (json['trns_disc_val'] as num?)?.toDouble(),
      trnsNet: (json['trns_net'] as num?)?.toDouble(),
    );
  }
}

class ItemCreatingModel {
  String? groupName;
  String? itemName;
  double? price;
  double? qty;
  double? totalVal;

  ItemCreatingModel({this.groupName, this.itemName, this.price, this.qty, this.totalVal});

  factory ItemCreatingModel.fromJson(Map<String, dynamic> json) {
    return ItemCreatingModel(
      groupName: json['group_name'] as String?, // Adjust keys to match your JSON
      itemName: json['item_name'] as String?,   // Adjust keys
      price: (json['price'] as num?)?.toDouble(),
      qty: (json['qty'] as num?)?.toDouble(),
      totalVal: (json['total_val'] as num?)?.toDouble(),
    );
  }
}
*/

/*import 'package:desktop_erp_4s/util/loading_service.dart';
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
      */ /*} else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
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
    }*/ /*
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

}*/
