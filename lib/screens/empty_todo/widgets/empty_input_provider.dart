import 'package:flutter/material.dart';
import 'package:to_do_app/models/item_todo.dart';
import 'package:to_do_app/services/firestore_service.dart';

// Classe que gerencia o estado relacionado à entrada de novas tarefas
class InputTodoProvider with ChangeNotifier {
  late AnimationController _controller; // Controlador de animação
  bool _submitted = false; // Estado de submissão

  bool get submitted => _submitted; // Getter para o estado de submissão
  TextEditingController controller = TextEditingController(); // Controlador de texto

  // Inicializa o controlador de animação com um ticker provider
  void initializeAnimationController(TickerProvider vsync) {
    _controller = AnimationController(
      vsync: vsync,
      duration: const Duration(milliseconds: 400),
    );

    // Adiciona um ouvinte para o status da animação
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        addTodoItem(controller.text); // Adiciona uma nova tarefa quando a animação é concluída
      }
    });
  }

  // Adiciona uma nova tarefa ao banco de dados
  void addTodoItem(String title) async {
    if (title.isNotEmpty) {
      TodoItem newItem = TodoItem(title: title);
      await FirestoreService.instance.insert(newItem.toMap());
      notifyListeners(); // Notifica os ouvintes sobre a alteração nos dados
    }
  }

  // Alterna o estado de submissão
  void toggleSubmitted() {
    _submitted = !_submitted;
    notifyListeners(); // Notifica os ouvintes sobre a alteração nos dados
  }

  // Libera recursos quando não são mais necessários
  void disposeController() {
    _controller.dispose();
  }
}
