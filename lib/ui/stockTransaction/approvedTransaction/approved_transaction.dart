import 'package:desktop_erp_4s/data/models/response/TransactionSpec.dart';
import 'package:desktop_erp_4s/ui/stockTransaction/approvedTransaction/approved_transaction_provider.dart';
import 'package:desktop_erp_4s/util/my_app_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../util/strings.dart' show Strings;
import '../../../data/models/response/Transaction.dart';

import '../../../data/api_state.dart';
import '../../../util/helper.dart';

class ApprovedTransaction extends StatefulWidget {
  final String selectedBranch;
  final String transCode;

  const ApprovedTransaction({
    Key? key,
    required this.selectedBranch,
    required this.transCode,
  }) : super(key: key);

  @override
  _ApprovedTransactionState createState() => _ApprovedTransactionState();
}

// At the top of your _ShowTransactionListState class

class _ApprovedTransactionState extends State<ApprovedTransaction> {
  // Keep a copy of the original full list from the provider
  List<Transaction> _transactionList = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Fetch initial data
      Provider.of<ApprovedTransactionProvider>(
        context,
        listen: false,
      ).storeTransactionList(context, widget.selectedBranch, widget.transCode).then((
        _,
      ) {
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
            _transactionList = List.from(provider.transactions);
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: MyAppColor.backgroundColor,
          // A darker blue for the AppBar
          title: const Text(
            'طلب شراء',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: const Text(
                'موافقة',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(width: 8),
            /*IconButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onPressed: () {},
                ),*/
          ],
        ),
        body: Consumer<ApprovedTransactionProvider>(
          builder: (context, provider, child) {
            // Important: Update _originalTransactions when provider data changes
            if (provider.state == APIStatue.success &&
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
                    _transactionList = List.from(provider.transactions);
                  });
                }
              });
            }

            if (provider.state == APIStatue.loading &&
                _transactionList.isEmpty) {
              // Show loader only on initial load
              return const Center(child: CircularProgressIndicator());
            } else if (provider.state == APIStatue.error) {
              return Center(
                child: Text(
                  provider.errorMessage ?? 'An error occurred',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (_transactionList.isNotEmpty) {
              // Use _filteredTransactions here
              return ListView.builder(
                itemCount: _transactionList.length,
                // Use filtered list length
                itemBuilder: (context, index) {
                  final transaction = _transactionList[index]; // Use filtered list
                  final branchNumber = _transactionList[index].branch;
                  final transCode = _transactionList[index].trnsCode;
                  final transNo = _transactionList[index].trnsNo;
                  final isApproved = transaction.approved!=null && transaction.approved == "Y";
                  return InkWell(
                    onTap: () {},
                    child: Column(
                      children: [
                        Opacity(
                          opacity: isApproved ? 1.0 : 1.0,
                          child: ListTile(
                            trailing: Checkbox(
                              value: false,
                              onChanged: (bool? newValue) {
                                // Handle checkbox state change here
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
