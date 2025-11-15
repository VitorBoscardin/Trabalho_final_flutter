import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trablho_final/module/dashboard/state/atendimento_cubit.dart';
import 'package:trablho_final/module/dashboard/domain/models/atendimento_model.dart';
import 'package:trablho_final/module/dashboard/view/atendimento_form_page.dart';
import 'package:trablho_final/module/dashboard/view/atendimento_detalhes_page.dart';
import 'package:trablho_final/module/dashboard/view/finalizar_atendimneto_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AtendimentoCubit()..carregarAtendimentos(),
      child: const _DashboardView(),
    );
  }
}

class _DashboardView extends StatefulWidget {
  const _DashboardView({super.key});

  @override
  State<_DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<_DashboardView> {
  String _statusFiltro = 'todos';
  bool _apenasAtivos = false;

  static const List<String> _opcoesStatus = [
    'todos',
    'pendente',
    'em andamento',
    'finalizado',
  ];

  List<AtendimentoModel> _aplicarFiltros(List<AtendimentoModel> lista) {
    var filtrada = lista;
    if (_statusFiltro != 'todos') {
      filtrada = filtrada.where((a) => a.status == _statusFiltro).toList();
    }
    if (_apenasAtivos) {
      filtrada = filtrada.where((a) => a.ativo).toList();
    }
    return filtrada;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AtendimentoCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gerenciador de Atendimentos'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            // NOVO ATENDIMENTO
            Wrap(
              spacing: 12,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: const Text('Novo Atendimento'),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: cubit,
                          child: const AtendimentoFormPage(),
                        ),
                      ),
                    );
                    cubit.carregarAtendimentos();
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // FILTROS
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 8,
              children: [
                const Text('Filtrar por status:'),
                DropdownButton<String>(
                  value: _statusFiltro,
                  items: _opcoesStatus
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s[0].toUpperCase() + s.substring(1)),
                          ))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      _statusFiltro = v ?? 'todos';
                    });
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Apenas ativos'),
                    const SizedBox(width: 8),
                    Switch(
                      value: _apenasAtivos,
                      onChanged: (v) => setState(() => _apenasAtivos = v),
                    ),
                  ],
                ),
                IconButton(
                  tooltip: 'Recarregar lista',
                  onPressed: () => cubit.carregarAtendimentos(),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Lista de Atendimentos (${_statusFiltro == 'todos' ? 'Todos' : _statusFiltro})',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 8),

            // LISTA
            Expanded(
              child: BlocBuilder<AtendimentoCubit, AtendimentoState>(
                builder: (context, state) {
                  if (state is AtendimentoLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AtendimentoLoaded) {
                    final listaFiltrada = _aplicarFiltros(state.lista);

                    if (listaFiltrada.isEmpty) {
                      return const Center(
                        child: Text('Nenhum atendimento encontrado.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: listaFiltrada.length,
                      itemBuilder: (context, index) {
                        final atendimento = listaFiltrada[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: Icon(
                              atendimento.ativo
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: atendimento.ativo
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: Text(atendimento.titulo),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Status: ${atendimento.status}'),
                                if (atendimento.local != null &&
                                    atendimento.local!.isNotEmpty)
                                  Text('Local: ${atendimento.local}'),
                                if (atendimento.hora != null &&
                                    atendimento.hora!.isNotEmpty)
                                  Text('Hora: ${atendimento.hora}'),
                              ],
                            ),

                            // ------- TRAILING ATUALIZADO -------
                            trailing: Wrap(
                              spacing: 4,
                              children: [
                                // EDITAR — agora somente quando pendente
                                if (atendimento.status == "pendente")
                                  IconButton(
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                    onPressed: () async {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider.value(
                                            value: cubit,
                                            child: AtendimentoFormPage(
                                              atendimentoExistente: atendimento,
                                            ),
                                          ),
                                        ),
                                      );
                                      cubit.carregarAtendimentos();
                                    },
                                  ),

                                // ATIVAR / DESATIVAR
                                Switch(
                                  value: atendimento.ativo,
                                  onChanged: (valor) async {
                                    await cubit.alternarAtivo(
                                        atendimento.id!, valor);
                                    cubit.carregarAtendimentos();
                                  },
                                ),

                                // EXCLUIR — não pode excluir em andamento
                                IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red),
                                  onPressed: () async {
                                    if (atendimento.status == 'em andamento') {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Não é possível excluir um atendimento em andamento.'),
                                        ),
                                      );
                                      return;
                                    }

                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (_) => AlertDialog(
                                        title:
                                            const Text('Confirmar exclusão'),
                                        content: Text(
                                            'Deseja excluir "${atendimento.titulo}"?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                            child: const Text('Cancelar'),
                                          ),
                                          ElevatedButton(
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Excluir'),
                                          ),
                                        ],
                                      ),
                                    );

                                    if (confirm == true) {
                                      await cubit.excluirAtendimento(
                                          atendimento.id!);
                                      cubit.carregarAtendimentos();
                                    }
                                  },
                                ),
                              ],
                            ),

                            // ON TAP — navega de acordo com o status
                            onTap: () async {
                              if (atendimento.status == 'pendente') {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: cubit,
                                      child: AtendimentoDetalhesPage(
                                        atendimento: atendimento,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (atendimento.status ==
                                  'em andamento') {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: cubit,
                                      child: FinalizarAtendimentoPage(
                                        atendimento: atendimento,
                                      ),
                                    ),
                                  ),
                                );
                              } else if (atendimento.status ==
                                  'finalizado') {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BlocProvider.value(
                                      value: cubit,
                                      child: FinalizarAtendimentoPage(
                                        atendimento: atendimento,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              cubit.carregarAtendimentos();
                            },
                          ),
                        );
                      },
                    );
                  } else if (state is AtendimentoError) {
                    return Center(child: Text(state.mensagem));
                  } else {
                    return const Center(child: Text('Carregando...'));
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
