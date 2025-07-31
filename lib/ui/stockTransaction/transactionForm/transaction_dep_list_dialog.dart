import 'package:desktop_erp_4s/ui/widgets/show_message.dart';
import 'package:desktop_erp_4s/util/strings.dart';
import 'package:flutter/material.dart';

import '../../../data/models/response/store_trans_list_dependency.dart';

class TransactionDepListDialog extends StatefulWidget {
  final List<StoreTransListDependency> storeTransDepModelList;
  //final ValueChanged onItemSelected;

  const TransactionDepListDialog({
    Key? key,
    required this.storeTransDepModelList,
    //required this.onItemSelected,
  }) : super(key: key);

  @override
  _TransactionDepListDialogState createState() => _TransactionDepListDialogState();
}

class _TransactionDepListDialogState extends State<TransactionDepListDialog> {
  String searchQuery = "";
  late List<StoreTransListDependency> filteredModels;
   List<StoreTransListDependency> selectedStoreTransDepList = [];

  @override
  void initState() {
    super.initState();
    filteredModels = widget.storeTransDepModelList;


      selectedStoreTransDepList = [];
      for(var item in widget.storeTransDepModelList){
        // add every itemselected.isSelected true in list
        if(item.isSelected== true){
          selectedStoreTransDepList.add(item);
        }
      }

    //inital

    // print selectedStoreTransDepList length
    //print(" initState selectedStoreTransDepList from dialog: ${selectedStoreTransDepList.length}",);

    print(" initState selectedStoreTransDepList from dialog: ${selectedStoreTransDepList.length}",);
    print("initState selectedTransDepListfromdialog: ${ widget.storeTransDepModelList.map((e) =>  e.isSelected).toList()}",);

  }

  void _filterList(String query) {
    setState(() {
      searchQuery = query;
      filteredModels = widget.storeTransDepModelList
          .where((item) => item.trnsCode.toString().contains(query.toLowerCase())||
          item.trnsNo.toString().contains(query))
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
                          contentPadding: EdgeInsets.symmetric(horizontal: 5, vertical: 5), // Reduce space
                          title: Text(" الفرع(${item.branch} ) -   الكود(${item.trnsCode} ) -  الرقم(${item.trnsNo} ) "),
                          trailing: Checkbox(
                            value: item.isSelected??false,
                            onChanged: (checked) => {
                              setState(() {
                                item.isSelected = checked ?? false;
                                bool isExist = false;
                                StoreTransListDependency itemSelected = StoreTransListDependency();
                                if(selectedStoreTransDepList.length>0){
                                  for(var depTrans in selectedStoreTransDepList){
                                    if(item.trnsNo==depTrans.trnsNo){
                                      isExist = true;
                                      depTrans.isSelected = checked;
                                      if(depTrans.isSelected==false)
                                        itemSelected = depTrans;
                                      break;
                                    }
                                  }
                                  if(!isExist)
                                    selectedStoreTransDepList.add(item);
                                  if(itemSelected.trnsNo!=null)
                                    selectedStoreTransDepList.remove(itemSelected);
                                }else{
                                  selectedStoreTransDepList.add(item);
                                }
                                //print("selected item ${selectedStoreTransDepList.length}");
                                print("item form select: (onChanged) ${selectedStoreTransDepList.map((e) => e.trnsNo).toList()} - ${item.trnsNo} - $checked }");

                              }),
                              // print("item form select: (onChanged) ${item.id} - ${item.name} - $checked }"),
                            }

                            //  _onItemCheckedChange(item, checked),
                          ),

                        ),
                        if (index < filteredModels.length - 1) Divider(),
                      ],
                    );
                  },
                ),
              ),
              //  SizedBox(height: 10),
              InkWell(
                onTap: () {
                  print("selected item ${selectedStoreTransDepList.length}");

                  if(selectedStoreTransDepList.length>0){
                    print("selected item ${selectedStoreTransDepList.length}");
                   // ShowMessage().showToast("selected item ${selectedStoreTransDepList.length}");
                    Navigator.of(context).pop(selectedStoreTransDepList); // Dismiss the dialog
                  }else{
                    ShowMessage().showToast("يرجى تحديد عنصر واحد على الأقل");
                  }
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 23, 111, 153),
                  ),
                  child: Text(
                    Strings.ADD,
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