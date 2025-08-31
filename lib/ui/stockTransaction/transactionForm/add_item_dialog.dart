import 'package:desktop_erp_4s/data/models/request/transaction_creating_model.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/transactionForm/transaction_form_provider.dart';
import 'package:flutter/material.dart';

import '../../../data/models/response/StoreTrnsOModel.dart';
import '../../../data/models/response/TransactionSpec.dart';
import '../../../util/item_form_with_spinner_list.dart';
import '../../../util/spinner_model.dart';
import '../../../util/strings.dart' show Strings;
import '../../widgets/custom_spinner_dialog.dart';
import '../../widgets/custom_spinner_drop_down.dart';
import '../../widgets/show_message.dart';

class AddItemDialog extends StatefulWidget {
  //final TransactionSpec transactionSpec;
  final TransactionFormProvider tfProvider;
  //final List<SpinnerModel> allItemsFormsList;
  //  final String? itemForm;
  final StoreTrnsOModel? editingItem; // New optional parameter


  const AddItemDialog({
    Key? key,
   // required this.transactionSpec,
    required this.tfProvider,
    this.editingItem,

    // required this.allItemsFormsList,
   // required this.itemForm,
  }) : super(key: key);

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {

  final TextEditingController priceController = TextEditingController();
  final TextEditingController qtyController = TextEditingController();
  final TextEditingController totalController = TextEditingController();

  SpinnerModel? selectedSpinnerModel;
  List<SpinnerModel>? allItemsList;
  SpinnerModel? selectedItem;
  //bool isLoading = false; // Loading state
  StoreTrnsOModel? itemStoreTrans= StoreTrnsOModel();

  String? selectedItemForm;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _loadItemListData();
    selectedItemForm = widget.tfProvider.transaction.itemForm;



   // print("itemFormWithItemList: ${widget.transactionFormProvider.itemFormWithItemList.length}");
   // print("storeTransOModelList: ${widget.transactionFormProvider.storeTransOModelList.length}");

    if (widget.editingItem != null) {
      itemStoreTrans = widget.editingItem!;
      qtyController.text = itemStoreTrans!.qty1?.toString() ?? '';
      if (itemStoreTrans?.unitPrice != null) {
        priceController.text = itemStoreTrans!.unitPrice?.toString() ?? '';
      }
    }

    _updateTotal();


    _setSelectedSpinnerModelById(
        selectedItemForm
    ); // Replace "desired_id" with the actual id
  }

  void _updateTotal (){
    final qty = double.tryParse(qtyController.text) ?? 0;
    final price = double.tryParse(priceController.text) ?? 0;
    final total = qty * price;
    setState(() {
      totalController.text = total.toString();
      itemStoreTrans?.total = total;
      print("Total : ${itemStoreTrans?.total}");
    });
  }

  //  Method to load initial item data
  // This method is called in initState to set the initial selected item
  Future _loadItemListData() async {

    allItemsList = await widget.tfProvider.getAllItemsList(
      widget.tfProvider.transactionSpec!.itemForm!,
      widget.tfProvider.transactionSpec!.itemPrice!.toString(),
    );

  }

  void _setSelectedSpinnerModelById(String? id) {
    final matchingModel = widget.tfProvider.allItemsFormsList.firstWhere(
      (item) => item.id == id,
      orElse:
          () =>
          widget.tfProvider.allItemsFormsList.isNotEmpty
                  ? widget.tfProvider.allItemsFormsList.first
                  : SpinnerModel(
                    id: '',
                    name: 'Default',
                  ), // Fallback if the list is empty
    );
    itemStoreTrans?.itemForm = matchingModel.id;
    itemStoreTrans?.formDesc = matchingModel.name;
    setState(() {
      selectedSpinnerModel = matchingModel;

    });
  }

  @override
  Widget build(BuildContext context) {
    // Access TransactionFormProvider
    // final transactionFormProvider = Provider.of<TransactionFormProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        child: /*isLoading? Center(child: CircularProgressIndicator()) :*/ Container(
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 23, 111, 153),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop(); // This should close the dialog
                       /* Future.microtask(() {
                          Navigator.of(context).pop();
                        });*/
                      },
                    ),
                    Expanded(
                      child: Text(
                        Strings.ADD_ITEM,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //1.Group Dropdown
                      Text(
                        Strings.GROUP,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 3),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color(0xFFf7f7f7),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Color(0xFFDADADA),
                            width: 1.3,
                          ),
                        ),
                        child: CustomSpinnerDropdown(
                          items: widget.tfProvider.allItemsFormsList,
                          // List of SpinnerModel
                          selectedItem: selectedSpinnerModel,
                          // Currently selected SpinnerModel
                          onChanged: (SpinnerModel? newValue) {
                            setState(() {
                              selectedSpinnerModel = newValue;
                              if(selectedSpinnerModel?.id!=selectedItemForm){
                                 itemStoreTrans?.itemDesc = null;
                                 itemStoreTrans?.itemCode = null;
                                 itemStoreTrans?.unitPrice = null;
                                 priceController.text = '';
                                 qtyController.text = '';
                                 _updateTotal();
                              }
                              selectedItemForm = selectedSpinnerModel?.id;
                              itemStoreTrans?.itemForm =selectedSpinnerModel?.id;
                              itemStoreTrans?.formDesc = selectedSpinnerModel?.name;

                              // widget.tfProvider.transaction.itemForm = selectedSpinnerModel?.id;
                             //  widget.tfProvider.transaction.itemFormName = selectedSpinnerModel?.name;
                              //print selectedSpinnerModel
                              print(
                                "Selected Group: ${selectedSpinnerModel?.name} + ${selectedSpinnerModel?.id}",
                              );
                            });
                          },
                        ),
                      ),
                      SizedBox(height: 3),

                      //2. Item Selection
                      Visibility(

                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.ITEM,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              GestureDetector(
                                // Handle item selection
                                onTap: () async {
                                  widget.tfProvider.showLoading();
                                  try {
                                    // Fetch spinner models
                                    if(widget.tfProvider.itemFormWithItemList.isEmpty){
                                      allItemsList =
                                      await widget.tfProvider
                                          .getAllItemsList(
                                        selectedItemForm!,
                                        widget.tfProvider.transactionSpec!.itemPrice!
                                            .toString(),
                                      );

                                      widget.tfProvider.itemFormWithItemList.add(
                                        ItemFormWithSpinnerList(
                                          itemForm: selectedItemForm!,
                                          itemList: allItemsList!,
                                        ),
                                      );
                                    }else{
                                      bool isExist =false;
                                      for(var itemFormWithItem in widget.tfProvider.itemFormWithItemList) {
                                        if (itemFormWithItem.itemForm == selectedItemForm!) {
                                          isExist = true;
                                          allItemsList = itemFormWithItem.itemList;
                                          break;
                                        }
                                      }
                                      if(!isExist){
                                        allItemsList =
                                        await widget.tfProvider
                                            .getAllItemsList(
                                          selectedItemForm!,
                                          widget.tfProvider.transactionSpec!.itemPrice!
                                              .toString(),
                                        );
                                        widget.tfProvider.itemFormWithItemList.add(
                                          ItemFormWithSpinnerList(
                                            itemForm: selectedItemForm!,
                                            itemList: allItemsList!,
                                          ),
                                        );

                                      }

                                    }
                                    widget.tfProvider.hideLoading();

                                    if (allItemsList!.length > 0) {
                                      final result = await showDialog<SpinnerModel>(
                                        context: context,
                                        builder:
                                            (context) => CustomSpinnerDialog(
                                          spinnerModels: allItemsList!,
                                          onItemSelected: (item) {
                                            setState(() {
                                             // selectedItem = item;
                                              itemStoreTrans?.itemCode = item?.id;
                                              itemStoreTrans?.itemDesc = item?.name;
                                              itemStoreTrans?.unitPrice = double.tryParse(item.extraItem);
                                              priceController.text = item.extraItem;
                                              _updateTotal();

                                              /* obj.transaction.itemForm =
                                         item!.id!; // Update the item form
                                         obj.transaction.itemFormName =
                                         item!.name!; // Update the item form*/
                                            });
                                          },
                                        ),
                                      );

                                      if (result != null) {
                                        setState(() {
                                          //selectedItem = result;
                                          itemStoreTrans?.itemCode = result.id;
                                          itemStoreTrans?.itemDesc = result.name;
                                          itemStoreTrans?.unitPrice = result.extraItem as double?;
                                          priceController.text = result.extraItem!;
                                          _updateTotal();

                                          /* obj.transaction.itemForm =
                                     result.id!; // Update the item form
                                     obj.transaction.itemFormName =
                                     result.name!; // Update the item form*/
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
                                    setState(() {
                                      widget.tfProvider.hideLoading();
                                      // Hide loader
                                    });
                                    print("Error fetching spinner models: $e");
                                  }
                                },

                                child: Container(
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
                                  Expanded(  // <-- Wrap Text with Expanded
                                  child: Text(
                                    itemStoreTrans?.itemDesc!=null
                                    ? "${itemStoreTrans?.itemDesc} - ${itemStoreTrans?.itemCode}"
                                      : Strings.SELECT_ITEM,
                                    style: TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis, // Add ellipsis if text is too long
                                  ),),
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


                      //3. Price Field
                      Visibility(
                        visible:
                            widget.tfProvider.transactionSpec!.showPrice == 1
                                ? true
                                : false,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.PRICE,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              TextField(
                                controller: priceController,
                                onChanged: (value) {
                                  // Update the price in the transaction model
                                  setState(() {
                                    itemStoreTrans?.unitPrice = double.tryParse(value);
                                    _updateTotal();

                                  });
                                },
                                keyboardType: TextInputType.number,
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
                              SizedBox(height: 3),
                            ],
                          ),
                        ),
                      ),

                      //4. Quantity Field
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              Strings.QTY,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 3),
                            TextField(
                              controller: qtyController,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                // Update the quantity in the transaction model
                                setState(() {
                                  itemStoreTrans?.qty1 = double.tryParse(value);
                                  _updateTotal();

                                });
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
                            SizedBox(height: 3),
                          ],
                        ),
                      ),

                      //5. Discount Section
                      Visibility(
                        visible:
                            widget.tfProvider.transactionSpec!.trnsItemsDiscount == 1
                                ? true
                                : false,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                Strings.DISCOUNT,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Strings.PERCENTAGE_TEXT,
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(height: 8),
                                        TextField(
                                          keyboardType: TextInputType.number,
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
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "قيمة",
                                          style: TextStyle(fontSize: 14),
                                        ),
                                        SizedBox(height: 8),
                                        TextField(
                                          keyboardType: TextInputType.number,
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
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 3),

                      // Total Field
                      Visibility(
                        visible:
                            widget.tfProvider.transactionSpec!.showPrice == 1
                                ? true
                                : false,
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                Strings.TOTAL,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 3),
                              TextField(
                                controller: totalController,
                                enabled: false,
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
                      ),
                      SizedBox(height: 8),

                      // Save Button
                      ElevatedButton(
                        onPressed: () {
                          print(" formDesc button ${itemStoreTrans?.formDesc}");
                          print(" itemForm button ${itemStoreTrans?.itemForm}");

                          // 1. Validation for itemCode
                          if (itemStoreTrans?.itemCode == null) {
                            ShowMessage().showToast(Strings.ERROR_DATA_NOT_COMPLETE,);
                            return; // Dialog does NOT dismiss
                          }
                          // 2. Validation for qty1
                          else if (itemStoreTrans?.qty1 == null) {
                            ShowMessage().showToast(Strings.ERROR_NO_DATA_FIELD,);
                            return; // Dialog does NOT dismiss
                          }
                          // 3. Main logic
                          else if (widget.tfProvider.storeTransOModelList.length > 0) {
                              bool itemExists = widget.tfProvider.storeTransOModelList.any(
                                    (item) => item.itemCode == itemStoreTrans?.itemCode,
                              );

                              // CRITICAL CHECK FOR UPDATE:
                              if (itemExists && widget.editingItem == null) {
                                ShowMessage().showToast(Strings.ITEM_EXIST_BEFORE);
                                return; // Dialog does NOT dismiss. This is a likely culprit for "update" issues.
                              } else {
                                // This path should be taken for a successful update
                                ShowMessage().showToast(widget.editingItem != null ? Strings.ITEM_UPDATED : Strings.ITEM_ADDED);
                                Navigator.of(context).pop(itemStoreTrans); // Dialog SHOULD dismiss
                              }
                            } else { // List is empty (only for adding first item)
                              ShowMessage().showToast(Strings.ITEM_ADDED);
                              Navigator.of(context).pop(itemStoreTrans); // Dialog SHOULD dismiss
                            }

                        },

                       /* onPressed: () {
                          // Handle save action
                          //validate
                          print("storeTransOModelList: ${widget.tfProvider.storeTransOModelList.length}");

                          if (itemStoreTrans?.itemCode == null) {
                            ShowMessage().showToast(Strings.ERROR_DATA_NOT_COMPLETE,);
                            return;
                          }else if (itemStoreTrans?.qty1==null) {
                            ShowMessage().showToast(Strings.ERROR_NO_DATA_FIELD,);
                            return;
                          }else{
                            if(widget.tfProvider.storeTransOModelList.length>0){
                              // Check if the item already exists in the list
                              bool itemExists = widget.tfProvider.storeTransOModelList.any(
                                (item) => item.itemCode == itemStoreTrans?.itemCode,
                              );
                              if (itemExists&& widget.editingItem==null) {
                                ShowMessage().showToast(Strings.ITEM_EXIST_BEFORE);
                                return;
                              }else{
                               // widget.tfProvider.addStoreTransOModel(itemStoreTrans!);
                                ShowMessage().showToast( widget.editingItem!=null?Strings.ITEM_UPDATED:Strings.ITEM_ADDED);
                                Navigator.of(context).pop(itemStoreTrans);
                                  // Dismiss the dialog
                              }
                            }else{
                             // widget.tfProvider.addStoreTransOModel(itemStoreTrans!);
                              ShowMessage().showToast(Strings.ITEM_ADDED,);
                              Navigator.of(context).pop(itemStoreTrans);

                              // Navigator.of(context).pop(true); // Dismiss the dialog


                              // Create or update StoreTrnsOModel
                           *//*   StoreTrnsOModel updatedItem = StoreTrnsOModel(
                                itemCode: selectedItem!.id,
                                itemForm: selectedItemForm,
                                qty1: double.tryParse(qtyController.text) ?? 0,
                                itemName: selectedItem!.name,
                                // Set other fields as needed
                              );

                              *//*


                            }
                          }
                        }*/
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 23, 111, 153),
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            (widget.editingItem!=null)?Strings.UPDATE: Strings.Save,
                            style: TextStyle(color: Colors.white, fontSize: 16),
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
      ),
    );
  }
}
