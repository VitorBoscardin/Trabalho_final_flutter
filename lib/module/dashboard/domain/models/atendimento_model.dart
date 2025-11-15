class AtendimentoModel {
  final int? id;
  final String titulo;
  final String status;
  final bool ativo;
  final String? foto;
  final String? local;
  final String? hora;
  final String? relatorio; 

  AtendimentoModel({
    this.id,
    required this.titulo,
    required this.status,
    required this.ativo,
    this.foto,
    this.local,
    this.hora,
    this.relatorio, 
  });

  AtendimentoModel copyWith({
    int? id,
    String? titulo,
    String? status,
    bool? ativo,
    String? foto,
    String? local,
    String? hora,
    String? relatorio, 
  }) {
    return AtendimentoModel(
      id: id ?? this.id,
      titulo: titulo ?? this.titulo,
      status: status ?? this.status,
      ativo: ativo ?? this.ativo,
      foto: foto ?? this.foto,
      local: local ?? this.local,
      hora: hora ?? this.hora,
      relatorio: relatorio ?? this.relatorio, 
    );
  }

  factory AtendimentoModel.fromMap(Map<String, dynamic> map) {
    return AtendimentoModel(
      id: map['id'],
      titulo: map['titulo'],
      status: map['status'],
      ativo: map['ativo'] == 1,
      foto: map['foto'],
      local: map['local'],
      hora: map['hora'],
      relatorio: map['relatorio'], 
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'status': status,
      'ativo': ativo ? 1 : 0,
      'foto': foto,
      'local': local,
      'hora': hora,
      'relatorio': relatorio, 
    };
  }
}
