import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/models/user_model.dart';

class AuthLocalRepository {
  String tableName = "users";
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "auth.db");
    return openDatabase(
      path,
      version: 2,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < newVersion) {
          await db.execute('drop table $tableName');
          db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL,
            token TEXT NOT NULL,
            name TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
        ''');
        }
      },
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE $tableName(
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL,
            token TEXT NOT NULL,
            name TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT NOT NULL
          )
    ''');
      },
    );
  }

  Future<void> insertUser(UserModel userModel) async {
    final db = await database;
    await db.insert(
      tableName,
      userModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<UserModel?> getUser() async {
    final db = await database;
    final res = await db.query(tableName, limit: 1);

    if (res.isEmpty) {
      return null;
    }

    return UserModel.fromMap(res.first);
  }
}
