import 'package:flutter/material.dart';
import '../../../db/SharedPereference.dart' show SharedPreferences;
import '../../../data/models/branch_model.dart';
import '../../../util/strings.dart';

class BranchListDialog extends StatefulWidget {
  const BranchListDialog();

  @override
  _BranchListDialogState createState() => _BranchListDialogState();
}

class _BranchListDialogState extends State<BranchListDialog> {
  List<Branches> _branches = [];
  Branches? selectedBranch ;


  @override
  void initState() {
    super.initState();
    _loadBranches();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = SharedPreferences();
      Branches   savedSelectedBranch = await prefs.loadSelectedBranch() as Branches;
      // If a branch was previously selected, you can handle it here
      print('Previously selected branch: $savedSelectedBranch');
      setState(() {
        this.selectedBranch = savedSelectedBranch;
      });
    });
  }


  Future<void> _loadBranches() async {
    final branches = await SharedPreferences().loadBranchesFromPrefs();
    if (branches != null) {
      setState(() {
        _branches = branches;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          color: Colors.white, // Set background color
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust size to fit content
            children: [
              Container(
                color: Color.fromARGB(255, 23, 111, 153), // Set background color
                padding: EdgeInsets.all(10), // Add padding around the text
                width: double.infinity, // Make the container fit the width of the parent
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white, // Set icon color
                    ),
                    Expanded(
                      child: Text(
                        Strings.SELECT,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center, // Center the text horizontally
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: _branches.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: (selectedBranch!.descr==_branches[index].descr )? Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(255, 23, 111, 153),
                      ):null,
                      title: Text(
                        _branches[index].code! + " - " + _branches[index].descr!,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        Navigator.of(context).pop(_branches[index]);
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Color(0xFFC7C6C6), // Set the color of the divider
                      thickness: 1, // Set the thickness of the line
                      height: 0,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0), // Add padding around the button
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  textColor: Colors.white,
                  child: Text(Strings.Cancel),
                  color: Color.fromARGB(255, 23, 111, 153),
                  minWidth: double.infinity, // Make the button stretch to full width
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }}