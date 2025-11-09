part of 'atendimento_cubit.dart';

abstract class AtendimentoState {}

class AtendimentoInitial extends AtendimentoState {}

class AtendimentoLoading extends AtendimentoState {}

class AtendimentoLoaded extends AtendimentoState {
  final List<AtendimentoModel> lista;

  AtendimentoLoaded(this.lista);
}

class AtendimentoError extends AtendimentoState {
  final String mensagem;

  AtendimentoError(this.mensagem);
}
