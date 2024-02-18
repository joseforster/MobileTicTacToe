import 'package:flutter/material.dart';
import 'custom_table_row.widget.dart';

class CustomTable extends StatelessWidget {
  const CustomTable({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomTableRow(rowNumber: 0),
        SizedBox(height: 10, width: 10),
        CustomTableRow(rowNumber: 1),
        SizedBox(height: 10, width: 10),
        CustomTableRow(rowNumber: 2),
      ],
    );
  }
}
