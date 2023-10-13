import 'package:flutter/material.dart';
import 'package:to_do_app/models/item_todo.dart';
import 'package:to_do_app/services/database_service.dart';

class InputTodoProvider with ChangeNotifier {
  late AnimationController _controller;
  bool _submitted = false;

  bool get submitted => _submitted;
  TextEditingController controller = TextEditingController();

  void initializeAnimationController(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 400),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        addTodoItem(controller.text);
      }
    });
  }

  void addTodoItem(String title) async {
    if (title.isNotEmpty) {
      TodoItem newItem = TodoItem(title: title);
      await DatabaseHelper.instance.insert(newItem.toMap());
      notifyListeners();
    }
  }

  void toggleSubmitted() {
    _submitted = !_submitted;
    notifyListeners();
  }

  void disposeController() {
    _controller.dispose();
  }
}
