import 'package:flutter/material.dart';
import 'package:to_do_app/models/item_todo.dart';
import 'package:to_do_app/services/database_service.dart';
import 'package:to_do_app/screens/empty_todo/empty_todo.dart';
import 'package:to_do_app/screens/list_todo/widgets/list_circle.dart';
import 'package:to_do_app/screens/list_todo/widgets/list_date_header.dart';
import 'package:to_do_app/screens/list_todo/widgets/list_todo_item.dart';

class TodosListScreen extends StatefulWidget {
  const TodosListScreen({super.key});

  @override
  TodosListScreenState createState() => TodosListScreenState();
}

class TodosListScreenState extends State<TodosListScreen>
    with SingleTickerProviderStateMixin {
  List<TodoItem> todoItems = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..value = 0.0;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });
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

  @override
  Widget build(BuildContext context) {
    if (todoItems.isEmpty) {
      return const EmptyTodoScreen();
    }

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 35),
                const Text(
                  'todo',
                  style: TextStyle(fontSize: 32),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: todoItems.length + 2,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return const Divider(color: Colors.black);
                      }
                      if (index == 1) {
                        return const ListTodoDateHeader(); // Sem argumentos.
                      }
                      return ListTodoItem(
                        item: todoItems[index - 2],
                        toggleTodo: _toggleTodoItem,
                        deleteTodo: _deleteTodoItem,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 20.0,
            top: 72.0,
            child: ListTodoCircleAvatar(
                controller: _controller,
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => const EmptyTodoScreen(),
                  ));
                }),
          ),
        ],
      ),
    );
  }

  void _toggleTodoItem(TodoItem item) async {
    setState(() {
      item.isDone = !item.isDone;
    });
    await DatabaseHelper.instance.update(item.toMap());
  }

  void _deleteTodoItem(TodoItem item) async {
    if (item.id != null) {
      setState(() {
        todoItems.remove(item);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
