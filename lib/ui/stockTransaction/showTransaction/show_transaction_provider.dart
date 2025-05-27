import 'package:flutter/cupertino.dart';

import '../../../data/api/api_service.dart';
import '../../../data/api_state.dart';
import '../../../data/models/response/BasicDataListResponse.dart';
import '../../../data/models/response/Transaction.dart';

class ShowTransactionProvider extends ChangeNotifier {
  final APIService _apiService = APIService();

  APIStatue _state = APIStatue.initial;
  String? _errorMessage;
  List<Transaction> _transactions = [];

  APIStatue get state => _state;
  String? get errorMessage => _errorMessage;
  List<Transaction> get transactions => _transactions;

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

}


