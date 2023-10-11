import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/item_todo.dart';
import 'package:to_do_app/utils/database.dart';
import 'package:to_do_app/screens/empty_todo.dart';

class TodosListScreen extends StatefulWidget {
  @override
  TodosListScreenState createState() => TodosListScreenState();
}

class TodosListScreenState extends State<TodosListScreen> {
  List<TodoItem> todoItems = [];

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  void _loadTodoItems() async {
    List<Map<String, dynamic>> allRows =
        await DatabaseHelper.instance.queryAllRows();
    List<TodoItem> loadedItems =
        allRows.map((row) => TodoItem.fromMap(row)).toList();

    setState(() {
      todoItems = loadedItems;
    });
  }

  void _toggleTodoItem(TodoItem item) async {
    setState(() {
      item.isDone = !item.isDone;
    });
    await DatabaseHelper.instance.update(item.toMap());
  }

  void _deleteTodoItem(TodoItem item) async {
    if (item.id != null) {
      int rowsDeleted = await DatabaseHelper.instance.delete(item.id!);
      print("Número de linhas excluídas: $rowsDeleted");
      setState(() {
        todoItems.remove(item);
      });
    }
  }

  Widget _buildTodoItem(TodoItem item) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.white,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete, color: Colors.black),
          ),
        ),
      ),
      onDismissed: (direction) {
        _deleteTodoItem(item);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Todo deletado")));
      },
      child: ListTile(
        leading: GestureDetector(
          onTap: () => _toggleTodoItem(item),
          child: Icon(
            item.isDone
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: item.isDone ? Colors.black : Colors.black45,
          ),
        ),
        title: Text(
          item.title,
          style: TextStyle(
            decoration: item.isDone ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (todoItems.isEmpty) {
      return EmptyTodoScreen();
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(
              'todo',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              DateFormat('EEEE dd MMM yyyy').format(DateTime.now()),
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: todoItems.length,
                separatorBuilder: (context, index) => Divider(
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) {
                  return _buildTodoItem(todoItems[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
