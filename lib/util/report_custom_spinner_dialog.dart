import 'package:flutter/material.dart';

import 'Strings.dart';

class ReportCustomSpinnerDialog extends StatefulWidget {
  final List spinnerModels;
  final ValueChanged onItemSelected;

  const ReportCustomSpinnerDialog({
    Key? key,
    required this.spinnerModels,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _CustomSpinnerDialogState createState() => _CustomSpinnerDialogState();
}

class _CustomSpinnerDialogState extends State<ReportCustomSpinnerDialog> {
  String searchQuery = "";
  late List filteredModels;

  @override
  void initState() {
    super.initState();
    filteredModels = widget.spinnerModels;
  }

  void _filterList(String query) {
    setState(() {
      searchQuery = query;
      filteredModels = widget.spinnerModels
          .where((item) =>
      item.name.toLowerCase().contains(query.toLowerCase()) ||
          item.id.toString().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              // ======= HEADER =======
              Container(
                color: const Color.fromARGB(255, 23, 111, 153),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Text(
                        Strings.SELECT,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // ======= SEARCH BOX =======
              Container(
                width: double.infinity,
                height: 50,
                margin: const EdgeInsets.all(5),
                padding: const EdgeInsets.all(5),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: Strings.SEARCH,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _filterList,
                ),
              ),

              const SizedBox(height: 10),

              // ======= LIST =======
              Expanded(
                child: ListView.builder(
                  itemCount: filteredModels.length,
                  itemBuilder: (context, index) {
                    final item = filteredModels[index];
                    return Column(
                      children: [
                        ListTile(
                          title: Text("${item.name}"),
                          onTap: () {
                            //  Return selected item to caller
                            Navigator.of(context).pop(item);
                          },
                        ),
                        if (index < filteredModels.length - 1)
                          const Divider(),
                      ],
                    );
                  },
                ),
              ),

              // ======= CANCEL BUTTON =======
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(); // just close dialog
                },
                child: Container(
                  margin: const EdgeInsets.all(5),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 23, 111, 153),
                  ),
                  child: Text(
                    Strings.Cancel,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
