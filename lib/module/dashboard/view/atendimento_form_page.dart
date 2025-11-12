import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
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

  String _status = 'pendente';
  bool _ativo = true;
  File? _imagemSelecionada;

  @override
  void initState() {
    super.initState();
    final atendimento = widget.atendimentoExistente;
    if (atendimento != null) {
      // Preenche campos quando está editando
      _localController.text = atendimento.local ?? '';
      _horaController.text = atendimento.hora ?? '';
      _status = atendimento.status;
      _ativo = atendimento.ativo;
    }
  }

  Future<void> _selecionarImagem() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagem = await picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _imagemSelecionada = File(imagem.path);
      });
    }
  }

  Future<void> _tirarFoto() async {
    final ImagePicker picker = ImagePicker();
    final XFile? foto = await picker.pickImage(source: ImageSource.camera);
    if (foto != null) {
      setState(() {
        _imagemSelecionada = File(foto.path);
      });
    }
  }

  void _salvar() {
    if (_formKey.currentState?.validate() ?? false) {
      final cubit = context.read<AtendimentoCubit>();

      final novo = AtendimentoModel(
        id: widget.atendimentoExistente?.id,
        titulo: widget.atendimentoExistente?.titulo ??
            _tituloController.text, // mantém o mesmo título ao atualizar
        local: _localController.text,
        hora: _horaController.text,
        status: _status,
        ativo: _ativo,
        foto: _imagemSelecionada?.path ?? widget.atendimentoExistente?.foto,
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
              // Mostra o campo título só se for novo atendimento
              if (!isEditando) ...[
                TextFormField(
                  controller: _tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Informe o título' : null,
                ),
                const SizedBox(height: 12),
              ],
              TextFormField(
                controller: _localController,
                decoration: const InputDecoration(labelText: 'Local'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _horaController,
                decoration: const InputDecoration(labelText: 'Hora'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(
                      value: 'pendente', child: Text('Pendente')),
                  DropdownMenuItem(
                      value: 'em andamento', child: Text('Em andamento')),
                  DropdownMenuItem(
                      value: 'finalizado', child: Text('Finalizado')),
                ],
                onChanged: (v) => setState(() => _status = v ?? 'pendente'),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text('Ativo'),
                value: _ativo,
                onChanged: (v) => setState(() => _ativo = v),
              ),
              const SizedBox(height: 12),
              if (_imagemSelecionada != null)
                Image.file(_imagemSelecionada!, height: 150, fit: BoxFit.cover)
              else if (widget.atendimentoExistente?.foto != null)
                Image.file(File(widget.atendimentoExistente!.foto!),
                    height: 150, fit: BoxFit.cover),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: const Icon(Icons.photo),
                    label: const Text('Galeria'),
                    onPressed: _selecionarImagem,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Câmera'),
                    onPressed: _tirarFoto,
                  ),
                ],
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
