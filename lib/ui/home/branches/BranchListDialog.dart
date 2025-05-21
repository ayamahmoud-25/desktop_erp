import 'package:flutter/material.dart';
import '../../../db/SharedPereference.dart' show SharedPreferences;
import '../../../data/models/branch_model.dart';

class BranchListDialog extends StatefulWidget {
  const BranchListDialog();

  @override
  _BranchListDialogState createState() => _BranchListDialogState();
}

class _BranchListDialogState extends State<BranchListDialog> {
  List<Branches> _branches = [];

  @override
  void initState() {
    super.initState();
    _loadBranches();
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        height: 400,
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Select Branch',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _branches.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_branches[index].descr ?? ''),
                    onTap: () {
                      Navigator.of(context).pop(_branches[index]);
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}

