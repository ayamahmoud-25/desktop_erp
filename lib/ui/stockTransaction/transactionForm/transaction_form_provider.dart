import 'package:desktop_erp_4s/data/api/api_result.dart';
import 'package:desktop_erp_4s/data/models/response/DataItemListResponseModel.dart';
import 'package:desktop_erp_4s/data/models/response/StoreTrnsDepModel.dart';
import 'package:desktop_erp_4s/data/models/response/TransactionDepOnData.dart';
import 'package:desktop_erp_4s/data/models/response/TransactionDetailsResponseModel.dart';
import 'package:desktop_erp_4s/data/models/response/store_trans_dep_list_response_model.dart';
import 'package:desktop_erp_4s/data/models/response/store_trans_list_dependency.dart';
import 'package:desktop_erp_4s/ui/widgets/show_message.dart';
import 'package:desktop_erp_4s/util/map_list_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../data/api/api_constansts.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/branch_model.dart';
import '../../../data/models/request/dependency_trans_list.dart';
import '../../../data/models/request/transaction_creating_model.dart';
import '../../../data/models/response/ItemList.dart';
import '../../../data/models/response/StoreTrnsOModel.dart';
import '../../../data/models/response/TransactionDepOnListResponseModel.dart';
import '../../../data/models/response/TransactionSpec.dart';
import '../../../db/SharedPereference.dart';
import '../../../util/form_utils.dart' show FormUtils;
import '../../../util/item_form_with_spinner_list.dart';
import '../../../util/loading_service.dart';
import '../../../util/navigation.dart';
import '../../../util/spinner_model.dart';
import '../../../util/strings.dart' show Strings;
import 'add_item_dialog.dart';

class TransactionFormProvider extends ChangeNotifier {
  // create instance of TransactionCreatingModel

  // Private instance of TransactionCreatingModel
  TransactionCreatingModel _transaction = TransactionCreatingModel();

  // Getter for the transaction instance
  TransactionCreatingModel get transaction => _transaction;

  // Setter for the transaction instance
  set transaction(TransactionCreatingModel transaction) {
    _transaction = transaction;
  }

  BuildContext? _context;


  // getter and setter for spinner model list
  List<SpinnerModel> _allItemsFormsList = [];

  List<SpinnerModel> get allItemsFormsList => _allItemsFormsList;

  set allItemsFormsList(List<SpinnerModel> spinnerModelList) {
    _allItemsFormsList = spinnerModelList;
    // Instead of notifyListeners() directly:
    notify();
  }
  BuildContext? get context => _context;


 /* bool _isLoading = false;
  bool get isLoading => _isLoading;

  set isLoading(bool isLoading) {
    _isLoading = isLoading;
    // Instead of notifyListeners() directly:
    notify();
  }*/

/*  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }*/

  set context(BuildContext? context) {
    _context = context;
    // Instead of notifyListeners() directly:
    notify();
  }

  StoreTrnsOModel storeTransOModel = StoreTrnsOModel();
  List<StoreTrnsOModel> storeTransOModelList = [];
  List<DependencyTransList> dependencyTransList = [];
  List<ItemFormWithSpinnerList> itemFormWithItemList = [];

  // set &  get for transactionSpec
  TransactionSpec? _transactionSpec;

  TransactionSpec? get transactionSpec => _transactionSpec;


  set transactionSpec(TransactionSpec? transactionSpec){
   //  isLoading = true; // Show loader
    _transactionSpec = transactionSpec;
    setValues();

    notify();
  }

  void setValues(){
    setAllItemForm();
    setFromToDstCode();

  }

  void setAllItemForm() {
     for(var item in allItemsFormsList) {
      if (item.id == transactionSpec?.itemForm) {
        transaction.itemForm = item.id;
        transaction.itemFormName = item.name;
        break; // Exit loop once the item form is found
      }

   }
     notify();
   }
  Future<void>  setFromToDstCode()async {

    //3.1 Form
    transaction.fromDst = transactionSpec?.fromDst;
    transaction.fromCode = transactionSpec?.fromCode;
     //3.2 To
    transaction.toDst = transactionSpec?.toDst;
    transaction.toCode = transactionSpec?.toCode;

    // Check if fromCode is not null or empty


    try {
      // Your existing async code here
      // e.g., await some API call or data processing
      if (transaction.fromCode != null && transaction.fromCode != "") {
        // Call the method to get spinner model list by index
        final List<SpinnerModel> spinnerModel = await getSpinnerModelListByIndex(
            transaction.fromDst!, transaction.trnsCode!);
        if (spinnerModel.length > 0) {
          for(var item in spinnerModel) {
            if (item.id == transaction.fromCode) {
              transaction.fromName = item.name; // Set the name based on the ID
              break; // Exit loop once the name is found
            }
          }
        }
      }


      if (transaction.toCode != null && transaction.toCode != "") {
        // Call the method to get spinner model list by index
        final List<SpinnerModel> spinnerModel = await getSpinnerModelListByIndex(
            transaction.toDst!, transaction.trnsCode!);
        if (spinnerModel.length > 0) {
          for(var item in spinnerModel) {
            if (item.id == transaction.toCode) {
              transaction.toName = item.name; // Set the name based on the ID
              break; // Exit loop once the name is found
            }
          }
        }
      }

    } catch (e) {
      print("Error in setFromToDstCode: $e");
    } finally {
     // notify();// Hide loader
    }




  }

  Future<List<SpinnerModel>> getSpinnerModelListByIndex(
    int indexName,
    String transCode,
  ) async {
    switch (indexName) {
      case Strings.SALES_REP: //Sales Rep
        final apiResult = await APIService().getAllSalesRep();
        return await mapDataList(apiResult);
      case Strings.CUSTOMER: //Customer
        final apiResult = await APIService().getAllCustomer(true, transCode);
        return await mapDataList(apiResult);
      case Strings.VENDORS: // Vendor
        // Call API to get all customers
        final apiResult = await APIService().getAllVendors(true, transCode);
        return await mapDataList(apiResult);
      case Strings.AGENTS: // Agent
        final apiResult = await APIService().getAllAgents(true, transCode);
        return await mapDataList(apiResult);
      case Strings.STORES: // Stores
        final apiResult = await APIService().getAllStores(true, transCode);
        return await mapDataList(apiResult);
      case Strings.WORK_AREAS: //works areas
        final apiResult = await APIService().getAllWorkAreas(true, transCode);
        return await mapDataList(apiResult);
      case Strings.DEPARTS: //department
        final apiResult = await APIService().getAllDepart(true, transCode);
        return await mapDataList(apiResult);
      case Strings.CONTRACTORS: //contractors
        final apiResult = await APIService().getAllContactor(true, transCode);
        return await mapDataList(apiResult);
      case Strings.PERSONS: //persons
        final apiResult = await APIService().getAllPersons(true, transCode);
        return await mapDataList(apiResult);

      default:
        throw Exception("Invalid index");
    }
  }

  Future<List<SpinnerModel>> mapDataList(APIResult apiResult) async {
    if (apiResult.status == true && apiResult.data != null) {
      // Map API response to SpinnerModel list
      List<SpinnerModel> spinnerModelList = await MapListModel()
          .mapGetAllDataListToSpinnerModelList(apiResult.data.items);
      return spinnerModelList;
    } else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
      // Handle unauthorized access
      print("Unauthorized access");
      ShowMessage().showSnackBar(_context!, apiResult.msg!);
      // You can navigate to the login screen or show a message
      Navigation().logout(_context!);
      // return null
      return [];
    } else {
      // Handle other cases, such as API failure or no data
      print("API call failed or no data");

      return [];
    }
  }

  Future<List<SpinnerModel>> getAllItemsForms() async {
    if (_allItemsFormsList.length > 0) {
      print("initState itemForm: Not call");
      return _allItemsFormsList;
    } else {
      print("initState itemForm:  call");
      final apiResult = await APIService().getAllItemsForms();
      if (apiResult.status == true && apiResult.data != null) {
        // Map API response to SpinnerModel list
        List<SpinnerModel> spinnerModelList = await MapListModel()
            .mapGetAllDataListToSpinnerModelList(apiResult.data.items);
        // Update the allItemsFormsList with the fetched data
        // Set the spinner model list to the allItemsFormsList
        _allItemsFormsList = spinnerModelList;

        //set default
        transaction.itemForm =
            _allItemsFormsList[0].id; // Set the first item as default
        transaction.itemFormName =
            _allItemsFormsList[0].name; // Set the first item as default

        // Notify listeners about the change
        notify();
        // Return the spinner model list
        print("Fetched all items forms successfully");
        print("Spinner Model List: $spinnerModelList");
        // Return the spinner model list
        print("Returning spinnerModelList: $spinnerModelList");
        // Return the spinner model list

        return allItemsFormsList;
      } else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
        // Handle unauthorized access
        print("Unauthorized access");
        ShowMessage().showSnackBar(_context!, apiResult.msg!);
        // You can navigate to the login screen or show a message
        Navigation().logout(_context!);
        return [];
      } else {
        // Handle other cases, such as API failure or no data
        print("API call failed or no data");
        return [];
      }
    }
  }

  //function get name of item form by itemform code (_allItemsFormsList)
  String? getItemFormNameByCode(String itemFormCode) {
    if (_allItemsFormsList.isEmpty) return "";
    for (var item in _allItemsFormsList) {
      if (item.id == itemFormCode) {
        return item.name;
      }
    }
    return ""; // Return empty string if not found
  }

  Future<List<SpinnerModel>> getAllItemsList(
    String itemForm,
    String itemPrice,
  ) async {
    final apiResult = await APIService().getItemList(itemForm);

    if (apiResult.status == true && apiResult.data != null) {
      // Map API response to SpinnerModel list
      //List<ItemList> itemList = apiResult.data.items;
      DataItemListResponseModel dataItemListResponseModel = apiResult.data;
      List<ItemList>? itemList = dataItemListResponseModel.itemList;
      List<SpinnerModel> spinnerModelList = await MapListModel()
          .mapGetAllDataListToSpinnerModelListItem(itemList!, itemPrice);
      // Update the allItemsFormsList with the fetched data
      // Set the spinner model list to the allItemsFormsList

      //set default

      // Notify listeners about the change
      notify();

      // Return the spinner model list
      print("Fetched all items forms successfully");
      print("Spinner Model List: $spinnerModelList");
      // Return the spinner model list
      print("Returning spinnerModelList: $spinnerModelList");
      // Return the spinner model list
      return spinnerModelList;
    } else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
      // Handle unauthorized access
      print("Unauthorized access");
      ShowMessage().showSnackBar(_context!, apiResult.msg!);
      // You can navigate to the login screen or show a message
      Navigation().logout(_context!);
      return [];
    } else {
      // Handle other cases, such as API failure or no data
      print("API call failed or no data");
      return [];
    }
  }



  ///make function take storeTransOModel(StoreTrnsOModel) and add it to storeTransOModelList
  void addOrUpdateStoreTransOModel(StoreTrnsOModel selectedItem) {
    if(storeTransOModelList.length>0){
      bool isExist = false;
      for (var item in storeTransOModelList) {
        if (item.itemCode == selectedItem.itemCode) {
           isExist = true;
           // update the item
          item = selectedItem;
        }
      }
      if(!isExist){
        storeTransOModelList.add(selectedItem);
      }
    }else {
      StoreTrnsOModel storeTransOModel = StoreTrnsOModel();
      storeTransOModel.branch = transaction.branch;
      storeTransOModel.trnsNo = transaction.trnsNo;
      storeTransOModel.trnsCode = transaction.trnsCode;
      storeTransOModel.itemForm = selectedItem.itemForm;
      storeTransOModel.formDesc = selectedItem.formDesc;

     /* storeTransOModel.formDesc = getItemFormNameByCode(
        storeTransOModel.itemForm!,
      );*/
      storeTransOModel.itemDesc = selectedItem.itemDesc;
      storeTransOModel.itemCode = selectedItem.itemCode;
      storeTransOModel.qty1 = selectedItem.qty1;
      storeTransOModel.unitPrice = selectedItem.unitPrice;
      storeTransOModel.total = selectedItem.total;


      storeTransOModelList.add(storeTransOModel);
    }
    calculateTotal();
    notify();
  }



  void removeOrEditStoreTransOModel(bool isDelete,int index, StoreTrnsOModel updateItem) {
    if(isDelete){
      if (index >= 0 && index < storeTransOModelList.length) {
        storeTransOModelList.removeAt(index);
        print("Removed item at index $index");
        notify();
      } else {
        print("Index out of range");
      }
    }else{
      for(var item in storeTransOModelList){
        if(item.itemCode == updateItem.itemCode){
          item = updateItem;
          break;
        }
      }
    }
    calculateTotal();
    notify();

  }

// Add this method to _TransactionScreenState


  /*Future<List<StoreTrnsDepModel>?> getStoreTransDependency() async {
    final apiResult = await APIService().getStoreTransDependencyList(transaction.branch!,transaction.trnsCode!);

    if (apiResult.status == true && apiResult.data != null) {
      // Map API response to SpinnerModel list
      //List<ItemList> itemList = apiResult.data.items;
      StoreTransDepListResponseModel storeTransListDependency = apiResult.data;
      List<StoreTransListDependency>? storeTransDepList = storeTransListDependency.storeTransDepList;
      //loop for evey item in StoreTransListDependency
      List<StoreTrnsDepModel> storeTransDepModel =[];
        for(var item in storeTransDepList!) {
          StoreTrnsDepModel model = StoreTrnsDepModel();
          model.branch = item.branch;
          model.depOnBranch = item.branch;

          model.trnsCode = item.trnsCode!;
          model.depOnTrnsCode = transactionSpec!.depOnTrnsCodeVal;

          model.trnsNo = item.trnsNo;
          model.depOnTrnsNo = item.trnsNo;
          storeTransDepModel.add(model);
        }


      *//*List<SpinnerModel> spinnerModelList = await MapListModel()
          .mapGetAllDataListToSpinnerModelListItem(itemList!, itemPrice);*//*
      // Update the allItemsFormsList with the fetched data
      // Set the spinner model list to the allItemsFormsList

      //set default

      // Notify listeners about the change
      notify();

      // Return the spinner model list
      print("Fetched all items forms successfully");
      print("Spinner Model List: $storeTransDepModel");
      // Return the spinner model list
      print("Returning spinnerModelList: $storeTransDepModel");
      // Return the spinner model list
      return storeTransDepModel;
    } else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
      // Handle unauthorized access
      print("Unauthorized access");
      ShowMessage().showSnackBar(_context!, apiResult.msg!);
      // You can navigate to the login screen or show a message
      Navigation().logout(_context!);
      return [];
    } else {
      // Handle other cases, such as API failure or no data
      print("API call failed or no data");
      return [];
    }
  }
*/
  Future<List<StoreTransListDependency>?> getStoreTransDependency() async {
    final apiResult = await APIService().getStoreTransDependencyList(transaction.branch!,transactionSpec!.depOnTrnsCodeVal!);

    if (apiResult.status == true && apiResult.data != null) {
      // Map API response to SpinnerModel list
      //List<ItemList> itemList = apiResult.data.items;
      StoreTransDepListResponseModel storeTransListDependency = apiResult.data;
      List<StoreTransListDependency>? storeTransDepList = storeTransListDependency.storeTransDepList;


      /*List<SpinnerModel> spinnerModelList = await MapListModel()
          .mapGetAllDataListToSpinnerModelListItem(itemList!, itemPrice);*/
      // Update the allItemsFormsList with the fetched data
      // Set the spinner model list to the allItemsFormsList

      //set default

      // Notify listeners about the change
      notify();

      // Return the spinner model list
      print("Fetched all items forms successfully");
      print("Spinner Model List: $storeTransDepList");
      // Return the spinner model list
      print("Returning spinnerModelList: $storeTransDepList");
      // Return the spinner model list
      return storeTransDepList;
    } else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
      // Handle unauthorized access
      print("Unauthorized access");

      if (context != null) {
        ShowMessage().showSnackBar(context!, apiResult.msg!);
      } else {
        print("Cannot show snackbar, context is null: ${apiResult.msg}");
      }
     // ShowMessage().showSnackBar(_context!, apiResult.msg!);
      // You can navigate to the login screen or show a message
      Navigation().logout(context!);
      return [];
    } else {
      ShowMessage().showToast(apiResult.msg!);
      // Handle other cases, such as API failure or no data
      print("API call failed or no data");
      return null;
    }
  }

  List<StoreTransListDependency>  getTransWithApprovedToDependOnIt(List<StoreTransListDependency>? storeTransDepList){
      List<StoreTransListDependency> approvedTransList = [];
      switch(transactionSpec?.filterApproved){//
        case Strings.APPROVED_NUMBER :
          // Filter for approved transactions
            for(var item in storeTransDepList!){
              if(item.approved == Strings.APPROVED_DEP) {
                approvedTransList.add(item);
              }
            }
          break;
        case Strings.NOT_APPROVED_NUMBER:
          for(var item in storeTransDepList!){
            if(item.approved != Strings.APPROVED_DEP) {
              approvedTransList.add(item);
            }
          }
          break;
        default:
          approvedTransList =  storeTransDepList!;
          break;
      }
      return approvedTransList;

  }

  Future<TransactionDepOnData?> getTransactionDepOnList(List<StoreTransListDependency>? storeTransDepList) async {

    final apiResult = await APIService().getListOfTransactionDepOn(mapSelectedDepStoreTransList(storeTransDepList),transactionSpec!.trnsCode!);

    if (apiResult.status == true && apiResult.data != null) {
      // Map API response to SpinnerModel list
      //List<ItemList> itemList = apiResult.data.items;
      //TransactionDepListResponseModel transactionDepListResponseModel = apiResult.data;
      TransactionDepOnData? transactionDeOnData = apiResult.data;


      //Map Data
      //1.branch
      List<Branches> branches = (await SharedPreferences().loadBranchesFromPrefs()) as List<Branches>;
      for (var branch in branches) {
        if (branch.code == transactionDeOnData!.branch) {
          transaction.branchName = branch.descr;
          transaction.branch = branch.code!;
          break; // Exit loop once the branch is found
        }
      }

      //2.date
      transaction.trnsDate = transactionDeOnData!.trnsDate.toString().substring(0,10);
      //3.From  & To
      //3.1 Form
      transaction.fromDst = transactionDeOnData.fromDst;
      transaction.fromCode = transactionDeOnData.fromCode;
      //3.1 To
      transaction.toDst = transactionDeOnData.toDst;
      transaction.toCode = transactionDeOnData.toCode;
      //4.Rem
      transaction.rem = transactionDeOnData.rem;

      //5.Groups
      transaction.itemForm = transactionDeOnData.itemForm;
       for(var item in _allItemsFormsList) {
         if (transactionDeOnData.itemForm == item.id) {
           transaction.itemFormName = item.name;
           break; // Exit loop once the item form is found
         }
       }
      //5.1 Items
      storeTransOModelList.clear();
      storeTransOModelList = transactionDeOnData.storeTrnsOModels!;
      for(var item in storeTransOModelList){
        item.total = item.qty1! * item.unitPrice!;
      }

      calculateTotal();

      notify();
      print("Returning TransactionDepOnData: $transactionDeOnData");
      print("Returning storeTransOModelList: $storeTransOModelList");


      /*List<SpinnerModel> spinnerModelList = await MapListModel()
          .mapGetAllDataListToSpinnerModelListItem(itemList!, itemPrice);*/
      // Update the allItemsFormsList with the fetchedI/Choreographer(32738): Skipped 60 frames!  The application may be doing too much work on its main thread. data
      // Set the spinner model list to the allItemsFormsList

      //set default

      // Notify listeners about the change

      // Return the spinner model list
      print("Fetched all items forms successfully");
      print("Spinner Model List: $transactionDeOnData");
      // Return the spinner model list
      print("Returning spinnerModelList: $transactionDeOnData");
      // Return the spinner model list
      return transactionDeOnData;
    } else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
      // Handle unauthorized access
      print("Unauthorized access");
      ShowMessage().showSnackBar(_context!, apiResult.msg!);
      // You can navigate to the login screen or show a message
      Navigation().logout(_context!);
      return TransactionDepOnData();
    } else {
      ShowMessage().showToast(apiResult.msg!);
      // Handle other cases, such as API failure or no data
      print("API call failed or no data");
       return TransactionDepOnData();
      ;
    }
  }



  List<DependencyTransList> mapSelectedDepStoreTransList(List<StoreTransListDependency>? storeTransDepList){
    dependencyTransList = [];
    for(var item in storeTransDepList!){
      DependencyTransList dependencyTrans  = DependencyTransList();
      dependencyTrans.branch = item.branch;
      dependencyTrans.trnsCode = item.trnsCode;
      dependencyTrans.trnsNo = item.trnsNo!;
      dependencyTrans.dateTime = item.trnsDate.toString().substring(0,10);
      dependencyTransList.add(dependencyTrans);
    }

    return dependencyTransList;


  }

  void makeTransaction(){
    if(validateForm()){
        showLoading();
       if(storeTransOModelList.length>0){
         transaction.storeTrnsOModels = storeTransOModelList;
       }

       List<StoreTrnsDepModel> storeTrnsDepModels = [];
       if(dependencyTransList.length>0){
         for(DependencyTransList item in dependencyTransList){
                StoreTrnsDepModel depModel = StoreTrnsDepModel();
                depModel.branch = item.branch;
                depModel.depOnBranch = item.branch;

                depModel.trnsCode = item.trnsCode;
                depModel.depOnTrnsCode =transactionSpec!.depOnTrnsCodeVal;

                depModel.trnsNo = item.trnsNo;
                depModel.depOnTrnsNo = item.trnsNo;

                storeTrnsDepModels.add(depModel);
         }
         transaction.storeTrnsDepModels = storeTrnsDepModels;
       }
      makeTransactionGetDetails();
      hideLoading();
    }
  }

  Future<TransactionDetailsResponseModel?> makeTransactionGetDetails() async {

    final apiResult = await APIService().savingOrUpdateTransaction(transaction,false);

    if (apiResult.status == true && apiResult.data != null) {
      // Map API response to SpinnerModel list
      //List<ItemList> itemList = apiResult.data.items;`
      //TransactionDepListResponseModel transactionDepListResponseModel = apiResult.data;
      TransactionDetailsResponseModel? transactionDeOnData = apiResult.data;
      ShowMessage().showSnackBar(_context!, apiResult.msg!);

      // Navigate to transaction details
      //Navigation().navigateToTransactionDetails(context!,_transaction.trnsCode! ,transactionDeOnData!.trnsNo!);

      notify();
      print("Returning TransactionDepOnData: $transactionDeOnData");
      print("Returning storeTransOModelList: $storeTransOModelList");

      print("Fetched all items forms successfully");
      print("Spinner Model List: $transactionDeOnData");
      // Return the spinner model list
      print("Returning spinnerModelList: $transactionDeOnData");
      // Return the spinner model list
      return transactionDeOnData;
    } else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
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
    }
  }



  bool validateForm(){
    if(transaction.branch == null || transaction.branch == ""){
      ShowMessage().showSnackBar(_context!, Strings.ERROR_SELECT_BRANCH);
      return false;
    }else if(transaction.trnsDate == null || transaction.trnsDate == ""){
      ShowMessage().showSnackBar(_context!, Strings.ERROR_SELECT_DATE);
      return false;
    }else if(transaction.fromDst !=0 && transaction.fromCode==""){
      ShowMessage().showSnackBar(_context!, Strings.ERROR_SELECT_FROM_STORE + FormUtils.getNameFromIndex(transaction.fromDst!));
      return false;
    }else if(transaction.toDst!=0 && transaction.toCode == ""){
      ShowMessage().showSnackBar(_context!, Strings.ERROR_SELECT_TO_STORE +FormUtils.getNameFromIndex(transaction.toDst!));
      return false;
    }else if(transaction.itemForm == null || transaction.itemForm == ""){
      ShowMessage().showSnackBar(_context!, Strings.ERROR_SELECT_GROUP_ITEM);
      return false;
    }else if(storeTransOModelList.length == 0){
      ShowMessage().showSnackBar(_context!, Strings.ERROR_SELECT_ITEM);
      return false;
    }else if(transaction.trnsCode == null || transaction.trnsCode=="") {
      ShowMessage().showSnackBar(_context!, Strings.ERROR_SELECT_DEPENDENCY);
    return false;
    }
    else if(transaction.salesRepCode == null && transactionSpec?.salesRep == 1){
      ShowMessage().showSnackBar(_context!, Strings.ERROR_SELECT_SALES_REP);
      return false;
    }

   return true;
  }


  //Refactor
  String calculateTotal() {
      double total = 0.0;
      for (var item in storeTransOModelList) {
         total += item.total;
            }

      transaction.trnsVal = total;
      transaction.trnsNet = total;

      return total.toString();
  }

  void showLoading(){
    LoadingService.showLoading(_context!); // Hide custom loading dialog
  }

  void hideLoading(){
    LoadingService.hideLoading(_context!); // Hide custom loading dialog
  }

  notify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //if (!_disposed) {
        notifyListeners();
      //}
    });
  }


}
