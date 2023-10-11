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
  double containerHeight = 0.0;
  TextEditingController _controller = TextEditingController();

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
    print("Toggling item with title: ${item.title}");
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

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          containerHeight = 60.0;
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
    );
  }

  Widget _buildInputWidget() {
    if (containerHeight == 0.0) {
      return ElevatedButton(
        onPressed: () {
          setState(() {
            containerHeight = 60.0;
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 5.0),
            Text('+ Add item'),
          ],
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.black,
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            SizedBox(width: 15.0),
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: 'What do you want to do today?',
                  hintStyle: TextStyle(color: Colors.black45),
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  _addTodoItem(value);
                  _controller.clear();
                  setState(() {
                    containerHeight = 0.0;
                  });
                },
              ),
            ),
            IconButton(
              icon: Icon(Icons.add, color: Colors.black),
              onPressed: () {
                _addTodoItem(_controller.text);
                _controller.clear();
                setState(() {
                  containerHeight = 0.0;
                });
              },
            ),
          ],
        ),
      );
    }
  }

  Widget customCheckbox(bool value, ValueChanged<bool?> onChanged) {
    return GestureDetector(
      onTap: () {
        onChanged(!value);
      },
      child: Container(
        width: 22.0,
        height: 22.0,
        margin: EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black, width: 1.6),
        ),
        child: Center(
          child: AnimatedContainer(
            duration: Duration(milliseconds: 200),
            width: value ? 16.0 : 0.0,
            height: 16.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTodoItem(TodoItem item) {
    return ListTile(
      leading: customCheckbox(item.isDone, (value) {
        _toggleTodoItem(item);
      }),
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
            if (containerHeight == 0.0) _buildAddButton(),
            AnimatedContainer(
              duration: Duration(milliseconds: 50),
              height: containerHeight,
              child: _buildInputWidget(),
            ),
            SizedBox(height: 20),
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
