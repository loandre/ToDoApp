import 'package:flutter/material.dart';
import 'package:to_do_app/screens/input_todo/widgets/input_header.dart';
import 'package:to_do_app/screens/input_todo/widgets/input_prompt_text.dart';
import 'package:to_do_app/screens/input_todo/widgets/input_input_provider.dart';

// Tela onde os usuários podem adicionar novas tarefas
class InputTodoScreen extends StatefulWidget {
  const InputTodoScreen({Key? key}) : super(key: key);

  @override
  InputTodoScreenState createState() => InputTodoScreenState();
}

class InputTodoScreenState extends State<InputTodoScreen> {
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
          const Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Spacer(flex: 2),
                AppHeader(),
                SizedBox(height: 45),
                Spacer(flex: 1),
                InputTodoProvider(),
                Spacer(flex: 1),
                TodoPromptText(),
                Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
