import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/item_todo.dart';
import 'package:to_do_app/services/firestore_service.dart';
import 'package:to_do_app/screens/empty_todo/empty_todo.dart';

// Tela que exibe a lista de tarefas
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
        await FirestoreService.instance.queryAllRows();
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
    await FirestoreService.instance.update(item.toMap());
  }

  void _deleteTodoItem(TodoItem item) async {
   if (item.id != null) {
       await FirestoreService.instance.delete(item.id!.toString());
       print("Todo item excluído");
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
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.delete, color: Colors.black),
          ),
        ),
      ),
      onDismissed: (direction) {
        _deleteTodoItem(item);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Todo deletado")));
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
                        // Data
                        double paddingValue =
                            MediaQuery.of(context).size.width * 0.05;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            Padding(
                              padding: EdgeInsets.only(left: paddingValue),
                              child: Text(
                                DateFormat('EEEE dd MMM yyyy')
                                    .format(DateTime.now()),
                                style: TextStyle(color: Colors.grey[600]),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      return _buildTodoItem(todoItems[index - 2]);
                    },
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 72,
            right: 20,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                      (MediaQuery.of(context).size.width / 2 - 200) *
                          _controller.value,
                      (MediaQuery.of(context).size.height / 2 - 370) *
                          -_controller.value),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const EmptyTodoScreen(),
                      ));
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.black,
                      child: AnimatedCrossFade(
                        duration: const Duration(milliseconds: 400),
                        firstChild:
                            const Icon(Icons.check, color: Colors.white),
                        secondChild: const Icon(Icons.add, color: Colors.white),
                        crossFadeState: _controller.value > 0.5
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
