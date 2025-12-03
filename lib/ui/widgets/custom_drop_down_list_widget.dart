import 'package:flutter/material.dart';
import '../../data/models/branch_model.dart';
import '../home/branches/BranchListDialog.dart';

class CustomDropdownListWidget extends StatelessWidget {
  final String label;
  final Branches? selectedBranch;
  final ValueChanged<Branches?> onChanged;

  const CustomDropdownListWidget({
    Key? key,
    required this.label,
    required this.selectedBranch,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: () async {
            Branches? selectedBranchResult = await showDialog<Branches>(
              context: context,
              barrierDismissible: false,
              builder: (context) => BranchListDialog(),
            );
            if (selectedBranchResult != null) {
              onChanged(selectedBranchResult);
            }
          },
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: Color(0xFFDADADA),
                width: 1.2,
              ),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedBranch?.descr ?? "Select Branch",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
                Icon(
                  Icons.arrow_drop_down, // Trailing icon
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}