import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trablho_final/module/dashboard/domain/models/atendimento_model.dart';
import 'package:trablho_final/module/dashboard/state/atendimento_cubit.dart';

class FinalizarAtendimentoPage extends StatefulWidget {
  final AtendimentoModel atendimento;

  const FinalizarAtendimentoPage({super.key, required this.atendimento});

  @override
  State<FinalizarAtendimentoPage> createState() =>
      _FinalizarAtendimentoPageState();
}

class _FinalizarAtendimentoPageState extends State<FinalizarAtendimentoPage> {
  final ImagePicker _picker = ImagePicker();

  String? _fotoFinalizacao;
  final TextEditingController _observacoesController = TextEditingController();

  @override
  void initState() {
    super.initState();

    
    _observacoesController.text = widget.atendimento.relatorio ?? '';

    
    _fotoFinalizacao = widget.atendimento.foto;
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<AtendimentoCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Finalizar Atendimento'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            Text(
              widget.atendimento.titulo,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Local: ${widget.atendimento.local ?? 'Não informado'}"),
            Text("Hora: ${widget.atendimento.hora ?? 'Não informado'}"),
            const Divider(height: 32),

            
            Text(
              "Foto da finalização",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            _fotoFinalizacao == null
                ? Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                      child: Text("Nenhuma foto tirada"),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      File(_fotoFinalizacao!),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Tirar Foto"),
                  onPressed: () async {
                    final XFile? imagem =
                        await _picker.pickImage(source: ImageSource.camera);

                    if (imagem != null) {
                      setState(() => _fotoFinalizacao = imagem.path);
                    }
                  },
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.image),
                  label: const Text("Galeria"),
                  onPressed: () async {
                    final XFile? imagem =
                        await _picker.pickImage(source: ImageSource.gallery);

                    if (imagem != null) {
                      setState(() => _fotoFinalizacao = imagem.path);
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

          
            TextField(
              controller: _observacoesController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: "Observações / Relatório",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 30),

            
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text("Finalizar Atendimento"),
                onPressed: () async {
                  if (_fotoFinalizacao == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Tire ou selecione uma foto antes."),
                      ),
                    );
                    return;
                  }

                  final atualizado = widget.atendimento.copyWith(
                    status: "finalizado",
                    foto: _fotoFinalizacao,
                    relatorio: _observacoesController.text,
                  );

                  await cubit.atualizarAtendimento(atualizado);

                  if (!mounted) return;

                  Navigator.pop(context);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Atendimento finalizado com sucesso!"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
