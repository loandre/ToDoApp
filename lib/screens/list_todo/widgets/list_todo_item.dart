import 'package:flutter/material.dart';
import 'package:to_do_app/models/item_todo.dart';

class ListTodoItem extends StatelessWidget {
  final TodoItem item;
  final Function(TodoItem) toggleTodo;
  final Function(TodoItem) deleteTodo;

  const ListTodoItem(
      {super.key,
      required this.item,
      required this.toggleTodo,
      required this.deleteTodo});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.white,
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete, color: Colors.black),
          ),
        ),
      ),
      onDismissed: (direction) {
        // Chama a função para deletar o item
        deleteTodo(item);
        // Exibe uma mensagem de Snackbar quando o item é deletado
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Todo deletado")));
      },
      child: ListTile(
        leading: GestureDetector(
          onTap: () => toggleTodo(item),
          child: Icon(
            item.isDone
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: item.isDone ? Colors.black : Colors.black45,
          ),
        ),
        title: Container(
          padding: const EdgeInsets.only(bottom: 9.0),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 0.5),
            ),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              item.title,
              style: TextStyle(
                decoration: item.isDone ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
