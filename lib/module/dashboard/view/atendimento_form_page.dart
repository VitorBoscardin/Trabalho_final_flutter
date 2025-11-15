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
  final _localController = TextEditingController();
  final _horaController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final a = widget.atendimentoExistente;

    if (a != null) {
      _tituloController.text = a.titulo;
      _localController.text = a.local ?? '';
      _horaController.text = a.hora ?? '';
    }
  }

  void _salvar() {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<AtendimentoCubit>();

      final novo = AtendimentoModel(
        id: widget.atendimentoExistente?.id,
        titulo: _tituloController.text,
        local: _localController.text,
        hora: _horaController.text,
        status: widget.atendimentoExistente?.status ?? "pendente",
        ativo: widget.atendimentoExistente?.ativo ?? true,
        foto: widget.atendimentoExistente?.foto,
      );

      if (widget.atendimentoExistente == null) {
        cubit.adicionarAtendimento(novo);
      } else {
        cubit.atualizarAtendimento(novo);
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditando = widget.atendimentoExistente != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditando ? 'Atualizar Atendimento' : 'Novo Atendimento'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Informe o título' : null,
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(labelText: 'Local'),
              ),

              const SizedBox(height: 12),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(labelText: 'Hora'),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: _salvar,
                child: Text(isEditando ? 'Atualizar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
