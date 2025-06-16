import 'package:desktop_erp_4s/util/spinner_model.dart';

import '../db/SharedPereference.dart';

class MapListModel<T> {

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
}