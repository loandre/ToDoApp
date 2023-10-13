import 'package:flutter/material.dart';
import 'package:to_do_app/models/item_todo.dart';
import 'package:to_do_app/services/database_service.dart';
import 'package:to_do_app/screens/third_screen/todo_list_screen.dart';

class InputTodoProvider extends StatefulWidget {
  @override
  _InputTodoProviderState createState() => _InputTodoProviderState();
}

class _InputTodoProviderState extends State<InputTodoProvider>
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
      duration: const Duration(milliseconds: 600),
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

      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => const TodosListScreen(),
            transitionDuration: const Duration(seconds: 1),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              var begin = const Offset(0.0, 1.0);
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
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
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
              width: _submitted ? 50 : MediaQuery.of(context).size.width * 0.9,
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
                        scale: Tween(begin: 0.1, end: 0.7).animate(_controller),
                        child: const Icon(Icons.check,
                            color: Colors.white, size: 24.0),
                      ),
                    )
                  : Visibility(
                      visible: !_submitted,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const SizedBox(width: 15.0),
                          Expanded(
                            child: TextField(
                              controller: controller,
                              enabled: !_submitted,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                hintStyle:
                                    TextStyle(color: Colors.black45),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (value) {
                                if (value.isNotEmpty && !_submitted) {
                                  setState(() {
                                    _submitted = true;
                                  });
                                  _controller.forward();
                                }
                              },
                            ),
                          ),
                          if (!_submitted) ...[
                            const SizedBox(width: 30.0),
                            IconButton(
                              icon: const Icon(Icons.add, color: Colors.black),
                              onPressed: () {
                                if (controller.text.isNotEmpty && !_submitted) {
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
                    ),
            ),
          ),
        );
      },
    );
  }
}
