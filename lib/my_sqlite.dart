import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  final databaseName = "items.db";
  String items = 'CREATE TABLE items(id INTEGER PRIMARY KEY, name TEXT)';

// Create and initialize the database
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(items);
    });
  }

  Future<void> insertItem(String name) async {
    final db = await initDB();
    await db.insert(
      'items',
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm
          .replace, // Handle conflicts by replacing existing data
    );
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await initDB();
    return await db.query('items');
  }

  Future<void> updateItem(int id, String name) async {
    final db = await initDB();
    await db.update(
      'items',
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await initDB();
    await db.delete(
      'items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
}
