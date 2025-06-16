import 'package:desktop_erp_4s/data/models/branch_model.dart';
import 'package:flutter/material.dart';
import '../../../db/SharedPereference.dart';
import '../../../util/map_list_model.dart';
import '../../../util/spinner_model.dart';
import '../../../util/strings.dart';

class BranchListDialog extends StatefulWidget {
  const BranchListDialog();

  @override
  _BranchListDialogState createState() => _BranchListDialogState();
}

class _BranchListDialogState extends State<BranchListDialog> {
  List<SpinnerModel> _spinnerModels = [];
  SpinnerModel? selectedSpinnerModel;

  @override
  void initState() {
    super.initState();
    _loadSpinnerModels();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Load previously selected branch
      SharedPreferences prefs = SharedPreferences();
      final savedSelectedBranch = await prefs.loadSelectedBranch();
      if (savedSelectedBranch != null) {
        setState(() {
          selectedSpinnerModel = SpinnerModel(
            id: savedSelectedBranch.code!,
            name: savedSelectedBranch.descr!,
          );
        });
      }
    });
  }

  Future<void> _loadSpinnerModels() async {
    final spinnerModels = await MapListModel().mapListToSpinnerModelList();
    setState(() {
      _spinnerModels = spinnerModels;
    });
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
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Color.fromARGB(255, 23, 111, 153),
                padding: EdgeInsets.all(10),
                width: double.infinity,
                child: Row(
                  children: [
                    Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    Expanded(
                      child: Text(
                        Strings.SELECT,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  itemCount: _spinnerModels.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      trailing: (selectedSpinnerModel?.id == _spinnerModels[index].id)
                          ? Icon(
                        Icons.check_circle,
                        color: Color.fromARGB(255, 23, 111, 153),
                      )
                          : null,
                      title: Text(
                        "${_spinnerModels[index].id} - ${_spinnerModels[index].name}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onTap: () {
                        setState(() {
                          selectedSpinnerModel = _spinnerModels[index];
                        });


                        // Convert SpinnerModel to Branches
                        Branches selectedBranch = _convertSpinnerModelToBranch(_spinnerModels[index]);

                        // Save the selected branch to SharedPreferences
                        SharedPreferences prefs = SharedPreferences();
                        prefs.saveSelectedBranch(selectedBranch);

                        // Close the dialog
                        Navigator.of(context).pop(selectedBranch);


                        // Save the selected branch to SharedPreferences
                       /* SharedPreferences prefs = SharedPreferences();
                        prefs.saveSelectedBranch(_spinnerModels[index] as Branches);

                        // Close the dialog and return the selected branch name
                        Navigator.of(context).pop(*//*_spinnerModels[index].name*//*);*/
                      },
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Divider(
                      color: Color(0xFFC7C6C6),
                      thickness: 1,
                      height: 0,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: MaterialButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  textColor: Colors.white,
                  child: Text(Strings.Cancel),
                  color: Color.fromARGB(255, 23, 111, 153),
                  minWidth: double.infinity,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}// Dart
Branches _convertSpinnerModelToBranch(SpinnerModel spinnerModel) {
  return Branches(
    code: spinnerModel.id,
    descr: spinnerModel.name,
  );
}