import 'package:desktop_erp_4s/ui/stockTransaction/transactionForm/dep_store_trans_table.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/transactionForm/store_trans_table.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/transactionForm/transaction_dep_list_dialog.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/transactionForm/transaction_form_provider.dart';
import 'package:desktop_erp_4s/util/form_utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/models/branch_model.dart';
import '../../../data/models/request/transaction_creating_model.dart';
import '../../../data/models/response/StoreTrnsOModel.dart';
import '../../../data/models/response/TransactionSpec.dart';
import '../../../data/models/response/store_trans_list_dependency.dart';
import '../../../db/SharedPereference.dart';
import '../../../util/map_list_model.dart';
import '../../../util/spinner_model.dart';
import '../../../util/strings.dart' show Strings;
import '../../widgets/custom_spinner_dialog.dart';
import '../../widgets/show_message.dart';
import 'add_item_dialog.dart';

class TransactionForm extends StatefulWidget {
  final Branches? selectedBranch;
  final TransactionSpec transactionSpec;

  const TransactionForm({
    Key? key,
    required this.selectedBranch,
    required this.transactionSpec,
  }) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionForm> {
  var obj = TransactionFormProvider();

  List<StoreTransListDependency>? transListWithDepSelected=[];
  // SpinnerModel? selectedItem;
  TextEditingController remController = TextEditingController();
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    obj.context = context;
   // obj.initial();

    // load selected branch from shared preferences
    // You can also initialize selectedBranchId if needed

    //Need to refactor
    _loadSelectedBranch();
    _loadAllItemsForm();

    remController.text =
        obj.transaction.rem ?? ""; // Initialize with existing value
  }

  Future<void> _loadAllItemsForm() async {
    final List<SpinnerModel> spinnerModel = await obj.getAllItemsForms();
    if (spinnerModel.isNotEmpty) {
      setState(() {
        obj.allItemsFormsList = spinnerModel;
        print("initState itemForm: ${obj.allItemsFormsList.length}");
        //set default
        obj.transaction.itemForm =
            obj.allItemsFormsList[0].id; // Set the first item as default
        obj.transaction.itemFormName =
            obj.allItemsFormsList[0].name; // Set the first item as default

        print(
          "initState itemForm: ${obj.transaction.itemForm} - ${obj.transaction.itemFormName}",
        );
      });
    }
  }

  Future<void> _loadSelectedBranch() async {
    // Load the selected branch from shared preferences not map list
    final savedBranch = await SharedPreferences().loadSelectedBranch();
    if (savedBranch != null) {
      setState(() {
        SpinnerModel selectedItem = SpinnerModel(
          id: savedBranch.code!,
          name: savedBranch.descr!,
        );
        // Update the TransactionFormProvider with the selected branch
        obj.transaction.trnsCode = widget.transactionSpec!.trnsCode;
        obj.transaction.branch = selectedItem.id!;
        obj.transaction.branchName = selectedItem.name!;
      // print("Selected Branch from Shared Preferences: ${selectedBranch!.name}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    obj = Provider.of<TransactionFormProvider>(context);
    obj.transactionSpec = widget.transactionSpec;
    obj.context = context;
    /*if(obj.isLoading){
      return Center(
        child: CircularProgressIndicator(),
      );
    }else{*/
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "${widget.transactionSpec!.trnsDesc} جديد ", // refactor
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color.fromARGB(255, 23, 111, 153),
            iconTheme: IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                // 1. Basic Data text
                Container(
                  child: Text(
                    Strings.BASIC_DATA,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 1),

                //2.Selected branch
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align children to the left
                    children: [
                      Container(
                        margin: EdgeInsets.all(7),
                        child: Text(
                          Strings.BRANCH,
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 1),
                      InkWell(
                        onTap: () async {
                          // Fetch branches dynamically
                          final List<SpinnerModel> spinnerModel =
                          await MapListModel().mapListToSpinnerModelList();
                          if (spinnerModel.length > 0) {
                            final result = await showDialog<SpinnerModel>(
                              context: context,
                              builder:
                                  (context) => CustomSpinnerDialog(
                                spinnerModels: spinnerModel,
                                onItemSelected: (items) {
                                  setState(() {
                                    obj.transaction.branchName = items.name;
                                    obj.transaction.branch = items.id;
                                  });
                                },
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                obj.transaction.branchName = result.name;
                                obj.transaction.branch = result.id;
                              });
                            }
                          } else {
                            // Show a message if no items are available
                            ShowMessage().showSnackBar(
                              context,
                              Strings.ERROR_NO_DATA_FOUND,
                            );
                          }
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
                                obj.transaction.branchName != null
                                    ? obj.transaction.branchName!
                                    : Strings.SELECT_BRANCH,
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

                //3.Date
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align children to the left
                    children: [
                      Container(
                        margin: EdgeInsets.all(7),
                        child: Text(
                          Strings.DATE,
                          style: TextStyle(fontSize: 17, color: Colors.grey),
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
                              obj.transaction.trnsDate =
                              "${pickedDate.toLocal()}".split(' ')[0];
                            });
                          }
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
                                obj.transaction.trnsDate != null
                                    ? obj.transaction.trnsDate!
                                    : Strings.DATE_FORM,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              Icon(Icons.calendar_today, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                //4.From & To Fields
                Container(
                  child: Row(
                    children: [
                      Visibility(
                        visible: obj.transaction.fromDst != 0 ? true : false,
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(7),
                                child: Text(
                                  Strings.FROM +
                                      " " +
                                      FormUtils.getNameFromIndex(
                                        obj.transaction.fromDst!,
                                      ),
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
                                    await obj.getSpinnerModelListByIndex(
                                      obj.transaction.fromDst!,
                                      obj.transaction.trnsCode!,
                                    );

                                    if (spinnerModel.length > 0) {
                                      // Show dialog with fetched spinner models
                                      final result =
                                      await showDialog<SpinnerModel>(
                                        context: context,
                                        builder:
                                            (context) => CustomSpinnerDialog(
                                          spinnerModels: spinnerModel,
                                          onItemSelected: (item) {
                                            setState(() {
                                              obj.transaction.fromDst =
                                                  widget
                                                      .transactionSpec
                                                      .fromDst;
                                              obj.transaction.fromCode =
                                              item!.id!;
                                              obj.transaction.fromName =
                                              item.name!;
                                            });
                                          },
                                        ),
                                      );

                                      if (result != null) {
                                        setState(() {
                                          obj.transaction.fromDst =
                                              obj.transactionSpec!.fromDst;
                                          obj.transaction.fromCode = result.id!;
                                          obj.transaction.fromName = result.name!;
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        obj.transaction.fromCode != null && obj.transaction.fromCode != ""
                                            ? obj.transaction.fromName ?? ""
                                            : FormUtils.getNameFromIndex(
                                          obj.transaction.fromDst!,
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
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
                      ),
                      SizedBox(width: 10),
                      // Add spacing between the two containers
                      Visibility(
                        visible: obj.transaction.toDst != 0 ? true : false,
                        child: Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(7),
                                child: Text(
                                  Strings.TO +
                                      " " +
                                      FormUtils.getNameFromIndex(
                                        obj.transaction.toDst!,
                                      ),
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
                                    await obj.getSpinnerModelListByIndex(
                                      obj.transaction.toDst!,
                                      obj.transaction.trnsCode!,
                                    );
                                    if (spinnerModel.length > 0) {
                                      // Show dialog with fetched spinner models
                                      final result =
                                      await showDialog<SpinnerModel>(
                                        context: context,
                                        builder:
                                            (context) => CustomSpinnerDialog(
                                          spinnerModels: spinnerModel,
                                          onItemSelected: (item) {
                                            setState(() {
                                              /* obj.transaction.toDst =
                                                        widget
                                                            .transactionSpec!
                                                            .toDst;*/
                                              obj.transaction.toCode =
                                              item!.id!;
                                              obj.transaction.toName =
                                              item.name!;
                                            });
                                          },
                                        ),
                                      );

                                      if (result != null) {
                                        setState(() {
                                          /*  obj.transaction.toDst =
                                            obj.transactionSpec!.toDst;*/
                                          obj.transaction.toCode = result.id!;
                                          obj.transaction.toName = result.name!;
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
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        obj.transaction.toCode != null && obj.transaction.toCode != ""
                                            ? obj.transaction.toName ?? ""
                                            : FormUtils.getNameFromIndex(
                                          obj.transaction.toDst!,
                                        ),
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
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
                      ),
                    ],
                  ),
                ),

                //5. Sales Rep Field
                Visibility(
                  visible: obj.transactionSpec!.salesRep != 0,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // Align children to the left
                      children: [
                        Container(
                          margin: EdgeInsets.all(7),
                          child: Text(
                            Strings.SALES_REP_TEXT,
                            style: TextStyle(fontSize: 17, color: Colors.grey),
                          ),
                        ),
                        SizedBox(height: 1),
                        InkWell(
                          onTap: () async {
                            final List<SpinnerModel> spinnerModel = await obj
                                .getSpinnerModelListByIndex(
                              Strings.SALES_REP,
                              obj.transactionSpec!.trnsCode!,
                            );
                            if (spinnerModel.length > 0) {
                              final result = await showDialog<SpinnerModel>(
                                context: context,
                                builder:
                                    (context) => CustomSpinnerDialog(
                                  spinnerModels: spinnerModel,
                                  onItemSelected: (items) {
                                    setState(() {
                                      obj.transaction.repName = items.name;
                                      obj.transaction.salesRepCode = items.id;
                                    });
                                  },
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  obj.transaction.repName = result.name;
                                  obj.transaction.salesRepCode = result.id;
                                });
                              }
                            } else {
                              // Show a message if no items are available
                              ShowMessage().showSnackBar(
                                context,
                                Strings.ERROR_NO_DATA_FOUND,
                              );
                            }
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
                                  obj.transaction.repName != null
                                      ? obj.transaction.repName!
                                      : Strings.SALES_REP_TEXT,
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
                ),

                //6. Remarks Field
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(7),
                        child: Text(
                          Strings.REM,
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 1),
                      TextField(
                        controller: remController,
                        onChanged: (value) {
                          obj.transaction.rem =
                              value; // Update the transaction object
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFf7f7f7),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(
                              color: Color(0xFFDADADA),
                              width: 1.3,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // 7. Groups&Items text
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            Strings.GROUPS_ITEMS,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (obj.allItemsFormsList.isNotEmpty) {
                                print(
                                  "AddItemDialog ${obj.transaction.itemForm}",
                                );

                                final updatedItem = await showDialog<StoreTrnsOModel>(
                                  context: context,
                                  builder:
                                      (context) => AddItemDialog(
                                    //transactionSpec:obj.transactionSpec!,
                                    tfProvider: obj,
                                    //  allItemsFormsList: obj.allItemsFormsList,
                                    // itemForm: obj.transaction.itemForm,
                                  ),
                                );
                                if (updatedItem != null) {
                                  setState(() {
                                    // Find index of the item in the list and update it
                                    int index = obj.storeTransOModelList
                                        .indexWhere(
                                          (item) =>
                                      item.itemCode ==
                                          updatedItem.itemCode,
                                    );
                                    if (index != -1) {
                                      obj.storeTransOModelList[index] =
                                          updatedItem;
                                    } else {
                                      // Or add if not found
                                      obj.addStoreTransOModel(updatedItem);
                                    }
                                  });
                                }
                              } else {
                                print(
                                  "allItemsFormsList size:  ${obj.transaction}",
                                );
                                ShowMessage().showSnackBar(
                                  context,
                                  Strings.ERROR_NO_DATA_FOUND,
                                );
                              }
                            },
                            child: Text(
                              Strings.ADD_ITEM,
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.blueAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 1),

                      //2.Selected item
                      Container(
                        margin: EdgeInsets.all(7),
                        child: Text(
                          Strings.GROUP_ITEMS,
                          style: TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                      ),
                      SizedBox(height: 1),
                      InkWell(
                        onTap: () async {
                          try {
                            // Fetch spinner models
                            print(
                              "before itemForm: ${obj.allItemsFormsList.length}",
                            );
                            final List<SpinnerModel> spinnerModel =
                            await obj.getAllItemsForms();

                            if (spinnerModel.length > 0) {
                              // Show dialog with fetched spinner models
                              final result = await showDialog<SpinnerModel>(
                                context: context,
                                builder:
                                    (context) => CustomSpinnerDialog(
                                  spinnerModels: spinnerModel,
                                  onItemSelected: (item) {
                                    setState(() {
                                      obj.transaction.itemForm =
                                          item.id; // Update the itemForm with the selected item's ID
                                      obj.transaction.itemFormName =
                                          item.name; // Optionally update the name
                                      print(
                                        "Updated itemForm: ${obj.transaction.itemForm} - ${item.id}",
                                      );
                                    });
                                  },
                                ),
                              );

                              if (result != null) {
                                setState(() {
                                  obj.transaction.itemForm =
                                  result.id!; // Update the item form
                                  obj.transaction.itemFormName =
                                  result.name!; // Update the item form
                                  //  print("item form select: (result) ${transactionFormProvider.transaction.itemForm}");
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
                                obj.transaction.itemForm != null
                                    ? obj.transaction.itemFormName!
                                    : Strings.ITEMS, // refactor
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
                SizedBox(height: 20),
                // 6. Items List
                Visibility(
                  visible: obj.storeTransOModelList.length > 0 ? true : false,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Strings.ITEM_LIST,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                //display dialog to delete  items and clear all items in storeTransOModelList
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                    title: Text(Strings.ERROR_TITLE_MESSAGE),
                                    //translate to arabic
                                    content: Text(Strings.ERROR_MESSAGE),
                                    actions: [
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(
                                          context,
                                        ).pop(false),
                                        child: Text(
                                          Strings.Cancel,
                                          style: TextStyle(
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed:
                                            () => Navigator.of(
                                          context,
                                        ).pop(true),
                                        child: Text(
                                          Strings.Delete,
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  setState(() {
                                    obj.storeTransOModelList.clear();
                                  });
                                }
                              },
                              child: Text(
                                Strings.DELETE_ITEMS,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1),
                        StoreTransTable(transactionFormProvider: obj),
                      ],
                    ),
                  ),
                ),

                // 7. Dependency
                Visibility(
                  visible:
                  (widget.transactionSpec!.depOnTrnsCodeVal == "" ||
                      obj.transactionSpec!.depOnTrnsCodeVal == "0")
                      ? false
                      : true,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Strings.DEPENDENCY,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () async{
                                //display dialog to add dependency
                                List<StoreTransListDependency>?  storeTransDepList = await obj.getStoreTransDependency();
                                if(storeTransDepList!=null&&storeTransDepList!.length>0){
                                  // Show dialog with fetched dependency items
                                  List<StoreTransListDependency>? transListWithDepApprove = obj.getTransWithApprovedToDependOnIt(storeTransDepList);

                                  if(transListWithDepApprove.length>0){
                                    if(transListWithDepSelected!.length>0){
                                      for(var depApprove in transListWithDepApprove){
                                        if(transListWithDepSelected!.length>0){
                                          for(var depSelected in transListWithDepSelected!){
                                            if(depApprove.trnsNo == depSelected.trnsNo){
                                              depApprove.isSelected = depSelected.isSelected;
                                            }
                                          }
                                        }
                                      }
                                    }
                                    //transListWithDepSelected = [];
                                    print("transListWithDepApprove: ${transListWithDepApprove.map((e) =>  e.isSelected).toList()}",);
                                    List<StoreTransListDependency> selectedTransDepList= (await showDialog<List<StoreTransListDependency>>(
                                      context: context,
                                      builder: (context) => TransactionDepListDialog(storeTransDepModelList: transListWithDepApprove),)) as List<StoreTransListDependency>;
                                    if(selectedTransDepList.length>0){
                                      setState(() {
                                        // obj.transaction.storeTransDepList = selectedTransDepList;
                                        print("selectedTransDep List from dialog: ${selectedTransDepList.map((e) =>  e.trnsNo).toList()}",);
                                        transListWithDepSelected = selectedTransDepList;
                                        isLoading = true;  // Show loader
                                      });
                                    }


                                    // Call getTransactionDepOnList and wait for result
                                    final result = await obj.getTransactionDepOnList(selectedTransDepList);

                                    setState(() {
                                      isLoading = false; // Hide loader
                                      // Optionally update transListWithDepSelected or other state with result if needed
                                      // For example, if getTransactionDepOnList returns updated list:
                                      if (result != null) {
                                        //transListWithDepSelected = result;

                                      }
                                    });

                                  }else{
                                    ShowMessage().showToast(Strings.NO_TRANS_DEP_ON);
                                  }


                                }else{
                                  if(storeTransDepList!=null)
                                    ShowMessage().showToast(Strings.NO_TRANS_DEP_ON);
                                }


                              },
                              child: Text(
                                Strings.ADD_DEPENDENCY,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.blueAccent,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 1),



                Visibility(
                  visible: obj.dependencyTransList.length>0 ? true:false,
                  child:DepStoreTransTable(transactionFormProvider: obj),),
                // 8.Finance text
                Visibility(
                  visible: obj.transactionSpec?.showPrice != 0 ? true : false,
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  Strings.FINANCE,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),

                            //2.Selected way pay
                            Container(
                              margin: EdgeInsets.all(7),
                              child: Text(
                                Strings.PAY_WAY,
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            SizedBox(height: 1),
                            InkWell(
                              onTap: () async {
                                // refactor{
                                try {
                                  // Fetch spinner models
                                  final List<SpinnerModel> spinnerModel =
                                  await FormUtils.getPaymentMethod();
                                  if (spinnerModel.length > 0) {
                                    // Show dialog with fetched spinner models
                                    final result = await showDialog<SpinnerModel>(
                                      context: context,
                                      builder:
                                          (context) => CustomSpinnerDialog(
                                        spinnerModels: spinnerModel,
                                        onItemSelected: (item) {
                                          setState(() {
                                            obj
                                                .transaction
                                                .payMethod = int.tryParse(
                                              item.id ?? '',
                                            ); // Convert String to int?
                                            obj.transaction.payMethodName =
                                            item.name!; // Update the item form
                                          });
                                        },
                                      ),
                                    );
                                    if (result != null) {
                                      setState(() {
                                        obj.transaction.payMethod = int.tryParse(
                                          result.id ?? '',
                                        ); // Convert String to int?
                                        obj.transaction.payMethodName =
                                        result.name!;
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      obj.transaction.payMethod != null
                                          ? obj.transaction.payMethodName!
                                          : (FormUtils().getSpinnerModelById(
                                        FormUtils.getPaymentMethod(),
                                        "3",
                                      ))!.name!, // refactor
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
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
                      //6. Total&Net  Field
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            //1.section total
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Container(
                                  margin: EdgeInsets.all(7),
                                  child: Text(
                                    Strings.TOTAL,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1),
                                TextField(
                                  controller: remController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    obj.transaction.rem =
                                        value; // Update the transaction object
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFf7f7f7),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Color(0xFFDADADA),
                                        width: 1.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            Visibility(
                              visible:
                              obj.transactionSpec?.salesTax != 0
                                  ? true
                                  : false,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          //4.section total net
                                          Container(
                                            margin: EdgeInsets.all(7),
                                            child: Text(
                                              Strings.SALES,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          TextField(
                                            controller: remController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              obj.transaction.rem =
                                                  value; // Update the transaction object
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xFFf7f7f7),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Color(0xFFDADADA),
                                                  width: 1.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          //4.section total net
                                          Container(
                                            margin: EdgeInsets.all(7),
                                            child: Text(
                                              Strings.SALES_VALUE,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          TextField(
                                            controller: remController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              obj.transaction.rem =
                                                  value; // Update the transaction object
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xFFf7f7f7),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Color(0xFFDADADA),
                                                  width: 1.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                              obj.transactionSpec?.commTax != 0
                                  ? true
                                  : false,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          //4.section total net
                                          Container(
                                            margin: EdgeInsets.all(7),
                                            child: Text(
                                              Strings.COMM,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          TextField(
                                            controller: remController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              obj.transaction.rem =
                                                  value; // Update the transaction object
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xFFf7f7f7),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Color(0xFFDADADA),
                                                  width: 1.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          //4.section total net
                                          Container(
                                            margin: EdgeInsets.all(7),
                                            child: Text(
                                              Strings.COMM_VALUE,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          TextField(
                                            controller: remController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              obj.transaction.rem =
                                                  value; // Update the transaction object
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xFFf7f7f7),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Color(0xFFDADADA),
                                                  width: 1.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Visibility(
                              visible:
                              obj.transactionSpec?.trnsDiscount != 0
                                  ? true
                                  : false,
                              child: Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          //4.section total net
                                          Container(
                                            margin: EdgeInsets.all(7),
                                            child: Text(
                                              Strings.DISCOUNT,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          TextField(
                                            controller: remController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              obj.transaction.rem =
                                                  value; // Update the transaction object
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xFFf7f7f7),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Color(0xFFDADADA),
                                                  width: 1.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        alignment: Alignment.bottomCenter,
                                        child: Text(
                                          Strings.PERCENTAGE,
                                          style: TextStyle(
                                            fontSize: 17,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          //4.section total net
                                          Container(
                                            margin: EdgeInsets.all(7),
                                            child: Text(
                                              Strings.COMM_VALUE,
                                              style: TextStyle(
                                                fontSize: 17,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                          TextField(
                                            controller: remController,
                                            keyboardType: TextInputType.number,
                                            onChanged: (value) {
                                              obj.transaction.rem =
                                                  value; // Update the transaction object
                                            },
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Color(0xFFf7f7f7),
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                BorderRadius.circular(5),
                                                borderSide: BorderSide(
                                                  color: Color(0xFFDADADA),
                                                  width: 1.3,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                //4.section total net
                                Container(
                                  margin: EdgeInsets.all(7),
                                  child: Text(
                                    Strings.TOTAL_NET,
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 1),
                                TextField(
                                  controller: remController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    obj.transaction.rem =
                                        value; // Update the transaction object
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Color(0xFFf7f7f7),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5),
                                      borderSide: BorderSide(
                                        color: Color(0xFFDADADA),
                                        width: 1.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(); // Dismiss the dialog
                  },
                  child: Container(
                    margin: EdgeInsets.all(5),
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 23, 111, 153),
                    ),
                    child: Text(
                      Strings.Save,
                      style: TextStyle(color: Colors.white, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

  }


/*
class CustomDropdownWidget extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<SpinnerModel> items;
  final ValueChanged<String?> onChanged;

  const CustomDropdownWidget({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: Color(0xFFDADADA),
              width: 1.2,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: DropdownButton<String>(
            isExpanded: true,
            underline: Container(),
            value: selectedValue,
            hint: Text("Select"),
            onChanged: onChanged,
            items: items.map((SpinnerModel item) {
              return DropdownMenuItem<String>(
                value: item.id.toString(),
                child: Text(
                  item.name.toString() + " - " + item.id.toString(),
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}*/
