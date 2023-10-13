import 'package:flutter/material.dart';

// Widget que exibe um texto de prompt para adicionar tarefas
class TodoPromptText extends StatelessWidget {
  const TodoPromptText({super.key});

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
