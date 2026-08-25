import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const String _databaseName = 'piramidgame.db';
  static const int _databaseVersion = 1;

  static const String _tableStudents = 'students';
  static const String _columnId = 'id';
  static const String _columnName = 'name';
  static const String _columnNickname = 'nickname';
  static const String _columnCourse = 'course';
  static const String _columnYear = 'year';
  static const String _columnBirthDate = 'birth_date';
  static const String _columnRatings = 'ratings';

  static final DatabaseHelper _instance = DatabaseHelper._internal();

  Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() {
    return _instance;
  }

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final String dbPath = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(
      dbPath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $_tableStudents (
        $_columnId TEXT PRIMARY KEY,
        $_columnName TEXT NOT NULL,
        $_columnNickname TEXT,
        $_columnCourse TEXT NOT NULL,
        $_columnYear INTEGER NOT NULL,
        $_columnBirthDate TEXT NOT NULL,
        $_columnRatings TEXT NOT NULL
      )
    ''');
  }

  Future<void> close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
