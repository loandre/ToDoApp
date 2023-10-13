import 'package:flutter/material.dart';

// Widget para exibir texto de prompt no aplicativo
class TodoPromptText extends StatelessWidget {
  const TodoPromptText({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "What do you want to do today?\nStart adding items to your to-do list.",
      textAlign: TextAlign.center,
      style: TextStyle(color: Colors.grey[600]),
    );
  }
}
