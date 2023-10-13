import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/screens/empty_todo/widgets/custom_widgets.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const CenteredText(
          text: 'todo',
          style: TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 15),
        CenteredText(
          text: DateFormat('EEEE dd MMM yyyy').format(DateTime.now()),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}