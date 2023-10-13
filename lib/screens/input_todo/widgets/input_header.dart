import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Widget que exibe o cabeçalho do aplicativo
class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Exibe o texto "todo" centralizado com estilo de fonte
        const Center(
          child: Text(
            'todo',
            style: TextStyle(fontSize: 32),
          ),
        ),
        const SizedBox(height: 15), // Espaçamento entre os elementos
        // Exibe a data atual no formato "EEEE dd MMM yyyy" com cor cinza
        Text(
          DateFormat('EEEE dd MMM yyyy').format(DateTime.now()),
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
