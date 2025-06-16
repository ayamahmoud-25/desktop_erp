

import 'package:desktop_erp_4s/data/api/api_service.dart';
import 'package:flutter/cupertino.dart';

import '../../data/api/api_constansts.dart';
import '../../data/api_state.dart';
import '../../data/models/response/AllAgents.dart';
import '../../data/models/response/AllContractor.dart';
import '../../data/models/response/AllCustomer.dart';
import '../../data/models/response/AllPersons.dart';
import '../../data/models/response/AllVendors.dart';
import '../../data/models/response/AllWorkAreas.dart';
import '../../data/models/response/BasicDataListResponse.dart';
import '../../data/models/response/DataResponseModel.dart';
import '../../data/models/response/TransactionSpec.dart';
import '../../db/database_helper.dart';
import '../../util/navigation.dart';
import '../stockTransaction/stock_transaction_list.dart';

class HomeProvider extends ChangeNotifier {
  final APIService _apiService = APIService();

  APIStatue _state = APIStatue.initial;
  String? _errorMessage;

  APIStatue get state => _state;

  String? get errorMessage => _errorMessage;

  Future<void> transactionStockSpecs(BuildContext context) async {
    _state = APIStatue.loading;
    notifyListeners();
    final response = await _apiService.getTransactionSpecs();

    if (response.status!) {
      _state = APIStatue.success;
      DataResponseModel dataResponseModel = response.data;

      //Create db and insert all data
      final dbHelper = DatabaseHelper();
      // dbHelper.clearDatabase();
      await dbHelper.database; // initialize the database

      // Check if the table exists
      final tableExists = await dbHelper.isTableExists('transaction_specs');
      if (!tableExists) {
        // Table does not exist, create it
        print('Table does not exist');
        dbHelper.createTable("transaction_specs", '''
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          TRNS_CODE TEXT,
          TRNS_TYPE INTEGER,
          TRNS_DESC TEXT,
          FROM_DST INTEGER,
          TO_DST INTEGER,
          FROM_CODE TEXT,
          TO_CODE TEXT,
          QUANTITY_EFFECT INTEGER,
          PAY_EFFECT INTEGER,
          NOTES INTEGER,
          IMMEDIATE_PAY INTEGER,
          ITEM_FORM TEXT,
          SHOW_PRICE INTEGER,
          ITEM_PRICE INTEGER,
          SALES_TAX INTEGER,
          TAX_RATE REAL,
          COMM_TAX INTEGER,
          COMM_RATE REAL,
          NEEDAPPROVE TEXT,
          APPROVE_NAME TEXT,
          HAS_CHATS INTEGER,
          SALES_REP INTEGER,
          DEP_ON_TRNS_CODE_VAL TEXT,
          NO_CALC_DEP INTEGER,
          ONLYONEDEP INTEGER,
          GET_DEP_QTY INTEGER,
          DEPSIGN INTEGER,
          FILTER_APPROVED TEXT,
          GET_FROM INTEGER,
          GET_TO INTEGER,
          REVERSE_POLES INTEGER,
          TRNS_ITEMS_DISCOUNT INTEGER,
          TRNS_DISCOUNT INTEGER,
          TRNSDEDUCRATE REAL,
          SHOW_DEDUC_RATE INTEGER,
          DEP_MUST INTEGER,
          ALLOW_MOBILE_EDIT INTEGER 
           ''');
        print('Table created successfully');

        List<TransactionSpec>? transactionSpecList =
            dataResponseModel.transactionSpecs;
        if (transactionSpecList != null) {
          transactionSpecList.forEach((transactionSpec) async {
            await dbHelper.insert('transaction_specs', {
              'TRNS_CODE': transactionSpec.trnsCode,
              'TRNS_TYPE': transactionSpec.trnsType,
              'TRNS_DESC': transactionSpec.trnsDesc,
              'FROM_DST': transactionSpec.fromDst,
              'TO_DST': transactionSpec.toDst,
              'FROM_CODE': transactionSpec.fromCode,
              'TO_CODE': transactionSpec.toCode,
              'QUANTITY_EFFECT': transactionSpec.quantityEffect,
              'PAY_EFFECT': transactionSpec.payEffect,
              'NOTES': transactionSpec.notes,
              'IMMEDIATE_PAY': transactionSpec.immediatePay,
              'ITEM_FORM': transactionSpec.itemForm,
              'SHOW_PRICE': transactionSpec.showPrice,
              'ITEM_PRICE': transactionSpec.itemPrice,
              'SALES_TAX': transactionSpec.salesTax,
              'TAX_RATE': transactionSpec.taxRate,
              'COMM_TAX': transactionSpec.commTax,
              'COMM_RATE': transactionSpec.commRate,
              'NEEDAPPROVE': transactionSpec.needApprove,
              'APPROVE_NAME': transactionSpec.approveName,
              'HAS_CHATS': transactionSpec.hasChats,
              'SALES_REP': transactionSpec.salesRep,
              'DEP_ON_TRNS_CODE_VAL': transactionSpec.depOnTrnsCodeVal,
              'NO_CALC_DEP': transactionSpec.noCalcDep,
              'ONLYONEDEP': transactionSpec.onlyOneDep,
              'GET_DEP_QTY': transactionSpec.getDepQty,
              'DEPSIGN': transactionSpec.depSign,
              'FILTER_APPROVED': transactionSpec.filterApproved,
              'GET_FROM': transactionSpec.getFrom,
              'GET_TO': transactionSpec.getTo,
              'REVERSE_POLES': transactionSpec.reversePoles,
              'TRNS_ITEMS_DISCOUNT': transactionSpec.trnsItemsDiscount,
              'TRNS_DISCOUNT': transactionSpec.trnsDiscount,
              'TRNSDEDUCRATE': transactionSpec.trnsDeducRate,
              'SHOW_DEDUC_RATE': transactionSpec.showDeducRate,
              'DEP_MUST': transactionSpec.depMust,
              'ALLOW_MOBILE_EDIT': transactionSpec.allowMobileEdit,
            });
          });
          print('Data inserted successfully');
        }
      } else {
        // Table exists, you can perform operations on it
        print('Table already exists');
        // Retrieve all rows from the table
        List<Map<String, dynamic>> rows = await dbHelper.getAll(
          'transaction_specs',
        );
        // Debug the structure of rows
        print(rows);
        // Map rows to TransactionSpec objects
        try {
          List<TransactionSpec> transactionSpecs =
          rows.map((map) {
            return TransactionSpec.fromJson(map);
          }).toList();

          transactionSpecs.forEach((transactionSpec) {
            print("Transaction Desc: ${transactionSpec.trnsCode}");
          });
        } catch (e) {
          print("Error mapping rows to TransactionSpec: $e");
        }
      }

      notifyListeners();
      //
      Navigation().pushNavigation(context, StockTransactionList());
    } else {
      if(response.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
       // Handle unauthorized access
        print("Unauthorized access");
        // You can navigate to the login screen or show a message
        Navigation().logout(context);


      }
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }
  }

 /* Future<void> fetchAllDats(BuildContext context) async {
    _state = APIStatue.loading;
    notifyListeners();
     //Fetch all data
    try {
      // Call all functions in parallel
      await Future.wait([
        allCustomer(context),
        allVendors(context),
        allAgents(context),
        allWorkAreas(context),
        allPersons(context),
        allContractor(context),
      ]);

      _state = APIStatue.success;
      notifyListeners();

    } catch (error) {
      _state = APIStatue.error;
      _errorMessage = error.toString();
      notifyListeners();

      if (error.toString().contains('UNAUTHORIZED')) {
        Navigation().logout(context);
      }
    }

    }*/
/*
   with saved in db


  // allCustomer
  Future<void> allCustomer(BuildContext context,String transType,String transCode) async {
    _state = APIStatue.loading;
    notifyListeners();
    final response = await _apiService.getAllCustomer(transType,transCode);

    if (response.status!) {
      _state = APIStatue.success;

      BasicDataListResponse<AllCustomer> basicDataListResponse = response.data;

      //Create db and insert all data
      final dbHelper = DatabaseHelper();

      // dbHelper.clearDatabase();
      await dbHelper.database; // initialize the database

      // Check if the table exists
      final tableExists = await dbHelper.isTableExists('all_customer');
      if (!tableExists) {
        // Table does not exist, create it
        print('Table does not exist');
        dbHelper.createTable("all_customer", '''
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          CODE TEXT,
          DESCR TEXT
           ''');
        print('Table created successfully');
        List<AllCustomer>? allCustomerList = basicDataListResponse.items;
        if (allCustomerList != null) {
          allCustomerList.forEach((customer) async {
            await dbHelper.insert('all_customer', {
              'CODE': customer.code,
              'DESCR': customer.description,
            });
          });
          print('Data inserted successfully');
        }
      } else {
        // Table exists, you can perform operations on it
        print('Table already exists');
        // Retrieve all rows from the table
        List<Map<String, dynamic>> rows = await dbHelper.getAll(
          'all_customer',
        );
        // Debug the structure of rows
        print(rows);
        // Map rows to TransactionSpec objects
        try {
          List<AllCustomer> allCustomerList =
          rows.map((map) {
            return AllCustomer.fromJson(map);
          }).toList();
          allCustomerList.forEach((customer) {
            print("Customer Desc: ${customer.description}");
          });
        } catch (e) {
          print("Error mapping rows to TransactionSpec: $e");
        }
      }
      notifyListeners();
      //   Navigation().pushNavigation(context, HomePage());
    } else {
      if(response.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        // Handle unauthorized access
        print("Unauthorized access");
        // You can navigate to the login screen or show a message
        Navigation().logout(context);
      }
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }
  }

  //All Vendor
  Future<void> allVendors(BuildContext context,String transType,String transCode) async {
    _state = APIStatue.loading;
    notifyListeners();
    final response = await _apiService.getAllVendors(transType,transCode);

    if (response.status!) {
      _state = APIStatue.success;

      BasicDataListResponse<AllVendors> basicDataListResponse = response.data;

      //Create db and insert all data
      final dbHelper = DatabaseHelper();

      // dbHelper.clearDatabase();
      await dbHelper.database; // initialize the database

      // Check if the table exists
      final tableExists = await dbHelper.isTableExists('all_vendors');
      if (!tableExists) {
        // Table does not exist, create it
        print('Table does not exist');
        dbHelper.createTable("all_vendors", '''
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          CODE TEXT,
          DESCR TEXT
           ''');
        print('Table created successfully');
        List<AllVendors>? allVendorsList = basicDataListResponse.items;
        if (allVendorsList != null) {
          allVendorsList.forEach((vendors) async {
            await dbHelper.insert('all_vendors', {
              'CODE': vendors.code,
              'DESCR': vendors.description,
            });
          });
          print('Data inserted successfully');
        }
      } else {
        // Table exists, you can perform operations on it
        print('Table already exists');
        // Retrieve all rows from the table
        List<Map<String, dynamic>> rows = await dbHelper.getAll(
          'all_vendors',
        );
        // Debug the structure of rows
        print(rows);
        // Map rows to TransactionSpec objects
        try {
          List<AllVendors> AllVendorsList =
          rows.map((map) {
            return AllVendors.fromJson(map);
          }).toList();
          AllVendorsList.forEach((customer) {
            print("Vendors Desc: ${customer.description}");
          });
        } catch (e) {
          print("Error mapping rows to AllVendors: $e");
        }
      }


      notifyListeners();
      //   Navigation().pushNavigation(context, HomePage());
    } else {
      if(response.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        // Handle unauthorized access
        print("Unauthorized access");
        // You can navigate to the login screen or show a message
        Navigation().logout(context);
      }
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }
  }

  //All Agents
  Future<void> allAgents(BuildContext context,String transType,String transCode) async {
    _state = APIStatue.loading;
    notifyListeners();
    final response = await _apiService.getAllAgents(transType,transCode);

    if (response.status!) {
      _state = APIStatue.success;

      BasicDataListResponse<AllAgents> basicDataListResponse = response.data;

      //Create db and insert all data
      final dbHelper = DatabaseHelper();

      // dbHelper.clearDatabase();
      await dbHelper.database; // initialize the database

      // Check if the table exists
      final tableExists = await dbHelper.isTableExists('all_agents');
      if (!tableExists) {
        // Table does not exist, create it
        print('Table does not exist');
        dbHelper.createTable("all_agents", '''
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          CODE TEXT,
          DESCR TEXT
           ''');
        print('Table created successfully');
        List<AllAgents>? allAgentsList = basicDataListResponse.items;
        if (allAgentsList != null) {
          allAgentsList.forEach((agent) async {
            await dbHelper.insert('all_agents', {
              'CODE': agent.code,
              'DESCR': agent.description,
            });
          });
          print('Data inserted successfully');
        }
      } else {
        // Table exists, you can perform operations on it
        print('Table already exists');
        // Retrieve all rows from the table
        List<Map<String, dynamic>> rows = await dbHelper.getAll(
          'all_agents',
        );
        // Debug the structure of rows
        print(rows);
        // Map rows to TransactionSpec objects
        try {
          List<AllAgents> allAgentsList =
          rows.map((map) {
            return AllAgents.fromJson(map);
          }).toList();
          allAgentsList.forEach((agent) {
            print("Agents Desc: ${agent.description}");
          });
        } catch (e) {
          print("Error mapping rows to AllVendors: $e");
        }
      }






      notifyListeners();
      //   Navigation().pushNavigation(context, HomePage());
    } else {
      if(response.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        // Handle unauthorized access
        print("Unauthorized access");
        // You can navigate to the login screen or show a message
        Navigation().logout(context);
      }
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }
  }

  //AllWork Areas
  Future<void> allWorkAreas(BuildContext context,String transType,String transCode) async {
    _state = APIStatue.loading;
    notifyListeners();
    final response = await _apiService.getAllWorkAreas(transType,transCode);

    if (response.status!) {
      _state = APIStatue.success;

      BasicDataListResponse<AllWorkAreas> basicDataListResponse = response.data;

      //Create db and insert all data
      final dbHelper = DatabaseHelper();

      // dbHelper.clearDatabase();
      await dbHelper.database; // initialize the database

      // Check if the table exists
      final tableExists = await dbHelper.isTableExists('all_work_areas');
      if (!tableExists) {
        // Table does not exist, create it
        print('Table does not exist');
        dbHelper.createTable("all_work_areas", '''
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          CODE TEXT,
          DESCR TEXT
           ''');
        print('Table created successfully');
        List<AllWorkAreas>? allWorkAreasList = basicDataListResponse.items;
        if (allWorkAreasList != null) {
          allWorkAreasList.forEach((agent) async {
            await dbHelper.insert('all_work_areas', {
              'CODE': agent.code,
              'DESCR': agent.description,
            });
          });
          print('Data inserted successfully');
        }
      } else {
        // Table exists, you can perform operations on it
        print('Table already exists');
        // Retrieve all rows from the table
        List<Map<String, dynamic>> rows = await dbHelper.getAll(
          'all_work_areas',
        );
        // Debug the structure of rows
        print(rows);
        // Map rows to TransactionSpec objects
        try {
          List<AllWorkAreas> allWorkAreasList =
          rows.map((map) {
            return AllWorkAreas.fromJson(map);
          }).toList();
          allWorkAreasList.forEach((agent) {
            print("All Work Areas Desc: ${agent.description}");
          });
        } catch (e) {
          print("Error mapping rows to All Work Areas: $e");
        }
      }






      notifyListeners();
      //   Navigation().pushNavigation(context, HomePage());
    } else {
      if(response.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        // Handle unauthorized access
        print("Unauthorized access");
        // You can navigate to the login screen or show a message
        Navigation().logout(context);
      }
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }
  }

  //All Persons
  Future<void> allPersons(BuildContext context,String transType,String transCode) async {
    _state = APIStatue.loading;
    notifyListeners();
    final response = await _apiService.getAllPersons(transType,transCode);

    if (response.status!) {
      _state = APIStatue.success;

      BasicDataListResponse<AllPersons> basicDataListResponse = response.data;

      //Create db and insert all data
      final dbHelper = DatabaseHelper();

      // dbHelper.clearDatabase();
      await dbHelper.database; // initialize the database

      // Check if the table exists
      final tableExists = await dbHelper.isTableExists('all_persons');
      if (!tableExists) {
        // Table does not exist, create it
        print('Table does not exist');
        dbHelper.createTable("all_persons", '''
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          CODE TEXT,
          DESCR TEXT
           ''');
        print('Table created successfully');
        List<AllPersons>? allPersonsList = basicDataListResponse.items;
        if (allPersonsList != null) {
          allPersonsList.forEach((person) async {
            await dbHelper.insert('all_persons', {
              'CODE': person.code,
              'DESCR': person.description,
            });
          });
          print('Data inserted successfully');
        }
      } else {
        // Table exists, you can perform operations on it
        print('Table already exists');
        // Retrieve all rows from the table
        List<Map<String, dynamic>> rows = await dbHelper.getAll(
          'all_persons',
        );
        // Debug the structure of rows
        print(rows);
        // Map rows to TransactionSpec objects
        try {
          List<AllPersons> allPersonsList =
          rows.map((map) {
            return AllPersons.fromJson(map);
          }).toList();
          allPersonsList.forEach((agent) {
            print("All Persons Desc: ${agent.description}");
          });
        } catch (e) {
          print("Error mapping rows to All Persons: $e");
        }
      }

      notifyListeners();
      //   Navigation().pushNavigation(context, HomePage());
    } else {
      if(response.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        // Handle unauthorized access
        print("Unauthorized access");
        // You can navigate to the login screen or show a message
        Navigation().logout(context);
      }
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }
  }

  //All Contractor
  Future<void> allContractor(BuildContext context,String transType,String transCode) async {
    _state = APIStatue.loading;
    notifyListeners();
    final response = await _apiService.getAllContactor(transType,transCode);

    if (response.status!) {
      _state = APIStatue.success;

      BasicDataListResponse<AllContractor> basicDataListResponse = response.data;

      //Create db and insert all data
      final dbHelper = DatabaseHelper();

      // dbHelper.clearDatabase();
      await dbHelper.database; // initialize the database

      // Check if the table exists
      final tableExists = await dbHelper.isTableExists('all_contractor');
      if (!tableExists) {
        // Table does not exist, create it
        print('Table does not exist');
        dbHelper.createTable("all_contractor", '''
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          CODE TEXT,
          DESCR TEXT
           ''');
        print('Table created successfully');
        List<AllContractor>? allContractorList = basicDataListResponse.items;
        if (allContractorList != null) {
          allContractorList.forEach((agent) async {
            await dbHelper.insert('all_contractor', {
              'CODE': agent.code,
              'DESCR': agent.description,
            });
          });
          print('Data inserted successfully');
        }
      } else {
        // Table exists, you can perform operations on it
        print('Table already exists');
        // Retrieve all rows from the table
        List<Map<String, dynamic>> rows = await dbHelper.getAll(
          'all_contractor',
        );
        // Debug the structure of rows
        print(rows);
        // Map rows to TransactionSpec objects
        try {
          List<AllContractor> allContractorList =
          rows.map((map) {
            return AllContractor.fromJson(map);
          }).toList();
          allContractorList.forEach((contactor) {
            print("All Contractor Desc: ${contactor.description}");
          });
        } catch (e) {
          print("Error mapping rows to All Contractor : $e");
        }
      }


      notifyListeners();
      //   Navigation().pushNavigation(context, HomePage());
    } else {
      if(response.code == APIConstants.RESPONSE_CODE_UNAUTHORIZED){
        // Handle unauthorized access
        print("Unauthorized access");
        // You can navigate to the login screen or show a message
        Navigation().logout(context);
      }
      _state = APIStatue.error;
      _errorMessage = response.msg;
      notifyListeners();
    }
  }

*/

  }


