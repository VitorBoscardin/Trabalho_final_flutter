import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trablho_final/module/dashboard/domain/models/atendimento_model.dart';
import 'package:trablho_final/module/dashboard/state/atendimento_cubit.dart';

class AtendimentoDetalhesPage extends StatefulWidget {
  final AtendimentoModel atendimento;

  const AtendimentoDetalhesPage({super.key, required this.atendimento});

  @override
  State<AtendimentoDetalhesPage> createState() => _AtendimentoDetalhesPageState();
}

class _AtendimentoDetalhesPageState extends State<AtendimentoDetalhesPage> {
  late TextEditingController _tituloController;
  late String _status;
  String? _fotoPath;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.atendimento.titulo);
    _status = widget.atendimento.status;
    _fotoPath = widget.atendimento.foto;
  }

  Future<void> _tirarFoto() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.camera);
    if (imagem != null) {
      setState(() {
        _fotoPath = imagem.path;
      });
    }
  }

  Future<void> _selecionarDaGaleria() async {
    final XFile? imagem = await _picker.pickImage(source: ImageSource.gallery);
    if (imagem != null) {
      setState(() {
        _fotoPath = imagem.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AtendimentoCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Atendimento'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_fotoPath != null)
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_fotoPath!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              else
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('Nenhuma imagem selecionada')),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _tirarFoto,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Câmera'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: _selecionarDaGaleria,
                    icon: const Icon(Icons.image),
                    label: const Text('Galeria'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(labelText: 'Título'),
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
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text('Salvar Alterações'),
                  onPressed: () async {
                    final atualizado = widget.atendimento.copyWith(
                      titulo: _tituloController.text,
                      status: _status,
                      foto: _fotoPath,
                    );
                    await cubit.atualizarAtendimento(atualizado);
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Atendimento atualizado com sucesso!')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
