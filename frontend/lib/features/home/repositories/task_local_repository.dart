import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_app/models/task_model.dart';

class TaskLocalRepository {
  String tableName = "tasks";
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
    final path = join(dbPath, "tasks.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          create table $tableName(
              id TEXT PRIMARY KEY,
              title TEXT NOT NULL,
              description TEXT NOT NULL,
              uid TEXT NOT NULL,
              dueAt TEXT NOT NULL,
              hexColor TEXT NOT NULL,
              createdAt TEXT NOT NULL,
              updatedAt TEXT NOT NULL,
              isSynced INTEGER NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertTask(TaskModel taskModel) async {
    final db = await database;
    db.insert(
      tableName,
      taskModel.toMap(),
    );
  }

  Future<void> insertTasks(List<TaskModel> tasks) async {
    final db = await database;
    final batch = db.batch();
    for (var task in tasks) {
      batch.insert(
        tableName,
        task.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    await batch.commit(noResult: true);
  }

  Future<List<TaskModel>> getTasks() async {
    final db = await database;
    final tasksMap = await db.query(tableName);

    if (tasksMap.isNotEmpty) {
      List<TaskModel> tasks = [];
      for (var task in tasksMap) {
        tasks.add(TaskModel.fromMap(task));
      }
      return tasks;
    }
    return [];
  }
}
