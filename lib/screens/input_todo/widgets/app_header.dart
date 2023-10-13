import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Text(
            'todo',
            style: TextStyle(fontSize: 32),
          ),
        ),
        const SizedBox(height: 15),
        Text(
          DateFormat('EEEE dd MMM yyyy').format(DateTime.now()),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
