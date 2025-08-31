import 'package:desktop_erp_4s/ui/stockTransaction/showTransaction/show_transaction_list.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/transactionForm/transaction_form.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/transactionForm/transaction_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/branch_model.dart';
import '../../data/models/response/TransactionSpec.dart';
import '../../db/SharedPereference.dart';
import '../../db/database_helper.dart';
import '../widgets/custom_alert_dialog.dart';
import '../../util/strings.dart';
import '../home/branches/BranchListDialog.dart';

class StockTransactionList extends StatefulWidget {

  const StockTransactionList({Key? key}) : super(key: key);

  @override
  _StockTransactionListState createState() => _StockTransactionListState();

}

class _StockTransactionListState extends State<StockTransactionList> {
  // Initialize any necessary data or state here
  Branches? selectedBranch ;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = SharedPreferences();
      Branches savedSelectedBranch = await prefs.loadSelectedBranch() ?? Branches();
      // If a branch was previously selected, you can handle it here
      print('Previously selected branch: $savedSelectedBranch');
      setState(() {
        this.selectedBranch = savedSelectedBranch;});
        });
  }

  // Initialize any necessary data or state here  }
  Future<List<TransactionSpec>> fetchTransactionSpecs() async {
    final dbHelper = DatabaseHelper();
    final rows = await dbHelper.getAll('transaction_specs');
    List<TransactionSpec> transactionSpecs = rows.map((map) => TransactionSpec.fromJson(map)).toList();
    print("Before sorting (raw string codes): ${transactionSpecs.map((spec) => spec.trnsCode).toList()}");

    transactionSpecs.sort((a, b) {
      // Both trnsCode are String?
      final String? codeA = a.trnsCode;
      final String? codeB = b.trnsCode;

      // 1. Handle nulls first
      if (codeA == null && codeB == null) return 0; // Both null, equal
      if (codeA == null) return -1; // Nulls first (or 1 for nulls last)
      if (codeB == null) return 1;  // Nulls first (or -1 for nulls last)

      // 2. Attempt to parse strings to integers
      int? numA = int.tryParse(codeA);
      int? numB = int.tryParse(codeB);

      // 3. Compare based on successful parsing
      if (numA != null && numB != null) {
        // Both are valid numbers, compare them numerically
        return numA.compareTo(numB);
      } else if (numA != null && numB == null) {
        // codeA is a number, codeB is not (or unparseable string). Numbers come first.
        return -1;
      } else if (numA == null && numB != null) {
        // codeB is a number, codeA is not. Numbers come first.
        return 1;
      } else {
        // Neither could be parsed as an int (or they are unparseable strings like "abc").
        // Fallback to standard string comparison for these non-numeric strings.
        // This ensures "abc" is sorted relative to "xyz" correctly.
        return codeA.compareTo(codeB);
      }
    });

    print("After sorting (attempted numeric string sort): ${transactionSpecs.map((spec) => spec.trnsCode).toList()}");

    return transactionSpecs;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            Strings.TRANS_STOCK,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 23, 111, 153),
          iconTheme: IconThemeData(
            color: Colors.white,
          ), // Set back button color to white
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.only(top: 10, right: 10),
              alignment: Alignment.topRight,
              child: Text(Strings.CHANGE_BRANCH,
                  style: TextStyle(
                      fontSize: 15,
                      color:Colors.black,
            ),),),
            InkWell(
              onTap: () {
                showBranchListDialog(context);
              }, // Show branch list dialog when tapped,
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 50,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFEEEEEE), width: 1),
                    bottom: BorderSide(
                      color: Color(0xFFEEEEEE),
                      width: 1,
                    ), // Set the color and width of the bottom border
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // Space between elements
                  children: [
                    Container(
                      margin: EdgeInsets.only(right: 20),
                      child: Text(selectedBranch != null && selectedBranch!.descr != null
                          ? "${selectedBranch!.descr}"
                          : Strings.SELECT_BRANCH, // Default text if no branch is selected
                        // Display selected branch or prompt to select
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Icon(
                        Icons.manage_search,
                        color: Color.fromARGB(255, 23, 111, 153),
                      ),
                    ), // Back button
                  ],
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<TransactionSpec>>(
                future: fetchTransactionSpecs(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No Transaction Specs found.'),
                    );
                  } else {
                    final transactionSpecs = snapshot.data!;
                    return ListView.separated(
                      itemCount: transactionSpecs.length,
                      separatorBuilder: (context, index) {
                        return Divider(
                          color: Color(0xFFC7C6C6),
                          // Set the color of the divider
                          thickness: 1,
                          // Set the thickness of the divider
                          height: 0,
                        );
                      },
                      itemBuilder: (context, index) {
                        final spec = transactionSpecs[index];
                        return StockTransactionListRow(
                          selectedBranch: selectedBranch,
                          transactionSpec: spec,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showBranchListDialog(BuildContext context) async {
    Branches? selectedBranch = await showDialog<Branches>(
      context: context,
      barrierDismissible: false,
      // Prevent dismissing the dialog by clicking outside
      builder: (context) => BranchListDialog(),
    );

    if (selectedBranch != null) {
      SharedPreferences prefs = SharedPreferences();
      prefs.saveSelectedBranch(selectedBranch);
      setState(() {
        this.selectedBranch = selectedBranch;
      });
    }
  }
}

// This widget is used to display a single row in the transaction list
class StockTransactionListRow extends StatelessWidget {
  final TransactionSpec transactionSpec;
  final Branches? selectedBranch;

  const StockTransactionListRow({Key? key, required this.selectedBranch,required this.transactionSpec})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    String transDesc =
        " (${transactionSpec.trnsCode}) ${transactionSpec.trnsDesc ?? 'No Description'}";
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Space between elements
        children: [
          Row(
            children: [
              Container(width: 8, height: 8, color: Color(0xFF2B86B4)),
              // Colored square
              Text(
                transDesc,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              MaterialButton(
                onPressed: () {
                  // Handle button press
                  if( selectedBranch==null || selectedBranch!.code==null) {
                    CustomAlertDialog().showAlertDialog(context);
                  }else{
                    //navigate to transaction form page
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionForm(
                          selectedBranch: selectedBranch!,
                          transactionSpec: transactionSpec,
                        ),
                      ),
                    );*/
                    //navigate to transaction form page
                    // Use ChangeNotifierProvider to create a new instance of TransactionFormProvider
                    // and pass it to the TransactionForm widget
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangeNotifierProvider(
                          create: (_) => TransactionFormProvider(), // Create a new instance
                          child: TransactionForm(
                            selectedBranch: selectedBranch,
                            transactionSpec: transactionSpec,
                          ),
                        ),
                      ),
                    );

                  }
                },
                textColor: Colors.white,
                child: Text(Strings.New),
                color: const Color(0xFF176F99),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  // Handle menu item selection
                  if (value == 'Show') {
                      if(selectedBranch==null || selectedBranch!.code==null) {
                        CustomAlertDialog().showAlertDialog(context);
                      }else{
                        //navigate to show transaction page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShowTransactionList(
                                selectedBranch: selectedBranch!.code!,
                                transCode: transactionSpec.trnsCode!,
                                transName: transactionSpec.trnsDesc!,
                              ),
                            ),
                          );
                      }
                    // Perform edit action
                  } else if (value == 'Approve') {
                    if(selectedBranch==null || selectedBranch!.code==null) {
                      CustomAlertDialog().showAlertDialog(context);
                    }else{
                      //navigate to the transaction approval page
                    }
                  }
                },
                itemBuilder: (BuildContext context) {
                  List<PopupMenuEntry<String>> items = [];
                  // Add 'Edit' item based on condition
                  if (transactionSpec.needApprove == Strings.APPROVED) {
                    items.add(
                      PopupMenuItem(
                        value: 'Approve',
                        child: Text(Strings.TRANS_APPROVED),
                      ),
                    );
                  }
                  // Add 'View' item always
                  items.add(
                    PopupMenuItem(
                      value: 'Show',
                      child: Text(Strings.TRANS_SHOW),
                    ),
                  );
                  return items;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}


