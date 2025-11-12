import 'dart:io';
import 'package:flutter/material.dart';
import '../domain/models/atendimento_model.dart';

class VisualizarAtendimentoPage extends StatelessWidget {
  final AtendimentoModel atendimento;

  const VisualizarAtendimentoPage({super.key, required this.atendimento});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Atendimento'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (atendimento.foto != null && atendimento.foto!.isNotEmpty)
              Image.file(
                File(atendimento.foto!),
                height: 200,
                fit: BoxFit.cover,
              ),
            const SizedBox(height: 16),
            Text(
              atendimento.titulo,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text('Local: ${atendimento.local ?? 'Não informado'}'),
            const SizedBox(height: 8),
            Text('Hora: ${atendimento.hora ?? 'Não informada'}'),
            const SizedBox(height: 8),
            Text('Status: ${atendimento.status}'),
            const SizedBox(height: 8),
            Text('Ativo: ${atendimento.ativo ? 'Sim' : 'Não'}'),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Voltar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
