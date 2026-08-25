import 'package:sqflite/sqflite.dart';
import '../database/database_helper.dart';

abstract class IStorageService {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

class SQLiteStorageService implements IStorageService {
  static const String _tableName = 'storage';
  static const String _columnKey = 'key';
  static const String _columnValue = 'value';

  late Database _db;
  final DatabaseHelper _dbHelper = DatabaseHelper();

  Future<void> initialize() async {
    _db = await _dbHelper.database;
    await _db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        $_columnKey TEXT PRIMARY KEY,
        $_columnValue TEXT
      )
    ''');
  }

  @override
  Future<void> saveString(String key, String value) async {
    await _db.insert(
      _tableName,
      {_columnKey: key, _columnValue: value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<String?> getString(String key) async {
    final result = await _db.query(
      _tableName,
      where: '$_columnKey = ?',
      whereArgs: [key],
    );
    return result.isEmpty ? null : result.first[_columnValue] as String?;
  }

  @override
  Future<void> remove(String key) async {
    await _db.delete(_tableName, where: '$_columnKey = ?', whereArgs: [key]);
  }

  @override
  Future<void> clear() async {
    await _db.delete(_tableName);
  }
}
