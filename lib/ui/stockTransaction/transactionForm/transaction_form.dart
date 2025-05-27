import 'package:desktop_erp_4s/ui/widgets/date_picker.dart';
import 'package:flutter/material.dart';

import '../../../data/models/branch_model.dart';
import '../../../data/models/response/TransactionSpec.dart';

import '../../../util/helper.dart';
import '../../../util/strings.dart';

class TransactionForm extends StatefulWidget {
  Branches? selectedBranch;
  TransactionSpec? transactionSpec;

  TransactionForm({
    Key? key,
    required this.selectedBranch,
    required this.transactionSpec,
  }) : super(key: key);

  @override
  _TransactionScreenState createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionForm> {
  String? transCode;
  String? fromName;
  String? toName;

  final Map<String, Map<String, int>> transactionSpecs = {
    "T1": {"from_dst": 1, "to_dst": 2},
    "T2": {"from_dst": 3, "to_dst": 4},
    "T3": {"from_dst": 5, "to_dst": 6},
  };

  void updateFromToFields(String code) {
    if (transactionSpecs.containsKey(code)) {
      final fromIndex = transactionSpecs[code]!['from_dst']!;
      final toIndex = transactionSpecs[code]!['to_dst']!;
      try {
        fromName = Helper().getNameFromIndex(fromIndex);
        toName = Helper().getNameFromIndex(toIndex);
      } catch (e) {
        fromName = "Invalid";
        toName = "Invalid";
      }
    } else {
      fromName = "Unknown";
      toName = "Unknown";
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${widget.transactionSpec!.trnsDesc}  ${Strings.New} ",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color.fromARGB(255, 23, 111, 153),
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              Text(
               Strings.BASIC_DATA,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 5), // Space between items
              CustomDropdownWidget(value: "الفرع", items: []),
              SizedBox(height: 10), // Space between items
              Text(
                Strings.TRANSACTION_DATE,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),
              ),
              SizedBox(height: 5), // Space between items
              SizedBox(
                width: double.infinity,
                child: TextField(
                  readOnly: true, // Make the text field non-editable
                  decoration: InputDecoration(
                    hintText: "MM/YY",
                    suffixIcon: Icon(Icons.calendar_today, color: Colors.black), // Icon at the end
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                      borderSide: BorderSide(color: Colors.grey, width: 1.2),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      // Update the text field with the selected date
                      print("Selected Date: ${pickedDate.toLocal()}".split(' ')[0]);
                    }
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
class CustomDropdownWidget extends StatelessWidget {
  final String? value;
  final List<String> items;
  //final ValueChanged<String?> onChanged;

  CustomDropdownWidget({
    Key? key,
    required this.value,
    required this.items,
   //required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Container(
        child:Column(children: [
          Container(
            alignment: Alignment.centerRight,
            margin: EdgeInsets.all(5),
            child: Text(
              textAlign: TextAlign.right,
              value != null ? value! : Strings.CHANGE_BRANCH,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold,color: Colors.grey),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Color(0xFFF7F7F7),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  color: Color(0xFFDADADA), // Border color
                  width: 1.2,          // Border width
                )
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:DropdownButton<String>(
              isExpanded: true,
              underline: Container(), // Remove the default underline
              value: value,
              hint: Text(Strings.SELECT),
              onChanged: (value){},
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
            ),
          ),


        ]));

        /*;*/
  }
}
/*//
async {
DateTime? pickedDate = await showDatePicker(
context: context,
initialDate: DateTime.now(),
firstDate: DateTime(2000),
lastDate: DateTime(2100),
);
if (pickedDate != null) {
// Handle the selected date
print("Selected Date: ${pickedDate.toLocal()}".split(' ')[0]);
}
} */
