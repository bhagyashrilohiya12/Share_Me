import 'package:flutter/material.dart';

class CPRDropdownWithLabel<T> extends StatelessWidget {
  final String label;
  final List<DropdownMenuItem<T>> items;
  final T value;

   CPRDropdownWithLabel({
    required this.items,
    required this.value,
    required this.label,

  })  ;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 2,
            child: DropdownButton<T>(
              items: items,
              onChanged: (v) {},
              value: value,
            ),
          )
        ],
      ),
    );
  }
}
