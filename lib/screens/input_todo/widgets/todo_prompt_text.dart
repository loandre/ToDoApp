import 'package:flutter/material.dart';

class TodoPromptText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "What do you want to do today?\nStart adding items to your to-do list.",
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey[600]),
      ),
    );
  }
}
