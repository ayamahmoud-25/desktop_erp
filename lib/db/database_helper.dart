import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }




  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Initial setup can be done here if needed
      },
    );
  }

  Future<bool> isTableExists(String tableName) async {
    final db = await database;
    final result = await db.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name='$tableName'");
    return result.isNotEmpty;
  }

  Future<void> createTable(String tableName, String tableSchema) async {
    final db = await database;
    await db.execute('CREATE TABLE IF NOT EXISTS $tableName ($tableSchema)');
  }

  Future<void> insert(String tableName, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(tableName, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getAll(String tableName) async {
    final db = await database;
    return await db.query(tableName);
  }
  Future  deleteAll(String tableName) async {
    final db = await database; await db.delete(tableName);
  }
  Future  deleteById(String tableName, String idColumn, int id) async {
    final db = await database; await db.delete(tableName, where: '$idColumn = ?', whereArgs: [id]);
  }
  Future execute(String sql) async {
    final db = await database;
    try {
      await db.execute(sql);
    } catch (e) {
      print("Error executing SQL: $e");
    }
  }

 /* Future<void> clearDatabase() async {
    final db = await database;
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    for (var table in tables) {
      final tableName = table['name'];
      if (tableName != 'sqlite_sequence') {
        await db.execute('DROP TABLE IF EXISTS $tableName');
      }
    }
  await db.close();
  }*/

  Future<void> clearDatabase() async {
    final db = await database;
    final tables = await db.rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
    for (var table in tables) {
      final tableName = table['name'];
      if (tableName != 'sqlite_sequence') {
        await db.execute('DROP TABLE IF EXISTS $tableName');
      }
    }
    await db.close();
    _database = null; // مهم جداً عشان تقدر تفتح db من جديد بعد كده
  }

}

