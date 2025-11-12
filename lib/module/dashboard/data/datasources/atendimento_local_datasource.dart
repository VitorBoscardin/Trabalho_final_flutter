import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:trablho_final/module/dashboard/domain/models/atendimento_model.dart';

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
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _databaseName);

    return openDatabase(
      path,
      version: 3, // 👈 nova versão pra garantir criação de colunas
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            status TEXT,
            ativo INTEGER,
            foto TEXT,
            local TEXT,
            hora TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE $_tableName ADD COLUMN foto TEXT');
        }
        if (oldVersion < 3) {
          await db.execute('ALTER TABLE $_tableName ADD COLUMN local TEXT');
          await db.execute('ALTER TABLE $_tableName ADD COLUMN hora TEXT');
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
    final maps = await db.query(_tableName);
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

  Future<List<AtendimentoModel>> getByStatus(String status) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'status = ?',
      whereArgs: [status],
    );
    return maps.map((e) => AtendimentoModel.fromMap(e)).toList();
  }
}
