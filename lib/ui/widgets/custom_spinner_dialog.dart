import 'package:desktop_erp_4s/util/strings.dart';
import 'package:flutter/material.dart';

class CustomSpinnerDialog extends StatefulWidget {
  final List spinnerModels;
  final ValueChanged onItemSelected;

  const CustomSpinnerDialog({
    Key? key,
    required this.spinnerModels,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  _CustomSpinnerDialogState createState() => _CustomSpinnerDialogState();
}

class _CustomSpinnerDialogState extends State<CustomSpinnerDialog> {
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
          .where((item) => item.name.toLowerCase().contains(query.toLowerCase())||
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
          borderRadius: BorderRadius.zero, // Remove rounded corners
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Container(
                color: Color.fromARGB(255, 23, 111, 153),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    Expanded(
                      child: Text(
                        Strings.SELECT,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.all(5),
                padding: EdgeInsets.all(5),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: Strings.SEARCH,
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: _filterList,
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredModels.length,
                  itemBuilder: (context, index) {
                    final item = filteredModels[index];
                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5), // Reduce space
                          title: Text(item.id.toString() + " - " + item.name.toString()),
                          onTap: () {
                            widget.onItemSelected(item);
                            Navigator.of(context).pop(item);
                          },
                        ),
                        if (index < filteredModels.length - 1) Divider(),
                      ],
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 23, 111, 153),
                  ),
                  child: Text(
                    Strings.Cancel,
                    style: TextStyle(color: Colors.white, fontSize: 16),
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