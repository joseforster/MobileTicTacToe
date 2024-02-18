import 'package:flutter/material.dart';

import 'square.widget.dart';

class CustomTableRow extends StatelessWidget {
  const CustomTableRow({super.key, required this.rowNumber});

  final int rowNumber;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: Key(rowNumber.toString()),
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Square(rowNumber: rowNumber, columnNumber: 0),
        const SizedBox(height: 10, width: 10),
        Square(rowNumber: rowNumber, columnNumber: 1),
        const SizedBox(height: 10, width: 10),
        Square(rowNumber: rowNumber, columnNumber: 2),
      ],
    );
  }
}
