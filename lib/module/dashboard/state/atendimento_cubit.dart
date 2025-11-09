import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/datasources/atendimento_local_datasource.dart';
import '../domain/models/atendimento_model.dart';

part 'atendimento_state.dart';

class AtendimentoCubit extends Cubit<AtendimentoState> {
  final AtendimentoLocalDataSource _dataSource = AtendimentoLocalDataSource.instance;

  AtendimentoCubit() : super(AtendimentoInitial());

  Future<void> carregarAtendimentos() async {
    emit(AtendimentoLoading());
    try {
      final lista = await _dataSource.getAll();
      emit(AtendimentoLoaded(lista));
    } catch (e, st) {
      emit(AtendimentoError('Erro ao carregar atendimentos: $e'));
      print('carregarAtendimentos error: $e\n$st');
    }
  }

  Future<void> adicionarAtendimento(AtendimentoModel atendimento) async {
    emit(AtendimentoLoading());
    try {
      print('adicionarAtendimento chamado: ${atendimento.titulo}');
      await _dataSource.insert(atendimento);
      await carregarAtendimentos();
    } catch (e, st) {
      emit(AtendimentoError('Erro ao adicionar atendimento: $e'));
      print('adicionarAtendimento error: $e\n$st');
    }
  }

  Future<void> atualizarAtendimento(AtendimentoModel atendimento) async {
    emit(AtendimentoLoading());
    try {
      await _dataSource.update(atendimento);
      await carregarAtendimentos();
    } catch (e) {
      emit(AtendimentoError('Erro ao atualizar atendimento: $e'));
    }
  }

  Future<void> excluirAtendimento(int id) async {
    emit(AtendimentoLoading());
    try {
      await _dataSource.delete(id);
      await carregarAtendimentos();
    } catch (e) {
      emit(AtendimentoError('Erro ao excluir atendimento: $e'));
    }
  }

  Future<void> alternarAtivo(int id, bool ativo) async {
    emit(AtendimentoLoading());
    try {
      await _dataSource.toggleAtivo(id, ativo);
      await carregarAtendimentos();
    } catch (e) {
      emit(AtendimentoError('Erro ao alterar status: $e'));
    }
  }
}
