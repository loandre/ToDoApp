import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:to_do_app/screens/empty_todo/widgets/empty_custom_widgets.dart';

// Widget para exibir o cabeçalho do aplicativo
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        // Título "todo" centralizado com estilo de fonte
        const CenteredText(
          text: 'todo',
          style: TextStyle(fontSize: 32),
        ),
        const SizedBox(height: 15), // Espaçamento entre os elementos
        // Exibe a data atual no formato "EEEE dd MMM yyyy" com cor cinza
        CenteredText(
          text: DateFormat('EEEE dd MMM yyyy').format(DateTime.now()),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
