import 'package:desktop_erp_4s/data/api/api_result.dart';
import 'package:desktop_erp_4s/ui/widgets/show_message.dart';
import 'package:desktop_erp_4s/util/map_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/api/api_constansts.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/request/transaction_creating_model.dart';
import '../../../util/navigation.dart';
import '../../../util/spinner_model.dart';
import '../../../util/strings.dart' show Strings;

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

  BuildContext? get context => _context;

  set context(BuildContext? context) {
    _context = context;
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
    final apiResult = await APIService().getAllItemsForms();
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
    }
    return [];
  }
}
