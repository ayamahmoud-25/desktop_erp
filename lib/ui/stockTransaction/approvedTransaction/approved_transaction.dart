import 'package:desktop_erp_4s/data/models/request/transaction_approve_list.dart';
import 'package:desktop_erp_4s/data/models/response/TransactionSpec.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/approvedTransaction/approved_transaction_provider.dart';
import 'package:desktop_erp_4s/ui/widgets/custom_alert_dialog.dart';
import 'package:desktop_erp_4s/ui/widgets/show_message.dart';
import 'package:desktop_erp_4s/util/my_app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../data/models/response/TransactionApproveModel.dart';
import '../../../util/navigation.dart';
import '../../../util/strings.dart' show Strings;
import '../../../data/models/response/Transaction.dart';

import '../../../data/api_state.dart';
import '../../../util/helper.dart';

class ApprovedTransaction extends StatefulWidget {
  final String selectedBranch;
  final String transCode;
  final String transName;

  const ApprovedTransaction({
    Key? key,
    required this.selectedBranch,
    required this.transCode,
    required this.transName,
  }) : super(key: key);

  @override
  _ApprovedTransactionState createState() => _ApprovedTransactionState();
}

// At the top of your _ShowTransactionListState class

class _ApprovedTransactionState extends State<ApprovedTransaction> {
  // Keep a copy of the original full list from the provider
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<Transaction> _filteredTransactions = []; // To hold filtered results

  // Keep a copy of the original full list from the provider
  List<Transaction> _originalTransactions = [];

  List<Transaction> get filteredTransactions => _filteredTransactions;

  // Declare the provider as a field
  ApprovedTransactionProvider? _provider;

  @override
  void initState() {
    super.initState();

    // Initialize the provider field
    _provider = Provider.of<ApprovedTransactionProvider>(context, listen: false);

    _provider?.context = context;

    _searchController.addListener(_filterTransactions);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch initial data

      // Initialize the provider field
      _provider
          ?.storeTransactionList(
            context,
            widget.selectedBranch,
            widget.transCode,
          )
          .then((_) {
            // After data is fetched, initialize original and filtered lists
            // Note: You might need to adjust this depending on how ShowTransactionProvider signals data loading completion
            // and makes the data accessible synchronously after the future completes.
            // For simplicity, assuming provider.transactions is populated after the future.
            final provider = Provider.of<ApprovedTransactionProvider>(
              context,
              listen: false,
            );
            if (provider.state == APIStatue.success) {
              setState(() {
                _originalTransactions = List.from(provider.transactions);
                _filteredTransactions = List.from(provider.transactions);
              });
            } else {
              Navigation().logout(context);
            }
          });
    });
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTransactions);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTransactions() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTransactions =
          _originalTransactions.where((transaction) {
            /*  final transNameLower = transaction.descr?.toLowerCase() ?? ''; // Handle null descr
        return transNameLower.contains(query);
*/
            final transNo = transaction.trnsNo.toString(); // Handle null descr
            return transNo.contains(query);
          }).toList();
    });
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear(); // Clear search text
      // _filteredTransactions = List.from(_originalTransactions); // Reset to full list - _filterTransactions will do this
    });
  }

  // Inside the build method of _ShowTransactionListState:

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 23, 111, 153),
          iconTheme: IconThemeData(
            color: Colors.white, // Set back button color to white
          ),
          title:
              _isSearching
                  ? TextField(
                    controller: _searchController,
                    autofocus: true, // Automatically focus the search field
                    decoration: InputDecoration(
                      hintText: Strings.SEARCH_HINT_TRANS,
                      hintStyle: TextStyle(color: Colors.white70),
                      border: InputBorder.none,
                    ),
                    style: TextStyle(color: Colors.white),
                  )
                  : Text(
                    widget.transName,
                    style: TextStyle(color: Colors.white),
                  ),
          actions: [
            Visibility(
              visible: _provider!.transApproveList.length > 0 ? true : false,
              child: TextButton(
                onPressed: () {
                  //show dialog alert and take action if it is agree to finish approve

                  CustomAlertDialog()
                      .showCustomAlertDialog(
                        context: context,
                        title: Strings.APPROVE_DIALOG_TRANS_TITLE,
                        message: Strings().approveDialogMessage(
                          _provider!.transApproveList.length,
                        ),
                        okText: Strings.APPROVE_DIALOG_TRANS_OK,
                        cancelText: Strings.APPROVE_DIALOG_TRANS_CANCEL,
                      )
                      .then((result) {
                        print("Result is ${result}");
                        if (result == true) {

                          _provider!
                              .approveTransactionList();
                        }
                      });
                },
                child: const Text(
                  Strings.APPROVE_DIALOG_TRANS_OK,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(_isSearching ? Icons.close : Icons.search),
              onPressed: () {
                if (_isSearching) {
                  _stopSearch();
                } else {
                  _startSearch();
                }
              },
            ),
          ],
        ),
        body: Consumer<ApprovedTransactionProvider>(
          builder: (context, provider, child) {
            // Important: Update _originalTransactions when provider data changes
            if (provider.state == APIStatue.success &&
                _originalTransactions.isEmpty &&
                provider.transactions.isNotEmpty) {
              // This is a common place to initialize after first successful fetch
              // Or if data can be refreshed, you'd update it here too.
              // Consider if the data fetching logic in initState is sufficient or needs adjustment
              // with this Consumer-based update.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // To avoid calling setState during build
                if (mounted) {
                  // Ensure widget is still mounted
                  setState(() {
                    _originalTransactions = List.from(provider.transactions);
                    // If not searching, filtered should match original.
                    // If searching, _filterTransactions will handle it based on current query.
                    if (!_isSearching || _searchController.text.isEmpty) {
                      _filteredTransactions = List.from(provider.transactions);
                    } else {
                      _filterTransactions(); // Re-apply filter if data changed
                    }
                  });
                }
              });
            }

            if (provider.state == APIStatue.loading &&
                _originalTransactions.isEmpty) {
              // Show loader only on initial load
              return const Center(child: CircularProgressIndicator());
            } else if (provider.state == APIStatue.error) {
              return Center(
                child: Text(
                  provider.errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (_filteredTransactions.isNotEmpty) {
              // Use _filteredTransactions here
              return ListView.builder(
                itemCount: _filteredTransactions.length,
                // Use filtered list length
                itemBuilder: (context, index) {
                  final transaction =
                      _filteredTransactions[index]; // Use filtered list
                  final branchNumber = transaction.branch;
                  final transCode = transaction.trnsCode;
                  final transNo = transaction.trnsNo;
                  var isApproved =
                      transaction.approved != null &&
                      transaction.approved == "Y";
                  var isChecked = transaction.isChecked;
                  final TransactionApproveModel? transApproveModel =
                      transaction.trnsApproveModel;
                  // ... rest of your Card widget remains the same
                  return InkWell(
                    // Use filtered list
                    onTap: () {},
                    child: Column(
                      children: [
                        Opacity(
                          opacity: isApproved ? 0.6 : 1.0,
                          child: ListTile(
                            trailing: Checkbox(
                              value: (isApproved || isChecked) ? true : false,
                              onChanged: (bool? newValue) {
                                setState(() {
                                  if (!isApproved) {
                                    if (provider.transApproveList.length > 0) {
                                      bool isExist = false;
                                      for (var item
                                          in provider.transApproveList) {
                                        if (item.transNo == transaction.trnsNo.toString()) {
                                          isExist = true;
                                          provider.transApproveList.remove(
                                            item,
                                          );
                                          setState(() {
                                            // isChecked = false;
                                            transaction.isChecked = false;
                                          });
                                          break;
                                        }
                                      }
                                      if (!isExist) {
                                        setState(() {
                                          // isChecked = true;
                                          transaction.isChecked = true;
                                        });
                                        TransactionApproveList transApproveObj =
                                            TransactionApproveList();
                                        transApproveObj.approve = 1;
                                        transApproveObj.branchId = branchNumber;
                                        transApproveObj.level =
                                            transApproveModel?.level;
                                        transApproveObj.transCode =
                                            transApproveModel?.trnsCode;
                                        transApproveObj.transNo =
                                            transApproveModel?.trnsNo
                                                ?.toString();
                                        provider.transApproveList.add(
                                          transApproveObj,
                                        );
                                      }
                                    } else {
                                      setState(() {
                                        //isChecked = true;
                                        transaction.isChecked = true;
                                      });
                                      TransactionApproveList transApproveObj =
                                          TransactionApproveList();
                                      transApproveObj.approve = 1;
                                      transApproveObj.branchId = branchNumber;
                                      transApproveObj.level =
                                          transApproveModel?.level;
                                      transApproveObj.transCode =
                                          transApproveModel?.trnsCode;
                                      transApproveObj.transNo =
                                          transApproveModel?.trnsNo?.toString();
                                      provider.transApproveList.add(
                                        transApproveObj,
                                      );
                                    }
                                  }
                                });
                              },
                              activeColor: Colors.blue[600],
                            ),
                            title: Text(
                              'الفرع ($branchNumber) - الكود ($transCode) - الرقم ($transNo)',
                              textAlign: TextAlign.right,
                              style: const TextStyle(fontSize: 16),
                            ),
                            dense: true,
                          ),
                        ),
                        const Divider(
                          height: 5,
                          thickness: 1,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (provider.state == APIStatue.success &&
                provider.transactions.isEmpty) {
              return const Center(child: Text(Strings.NO_TRANS_FOUND));
            }
            // Fallback, should ideally be covered by other conditions
            return const Center(child: Text(Strings.LOADING_NO_DATA));
          },
        ),
      ),
    );
  }
}
