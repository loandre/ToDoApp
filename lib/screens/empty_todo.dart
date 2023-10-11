import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/screens/input_todo.dart';

class EmptyTodoScreen extends StatefulWidget {
  @override
  _EmptyTodoScreenState createState() => _EmptyTodoScreenState();
}

class _EmptyTodoScreenState extends State<EmptyTodoScreen> {
  void _navigateToInputScreen() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => InputTodoScreen()));
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
              onPressed: _navigateToInputScreen,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, color: Colors.white),
                  SizedBox(width: 5.0),
                  Text('Add item'),
                ],
              ),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "What do you want to do today?\nStart adding items to your to-do list.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
