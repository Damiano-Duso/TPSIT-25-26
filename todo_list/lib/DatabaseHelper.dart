import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Task.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Ottiene l'istanza del database
  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  // Inizializza il database
  Future<Database> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'todo_list.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Crea la tabella dei task
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titolo TEXT NOT NULL,
        completato INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // Inserisce un nuovo task nel database
  Future<int> insertTask(Task task) async {
    final db = await database;
    return await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Recupera tutti i task dal database
  Future<List<Task>> getAllTasks() async {
    final db = await database;
    final maps = await db.query('tasks');
    return List.generate(maps.length, (i) {
      return Task.fromMap(maps[i]);
    });
  }

  // Aggiorna un task nel database
  Future<int> updateTask(Task task) async {
    final db = await database;
    return await db.update(
      'tasks',
      task.toMap(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Elimina un task dal database
  Future<int> deleteTask(int id) async {
    final db = await database;
    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Chiude il database
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
