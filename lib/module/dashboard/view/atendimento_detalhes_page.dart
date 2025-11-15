import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trablho_final/module/dashboard/state/atendimento_cubit.dart';
import 'package:trablho_final/module/dashboard/domain/models/atendimento_model.dart';

class AtendimentoDetalhesPage extends StatelessWidget {
  final AtendimentoModel atendimento;

  const AtendimentoDetalhesPage({super.key, required this.atendimento});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AtendimentoCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Atendimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              atendimento.titulo,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Text('Status: ${atendimento.status}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),

            if (atendimento.local != null)
              Text('Local: ${atendimento.local}',
                  style: const TextStyle(fontSize: 16)),

            if (atendimento.hora != null)
              Text('Hora: ${atendimento.hora}',
                  style: const TextStyle(fontSize: 16)),

            const Spacer(),

            // 🔥 Botão só aparece se estiver pendente
            if (atendimento.status == "pendente")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text("Iniciar Atendimento"),
                  onPressed: () async {
                    final atualizado = atendimento.copyWith(status: "em andamento");

                    await cubit.atualizarAtendimento(atualizado);

                    if (context.mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Atendimento iniciado!")),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
