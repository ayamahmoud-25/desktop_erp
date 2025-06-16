import 'package:flutter/material.dart';
import 'custom_spinner_dialog.dart';
import '../../util/spinner_model.dart';
import '../../util/map_list_model.dart';

class ExamplePage extends StatefulWidget {
  @override
  _ExamplePageState createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  SpinnerModel? selectedBranch;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Custom Dialog Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () async {
                // Fetch branches dynamically
                final List<SpinnerModel> branches = await MapListModel().mapListToSpinnerModelList();

                final result = await showDialog<SpinnerModel>(
                  context: context,
                  builder: (context) => CustomSpinnerDialog(
                    spinnerModels: branches,
                    onItemSelected: (branch) {
                      setState(() {
                        selectedBranch = branch;
                      });
                    },
                  ),
                );

                if (result != null) {
                  setState(() {
                    selectedBranch = result;
                  });
                }
              },
              child: Container(
                margin: EdgeInsets.all(5),
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  color: Color(0xFFF7F7F7),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: Color(0xFFDADADA),
                    width: 1.2,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      selectedBranch != null ? selectedBranch!.name! : "Select Branch",
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Icon(
                      Icons.arrow_drop_down,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}