import 'package:flutter/material.dart';

import '../../../data/models/request/transaction_creating_model.dart';
import '../../../data/models/response/StoreTrnsOModel.dart';
import '../../../ui/stockTransaction/transactionForm/add_item_dialog.dart';
import '../../../ui/stockTransaction/transactionForm/transaction_form_provider.dart';
import '../../../util/strings.dart';

class StoreTransTable extends StatelessWidget {
  final TransactionFormProvider transactionFormProvider;
  final void Function(int index, StoreTrnsOModel item,bool isDelete) oneEditOrDeleteItemRequested;

 // const StoreTransTable({Key? key, required this.transactionFormProvider}) : super(key: key);
  const StoreTransTable({
    Key? key,
    required this.transactionFormProvider,
    required this.oneEditOrDeleteItemRequested, // Parent MUST provide a function for this
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final showTotal = transactionFormProvider.transactionSpec!.showPrice == 1;

    // Placeholder for any values you want to calculate for the footer
    // For example:
    // int totalItemCount = transactionFormProvider.storeTransOModelList.length;
    // double grandTotalValue = transactionFormProvider.storeTransOModelList.fold(0, (sum, item) => sum + (item.total ?? 0));

    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Center(
        child: Container( // This is the container with the border
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black, width: 1.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Column( // <--- New Column to hold DataTable and Footer
            mainAxisSize: MainAxisSize.min, // Important to keep the column compact
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make children stretch horizontally
            children: [
              SingleChildScrollView( // Your existing DataTable
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  showCheckboxColumn: false,
                  headingTextStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                  columns: [
                    const DataColumn(label: Center(child: Text(Strings.GROUP))),
                    const DataColumn(label: Align(alignment: Alignment.center, child: Text(Strings.ITEM))),
                    const DataColumn(label: Center(child: Text(Strings.QTY))),
                    if (showTotal) const DataColumn(label: Center(child: Text(Strings.PRICE))),
                    if (showTotal) const DataColumn(label: Center(child: Text(Strings.TOTAL))),
                  ],
                  rows: transactionFormProvider.storeTransOModelList.asMap().entries.map((entry) {
                    // ... your existing DataRow generation code ...
                    // (This part remains unchanged)
                    int index = entry.key;
                    StoreTrnsOModel storeTrans = entry.value;
                    //storeTrans.total = (storeTrans.unitPrice! * storeTrans.qty1!);

                    return DataRow(
                      selected: false,
                      onSelectChanged: (selected) async {
                        if (selected == true) {
                          // Show dialog when row is tapped
                          await showDialog(

                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(Strings.TITLE_DELETE_ITEM),
                              content: Text(
                                  Strings.CONTENT_MESSAGE
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      // transactionFormProvider.removeStoreTransOModel(index);
                                      Navigator.of(context).pop(); // Dismiss the AlertDialog
                                      oneEditOrDeleteItemRequested(index,storeTrans,true); // 'index' is the entry.key for the row
                                    },
                                    child: Text(Strings.Delete)//حذف,
                                ),
                                TextButton(
                                  onPressed: () async {

                                    // 1. Dismiss the current small confirmation dialog
                                    Navigator.of(context).pop(); // Dismisses the AlertDialog (Delete/Update)
                                    //2. update
                                    final updatedItem = await showDialog<StoreTrnsOModel>(
                                      context: context,
                                      builder:
                                          (context) => AddItemDialog(
                                        //transactionSpec:obj.transactionSpec!,
                                        tfProvider: transactionFormProvider,
                                        editingItem: storeTrans,
                                        //  allItemsFormsList: obj.allItemsFormsList,
                                        // itemForm: obj.transaction.itemForm,
                                      ),
                                    );
                                    oneEditOrDeleteItemRequested(index,updatedItem!,false); // 'index' is the entry.key for the row
                                  },
                                  child: Text(Strings.UPDATE),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      cells: [
                        DataCell(Align(alignment: Alignment.center, child: Text(storeTrans.formDesc ?? '-'))),
                        DataCell(Align(alignment: Alignment.center, child: Text(storeTrans.itemDesc ?? '-'))),
                        DataCell(Align(alignment: Alignment.center, child: Text(storeTrans.qty1?.toString() ?? '0'))),
                        if (showTotal) DataCell(Center(child: Text(storeTrans.unitPrice?.toString() ?? '0'))),
                        if (showTotal) DataCell(Center(child: Text(storeTrans.total.toString()))),
                      ],
                    );
                  }).toList(),
                ),
              ),

              // --- Footer Section ---
              Divider(height: 1, thickness: 1, color: Colors.black), // Optional visual separator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0), // Adjust padding as needed
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            Strings.TOTAL, // Replace with your actual content
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start, // Or .center, .end
                          ),
                        ),
                        Expanded(
                          child: Text(
                            transactionFormProvider.calculateTotal(), // Replace with your actual content
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end, // Or .center, .start
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(

                            Strings.ITEM_DISCOUNT, // Replace with your actual content
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start, // Or .center, .end
                          ),
                        ),
                        Expanded(
                          child: Text(
                            Strings.VALUE_NO, // Replace with your actual content
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end, // Or .center, .start
                          ),
                        ),
                      ],
                    )

                  ],
                ),
              ),
              // --- End Footer Section ---
            ],
          ),
        ),
      ),
    );
  }




}
