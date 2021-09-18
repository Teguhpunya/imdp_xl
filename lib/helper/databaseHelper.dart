import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/node.dart';

class DatabaseHelper {
  //Create a private constructor
  DatabaseHelper._();

  static const databaseName = 'quaildea_database.db';
  static final DatabaseHelper instance = DatabaseHelper._();
  static Database? _database;

  Future<Database?> get database async {
    if (_database == null) {
      return await initializeDatabase();
    }
    return _database;
  }

  initializeDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), databaseName),
        version: 1, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE nodesuhu(id INTEGER PRIMARY KEY NOT NULL, jenis TEXT, timestamp INTEGER, suhu INTEGER, stateLampu INTEGER)");
      await db.execute(
          "CREATE TABLE nodepakan(id INTEGER PRIMARY KEY NOT NULL, jenis TEXT, timestamp INTEGER, statePakan INTEGER, statePakanCadangan INTEGER)");
    });
  }

  insertPakan(NodePakan node) async {
    final db = await database;
    var res = await db!.insert(node.tablename, node.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  insertSuhu(NodeSuhu node) async {
    final db = await database;
    var res = await db!.insert(node.tablename, node.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    return res;
  }

  Future<List<NodeSuhu>> retrieveNodeSuhuList() async {
    final db = await database;
    final String tableName = "nodesuhu";

    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (i) {
      return NodeSuhu(
          id: maps[i]['id'],
          jenis: maps[i]['jenis'],
          stateLampu: maps[i]['stateLampu'],
          suhu: maps[i]['suhu'],
          timestamp: maps[i]['timestamp']);
    });
  }

  Future<List<NodePakan>> retrieveNodePakanList() async {
    final db = await database;
    final String tableName = "nodepakan";

    final List<Map<String, dynamic>> maps = await db!.query(tableName);

    return List.generate(maps.length, (i) {
      return NodePakan(
          id: maps[i]['id'],
          jenis: maps[i]['jenis'],
          timestamp: maps[i]['timestamp'],
          statePakan: maps[i]['statePakan'],
          statePakanCadangan: maps[i]['statePakanCadangan']);
    });
  }

  updateSuhu(NodeSuhu node) async {
    final db = await database;

    var queryResult =
        await db!.rawQuery('SELECT * FROM nodesuhu WHERE id = ?', [node.getId]);

    if (queryResult.isNotEmpty) {
      await db.update(node.tablename, node.toMap(),
          where: 'id = ?',
          whereArgs: [node.getId],
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else
      insertSuhu(node);
  }

  updatePakan(NodePakan node) async {
    final db = await database;

    var queryResult =
        await db!.rawQuery('SELECT * FROM nodesuhu WHERE id = ?', [node.getId]);

    if (queryResult.isNotEmpty) {
      await db.update(node.tablename, node.toMap(),
          where: 'id = ?',
          whereArgs: [node.getId],
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else
      insertPakan(node);
  }

  deleteSuhu(NodeSuhu node) async {
    var db = await database;
    db!.delete(node.tablename, where: 'id = ?', whereArgs: [node.getId]);
  }

  deletePakan(NodePakan node) async {
    var db = await database;
    db!.delete(node.tablename, where: 'id = ?', whereArgs: [node.getId]);
  }
}
