import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/screens/input_todo.dart';

class EmptyTodoScreen extends StatefulWidget {
  @override
  EmptyTodoScreenState createState() => EmptyTodoScreenState();
}

class EmptyTodoScreenState extends State<EmptyTodoScreen> {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Text(
                'todo',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: Text(
                DateFormat('EEEE dd MMM yyyy').format(DateTime.now()),
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _navigateToInputScreen,
              icon: Icon(Icons.add, color: Colors.white),
              label: Text('Add item'),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                "What do you want to do today?\nStart adding items to your to-do list.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
