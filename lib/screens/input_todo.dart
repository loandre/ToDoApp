import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/item_todo.dart';
import 'package:to_do_app/utils/database.dart';
import 'package:to_do_app/screens/list_todos.dart';

class InputTodoScreen extends StatefulWidget {
  @override
  InputTodoScreenState createState() => InputTodoScreenState();
}

class InputTodoScreenState extends State<InputTodoScreen> {
  TextEditingController controller = TextEditingController();

  void _addTodoItem(String title) async {
    if (title.isNotEmpty) {
      TodoItem newItem = TodoItem(title: title);
      await DatabaseHelper.instance.insert(newItem.toMap());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => TodosListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: screenHeight / 2 + 30,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(color: Colors.grey[100]),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 2),
                Center(
                  child: Text(
                    'todo',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 45),
                Center(
                  child: Text(
                    DateFormat('EEEE dd MMM yyyy').format(DateTime.now()),
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Spacer(flex: 1),
                Container(
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
                          controller: controller,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                            hintText: 'What do you want to do today?',
                            hintStyle: TextStyle(color: Colors.black45),
                            border: InputBorder.none,
                          ),
                          onSubmitted: (value) {
                            _addTodoItem(value);
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.add, color: Colors.black),
                        onPressed: () {
                          _addTodoItem(controller.text);
                          controller.clear();
                        },
                      ),
                    ],
                  ),
                ),
                Spacer(flex: 1),
                Center(
                  child: Text(
                    "What do you want to do today?\nStart adding items to your to-do list.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
