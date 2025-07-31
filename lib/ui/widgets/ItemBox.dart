import 'package:flutter/material.dart';

class ItemBox extends StatelessWidget {
  final String itemText;

  ItemBox({required this.itemText});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(5),
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: Color(0xFFf7f7f7),
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: Color(0xFFDADADA),
          width: 1.3,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            itemText,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Icon(Icons.arrow_drop_down, color: Colors.grey),
        ],
      ),
    );
  }
}