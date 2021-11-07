import 'package:imdp_xl/database/database.queries/pembenih_query.dart';
import 'package:imdp_xl/models/pembenih.dart';
import 'package:sqflite/sqflite.dart' as sqlite;
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart' as path;

class DbHelper {
  //membuat method singleton
  static DbHelper _dbHelper = DbHelper._singleton();

  factory DbHelper() {
    return _dbHelper;
  }

  DbHelper._singleton();

  //baris terakhir singleton

  final tables = [
    PembenihQuery.CREATE_TABLE,
  ]; // membuat daftar table yang akan dibuat

  Future<Database> openDB() async {
    final dbPath = await sqlite.getDatabasesPath();
    return sqlite.openDatabase(path.join(dbPath, 'quaildea.db'),
        onCreate: (db, version) {
      tables.forEach((table) async {
        await db.execute(table).then((value) {
          print("Database opened ");
        }).catchError((err) {
          print("errornya ${err.toString()}");
        });
      });
      print('Table Created');
    }, version: 1);
  }

  insert(String table, Map<String, dynamic> data) {
    openDB().then((db) {
      db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    }).catchError((err) {
      print("error $err");
    });
  }

  Future<List> getData(String tableName) async {
    final db = await openDB();
    var result = await db.query(tableName);
    return result.toList();
  }

  Future<List<Pembenih>> getDataPembenih(String tableName) async {
    final db = await openDB();
    final List<Map<String, Object?>> result =
        await db.query(tableName, orderBy: 'id DESC');
    return result.map((e) => Pembenih.fromJson(e)).toList();
  }

  Future<Pembenih> getSingleDataPembenih(String tableName) async {
    final db = await openDB();
    final List<Map<String, Object?>> result =
        await db.query(tableName, orderBy: 'id DESC', limit: 1);
    return Pembenih.fromJson(result[0]);
  }

  Future<bool> hasData(String tableName) async {
    final db = await openDB();
    var result = await db.rawQuery(
      'SELECT 1 FROM $tableName',
    );
    return result.isNotEmpty;
  }
}
