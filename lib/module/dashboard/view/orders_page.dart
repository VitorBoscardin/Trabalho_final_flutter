import 'package:flutter/material.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de Serviço'),
      ),
      body: const Center(
        child: Text(
          'Página de Ordens de Serviço\n(implementação futura)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
