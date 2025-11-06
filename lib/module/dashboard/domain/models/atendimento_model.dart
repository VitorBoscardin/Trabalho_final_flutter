class AtendimentoModel {
  final int? id;
  final String titulo;
  final String descricao;
  final String status; 
  final bool ativo;
  final String? imagemPath; 

  AtendimentoModel({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.status,
    required this.ativo,
    this.imagemPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'status': status,
      'ativo': ativo ? 1 : 0,
      'imagemPath': imagemPath,
    };
  }

  factory AtendimentoModel.fromMap(Map<String, dynamic> map) {
    return AtendimentoModel(
      id: map['id'] as int?,
      titulo: map['titulo'] as String? ?? '',
      descricao: map['descricao'] as String? ?? '',
      status: map['status'] as String? ?? 'pendente',
      ativo: (map['ativo'] is int ? (map['ativo'] as int) == 1 : map['ativo'] == true),
      imagemPath: map['imagemPath'] as String?,
    );
  }

  AtendimentoModel copyWith({
    int? id,
    String? titulo,
    String? descricao,
    String? status,
    bool? ativo,
    String? imagemPath,
  }) {
    return AtendimentoModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      descricao: descricao ?? this.descricao,
      status: status ?? this.status,
      ativo: ativo ?? this.ativo,
      imagemPath: imagemPath ?? this.imagemPath,
    );
  }
}
