import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/screens/input_todo.dart';

class EmptyTodoScreen extends StatefulWidget {
  @override
  EmptyTodoScreenState createState() => EmptyTodoScreenState();
}

class EmptyTodoScreenState extends State<EmptyTodoScreen> {
  bool isExpanding = false;

  void _startAnimation() {
    setState(() {
      isExpanding = true;
    });

    Future.delayed(Duration(milliseconds: 300), () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => InputTodoScreen()))
          .then((value) {
        setState(() {
          isExpanding = false;
        });
      });
    });
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
                GestureDetector(
                  onTap: _startAnimation,
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 600),
                    curve: Curves.fastOutSlowIn,
                    width: isExpanding
                        ? MediaQuery.of(context).size.width - 40
                        : 140,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isExpanding ? Colors.white : Colors.black,
                      border:
                          isExpanding ? Border.all(color: Colors.grey) : null,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    alignment: Alignment.center,
                    child: isExpanding
                        ? Row(
                            children: [
                              SizedBox(width: 15.0),
                              Expanded(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: 'What do you want to do today?',
                                    hintStyle: TextStyle(color: Colors.black45),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.add, color: Colors.black),
                                onPressed: () {},
                              ),
                            ],
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add, color: Colors.white),
                              SizedBox(
                                  width:
                                      5.0),
                              Text(
                                'Add item',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
