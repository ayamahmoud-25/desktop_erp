import 'package:desktop_erp_4s/data/models/response/TransactionSpec.dart';
import 'package:flutter/cupertino.dart';

import '../../../data/api/api_constansts.dart';
import '../../../data/api/api_service.dart';
import '../../../data/api_state.dart';
import '../../../data/models/request/transaction_approve_list.dart';
import '../../../data/models/response/BasicDataListResponse.dart';
import '../../../data/models/response/Transaction.dart';
import '../../../data/models/response/TransactionDetailsResponseModel.dart';
import '../../../util/loading_service.dart';
import '../../../util/navigation.dart';
import '../../widgets/show_message.dart';

class ApprovedTransactionProvider extends ChangeNotifier {
  final APIService _apiService = APIService();

  APIStatue _state = APIStatue.initial;
  String? _errorMessage;
  List<Transaction> _transactions = [];

  APIStatue get state => _state;
  String? get errorMessage => _errorMessage;
  List<Transaction> get transactions => _transactions;

  List<TransactionApproveList> _transApproveList = [];


  //set get
  List<TransactionApproveList> get transApproveList => _transApproveList;
  set transApproveList(List<TransactionApproveList> transApproveList) {
    _transApproveList = transApproveList;
    notify();
  }

  BuildContext? _context;
  BuildContext? get context => _context;

  set context(BuildContext? context) {
    _context = context;
    // Instead of notifyListeners() directly:
    notify();
  }

/*
  Future<void> storeTransactionList(BuildContext context, String selectedBranch, String transCode) async {
    _state = APIStatue.loading;
    notifyListeners();

    try {
      final result = await _apiService.getStoreTransactionList(selectedBranch, transCode);
      _transactions = result.data as List<Transaction>;
      _state = APIStatue.success;
    } catch (e) {
      _errorMessage = e.toString();
      _state = APIStatue.error;
    }

    notifyListeners();
  }
*/
  Future<List<Transaction>> storeTransactionList(BuildContext context, String selectedBranch, String transCode) async {
    _state = APIStatue.loading;
    notifyListeners();

    try {
      final response = await _apiService.getStoreTransactionList(selectedBranch, transCode);
      if (response.status!) {
        BasicDataListResponse<Transaction> basicDataListResponse = response.data;
        _transactions = basicDataListResponse.items!;

        _transactions.sort((a,b) {
          // Both trnsCode are String?
          final String? codeA = a.trnsDate;
          final String? codeB = b.trnsDate;

          // 1. Handle nulls first
          if (codeA == null && codeB == null) return 0; // Both null, equal
          if (codeA == null) return -1; // Nulls first (or 1 for nulls last)
          if (codeB == null) return 1;  // Nulls first (or -1 for nulls last)

          // 2. Attempt to parse strings to integers
          int? numA = int.tryParse(codeA);
          int? numB = int.tryParse(codeB);

          // 3. Compare based on successful parsing
          if (numA != null && numB != null) {
            // Both are valid numbers, compare them numerically
            return numB.compareTo(numA);
          } else if (numA != null && numB == null) {
            // codeA is a number, codeB is not (or unparseable string). Numbers come first.
            return -1;
          } else if (numA == null && numB != null) {
            // codeB is a number, codeA is not. Numbers come first.
            return 1;
          } else {
            // Neither could be parsed as an int (or they are unparseable strings like "abc").
            // Fallback to standard string comparison for these non-numeric strings.
            // This ensures "abc" is sorted relative to "xyz" correctly.
            return codeB.compareTo(codeA);
          }
        });
        _state = APIStatue.success;
        notifyListeners();
        return _transactions; // Return the list of transactions
      } else {
        _state = APIStatue.error;
        _errorMessage = response.msg;
        notifyListeners();
        return []; // Return an empty list on error
      }
    } catch (e) {
      _state = APIStatue.error;
      _errorMessage = e.toString();
      notifyListeners();
      return []; // Return an empty list on exception
    }
  }


  Future<TransactionDetailsResponseModel?> approveTransactionList() async {
    LoadingService.showLoading(_context!);

    final apiResult = await APIService().postApproveTransList(_transApproveList);

    if (apiResult.status == true && apiResult.data != null) {
      LoadingService.hideLoading(_context!);

      // Map API response to SpinnerModel list
      //List<ItemList> itemList = apiResult.data.items;`
      //TransactionDepListResponseModel transactionDepListResponseModel = apiResult.data;
      TransactionDetailsResponseModel? transaction = apiResult.data;
      //ShowMessage().showSnackBar(_context!, apiResult.msg!);



      notify();
      print("Returning TransactionDepOnData: $transaction");
      print("Returning storeTransOModelList: $transaction");

      print("Fetched all items forms successfully");
      print("Spinner Model List: $transaction");
      // Return the spinner model list
      print("Returning spinnerModelList: $transaction");
      // Return the spinner model list
      return transaction;
    } else if (apiResult.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED) {
      // Handle unauthorized access
      print("Unauthorized access");
      ShowMessage().showSnackBar(_context!, apiResult.msg!);
      // You can navigate to the login screen or show a message
      Navigation().logout(_context!);
      return TransactionDetailsResponseModel();
    }else if(apiResult.code==APIConstants.RESPONSE_CODE_ERROR){
      LoadingService.hideLoading(_context!);
      ShowMessage().showSnackBar(_context!, apiResult.msg!);

      return TransactionDetailsResponseModel();

    } else  {
      LoadingService.hideLoading(_context!);
      ShowMessage().showSnackBar(_context!,apiResult.msg!);
      // Handle other cases, such as API failure or no data
      print("API call failed or no data");
      return TransactionDetailsResponseModel();
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



