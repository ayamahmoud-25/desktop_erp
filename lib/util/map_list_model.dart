import 'package:desktop_erp_4s/util/spinner_model.dart';
import 'package:desktop_erp_4s/util/strings.dart';

import '../data/models/branch_model.dart';
import '../data/models/response/ItemList.dart';
import '../db/SharedPereference.dart';

class MapListModel<T> {

  Future<List<Branches>> getBranches() async{
    return await SharedPreferences().loadBranchesFromPrefs() ?? [];;
  }


  // map list of branches and return as spinner model list
Future<List<SpinnerModel>> mapListToSpinnerModelList() async{
   //fetch branches list from database or API
   // load branches from shared preferences or any other source
   //loadBranchesFromPrefs
  final branchesList = await SharedPreferences().loadBranchesFromPrefs() ?? [];
  List<SpinnerModel> spinnerModelList = [];
  for (var branch in branchesList) {
      spinnerModelList.add(SpinnerModel(
        id: branch.code!,
        name: branch.descr!,
      ));
    }
    return spinnerModelList;
  }


Future<List<SpinnerModel>>  mapGetAllDataListToSpinnerModelList(dynamic customerList) async{
  //fetch branches list from database or API
  // load branches from shared preferences or any other source
  //loadBranchesFromPrefs
  List<SpinnerModel> spinnerModelList = [];
  for (var item in customerList) {
    spinnerModelList.add(SpinnerModel(
      id: item.code!,
      name: item.description!,
    ));
  }
  return spinnerModelList;
}
  // map list of customers and return as spinner model list


Future<List<SpinnerModel>>  mapGetAllDataListToSpinnerModelListItem(List<ItemList> itemList,String itemPrice) async{
  //fetch branches list from database or API
  // load branches from shared preferences or any other source
  //loadBranchesFromPrefs
  List<SpinnerModel> spinnerModelList = [];
  for (var item in itemList) {
    final price = getPrice(itemPrice, item);
    print("mapGetAllDataListToSpinnerModelListItem: item=${item.itemCode}, price=$price"); // Debugging log
    spinnerModelList.add(SpinnerModel(
      id: item.itemCode!,
      name: item.itemDesc!= null ? item.itemDesc! : Strings.No_DESC_AVAILABLE, // Use a default value if itemDesc is null
      extraItem: price.toString(), // Ensure valid string conversion
    ));
  }
  return spinnerModelList;
}


// map list of customers and return as spinner model list
double getPrice(String priceType, ItemList model) {
  double price =0.0;
  switch (priceType) {
    case "1":
      price =  model.cPurchPrice ?? 0.0;
      break;
    case "2":
      price = model.cDealPrice ?? 0.0;
      break;
    case "3":
      price = model.cSalePrice ?? 0.0;
      break;
    case "4":
      price = model.cBranPrice ?? 0.0;
      break;
    case "5":
      price = model.avPurchPrice ?? 0.0;
    break;
  }
  return price;
}

}
//
