import 'package:flutter/material.dart';

import '../../util/spinner_model.dart';

class CustomSpinnerDropdown extends StatelessWidget {
  final List<SpinnerModel> items;
  final SpinnerModel? selectedItem;
  final ValueChanged<SpinnerModel?> onChanged;

  const CustomSpinnerDropdown({
    Key? key,
    required this.items,
    required this.selectedItem,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      /*decoration: BoxDecoration(
        color: Color(0xFFf7f7f7),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xFFDADADA),
          width: 1.3,
        ),
      ),*/
      child: DropdownButton<SpinnerModel>(
        isExpanded: true,
        underline: SizedBox(),
        value: selectedItem,
        hint: Text("اختر المجموعة"),
        items: items.map((SpinnerModel item) {
          return DropdownMenuItem<SpinnerModel>(
            value: item,
            child: Text(item.name!),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}