import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/api_state.dart';
import '../../../util/helper.dart';
import 'show_transaction_provider.dart';
import '../../../data/models/response/Transaction.dart';

class ShowTransactionList extends StatefulWidget {
  final String selectedBranch;
  final String transCode;

  const ShowTransactionList({
    Key? key,
    required this.selectedBranch,
    required this.transCode,
  }) : super(key: key);

  @override
  _ShowTransactionListState createState() => _ShowTransactionListState();
}

class _ShowTransactionListState extends State<ShowTransactionList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShowTransactionProvider>(context, listen: false)
          .storeTransactionList(context, widget.selectedBranch, widget.transCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction List'),
      ),
      body: Consumer<ShowTransactionProvider>(
        builder: (context, provider, child) {
          if (provider.state == APIStatue.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == APIStatue.error) {
            return Center(
              child: Text(
                provider.errorMessage ?? 'An error occurred',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (provider.state == APIStatue.success && provider.transactions.isNotEmpty) {
            return ListView.builder(
              itemCount: provider.transactions.length,
              itemBuilder: (context, index) {
                final transaction = provider.transactions[index];
                String formattedDate = Helper().formatDate(transaction.trnsDate!);
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child:Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 27, 149, 206),
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
                              child: Text(
                                "طباعة",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            Center(
                              child: Text(
                                "# ${transaction.branch} - ${transaction.trnsCode} - ${transaction.trnsNo}",
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(



                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(padding: EdgeInsets.all(5), margin:EdgeInsets.only(left:20), child: const Text("  ")),
                          Container(padding: EdgeInsets.all(5), margin:EdgeInsets.only(right: 20), child: const Text("التاريخ")),
                        ],
                      ),

                    ],
                  ) /*ListTile(
                    title: Text(transaction.branch ?? 'Unknown Branch'),
                    subtitle: Text(transaction.descr ?? 'No Description'),
                  )*/,
                );
              },
            );
          } else {
            return const Center(
              child: Text('No transactions found'),
            );
          }
        },
      ),
    );
  }
}