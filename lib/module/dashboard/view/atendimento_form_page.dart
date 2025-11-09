import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trablho_final/module/dashboard/state/atendimento_cubit.dart';
import 'package:trablho_final/module/dashboard/domain/models/atendimento_model.dart';

class AtendimentoFormPage extends StatefulWidget {
  final AtendimentoModel? atendimentoExistente;

  const AtendimentoFormPage({super.key, this.atendimentoExistente});

  @override
  State<AtendimentoFormPage> createState() => _AtendimentoFormPageState();
}

class _AtendimentoFormPageState extends State<AtendimentoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  String _status = 'pendente';

  @override
  void initState() {
    super.initState();
    if (widget.atendimentoExistente != null) {
      _tituloController.text = widget.atendimentoExistente!.titulo;
      _descricaoController.text = widget.atendimentoExistente!.descricao;
      _status = widget.atendimentoExistente!.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AtendimentoCubit>();
    final isEditing = widget.atendimentoExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Editar Atendimento' : 'Novo Atendimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe o título' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Informe a descrição' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'pendente', child: Text('Pendente')),
                  DropdownMenuItem(value: 'em andamento', child: Text('Em andamento')),
                  DropdownMenuItem(value: 'finalizado', child: Text('Finalizado')),
                ],
                onChanged: (value) => setState(() => _status = value ?? 'pendente'),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.save),
                label: Text(isEditing ? 'Salvar Alterações' : 'Salvar Atendimento'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final novo = AtendimentoModel(
                      id: widget.atendimentoExistente?.id,
                      titulo: _tituloController.text,
                      descricao: _descricaoController.text,
                      status: _status,
                      ativo: widget.atendimentoExistente?.ativo ?? true,
                    );

                    if (isEditing) {
                      await cubit.atualizarAtendimento(novo);
                    } else {
                      await cubit.adicionarAtendimento(novo);
                    }

                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
