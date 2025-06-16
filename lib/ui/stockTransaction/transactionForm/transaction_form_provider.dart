import 'package:desktop_erp_4s/data/api/api_result.dart';
import 'package:desktop_erp_4s/data/app_constants.dart';
import 'package:desktop_erp_4s/util/map_list_model.dart';

import '../../../data/api/api_service.dart';
import '../../../data/models/request/transaction_creating_model.dart';
import '../../../util/spinner_model.dart';
import '../../../util/strings.dart' show Strings;

class TransactionFormProvider {

 // create instance of TransactionCreatingModel

  // Private instance of TransactionCreatingModel
  TransactionCreatingModel _transaction = TransactionCreatingModel();

  // Getter for the transaction instance
  TransactionCreatingModel get transaction => _transaction;

  // Setter for the transaction instance
  set transaction(TransactionCreatingModel transaction) {
    _transaction = transaction;
  }
  static Future<List<SpinnerModel>> getSpinnerModelListByIndex(int indexName ,String transCode) async {
    switch (indexName) {
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
      case  Strings.DEPARTS://department
        final apiResult = await APIService().getAllDepart(true , transCode);
        return await mapDataList(apiResult);
      case  Strings.CONTRACTORS://contractors
        final apiResult = await APIService().getAllContactor(true, transCode);
        return await mapDataList(apiResult);
      case Strings.PERSONS://persons
        final apiResult = await APIService().getAllPersons(true, transCode);
        return await mapDataList(apiResult);
      default:
        throw Exception("Invalid index");
    }
  }

  static Future<List<SpinnerModel>> mapDataList(APIResult apiResult) async {
     if (apiResult.status == true && apiResult.data != null) {
      // Map API response to SpinnerModel list
      List<SpinnerModel> spinnerModelList = await MapListModel().mapGetAllDataListToSpinnerModelList(apiResult.data.items);
      return spinnerModelList;
    } else {
      return [];
    }
  }

  static Future<List<SpinnerModel>> getAllItemsForms() async {
    final apiResult = await APIService().getAllItemsForms();
    if (apiResult.status == true && apiResult.data != null) {
      // Map API response to SpinnerModel list
      List<SpinnerModel> spinnerModelList = await MapListModel().mapGetAllDataListToSpinnerModelList(apiResult.data.items);
      return spinnerModelList;
    } else {
      return [];
    }
  }



}