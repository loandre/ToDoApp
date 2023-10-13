import 'package:flutter/material.dart';
import 'package:to_do_app/screens/input_todo/input_todo_screen.dart';
import 'package:to_do_app/screens/empty_todo/widgets/empty_custom_widgets.dart';
import 'package:to_do_app/screens/empty_todo/widgets/empty_header.dart';
import 'package:to_do_app/screens/empty_todo/widgets/empty_prompt_text.dart';

// Tela vazia que aparece quando não há tarefas a serem exibidas
class EmptyTodoScreen extends StatefulWidget {
  const EmptyTodoScreen({super.key});

  @override
  EmptyTodoScreenState createState() => EmptyTodoScreenState();
}

class EmptyTodoScreenState extends State<EmptyTodoScreen> {
  // Estado de expansão do botão de adição
  bool isExpanding = false; 

  // Inicia a animação e navega para a tela de adição de tarefas
  void _startAnimation() {
    setState(() {
      isExpanding = true;
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      Navigator.of(context)
          .push(
              MaterialPageRoute(builder: (context) => const InputTodoScreen()))
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
                const Spacer(flex: 3),
                const AppHeader(),
                const Spacer(flex: 2),
                GestureDetector(
                  onTap: _startAnimation,
                  child: AnimatedAddButton(
                    isExpanding: isExpanding,
                    onTap: _startAnimation,
                  ),
                ),
                const Spacer(flex: 2),
                const Center(child: TodoPromptText()),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
