import 'package:desktop_erp_4s/data/models/response/TransactionSpec.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/api_state.dart';
import '../../../util/helper.dart';
import '../../../util/strings.dart' show Strings;
import 'show_transaction_provider.dart';
import '../../../data/models/response/Transaction.dart';

class ShowTransactionList extends StatefulWidget {
  final String selectedBranch;
  final TransactionSpec transactionSpec;

  const ShowTransactionList({
    Key? key,
    required this.selectedBranch,
    required this.transactionSpec,
  }) : super(key: key);

  @override
  _ShowTransactionListState createState() => _ShowTransactionListState();
}

// At the top of your _ShowTransactionListState class

class _ShowTransactionListState extends State<ShowTransactionList> {
  // Add these state variables:
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();
  List<Transaction> _filteredTransactions = []; // To hold filtered results

  // Keep a copy of the original full list from the provider
  List<Transaction> _originalTransactions = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(
      _filterTransactions,
    ); // Listen to search input changes

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch initial data
      Provider.of<ShowTransactionProvider>(
        context,
        listen: false,
      ).storeTransactionList(context, widget.selectedBranch, widget.transactionSpec.trnsCode!).then((
        _,
      ) {
        // After data is fetched, initialize original and filtered lists
        // Note: You might need to adjust this depending on how ShowTransactionProvider signals data loading completion
        // and makes the data accessible synchronously after the future completes.
        // For simplicity, assuming provider.transactions is populated after the future.
        final provider = Provider.of<ShowTransactionProvider>(
          context,
          listen: false,
        );
        if (provider.state == APIStatue.success) {
          setState(() {
            _originalTransactions = List.from(provider.transactions);
            _filteredTransactions = List.from(provider.transactions);
          });
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
                   widget.transactionSpec.trnsDesc!,
                    style: TextStyle(color: Colors.white),
                  ),
          actions: <Widget>[
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
        body: Consumer<ShowTransactionProvider>(
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
                  // ... rest of your Card widget remains the same
                  return InkWell(
                    onTap: () {
                      Provider.of<ShowTransactionProvider>(
                        context,
                        listen: false,
                      ).navigateToTransactionDetails(
                        context,
                        widget.transactionSpec,
                        transaction.branch!,
                        transaction.trnsCode!,
                        transaction.trnsNo,
                        true,
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 23, 111, 153),
                              borderRadius: //circular list top left and right
                                  const BorderRadius.only(
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            padding: const EdgeInsets.all(8.0),
                            width: double.infinity,
                            height: 50,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: const EdgeInsets.only(right: 60),
                                    child: Text(
                                      "${transaction.trnsNo} - ${transaction.trnsCode} - ${transaction.branch} # ",
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      Strings.PRINT,
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    " \u25CF  الفرع  : ${transaction.descr!} ",
                                    // This is 'descr', which is transaction name/description
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        23,
                                        111,
                                        153,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "  \u25CF التاريخ: ${Helper().formatDate(transaction.trnsDate!)}",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        23,
                                        111,
                                        153,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(right: 10),
                                  child: Text(
                                    " \u25CF الطرف إلى : ${transaction.toName != null ? transaction.toName : 'لا يوجد '}",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        23,
                                        111,
                                        153,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(left: 10),
                                  child: Text(
                                    "  \u25CF الطرف من: ${transaction.fromName != null ? transaction.fromName : 'لا يوجد '}",
                                    style: TextStyle(
                                      color: const Color.fromARGB(
                                        255,
                                        23,
                                        111,
                                        153,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ) /*ListTile(
                        title: Text(transaction.branch ?? 'Unknown Branch'),
                        subtitle: Text(transaction.descr ?? 'No Description'),
                      )*/,
                    ),
                  );
                },
              );
            } else if (provider.state == APIStatue.success &&
                provider.transactions.isEmpty) {
              return const Center(child: Text(Strings.NO_TRANS_FOUND));
            } else if (_isSearching && _filteredTransactions.isEmpty) {
              // If searching and no results
              return const Center(child: Text(Strings.NO_TRANS_MATCH));
            }
            // Fallback, should ideally be covered by other conditions
            return const Center(child: Text(Strings.LOADING_NO_DATA));
          },
        ),
      ),
    );
  }

  // ... rest of your _ShowTransactionListState class ...
}
