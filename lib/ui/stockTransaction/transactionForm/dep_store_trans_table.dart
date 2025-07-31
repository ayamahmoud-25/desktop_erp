import 'package:desktop_erp_4s/data/models/request/dependency_trans_list.dart';
import 'package:flutter/material.dart';

import '../../../data/models/request/transaction_creating_model.dart';
import '../../../data/models/response/StoreTrnsOModel.dart';
import '../../../ui/stockTransaction/transactionForm/add_item_dialog.dart';
import '../../../ui/stockTransaction/transactionForm/transaction_form_provider.dart';
import '../../../util/strings.dart';

class DepStoreTransTable extends StatelessWidget {
  final TransactionFormProvider transactionFormProvider;

  const DepStoreTransTable({Key? key, required this.transactionFormProvider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),

      child:Center(child: SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Enable horizontal scroll if needed
          child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: BorderRadius.circular(5.0),
              ),child:
          DataTable(
            showCheckboxColumn: false, // Disable checkbox column
            headingTextStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            columns: const [
              DataColumn(label:Center(child: Text(Strings.BRANCH))),
              DataColumn(label:Align(alignment: Alignment.center,child: Text(Strings.CODE))),
              DataColumn(label:Center(child: Text(Strings.NUMBER))),
              DataColumn(label:Center(child: Text(Strings.TIME))),
            ],
            rows:transactionFormProvider.dependencyTransList.asMap().entries.map((entry){
              int index = entry.key;
              DependencyTransList dependencyTrans = entry.value;

              return DataRow(
                // Use selected: false to disable selection highlight and checkbox

                /*selected: false, // Do not show selection highlight or checkbox
                onSelectChanged: (selected) async {
                  if (selected == true) {
                    print("storeTrans: ${storeTrans.itemName}+" "+${storeTrans.itemCode}");

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
                             *//* transactionFormProvider.removeStoreTransOModel(index);
                              Navigator.of(context).pop(true);*//*
                            },
                            child: Text(Strings.Delete),
                          ),
                          TextButton(
                            onPressed: () {
                             *//* showDialog<StoreTrnsOModel>(
                                context: context,
                                builder: (context) => AddItemDialog(
                                  tfProvider: transactionFormProvider,
                                  editingItem: storeTrans, // Pass the item to edit
                                ),
                              );*//*
                              //  Navigator.of(context).pop(); // Dismiss the dialog after action
                            },
                            child: Text(Strings.UPDATE),
                          ),
                        ],
                      ),
                    );
                  }
                },*/
                cells: [
                  DataCell(Align(alignment: Alignment.center, child: Text(dependencyTrans.branch ?? '-'))),
                  DataCell(Align(alignment: Alignment.center, child: Text(dependencyTrans.trnsCode ?? '-'))),
                  DataCell(Align(alignment: Alignment.center, child: Text(dependencyTrans.trnsNo.toString() ?? '0'))),
                  DataCell(Align(alignment: Alignment.center, child: Text(dependencyTrans.dateTime?? '0'))),

                ],
              );
            }).toList(),
          ))),
      ),
    );
  }
}
