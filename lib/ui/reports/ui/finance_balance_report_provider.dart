// create class provider
import 'package:desktop_erp_4s/ui/reports/model/report_data_model.dart';
import 'package:desktop_erp_4s/util/helper.dart';
import 'package:desktop_erp_4s/util/spinner_model.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/api/api_constansts.dart';
import '../../../data/api/api_result.dart';
import '../../../data/api/api_service.dart';
import '../../../data/models/response/FinanceBalanceReportResponse.dart';
import '../../../util/Strings.dart';
import '../../../util/loading_service.dart';
import '../../../util/map_list_model.dart';
import '../../../util/navigation.dart';
import '../../widgets/show_message.dart';

class FinanceBalanceReportProvider extends ChangeNotifier {


  BuildContext? _context;
  ReportDataModel reportDataModel = ReportDataModel();



  SpinnerModel? _reportType;

  SpinnerModel? get reportType => _reportType;

  set reportType(SpinnerModel? value) {
    _reportType = value;
    reportDataModel.agentType = value?.id;
    print("reportType: ${reportDataModel.agentType}");
    notifyListeners(); // المفروض تكون notifyListeners() مش notify()
  }



  set context(BuildContext? context) {
    _context = context;
    // Instead of  notifyListeners() directly:
    notify();
  }

  BuildContext? get context => _context;


  Future<void> initial() async {
    // 1. تعيين قيم مبدئية
    reportType = getReportTypeList()[0];
    reportDataModel.fromDate = Helper().getCurrentFormattedDate();
    reportDataModel.toDate = Helper().getCurrentFormattedDate();

    // 2. تحميل البيانات
    await getSpinnerModelListByIndex();

    // 3. إشعار الواجهة إن البيانات اتحدثت
    notify();
  }

  List<SpinnerModel>  getReportTypeList() {
    return Helper().getReportTypeList();
  }


  Future<List<SpinnerModel>> getSpinnerModelListByIndex() async {
    //LoadingService.showLoading(_context!);
    switch (reportType!.id) {
      case Strings.CUSTOMER_TYPE: //Customer
        final apiResult = await APIService().getAllCustomer();
        return await mapDataList(apiResult);
      case Strings.VENDOR_TYPE: // Vendor
      // Call API to get all customers
        final apiResult = await APIService().getAllVendors();
        return await mapDataList(apiResult);
      case Strings.CONTRACTOR_TYPE: //contractors
        final apiResult = await APIService().getAllContactor();
        return await mapDataList(apiResult);
      case Strings.AGENT_TYPE: // Agent
        final apiResult = await APIService().getAllAgents();
        return await mapDataList(apiResult);
      case Strings.BANK_TYPE: // Agent
        final apiResult = await APIService().getAllBank();
        return await mapDataList(apiResult);
      case Strings.TREASURE_BAS_TYPE: // Agent
        final apiResult = await APIService().getAllTreasures();
        return await mapDataList(apiResult);

      default:
        throw Exception("Invalid index");
    }
  }

  Future<List<SpinnerModel>> mapDataList(APIResult apiResult) async {
    //LoadingService.hideLoading(_context!);
    if (apiResult.status == true && apiResult.data != null) {
      // Map API response to SpinnerModel list
      List<SpinnerModel> spinnerModelList = await MapListModel().mapGetAllDataListToSpinnerModelList(apiResult.data.items);
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




  Future<List<FinanceBalanceReportResponse>> getFinanceBalanceReport() async {
    LoadingService.showLoading(_context!);
    final apiResult = await APIService().getFinanceBalanceReport(reportDataModel);

    if (apiResult.status == true && apiResult.data != null) {
      LoadingService.hideLoading(_context!);

      // Map API response to SpinnerModel list
      //List<ItemList> itemList = apiResult.data.items;`
      //TransactionDepListResponseModel transactionDepListResponseModel = apiResult.data;
      //TransactionDetailsResponseModel? transaction = apiResult.data;
      //ShowMessage().showSnackBar(_context!, apiResult.msg!);
     List<FinanceBalanceReportResponse> financeBalanceReportList = apiResult.data.items;




      notify();
      print("Returning TransactionDepOnData: $financeBalanceReportList");
      print("Returning storeTransOModelList: $financeBalanceReportList");

      print("Fetched all items forms successfully");
      print("Spinner Model List: $financeBalanceReportList");
      // Return the spinner model list
      print("Returning spinnerModelList: $financeBalanceReportList");
      // Return the spinner model list
      return financeBalanceReportList;
    } else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
      // Handle unauthorized access
      print("Unauthorized access");
      ShowMessage().showSnackBar(_context!, apiResult.msg!);
      // You can navigate to the login screen or show a message
      Navigation().logout(_context!);
      return [];
    }else if(apiResult.code==APIConstants.RESPONSE_CODE_ERROR){
      LoadingService.hideLoading(_context!);
      ShowMessage().showSnackBar(_context!, apiResult.msg!);

      return  [];

    } else  {
      LoadingService.hideLoading(_context!);
      ShowMessage().showSnackBar(_context!,apiResult.msg!);
      // Handle other cases, such as API failure or no data
      print("API call failed or no data");
      return  [];
      ;
    }
  }









  notify() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //if (!_disposed) {
      notifyListeners();
      //}
    });
  }




}