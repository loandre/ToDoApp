import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/models/item_todo.dart';
import 'package:to_do_app/utils/database.dart';
import 'package:to_do_app/screens/list_todos.dart';

class InputTodoScreen extends StatefulWidget {
  @override
  InputTodoScreenState createState() => InputTodoScreenState();
}

class InputTodoScreenState extends State<InputTodoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late Animation<BorderRadius?> _borderRadiusAnimation;
  bool _submitted = false;
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _borderRadiusAnimation = BorderRadiusTween(
      begin: BorderRadius.circular(30.0),
      end: BorderRadius.circular(50.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _colorAnimation = ColorTween(
      begin: Colors.white,
      end: Colors.black,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _addTodoItem(controller.text);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTodoItem(String title) async {
    if (title.isNotEmpty) {
      TodoItem newItem = TodoItem(title: title);
      await DatabaseHelper.instance.insert(newItem.toMap());

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => TodosListScreen(),
          transitionDuration: Duration(seconds: 1),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = Offset(0.0, 1.0);
            var end = Offset.zero;
            var curve = Curves.fastOutSlowIn;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
        ),
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
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _submitted = true;
                        });
                        _controller.forward();
                      },
                      child: ClipRect(
                        child: Container(
                            width: _submitted
                                ? 50
                                : MediaQuery.of(context).size.width * 0.9,
                            height: 50,
                            decoration: BoxDecoration(
                              color: _colorAnimation.value,
                              border: Border.all(color: Colors.grey),
                              borderRadius: _borderRadiusAnimation.value ??
                                  BorderRadius.circular(20.0),
                            ),
                            child: _submitted && _controller.value > 0.5
                                ? Center(
                                    child: ScaleTransition(
                                      scale: Tween(begin: 0.1, end: 0.7)
                                          .animate(_controller),
                                      child: Icon(Icons.check,
                                          color: Colors.white, size: 24.0),
                                    ),
                                  )
                                : Visibility(
                                    visible: !_submitted, // Adicionado aqui
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        SizedBox(width: 15.0),
                                        Expanded(
                                          child: TextField(
                                            controller: controller,
                                            enabled: !_submitted,
                                            style:
                                                TextStyle(color: Colors.black),
                                            decoration: InputDecoration(
                                              hintText:
                                                  'What do you want to do today?',
                                              hintStyle: TextStyle(
                                                  color: Colors.black45),
                                              border: InputBorder.none,
                                            ),
                                            onSubmitted: (value) {
                                              if (value.isNotEmpty &&
                                                  !_submitted) {
                                                setState(() {
                                                  _submitted = true;
                                                });
                                                _controller.forward();
                                              }
                                            },
                                          ),
                                        ),
                                        if (!_submitted) ...[
                                          SizedBox(width: 30.0),
                                          IconButton(
                                            icon: Icon(Icons.add,
                                                color: Colors.black),
                                            onPressed: () {
                                              if (controller.text.isNotEmpty &&
                                                  !_submitted) {
                                                setState(() {
                                                  _submitted = true;
                                                });
                                                _controller.forward();
                                              }
                                            },
                                          ),
                                        ],
                                      ],
                                    ),
                                  )),
                      ),
                    );
                  },
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
