import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../domain/models/atendimento_model.dart';

class AtendimentoLocalDataSource {
  static const _databaseName = 'atendimentos.db';
  static const _tableName = 'atendimentos';

  static final AtendimentoLocalDataSource instance =
      AtendimentoLocalDataSource._internal();
  Database? _database;

  AtendimentoLocalDataSource._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);

    return openDatabase(
      path,
      version: 2, // 🔥 ATUALIZADO PARA 2 PARA PERMITIR MIGRAÇÃO
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT NOT NULL,
            status TEXT NOT NULL,
            ativo INTEGER NOT NULL,
            foto TEXT,
            local TEXT,
            hora TEXT,
            relatorio TEXT   -- 🔥 ADICIONADO
          );
        ''');
      },

      /// 🔥 MIGRAÇÃO — caso o banco antigo exista sem a coluna RELATORIO
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE $_tableName ADD COLUMN relatorio TEXT;",
          );
        }
      },
    );
  }

  Future<int> insert(AtendimentoModel atendimento) async {
    final db = await database;
    return await db.insert(_tableName, atendimento.toMap());
  }

  Future<List<AtendimentoModel>> getAll() async {
    final db = await database;
    final maps = await db.query(_tableName, orderBy: 'id DESC');
    return maps.map((e) => AtendimentoModel.fromMap(e)).toList();
  }

  Future<int> update(AtendimentoModel atendimento) async {
    final db = await database;
    return await db.update(
      _tableName,
      atendimento.toMap(),
      where: 'id = ?',
      whereArgs: [atendimento.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> toggleAtivo(int id, bool ativo) async {
    final db = await database;
    await db.update(
      _tableName,
      {'ativo': ativo ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
