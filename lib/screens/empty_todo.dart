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
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: screenHeight * 0.529,
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
                Spacer(flex: 3),
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
                Spacer(flex: 2),
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
                Spacer(flex: 2),
                Center(
                  child: Text(
                    "What do you want to do today?\nStart adding items to your to-do list.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
                Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
