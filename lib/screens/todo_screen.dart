import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo_item.dart';
import 'package:to_do_app/utils/database_helper.dart';
import 'package:intl/intl.dart';

class TodoScreen extends StatefulWidget {
  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoItem> todoItems = [];
  bool isInputVisible = false;

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  void _loadTodoItems() async {
    List<Map<String, dynamic>> allRows =
        await DatabaseHelper.instance.queryAllRows();
    print("Itens carregados do banco de dados: $allRows");

    List<TodoItem> loadedItems =
        allRows.map((row) => TodoItem.fromMap(row)).toList();

    setState(() {
      todoItems = loadedItems;
    });
  }

  void _deleteTodoItem(TodoItem item) async {
    print("Tentando excluir item com ID: ${item.id}");
    if (item.id != null) {
      int rowsDeleted = await DatabaseHelper.instance.delete(item.id!);
      print("Número de linhas excluídas: $rowsDeleted");
      setState(() {
        todoItems.remove(item);
      });
    }
  }

  void _toggleTodoItem(TodoItem item) async {
    setState(() {
      item.isDone = !item.isDone;
    });
    await DatabaseHelper.instance.update(item.toMap());
  }

  void _addTodoItem(String title) async {
    if (title.length > 0) {
      TodoItem newItem = TodoItem(title: title);
      int id = await DatabaseHelper.instance.insert(newItem.toMap());
      newItem.id = id;

      setState(() {
        todoItems.insert(0, newItem);
      });
    }
  }

  Widget _buildInputWidget() {
    TextEditingController controller = TextEditingController();

    return Row(
      children: <Widget>[
        Expanded(
          child: TextField(
            controller: controller,
            decoration:
                InputDecoration(hintText: 'What do you want to do today?'),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () {
            _addTodoItem(controller.text);
            controller.clear();
          },
        ),
      ],
    );
  }

  Widget _buildTodoItem(TodoItem item) {
    return ListTile(
      leading: Checkbox(
        value: item.isDone,
        onChanged: (bool? value) {
          setState(() {
            item.isDone = value!;
          });
        },
      ),
      title: Text(
        item.title,
        style: TextStyle(
          decoration: item.isDone ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () => _deleteTodoItem(item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isInputVisible = !isInputVisible;
                });
              },
              child: Text('+ Add item'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            if (isInputVisible) ...[_buildInputWidget()],
            Expanded(
              child: ListView.builder(
                itemCount: todoItems.length,
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
