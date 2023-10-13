import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListTodoDateHeader extends StatelessWidget {
  const ListTodoDateHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Calcula o valor de padding com base na largura da tela
    double paddingValue = MediaQuery.of(context).size.width * 0.05;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        // Cabeçalho de data com formatação "dia da semana, dia mês ano"
        Padding(
          padding: EdgeInsets.only(left: paddingValue),
          child: Text(
            DateFormat('EEEE dd MMM yyyy').format(DateTime.now()),
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
