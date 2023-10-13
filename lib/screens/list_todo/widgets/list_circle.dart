import 'package:flutter/material.dart';

class ListTodoCircleAvatar extends AnimatedWidget {
  final AnimationController controller;
  final Function onTap;

  // Construtor da classe ListTodoCircleAvatar
  // - `controller`: Controla a animação do widget.
  // - `onTap`: Função a ser executada quando o widget for tocado.
  const ListTodoCircleAvatar(
      {super.key, required this.controller, required this.onTap})
      : super(listenable: controller);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      // Calcula a posição do widget com base nos valores do controlador
      offset: Offset(
          (MediaQuery.of(context).size.width / 2 - 200) * controller.value,
          (MediaQuery.of(context).size.height / 2 - 370) * -controller.value),
      child: GestureDetector(
        onTap: () => onTap(),
        child: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.black,
          child: AnimatedCrossFade(
            duration: const Duration(milliseconds: 400),
            firstChild: const Icon(Icons.check, color: Colors.white),
            secondChild: const Icon(Icons.add, color: Colors.white),
            crossFadeState: controller.value > 0.5
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
          ),
        ),
      ),
    );
  }
}
