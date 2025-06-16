import 'package:desktop_erp_4s/ui/stockTransaction/transactionForm/transaction_form_provider.dart';
import 'package:desktop_erp_4s/util/form_utils.dart';
import 'package:flutter/material.dart';

import '../../../data/models/branch_model.dart';
import '../../../data/models/response/TransactionSpec.dart';
import '../../../db/SharedPereference.dart';
import '../../../util/map_list_model.dart';
import '../../../util/spinner_model.dart';
import '../../../util/strings.dart' show Strings;
import '../../widgets/custom_spinner_dialog.dart';

class TransactionForm extends StatefulWidget {
  final Branches? selectedBranch;
  final TransactionSpec? transactionSpec;

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

  // SpinnerModel? selectedItem;
  TextEditingController remController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // load selected branch from shared preferences
    // You can also initialize selectedBranchId if needed
    _loadSelectedBranch();
    remController.text =
        obj.transaction.rem ?? ""; // Initialize with existing value
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
        obj.transaction.branch = selectedItem!.id!;
        obj.transaction.branchName = selectedItem!.name!;

        // print("Selected Branch from Shared Preferences: ${selectedBranch!.name}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Text(
                Strings.BASIC_DATA,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 1),

              //2.Selected branch
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
                  final List<SpinnerModel> branches =
                      await MapListModel().mapListToSpinnerModelList();

                  final result = await showDialog<SpinnerModel>(
                    context: context,
                    builder:
                        (context) => CustomSpinnerDialog(
                          spinnerModels: branches,
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
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFFf7f7f7),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Color(0xFFDADADA), width: 1.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        obj.transaction.branchName != null
                            ? obj.transaction.branchName!
                            : Strings.SELECT_BRANCH,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Icon(Icons.arrow_drop_down, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              //3.Date
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    color: Color(0xFFf7f7f7),
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Color(0xFFDADADA), width: 1.3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        obj.transaction.trnsDate != null
                            ? obj.transaction.trnsDate!
                            : Strings.DATE_FORM,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                      Icon(Icons.calendar_today, color: Colors.grey),
                    ],
                  ),
                ),
              ),

              //4.From & To Fields
              Row(
                children: [
                  Visibility(
                    visible:
                        widget.transactionSpec!.fromDst != 0 ? true : false,
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
                                    widget.transactionSpec!.fromDst!,
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
                                    await TransactionFormProvider.getSpinnerModelListByIndex(
                                      widget.transactionSpec!.fromDst!,
                                      widget.transactionSpec!.trnsCode!,
                                    );

                                // Show dialog with fetched spinner models
                                final result = await showDialog<SpinnerModel>(
                                  context: context,
                                  builder:
                                      (context) => CustomSpinnerDialog(
                                        spinnerModels: spinnerModel,
                                        onItemSelected: (item) {
                                          setState(() {
                                            obj.transaction.fromDst =
                                                widget.transactionSpec!.fromDst;
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
                                        widget.transactionSpec!.fromDst;
                                    obj.transaction.fromCode = result.id!;
                                    obj.transaction.fromName = result.name!;
                                  });
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
                                    obj.transaction.fromCode != null
                                        ? obj.transaction.fromName!
                                        : FormUtils.getNameFromIndex(
                                          widget.transactionSpec!.fromDst!,
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
                    visible: widget.transactionSpec!.toDst != 0 ? true : false,
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
                                    widget.transactionSpec!.toDst!,
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
                                    await TransactionFormProvider.getSpinnerModelListByIndex(
                                      widget.transactionSpec!.toDst!,
                                      widget.transactionSpec!.trnsCode!,
                                    );

                                // Show dialog with fetched spinner models
                                final result = await showDialog<SpinnerModel>(
                                  context: context,
                                  builder:
                                      (context) => CustomSpinnerDialog(
                                        spinnerModels: spinnerModel,
                                        onItemSelected: (item) {
                                          setState(() {
                                            obj.transaction.toDst =
                                                widget.transactionSpec!.toDst;
                                            obj.transaction.toCode = item!.id!;
                                            obj.transaction.toName = item.name!;
                                          });
                                        },
                                      ),
                                );

                                if (result != null) {
                                  setState(() {
                                    obj.transaction.toDst =
                                        widget.transactionSpec!.toDst;
                                    obj.transaction.toCode = result.id!;
                                    obj.transaction.toName = result.name!;
                                  });
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
                                    obj.transaction.toCode != null
                                        ? obj.transaction.toName!
                                        : FormUtils.getNameFromIndex(
                                          widget.transactionSpec!.toDst!,
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

              //5. Remarks Field
              Column(
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

              // 6. Groups&Items text
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    Strings.GROUPS_ITEMS,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    Strings.ADD_ITEM,
                    style: TextStyle(fontSize: 15, color: Colors.blueAccent),
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
                    final List<SpinnerModel> spinnerModel =
                    await TransactionFormProvider.getAllItemsForms();

                    // Show dialog with fetched spinner models
                    final result = await showDialog<SpinnerModel>(
                      context: context,
                      builder:
                          (context) => CustomSpinnerDialog(
                        spinnerModels: spinnerModel,
                        onItemSelected: (item) {
                          setState(() {
                            obj.transaction.itemForm = item!.id!; // Update the item form
                            obj.transaction.itemFormName =  item!.name!;    // Update the item form
                          });
                        },
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        obj.transaction.itemForm = result.id!; // Update the item form
                        obj.transaction.itemFormName =  result.name!;    // Update the item form

                      });
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

                        obj.transaction.itemForm != null
                            ? obj.transaction.itemFormName!
                            : Strings.ITEMS, // refactor
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
