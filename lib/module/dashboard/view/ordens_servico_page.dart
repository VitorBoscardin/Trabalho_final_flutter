import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trablho_final/module/dashboard/view/vizualizar_atendimento_page.dart';
import '../state/atendimento_cubit.dart';
import '../domain/models/atendimento_model.dart';

class OrdensServicoPage extends StatelessWidget {
  const OrdensServicoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordens de Serviço'),
      ),
      body: BlocBuilder<AtendimentoCubit, AtendimentoState>(
        builder: (context, state) {
          if (state is AtendimentoLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AtendimentoLoaded) {
            // Filtra apenas Ativo e Finalizado
            final atendimentos = state.lista.where((a) =>
                a.status.toLowerCase() == 'ativo' ||
                a.status.toLowerCase() == 'finalizado').toList();

            if (atendimentos.isEmpty) {
              return const Center(
                child: Text('Nenhuma ordem de serviço ativa ou finalizada.'),
              );
            }

            return ListView.builder(
              itemCount: atendimentos.length,
              itemBuilder: (context, index) {
                final atendimento = atendimentos[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: ListTile(
                    title: Text(atendimento.titulo),
                    subtitle: Text('Status: ${atendimento.status}'),
                    trailing: Icon(
                      atendimento.status.toLowerCase() == 'finalizado'
                          ? Icons.check_circle
                          : Icons.pending,
                      color: atendimento.status.toLowerCase() == 'finalizado'
                          ? Colors.green
                          : Colors.orange,
                    ),
                    onTap: () {
                      // Abre a tela de visualização de detalhes
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => VisualizarAtendimentoPage(
                            atendimento: atendimento,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          } else if (state is AtendimentoError) {
            return Center(child: Text('Erro: ${state.mensagem}'));
          }

          return const Center(child: Text('Carregando ordens...'));
        },
      ),
    );
  }
}
