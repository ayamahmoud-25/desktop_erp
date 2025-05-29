import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/api_state.dart';
import '../../../util/helper.dart';
import 'show_transaction_provider.dart';
import '../../../data/models/response/Transaction.dart';

class ShowTransactionList extends StatefulWidget {
  final String selectedBranch;
  final String transCode;
  final String transName;

  const ShowTransactionList({
    Key? key,
    required this.selectedBranch,
    required this.transCode,
    required this.transName,

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
          .storeTransactionList(
          context, widget.selectedBranch, widget.transCode);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
        appBar: AppBar(
          title:  Text(
            widget.transName,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 23, 111, 153),
          iconTheme: IconThemeData(
            color: Colors.white,
          ), // Set back button color to white
        ),
        body: Consumer<ShowTransactionProvider>(
        builder: (context, provider, child)
    {
      if (provider.state == APIStatue.loading) {
        return const Center(child: CircularProgressIndicator());
      } else if (provider.state == APIStatue.error) {
        return Center(
          child: Text(
            provider.errorMessage ?? 'An error occurred',
            style: const TextStyle(color: Colors.red),
          ),
        );
      } else if (provider.state == APIStatue.success &&
          provider.transactions.isNotEmpty) {
        return ListView.builder(
          itemCount: provider.transactions.length,
          itemBuilder: (context, index) {
            final transaction = provider.transactions[index];
            return Card(
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
                              "${transaction.trnsNo} - ${transaction
                                  .trnsCode} - ${transaction.branch} # ",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "طباعة",
                              style: const TextStyle(color: Colors.white),
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
                        child: Container(padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 10),
                            child: Text(" \u25CF  الفرع  : ${transaction
                                .descr!} ", style: TextStyle(
                                color: const Color.fromARGB(
                                    255, 23, 111, 153)),)),
                      ),
                      Expanded(
                        child: Container(padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 10),
                            child: Text("  \u25CF التاريخ: ${Helper().formatDate(
                                transaction.trnsDate!)}",
                                style: TextStyle(color: const Color.fromARGB(
                                    255, 23, 111, 153)))),
                      ),

                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(right: 10),
                            child: Text(" \u25CF الطرف إلى : ${transaction.toName !=
                                null ? transaction.toName : 'لا يوجد '}",
                                style: TextStyle(color: const Color.fromARGB(
                                    255, 23, 111, 153)))),
                      ),
                      Expanded(

                        child: Container(padding: EdgeInsets.all(5),
                            margin: EdgeInsets.only(left: 10),
                            child: Text("  \u25CF الطرف من: ${transaction.fromName != null ? transaction.fromName : 'لا يوجد '}", style: TextStyle(
                                color: const Color.fromARGB(
                                    255, 23, 111, 153)),)),
                      ),

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
    },)
    ,
    ));
  }
}