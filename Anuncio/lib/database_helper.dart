import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models/anuncio.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('anuncios.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(''' 
          CREATE TABLE anuncios(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            descricao TEXT,
            preco REAL,
            imagem TEXT
          )
        ''');
      },
    );
  }

  // Inserir um novo anúncio
  Future<int> insertAnuncio(Anuncio anuncio) async {
    final db = await instance.database;
    return await db.insert('anuncios', anuncio.toMap());
  }

  // Buscar todos os anúncios
  Future<List<Anuncio>> fetchAnuncios() async {
    final db = await instance.database;
    final result = await db.query('anuncios');
    return result.map((map) => Anuncio.fromMap(map)).toList();
  }

  // Atualizar um anúncio
  Future<int> updateAnuncio(Anuncio anuncio) async {
    final db = await instance.database;
    return await db.update(
      'anuncios',
      anuncio.toMap(),
      where: 'id = ?',
      whereArgs: [anuncio.id],
    );
  }

  // Excluir um anúncio
  Future<int> deleteAnuncio(int id) async {
    final db = await instance.database;
    return await db.delete(
      'anuncios',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
